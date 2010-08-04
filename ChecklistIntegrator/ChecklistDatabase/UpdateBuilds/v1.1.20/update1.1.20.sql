/* FULL TEXT INDEXING ???

CREATE FULLTEXT CATALOG [full_name]WITH ACCENT_SENSITIVITY = OFF
AUTHORIZATION [dbo]

GO
CREATE FULLTEXT INDEX ON [dbo].[tblName] KEY INDEX [PK_tblName] ON ([full_name], FILEGROUP [PRIMARY]) WITH (CHANGE_TRACKING AUTO)
GO
ALTER FULLTEXT INDEX ON [dbo].[tblName] ADD ([NameFull] LANGUAGE [English])
GO
ALTER FULLTEXT INDEX ON [dbo].[tblName] ADD ([NameOrthography] LANGUAGE [English])
GO
ALTER FULLTEXT INDEX ON [dbo].[tblName] ENABLE
GO
CREATE FULLTEXT INDEX ON [dbo].[tblProviderName] KEY INDEX [PK_tblProviderName] ON ([full_name], FILEGROUP [PRIMARY]) WITH (CHANGE_TRACKING AUTO)
GO
ALTER FULLTEXT INDEX ON [dbo].[tblProviderName] ADD ([PNNameAuthors] LANGUAGE [English])
GO
ALTER FULLTEXT INDEX ON [dbo].[tblProviderName] ADD ([PNNameFull] LANGUAGE [English])
GO
ALTER FULLTEXT INDEX ON [dbo].[tblProviderName] ENABLE
GO

USE [msdb]
GO
DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=N'Start Optimize Catalog Population on Compositae.full_name', 
		@enabled=1, 
		@start_step_id=1, 
		@description=N'Scheduled full-text optimize catalog population for full-text catalog full_name in database Compositae. This job was created by the Full-Text Catalog Scheduling dialog or Full-Text Indexing Wizard.', 
		@category_name=N'Full-Text', @job_id = @jobId OUTPUT
select @jobId
GO
EXEC msdb.dbo.sp_add_jobserver @job_name=N'Start Optimize Catalog Population on Compositae.full_name', @server_name = N'IDT-LAPTOP'
GO
USE [msdb]
GO
DECLARE @schedule_id int
EXEC msdb.dbo.sp_add_jobschedule @job_name=N'Start Optimize Catalog Population on Compositae.full_name', @name=N'weekly', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=8, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20091026, 
		@active_end_date=99991231, 
		@active_start_time=31627, 
		@active_end_time=235959, @schedule_id = @schedule_id OUTPUT
select @schedule_id
GO
USE [msdb]
GO
EXEC msdb.dbo.sp_add_jobstep @job_name=N'Start Optimize Catalog Population on Compositae.full_name', @step_name=N'Full-Text Indexing', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=-1, 
		@on_fail_action=2, 
		@on_fail_step_id=-1, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE [Compositae]
ALTER FULLTEXT CATALOG [full_name] REORGANIZE
', 
		@database_name=N'master'
GO

use compositae
go

alter fulltext index on tblname start update population 
go
alter fulltext index on tblprovidername start update population 
go

*/


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



IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameEditTrail')
	BEGIN
		DROP  Procedure  sprSelect_NameEditTrail
	END

GO

CREATE Procedure sprSelect_NameEditTrail
	@nameGuid uniqueidentifier
AS

	declare @details table(dt datetime, type nvarchar(100), details xml)

	insert @details
	select distinct pn.changeddate, 'Editor Update', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and provideriseditor = 1
	
	insert @details
	select distinct pn.changeddate, 'Provider Name Updated', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and (provideriseditor = 0 or provideriseditor is null) 
	
	insert @details
	select top 1 pn.changeddate, 'Provider Name Imported', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and (provideriseditor = 0 or provideriseditor is null) 
	order by pn.PNUpdatedDate desc
	
	select * from @details

GO


GRANT EXEC ON sprSelect_NameEditTrail TO PUBLIC

GO




IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Author')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Author
	END

GO

CREATE Procedure sprTransferInsertUpdate_Author
	@AuthorPk int,
	@IPNIAuthor_Id nvarchar(255),
	@IPNIVersion nvarchar(255),
	@Abbreviation nvarchar(255),
	@Forename nvarchar(255),
	@Surname nvarchar(255),
	@TaxonGroups nvarchar(255),
	@Dates nvarchar(255),
	@IPNIAlternativeNames nvarchar(255),
	@CorrectAuthorFk int,
	@AddedDate smalldatetime,
	@AddedBy nvarchar(255),
	@UpdatedDate smalldatetime,
	@UpdatedBy nvarchar(255)
AS

	delete tblAuthors where AuthorPk = @authorPk
	
	set identity_insert tblAuthors on
		
	insert tblAuthors(AuthorPK, IPNIAuthor_id, IPNIversion, Abbreviation, Forename, Surname, TaxonGroups, Dates, IPNIAlternativeNames, CorrectAuthorFK, AddedDate, AddedBy, UpdatedDate, UpdatedBy)
	select @AuthorPk, @IPNIAuthor_Id, @IPNIVersion, @Abbreviation, @Forename, @Surname, @TaxonGroups,
		@Dates, @IPNIAlternativeNames, @CorrectAuthorFk, @AddedDate, @AddedDate, @UpdatedDate, @UpdatedBy
	
	set identity_insert tblAuthors off
	
GO


GRANT EXEC ON sprTransferInsertUpdate_Author TO PUBLIC

GO


  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ConceptRelationship')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ConceptRelationship
	END

GO

CREATE Procedure sprTransferInsertUpdate_ConceptRelationship
	@CRGuid uniqueidentifier,
	@CRLSID nvarchar(300),
	@CRConcept1Fk int,
	@CRConcept2Fk int,
	@CRRelationship nvarchar(300),
	@CRRelationshipFk int,
	@CRHybridOrder int,
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
AS

	if (@CRGuid is null or not exists(select * from tblConceptRelationship where ConceptRelationshipGuid = @CRGuid))
	begin
		insert tblConceptRelationship
		select @CRGuid,
			@CRLSID,
			@CRConcept1Fk,
			@CRConcept2Fk,
			@CRRelationship,
			@CRRelationshipFk,
			@CRHybridOrder,
			@createddate,
			@createdBy,
			@updatedDate,
			@updatedBy
			
		select @CRGuid
	end
	else
	begin
		
		update tblConceptRelationship
		set ConceptRelationshipConcept1Fk = @CRConcept1Fk,
			ConceptRelationshipConcept2Fk = @CRConcept2Fk,
			ConceptRelationshipRelationship = @CRRelationship,
			ConceptRelationshipRelationshipFk = @CRRelationshipFk,
			ConceptRelationshipHybridOrder = @CRHybridOrder,
			ConceptRelationshipCreatedDate = @createdDate,
			ConceptRelationshipCreatedBy = @createdBy,
			ConceptRelationshipUpdatedDate = @updatedDate,
			ConceptRelationshipUpdatedBy = @updatedBy
		where ConceptRelationshipGuid = @CRGuid
		
		select @CRGuid
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_ConceptRelationship TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_NameAuthor')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_NameAuthor
	END

GO

CREATE Procedure sprTransferInsertUpdate_NameAuthor
	@NameAuthorsPk int, 
	@NameAuthorsNameFk uniqueidentifier, 
	@NameAuthorsBasionymAuthors nvarchar(100), 
	@NameAuthorsCombinationAuthors nvarchar(100), 
	@NameAuthorsBasEx nvarchar(100), 
	@NameAuthorsCombEx nvarchar(100), 
	@NameAuthorsIsCorrected bit, 
	@NameAuthorsCreatedDate datetime, 
	@NameAuthorsCreatedBy nvarchar(50) 

AS

	delete tblNameAuthors where NameAuthorsPk = @nameAuthorsPk
	
	set identity_insert tblNameAuthors on
	
	insert tblNameAuthors(NameAuthorsPk, NameAuthorsNameFk, NameAuthorsBasionymAuthors, NameAuthorsCombinationAuthors, NameAuthorsBasEx, NameAuthorsCombEx, NameAuthorsIsCorrected, NameAuthorsCreatedDate, NameAuthorsCreatedBy)
	select @NameAuthorsPk, @NameAuthorsNameFk, @NameAuthorsBasionymAuthors, @NameAuthorsCombinationAuthors, @nameAuthorsBasEx, @nameAuthorsCombEx,
		@NameAuthorsIsCorrected, @NameAuthorsCreatedDate, @NameAuthorsCreatedBy
	
	set identity_insert tblNameAuthors off

GO


GRANT EXEC ON sprTransferInsertUpdate_NameAuthor TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderNameAuthor')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderNameAuthor
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderNameAuthor
	@PNAPk int, 
	@PNAProviderNameFk int, 
	@PNABasionymAuthors nvarchar(100), 
	@PNACombinationAuthors nvarchar(100), 
	@PNABasExAuthors nvarchar(100), 
	@PNACombExAuthors nvarchar(100), 
	@PNAIsCorrected bit, 
	@PNACreatedDate datetime, 
	@PNACreatedBy nvarchar(50)

AS

	delete tblprovidernameauthors where pnapk = @pnapk
	
	set identity_insert tblProviderNameAuthors on
	
	insert tblProviderNameAuthors(PNAPk, PNAProviderNameFk, PNABasionymAuthors, PNACombinationAuthors, PNABasExAuthors, PNACombExAuthors, PNAIsCorrected, PNACreatedDate, PNACreatedBy)
	select @PNAPk, @PNAProviderNameFk, @PNABasionymAuthors, @PNACombinationAuthors, @pnaBasExAuthors, @pnaCombExAuthors, @PNAIsCorrected, 
		@PNACreatedDate, @PNACreatedBy

	set identity_insert tblProviderNameAuthors off

GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderNameAuthor TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Name')
	BEGIN
		DROP  Procedure  sprSelect_Name
	END

GO

CREATE Procedure sprSelect_Name
	@nameGuid uniqueidentifier
AS

	select cast(NameGUID as varchar(38)) as NameGuid, 
		NameLSID, 
		NameFull, 
		NameRank, 
		NameRankFk, 
		cast(NameParentFk as varchar(38)) as NameParentFk,
		NameParent,
		cast(NamePreferredFk as varchar(38)) as NamePreferredFk,
		NamePreferred,
		dbo.fnGetFullName(NamePreferredFk, 1,0,1,0,0) as NamePreferredFormatted,
		NameCanonical, 
		NameAuthors, 
		NameBasionymAuthors, 
		NameCombinationAuthors, 
		NamePublishedIn, 
		cast(NameReferenceFk as varchar(38)) as NameReferenceFk, 
		NameYear, 
		NameMicroReference, 
		NameTypeVoucher, 
		NameTypeName, 
		cast(NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		dbo.fnGetFullName(NameTypeNameFk, 1,0,1,0,0) as NameTypeNameFormatted,
		NameOrthography, 
		NameBasionym, 
		cast(NameBasionymFk as varchar(38)) as NameBasionymFk, 
		dbo.fnGetFullName(NameBasionymFk, 1,0,1,0,0) as NameBasionymFormatted,
		NameBasedOn, 
		cast(NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		dbo.fnGetFullName(NameBasedOnFk, 1,0,1,0,0) as NameBasedOnFormatted,
		NameConservedAgainst, 
		cast(NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		dbo.fnGetFullName(NameConservedAgainstFk, 1,0,1,0,0) as NameConservedAgainstFormatted,
		NameHomonymOf, 
		cast(NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		dbo.fnGetFullName(NameHomonymOfFk, 1,0,1,0,0) as NameHomonymOfFormatted,
		NameReplacementFor, 
		cast(NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		dbo.fnGetFullName(NameReplacementForFk, 1,0,1,0,0) as NameReplacementForFormatted,
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
		dbo.fnGetFullName(NameBlockingFk, 1,0,1,0,0) as NameBlockingFormatted,
		NameInCitation,
		NameInvalid, 
		NameIllegitimate, 
		NameMisapplied, 
		NameProParte, 
		NameNomNotes, 
		NameStatusNotes,
		NameNotes,
		NameCreatedDate, 
		NameCreatedBy, 
		NameUpdatedDate, 
		NameUpdatedBy,
		dbo.fnGetFullName(NameGuid, 1,0,1,0,0) as NameFullFormatted,
		NameCounter,
		RankSort
	from tblName 
	inner join tblrank on rankpk = namerankfk
	where NameGuid = @nameGuid

GO


GRANT EXEC ON sprSelect_Name TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ChildNames')
	BEGIN
		DROP  Procedure  sprSelect_ChildNames
	END

GO

CREATE Procedure sprSelect_ChildNames
	@parentNameGuid uniqueidentifier,
	@recurseChildren bit	
AS

	declare @ranks table(rankPk int)
	declare @res table(NameGuid uniqueidentifier, GotChildren bit)


	--we only want to select recursive children where they have the same rank as any of the immediate children	
	insert @ranks
	select distinct RankPk
	from tblRank
	inner join tblName on NameRankFk = RankPk 
	where NameParentFk = @parentNameGuid

	--get all immediate children
	insert @res
	select NameGuid, null
	from tblName
	where NameParentFk = @parentNameGuid
	
	declare @count int, @lastCount int
	select @count = count(*), @lastCount = 0 from @res
	
	while (@recurseChildren = 1 and @count > @lastCount)
	begin
		set @lastCount = @count
		
		update @res set GotChildren = 1 where GotChildren = 0
		update @res set GotChildren = 0 where GotChildren is null
		
		insert @res
		select n.NameGuid, null
		from tblName n
		inner join @res r on n.NameParentfk = r.NameGuid and r.GotChildren = 0
		inner join @ranks rnk on rnk.RankPk = n.NameRankFk
		
		select @count = count(*) from @res
	end

	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		NameLSID, 
		NameFull, 
		NameRank, 
		NameRankFk, 
		cast(NameParentFk as varchar(38)) as NameParentFk,
		NameParent,
		cast(NamePreferredFk as varchar(38)) as NamePreferredFk,
		NamePreferred,
		NameCanonical, 
		NameAuthors, 
		NameBasionymAuthors, 
		NameCombinationAuthors, 
		NamePublishedIn, 
		cast(NameReferenceFk as varchar(38)) as NameReferenceFk, 
		NameYear, 
		NameMicroReference, 
		NameTypeVoucher, 
		NameTypeName, 
		cast(NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		NameOrthography, 
		NameBasionym, 
		cast(NameBasionymFk as varchar(38)) as NameBasionymFk, 
		NameBasedOn, 
		cast(NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		NameConservedAgainst, 
		cast(NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		NameHomonymOf, 
		cast(NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		NameReplacementFor, 
		cast(NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
		NameInCitation,
		NameInvalid, 
		NameIllegitimate, 
		NameMisapplied, 
		NameProParte, 
		NameNomNotes, 
		NameStatusNotes,
		NameNotes,
		NameCreatedDate, 
		NameCreatedBy, 
		NameUpdatedDate, 
		NameUpdatedBy,
		dbo.fnGetFullName(n.NameGuid, 1,0,1,0,0) as NameFullFormatted,
		NameCounter,
		RankSort
	from tblName n
	inner join @res r on r.NameGuid = n.NameGuid
	inner join tblrank on rankpk = namerankfk
	
GO


GRANT EXEC ON sprSelect_ChildNames TO PUBLIC

GO
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
			n.NamePreferred,  
			dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted,
			RankSort,
			'Data Providers : ' + dbo.fnGetProviderTitles(n.nameguid) as DataProviders
		from @ids id 
		inner join tblName n on id.id = n.nameguid
		inner join tblrank r on r.rankpk = n.namerankfk
	end


GO


GRANT EXEC ON sprSelect_ReportNamesList TO PUBLIC

GO




IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Concept')
	BEGIN
		DROP  Procedure  dbo.sprDelete_Concept
	END

GO

CREATE Procedure dbo.sprDelete_Concept
	@conceptLSID nvarchar(300),
	@newConceptLSID nvarchar(300),
	@user nvarchar(50)
AS

	
	delete tblConceptRelationship 
	from tblConceptRelationship 
	inner join tblConcept on ConceptPk = ConceptRelationshipConcept1Fk 
	where ConceptLsid = @conceptLsid 
		
	delete tblConceptRelationship 
	from tblConceptRelationship 
	inner join tblConcept on ConceptPk = ConceptRelationshipConcept2Fk 
	where ConceptLsid = @conceptLsid
	
	insert into tblDeprecated
	select @conceptLsid, @newConceptLsid, 'tblConcept', getdate(), @user
	
	delete tblConcept
	where ConceptLsid = @conceptLsid
	
GO

GO


GRANT EXEC ON dbo.sprDelete_Concept TO PUBLIC

GO


