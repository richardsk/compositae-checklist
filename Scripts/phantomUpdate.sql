
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameChildCount')
	BEGIN
		DROP  Procedure  sprSelect_NameChildCount
	END

GO

CREATE Procedure sprSelect_NameChildCount
(
	@nameGuid uniqueidentifier
)
AS

	select count(nameguid) from tblname where nameparentfk = @nameguid

GO


GRANT EXEC ON sprSelect_NameChildCount TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetProviderTitles')
	BEGIN
		DROP  Function  fnGetProviderTitles
	END

GO

CREATE Function fnGetProviderTitles
	(
		@nameGuid uniqueidentifier
	)
returns nvarchar(2000)
AS
begin
	declare @provs nvarchar(2000)
	
	set @provs = ''
	
	select @provs = case when charindex(', ' + p.providername, @provs) <> 0 then @provs 
		else @provs + ', ' + p.providername end
	from tblprovidername pn
	inner join tblproviderimport pim on pim.providerimportpk = pnproviderimportfk
	inner join tblprovider p on p.providerpk = pim.providerimportproviderfk
	where pn.pnnamefk = @nameguid
	
	if (len(@provs) > 0) set @provs = substring(@provs, 2, len(@provs))
	
	return @provs
end

GO


GRANT EXEC ON fnGetProviderTitles TO PUBLIC

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FuzzyNameSearch')
	BEGIN
		DROP  Procedure  sprSelect_FuzzyNameSearch
	END

GO

CREATE Procedure sprSelect_FuzzyNameSearch
(
	@searchText nvarchar(300)
)
AS

	declare @ids table(id uniqueidentifier, match nvarchar(500))
	
	insert @ids
	select distinct n.nameguid, cn.namefull
	from tblName n 
	inner join tblname cn on cn.nameparentfk = n.nameguid 
	where cn.namefull like '%' + @searchText + '%'
	union
	select distinct n.nameguid, pn.pnnamefull
	from tblName n 
	inner join tblprovidername pn on pn.pnnamefk = n.nameguid
	where pn.pnnamefull like '%' + @searchText + '%'
	union
	select distinct n.nameguid, pn.pnnameauthors
	from tblName n 
	inner join tblprovidername pn on pn.pnnamefk = n.nameguid
	where pn.pnnameauthors like '%' + @searchText + '%'
	union
	select distinct n.nameguid, n.nameorthography
	from tblName n 
	where n.nameorthography like '%' + @searchText + '%'
	
	
	select distinct n.nameguid, 
		n.namerankfk, 
		n.namefull, 
		n.namecanonical, 
		n.nameparent, 
		n.nameauthors, 
		tblrank.*, 
        match as MatchingText 
    from @ids i
    inner join tblName n on n.nameguid = i.id
    inner join tblRank on rankpk = n.namerankfk
    order by RankSort, n.NameFull

GO


GRANT EXEC ON sprSelect_FuzzyNameSearch TO PUBLIC

GO



 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRelationData')
	BEGIN
		DROP  Procedure  sprUpdate_NameRelationData
	END

GO

CREATE Procedure sprUpdate_NameRelationData
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update parent and preferred fks
	declare @parentFk uniqueidentifier
	--try system PN rec
	select top 1 @parentfk = p.PNNameFk
	from vwProviderName pn
	inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
	inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and PCR.ProviderPk = pc.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc.ProviderPk
	where ppn.PNNameFk = @nameGuid and p.ProviderIsEditor = 1 and pcr.PCRRelationshipFk = 6 --parent
	
	if (@parentFk is null)
	begin
		--try parentage PN rec
		select top 1 @parentfk = p.PNNameFk
		from vwProviderName pn
		inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and PCR.ProviderPk = pc.ProviderPk
		inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc.ProviderPk
		inner join tblProvider pr on pr.ProviderPk = p.ProviderPk
		where ppn.PNNameFk = @nameGuid and pr.ProviderUseForParentage = 1 and pcr.PCRRelationshipFk = 6 --parent	
			and ppn.pnnameid <> p.pnnameid
	end
	
	if (@parentFk is null)
	begin
		--use majority
		select top 1 @parentfk = v.val
		from tblName n
		inner join (select p.PNNameFk as val, count(*) as c
			from vwProviderName pn
			inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
			inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
			inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and PCR.ProviderPk = pc.ProviderPk
			inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
			inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc.ProviderPk
			where ppn.PNNameFk = @nameGuid and pcr.PCRRelationshipFk = 6 --parent rel
				and ppn.pnnameid <> p.pnnameid
			group by p.pnnamefk
			) v on v.val = n.NameGuid
		order by c desc	
	end

	if (@parentFk is null)
	begin
		select @parentFk = dbo.fnGetNameParentMatch(@nameGuid)
		
		if (@parentFk = '00000000-0000-0000-0000-000000000000')
		begin
			set @parentFk = null
			--select @parentFk = NameGuid	from tblName where NameFull = 'Unknown'
		end
	end
		
	--parent
	update n
	set n.NameParentFk = @parentFk, n.NameParent = pn.NameFull
	from tblName n
	inner join tblName pn on pn.NameGuid = @parentFk
	where n.NameGuid = @nameGuid				
	

	--preferred	
	declare @prefFk uniqueidentifier
	
	select @prefFk = dbo.fnGetPreferredName(@nameGuid)
	
	update n
	set n.NamePreferredFk = @prefFk, n.NamePreferred = pn.NameFull
	from tblName n
	left join tblName pn on pn.NameGuid = @prefFk
	where n.NameGuid = @nameGuid		
	
	
GO
	
GRANT EXEC ON sprUpdate_NameRelationData TO PUBLIC

GO

if not exists(select * from tblReport where ReportName = 'Phantom Names')
begin
	insert tblreport
	select 'Phantom Names', 'Find all names where their parent does not exist, and therefore cannot be displayed in the tree.', 'sprSelect_ReportPhantoms', 'PhantomNamesReport.xslt', 0
end

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportPhantoms')
	BEGIN
		DROP  Procedure  sprSelect_ReportPhantoms
	END

GO

CREATE Procedure sprSelect_ReportPhantoms
	
AS

	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res	
	select cast(n.NameGuid as varchar(300)), 'Provider count: ' + cast(count(pnpk) as varchar(100)) +
		'; Child count: ' + cast(count(cn.nameguid) as varchar(100)) + '; FullName : ' + isnull(n.NameFull, '[null]'),
		'Name', 'tblName'
	from tblName n
	left join tblName pn on pn.NameGUID = n.NameParentFk
	left join tblProviderName on PNNameFk = n.NameGUID
	left join tblName cn on cn.NameParentFk = n.NameGUID
	where (pn.NameGUID is null or pn.nameguid = n.nameguid) and (n.NameFull is null or n.NameFull <> 'root')
	group by n.NameFull, n.NameGUID
	order by n.namefull
	
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordDetails

GO


GRANT EXEC ON sprSelect_ReportPhantoms TO PUBLIC

GO


  