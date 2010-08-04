IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameLink')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameLink
	END

GO

CREATE Procedure sprUpdate_ProviderNameLink
	@PNPK int,
	@PNNameFk uniqueidentifier,
	@PNLinkStatus nvarchar(20),
	@user nvarchar(50)
AS

	declare @oldNameFk uniqueidentifier, @oldLSID nvarchar(300), @newLSID nvarchar(300), @c int
	select @oldNameFk = PNNameFk, @oldLSID = NameLSID
	from tblProviderName 
	inner join tblName on NameGuid = PNNameFk
	where PNPk = @PNPk
	
	
	update tblProviderName
	set PNNameFk = @PNNameFk,
		PNLinkStatus = @PNLinkStatus,
		PNUpdatedDate = getdate(),
		PNUpdatedBy = @user
	where PNPk = @PNPk
	
	
	/*delete name if no provider names left
	select @c = count(*) from vwProviderName where PNNameFk = @oldNameFk and ProviderName <> 'SYSTEM'
	if (@c = 0)
	begin
		if (@PNNameFk is null) set @newLSID = 'unlinked'
		else select @newLSID = NameLSID from tblName where NameGuid = @PNNameFk
		
		exec sprDelete_Name @oldLSID, @newLSID, @user
	end*/

GO


GRANT EXEC ON sprUpdate_ProviderNameLink TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_PCRById')
	BEGIN
		DROP  Procedure  sprSelect_PCRById
	END

GO

CREATE Procedure sprSelect_PCRById
	@providerPk int,
	@PCRId nvarchar(300)
AS

	select *
	from vwProviderConceptRelationship
	where PCRId = @pcrId and ProviderPk = @ProviderPk
	

GO


GRANT EXEC ON sprSelect_PCRById TO PUBLIC

GO


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
	
	--names that point to themselves as parent - should happen, but if it does a refresh should fix it
	insert @names 
	select nameguid
	from tblName 
	where nameparentfk = nameguid
	
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


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportConflictingAuthors')
	BEGIN
		DROP  Procedure  sprSelect_ReportConflictingAuthors
	END

GO

CREATE Procedure sprSelect_ReportConflictingAuthors
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select distinct cast(n.NameGuid as varchar(300)), n.NameFull, 'Name', 'tblName'
	from tblname n
	inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
	left join tblprovidername pn on pn.pnnamefk = n.nameguid and pn.pnproviderimportfk = 3
	inner join tblprovidername pn2 on pn2.pnnamefk = n.nameguid and pn2.pnproviderimportfk <> 3
	inner join tblprovidernameauthors pna on pna.pnaprovidernamefk = pn2.pnpk
	where pn.pnpk is null and 			
		((pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is not null 
			and dbo.fngetcorrectedauthors(pna.pnabasionymauthors) <> na.nameauthorsbasionymauthors)
		or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is not null 
			and dbo.fngetcorrectedauthors(pna.pnacombinationauthors) <> na.nameauthorscombinationauthors)
		or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is null) 
		or (pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is null) )

	/*from vwProviderName pn
	inner join tblprovidernameauthors pna on pnaprovidernamefk = pnpk
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
	left join vwProviderName edPn on edPn.PNNameFk = n.NameGuid and edPn.ProviderIsEditor = 1
	where pn.PNLinkStatus <> 'Discarded' and	
		edPn.PNPk is null and	
		(select count(*) from tblproviderName 
			inner join tblproviderimport on providerimportpk = pnproviderimportfk
			where pnnamefk = n.NameGuid and providerimportstatus <> 'system') > 1 and
		(isnull(dbo.fnGetCorrectedAuthors(pna.PNaBasionymAuthors), '') <> isnull(na.NameAuthorsBasionymAuthors, '') or
		isnull(dbo.fnGetCorrectedAuthors(pna.PNaCombinationAuthors), '') <> isnull(na.NameAuthorsCombinationAuthors,''))*/
		

	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportConflictingAuthors TO PUBLIC

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithPartialCanonical')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithPartialCanonical
	END

GO

CREATE Procedure sprSelect_NamesWithPartialCanonical
	@providerNamePk int,
	@threshold int
AS

	declare @nameCanonical nvarchar(300)
	select @nameCanonical = lower(PNNameCanonical) from tblProviderName where PNPk = @providerNamePk
	
	if (@namecanonical is null)
	begin
		--fail
		delete tmpMatchResults
		return
	end

	declare @lvs table(nid uniqueidentifier, lv int)
	declare @leftStr nvarchar(300), @rightStr nvarchar(300), @endsStr nvarchar(300)
	
	set @leftStr = @nameCanonical
	if (len(@nameCanonical) > 4) set @leftStr = left(@nameCanonical, len(@namecanonical) - 3) + '%'
	set @rightStr = @nameCanonical
	if (len(@nameCanonical) > 4) set @rightStr = '%' + right(@nameCanonical, len(@namecanonical) - 3) 
	set @endsStr = @nameCanonical
	if (len(@namecanonical) > 7) set @endsStr = left(@namecanonical, 3) + '%' + right(@nameCanonical, 3)
	
	
	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin		
				
		insert tmpMatchResults
		select NameGuid, null
		from tblName 
		where namecanonical like @leftStr or namecanonical like @rightStr or namecanonical like @endsStr
		
		insert @lvs
		select NameGuid, dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical) 
		from tmpmatchresults m
		inner join tblname on nameguid = m.matchresultrecordid

		delete m
		from tmpmatchresults m
		inner join @lvs l on l.nid = m.matchresultrecordid
		where l.lv < @threshold
		
		update m
		set MatchResultScore = lv.lv
		from tmpMatchResults m
		inner join @lvs lv on lv.nid = m.MatchResultRecordId
	end
	else
	begin
		delete m
		from tmpmatchresults m
		inner join tblName on NameGuid = MatchResultRecordId
		where namecanonical is null or 
		(namecanonical not like @leftStr and namecanonical not like @rightStr and namecanonical not like @endsStr)
	
		insert @lvs
		select NameGuid, dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical) 
		from tmpmatchresults m
		inner join tblname on nameguid = m.matchresultrecordid

		delete m
		from tmpmatchresults m
		inner join @lvs l on l.nid = m.matchresultrecordid
		where l.lv < @threshold
		
	end

GO


GRANT EXEC ON sprSelect_NamesWithPartialCanonical TO PUBLIC

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithCanonical')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithCanonical
	END

GO

CREATE Procedure sprSelect_NamesWithCanonical
	@providerNamePk int,
	@threshold int
AS

	declare @nameCanonical nvarchar(300)
	select @nameCanonical = lower(PNNameCanonical) from tblProviderName where PNPk = @providerNamePk
		
	if (@namecanonical is null)
	begin
		--fail
		delete tmpMatchResults
		return
	end

	declare @lenDiff int
	set @lenDiff = ceiling((len(@nameCanonical)*10/100))
	
	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical)
		from tblName 
		where dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical) >= @threshold
	end
	else
	begin
		declare @lvs table(nid uniqueidentifier, lv int)
		insert @lvs
		select NameGuid, null 
		from tmpmatchresults
		inner join tblName on NameGuid = MatchResultRecordId
		where namecanonical is null or abs(len(NameCanonical) - len(@nameCanonical)) <= @lenDiff
		
		update l
		set lv = dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical) 
		from @lvs l
		inner join tblname n on n.nameguid = l.nid
		

		delete m
		from tmpmatchresults m
		left join @lvs l on l.nid = m.matchresultrecordid
		where l.lv < @threshold or l.nid is null
		
	end

GO


GRANT EXEC ON sprSelect_NamesWithCanonical TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithExactCanonical')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithExactCanonical
	END

GO

CREATE Procedure sprSelect_NamesWithExactCanonical
	@providerNamePk int,
	@threshold int
AS

	declare @nameCanonical nvarchar(300)
	select @nameCanonical = ltrim(rtrim(lower(PNNameCanonical))) from tblProviderName where PNPk = @providerNamePk
	
	if (@namecanonical is null or len(@nameCanonical) = 0)
	begin
		--fail
		delete tmpMatchResults
		return
	end

	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical)
		from tblName 
		where ltrim(rtrim(NameCanonical)) = @nameCanonical
	end
	else
	begin
	
		delete m
		from tmpmatchresults m
		inner join tblName on NameGuid = MatchResultRecordId
		where namecanonical is null or ltrim(rtrim(NameCanonical)) <> @nameCanonical
		
	end

GO


GRANT EXEC ON sprSelect_NamesWithExactCanonical TO PUBLIC

GO




