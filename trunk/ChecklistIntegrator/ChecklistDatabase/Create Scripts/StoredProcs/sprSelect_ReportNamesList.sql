IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportNamesList')
	BEGIN
		DROP  Procedure  sprSelect_ReportNamesList
	END

GO

CREATE Procedure sprSelect_ReportNamesList
	@nameIds nvarchar(max),
	@showConflicts bit
AS


	declare @pos int, @lastPos int, @id nvarchar(100)
	declare @ids table(id uniqueidentifier)
	set @pos = CHARINDEX(',', @nameids)
	set @lastPos = 0
	while (@pos <> 0)
	begin
		set @id = SUBSTRING(@nameids, @lastpos, @pos - @lastpos)
		print(@id)
		insert @ids
		select @id
		
		set @lastPos = @pos + 1
		set @pos = CHARINDEX(',', @nameids, @lastpos)
	end

	if (LEN(@nameids) > 0)
	begin
		if (@lastPos > 0) 
		begin
			set @id = SUBSTRING(@nameids, @lastpos, len(@nameids))
			insert @ids select @id
		end
		else
		begin
			insert @ids select @nameids
		end
	end


	if (@showConflicts = 1)
	begin
		select distinct n.nameguid, n.namefull, n.namepreferredfk, 
			n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied,
			n.namepublishedin, n.nameorthography, 
			n.namebasionymauthors, n.namecombinationauthors,
			n.NamePreferred,  
			dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted,
			RankSort,
			case when pcr.PCName2 <> n.NamePreferred then '1' else '0' end as hasConf,
			case when cn.NamePreferredFk <> cn.NameGUID then '1' else '0' end as hasPrefNameIncons,
			case when exists(select top 1 ssn.NameGUID
				from tblname sn 
				inner join tblName ssn on ssn.NamePreferredFk = sn.NameGUID and ssn.NameGUID <> sn.NameGUID
				where sn.namepreferredfk = n.NameGUID and sn.NameGUID <> n.NameGUID
				) then '1' else '0' end as hasSynonymIncons,
			'Data Providers : ' + dbo.fnGetProviderTitles(n.nameguid) as DataProviders
		from @ids id 
		inner join tblName n on id.id = n.nameguid
		inner join tblrank r on r.rankpk = n.namerankfk
		left join tblName cn on cn.NameGUID = n.NamePreferredFk and cn.NameGUID <> n.NameGUID
		inner join tblProviderName pn on pn.pnnamefk = n.nameguid  
		inner join tblProviderImport pim on pim.ProviderImportPk = pn.pnproviderimportfk  
		inner join tblProvider p on p.providerpk = pim.providerimportproviderfk  
		left join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId and pcr.ProviderPk = p.ProviderPk
	end
	else
	begin
		select distinct n.nameguid, n.namefull, n.namepreferredfk, 
			n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied,
			n.namepublishedin, n.nameorthography, 
			n.namebasionymauthors, n.namecombinationauthors,
			n.NamePreferred,  
			dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted,
			RankSort,
			'Data Providers : ' + dbo.fnGetProviderTitles(n.nameguid) as DataProviders
		from @ids id 
		inner join tblName n on id.id = n.nameguid
		inner join tblrank r on r.rankpk = n.namerankfk
	end

go

GRANT EXEC ON sprSelect_ReportNamesList TO PUBLIC

GO


