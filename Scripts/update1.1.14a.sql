alter table tblProviderName alter column PNMatchPath nvarchar(3000)
alter table tblProviderName_change alter column PNMatchPath nvarchar(3000)
alter table tmpIntegration alter column SPTrace nvarchar(3000)
go

update tblprovidername set pnnameauthors = null 
where pnnameauthors = ''

update tblprovidername set pnbasionymauthors = null 
where pnbasionymauthors = ''

update tblprovidername set pncombinationauthors = null 
where pncombinationauthors = ''

update tblprovidernameauthors set pnabasionymauthors = null
where pnabasionymauthors = ''

update tblprovidernameauthors set pnacombinationauthors = null
where pnacombinationauthors = ''

go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesForUpdate')
	BEGIN
		DROP  Procedure  sprSelect_NamesForUpdate
	END

GO

CREATE Procedure sprSelect_NamesForUpdate
	
AS

	declare @names table(nameGuid uniqueidentifier)
	declare @moreNames table(nameGuid uniqueidentifier)
	
	insert @names
	select distinct nameguid 
	from tblName n
	inner join tblProviderName pn on pn.pnnamefk = n.nameguid
	where pn.pnupdateddate > n.nameupdateddate
	
	insert @moreNames
	select distinct c.conceptname1fk
	from tblconcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept2fk = c.conceptpk
	inner join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept1fk
	inner join @names n on n.nameguid = c.conceptname1fk
	where c.conceptname1fk <> c2.conceptname1fk 
	
	insert @moreNames
	select distinct c.conceptname1fk
	from tblconcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept1fk = c.conceptpk
	inner join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept2fk
	inner join @names n on n.nameguid = c.conceptname1fk
	where c.conceptname1fk <> c2.conceptname1fk 
	
	
	insert @names
	select * from @moreNames
	
	
	insert @names
	select distinct n.nameguid
	from tblName n
	left join @names nam on nam.nameguid = n.nameguid 
	left join tblName p on p.nameguid = n.nameparentfk
	left join tblName pr on pr.nameguid = n.namepreferredfk
	left join tblName b on b.nameguid = n.namebasionymfk
	left join tblName ba on ba.nameguid = n.namebasedonfk
	left join tblName t on t.nameguid = n.nametypenamefk
	left join tblName h on h.nameguid = n.namehomonymoffk
	left join tblName r on r.nameguid = n.namereplacementforfk
	left join tblName bl on bl.NameGuid = n.NameBlockingFk
	left join tblName c on c.nameguid = n.nameconservedagainstfk
	where nam.nameguid is null and 
		((p.namefull collate SQL_Latin1_General_CP1_CI_AI  <> n.nameparent) or
		(pr.nameguid is not null and pr.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namepreferred) or
		(b.nameguid is not null and b.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namebasionym) or
		(ba.nameguid is not null and ba.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namebasedon) or
		(t.nameguid is not null and t.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nametypename) or
		(h.nameguid is not null and h.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namehomonymof) or
		(r.nameguid is not null and r.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namereplacementfor) or
		(bl.nameguid is not null and bl.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nameblocking) or
		(c.nameguid is not null and c.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nameconservedagainst))
		

	select distinct cast(n.NameGUID as varchar(38)) as NameGuid
	from tblName n
	inner join @names u on u.nameGuid = n.NameGuid

GO


GRANT EXEC ON sprSelect_NamesForUpdate TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredName')
	BEGIN
		DROP  Function  fnGetPreferredName
	END

GO

CREATE Function fnGetPreferredName
(
	@nameGuid uniqueidentifier
)
returns uniqueidentifier
AS
begin
	--get preferred name
	-- if that name has a diff preferred name then use that one
	-- to avoid inconsistencies
	
	
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier)
	
	set @done = 0
	
	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk
		from tblName
		inner join vwProviderName pn on PNNameFk = NameGUID
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId and pcr.ProviderPk = pn.ProviderPk and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p2 on p2.PNNameId = pcr.PCName2Id and p2.ProviderPk = pcr.ProviderPk
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(*) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv and ispref = 1
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				
			end
		end
				
		if (@prefFk is null) set @done = 1
		else
		begin
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk) set @done = 1
			else set @nameGuid = @prefPrefFk
		end
	end
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
		end
	end
	
	return @prefFk
end

GO


GRANT EXEC ON fnGetPreferredName TO PUBLIC

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AllNamesForUpdate')
	BEGIN
		DROP  Procedure  sprSelect_AllNamesForUpdate
	END

GO

CREATE Procedure sprSelect_AllNamesForUpdate

AS

	--all names except root name

	select cast(n.NameGUID as varchar(38)) as NameGuid
	from tblName n
	where NameFull <> 'ROOT' and namefull <> 'unknown'

GO


GRANT EXEC ON sprSelect_AllNamesForUpdate TO PUBLIC

GO



 