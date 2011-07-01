
update so
set OtherDataFk = od.OtherDataPk
from tblStandardOutput so	
inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
inner join tblOtherData od on od.RecordFk = pn.PNNameFk and od.OtherDataTypeFk = so.OtherTypeFk 
where so.OtherDataFk is null


go




IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameOtherDataToUpdate')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderNameOtherDataToUpdate
	END

GO

CREATE Procedure dbo.sprSelect_ProviderNameOtherDataToUpdate
	@nameGuid uniqueidentifier
AS

	select od.*, pn.PNNameFk 
	from vwProviderOtherData od
	inner join vwProviderName pn on pn.PNNameId = od.POtherDataRecordId and pn.ProviderPk = od.ProviderPk
	left join tblStandardOutput so on so.POtherDataFk = od.POtherDataTextPk
	where pn.PNNameFk = @nameGuid and od.OutputTypeFk is not null and
		(od.StandardOutputPk is null or od.OtherDataFk is null or OtherDataTransUpdatedDate > so.UpdatedDate
			or isnull(POtherDataUpdatedDate, POTherDataCreatedDate) > so.UpdatedDate
			or isnull(pn.PNUpdatedDate, pn.PNCreatedDate) > so.UpdatedDate)

GO


GRANT EXEC ON dbo.sprSelect_ProviderNameOtherDataToUpdate TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRecords')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRecords
	END

GO

CREATE Procedure sprSelect_ProviderConceptRecords
	@conceptPk int
AS
	select p.ProviderName,
		PCName1, 
		PCAccordingTo, 
		PCConceptVersion,
		PCLinkStatus, 
		PCMatchScore, 
		PCConceptId, 
		PCName1Id, 
		PCAccordingToId, 
		PCConceptFk, 
		p.ProviderPk,
		p.ProviderIsEditor,
		PCPk, 
		PCProviderImportFk, 
		PCCreatedDate, 
		PCCreatedBy, 
		PCUpdatedDate, 
		PCUpdatedBy,
		pr.PRReferenceFk
	from tblProviderConcept pc
	inner join tblProviderImport pim on pim.ProviderImportPk = pc.PCProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	left join tblProviderReference pr on pr.PRReferenceId = pc.PCAccordingToId 
	left join tblProviderImport prim on prim.ProviderImportPk = pr.PRProviderImportFk and p.providerpk = prim.ProviderImportProviderFk
	where PCConceptFk = @conceptPk

GO


GRANT EXEC ON sprSelect_ProviderConceptRecords TO PUBLIC

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherData')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherData
	END

GO

CREATE Procedure sprInsertUpdate_OtherData
	@otherDataPk uniqueidentifier,
	@otherDataTypeFk int,
	@recordFk nvarchar(300),
	@xml nvarchar(max),
	@data nvarchar(max),
	@user nvarchar(50)
AS

	if (@otherDataPk is null or not exists(select * from tblOtherData where OtherDataPk = @otherDataPk))
	begin
		--check if a record for this name and data type already exists
		select @otherDataPk = OtherDataPk from tblOtherData where RecordFk = @recordFk and OtherDataTypeFk = @otherDataTypeFk
		
		if (@otherDataPk is null)
		begin
			set @otherDataPk = newid()
			
			insert tblOtherData
			select @otherDataPk,
				@otherDataTypeFk,
				@recordFk,
				@xml, 
				@data,
				@user,
				getdate(),
				null, null					
		end
		else
		begin
			update tblOtherData
			set OtherDataTypeFk = @otherDataTypeFk,
				RecordFk = @recordFk,
				OtherDataXml = @Xml,
				OtherDataData = @data,
				UpdatedBy = @user,
				UpdatedDate = getdate()
			where OtherDataPk = @otherDataPk
		end
	end
	else
	begin
		update tblOtherData
		set OtherDataTypeFk = @otherDataTypeFk,
			RecordFk = @recordFk,
			OtherDataXml = @Xml,
			OtherDataData = @data,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where OtherDataPk = @otherDataPk
			
	end
	
	
	--all standard output for this name and type will point to this record
	update so
	set OtherDataFk = @otherDataPk
	from tblStandardOutput so	
	inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
	where pn.PNNameFk = @recordFk and so.OtherTypeFk = @otherDataTypeFk
	
	
	select * from tblOtherData where OtherDataPk = @otherDataPk

GO


GRANT EXEC ON sprInsertUpdate_OtherData TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AutonymIssues')
	BEGIN
		DROP  Procedure  sprSelect_AutonymIssues
	END

GO

CREATE Procedure sprSelect_AutonymIssues
as

	--find autonyms that are not accepted names but have "siblings" that are accepted => nomen. inconsistency
	select distinct n.NameGUID, n.NameFull, tr.RankName
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		   and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and pn.NamePreferredFk = pn.NameGUID and n.NamePreferredFk <> n.NameGUID
			and tr.RankSort > 4200
    
    --find autonyms that have no accepted concept and have no "siblings" that are accepted, then need to point to parent as the pref name
    select distinct n.NameGUID, n.NameFull, n.NameParentFk
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		   and not exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and n.NamePreferredFk is null
			and tr.RankSort > 4200
    
	--find names that have infraspecific child names but no autonym child
	select distinct n.NameGUID, n.NameFull, n.NameCanonical,
		cast((select distinct isnull(cast(infn.NameRankFk as varchar(10)) + ',','') as [text()] 
			from tblName infn
			where infn.NameParentFk = n.nameguid 
				and not exists(select n2.nameguid
					from tblName n2
					where n2.NameParentFk = n.NameGUID and
						infn.NameRankFk = n2.NameRankFk and
						CHARINDEX(n2.NameCanonical, n2.namefull, charindex(n2.NameCanonical, n2.namefull) + 1) <> 0)
			for xml path(''), type) as nvarchar(1000)) as Ranks
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName cn on cn.NameParentFk = n.NameGUID and cn.NameRankFk <> 24
	inner join tblRank ctr on ctr.RankPk = cn.NameRankFk
	left join (select n.nameguid, n.NameParentFk, tr.RankSort
		from tblName n
		inner join tblRank tr on tr.RankPk = n.NameRankFk
		where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			) can on can.NameParentFk = n.NameGUID and can.RankSort = ctr.ranksort
	where can.NameGUID is null and tr.RankSort = 4200
	
GO


GRANT EXEC ON sprSelect_AutonymIssues TO PUBLIC

GO
	
	IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameRank')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameRank
	END

GO

CREATE Procedure sprUpdate_ProviderNameRank
	@providerNamePk int,
	@user nvarchar(50)
AS

	--update ProviderNameRankFk to point to rank in tblRank table
	-- match on any of the known ranks for each rank
	
	exec sprInsert_ProviderNameChange @providerNamePk, @user
	
	declare  @pnRank nvarchar(100), @curRankFk int
	
	select @pnRank = rtrim(ltrim(lower(PNNameRank))), @curRankFk = PNNameRankFk
	from tblProviderName 
	where PNPk = @providerNamePk

	if (@curRankFk is not null) 
	begin
		select @curRankFk
		return
	end
	
	if (substring(@pnRank, len(@pnrank) - 1, 1) = '.')
	begin
		set @pnRank = SUBSTRING(@pnRank, 1, len(@pnRank) - 1)
	end
	
	declare @ranks table(Counter int identity, RankPk int, KnownRanks nvarchar(500))
		
	
	insert into @ranks
	select RankPk, '@' + RankKnownAbbreviations + '@'
	from tblRank
		
	declare @pos int, @count int, @abbrevs nvarchar(500), @pk int, @setRank int
	select @pos = 1, @count = count(*) from @ranks
	
	while (@pos < @count + 1)
	begin
		select @abbrevs = KnownRanks, @pk = RankPk from @ranks where Counter = @pos
		
		if (charindex('@' + @pnRank + '@', @abbrevs) <> 0)
		begin
			update tblProviderName 
			set PNNameRankFk = @Pk, PNUpdatedDate = getdate(), PNUpdatedBy = @user
			where PNPk = @providerNamePk
			
			set @setRank = @Pk
			set @count = -1 --end loop			
		end
		
		set @pos = @pos + 1
	end
	
	select @setRank
	
GO


GRANT EXEC ON sprUpdate_ProviderNameRank TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_Name')
	BEGIN
		DROP  Procedure  sprInsert_Name
	END

GO

CREATE Procedure sprInsert_Name
	@NameGUID uniqueidentifier, 
	@NameLSID nvarchar(300), 
	@NameFull nvarchar(300), 
	@NameRank nvarchar(50), 
	@NameRankFk int, 
	@NameParentFk uniqueidentifier,
	@NameParentName nvarchar(300),
	@NamePreferredFk uniqueidentifier,
	@NamePreferredName nvarchar(300),
	@NameCanonical nvarchar(300), 
	@NameAuthors nvarchar(300), 
	@NameBasionymAuthors nvarchar(300), 
	@NameCombinationAuthors nvarchar(300), 
	@NamePublishedIn nvarchar(1000), 
	@NameReferenceFk uniqueidentifier, 
	@NameYear nvarchar(20), 
	@NameMicroReference nvarchar(150), 
	@NameTypeVoucher ntext, 
	@NameTypeName nvarchar(300), 
	@NameTypeNameFk uniqueidentifier, 
	@NameOrthography nvarchar(300), 
	@NameBasionym nvarchar(300), 
	@NameBasionymFk uniqueidentifier, 
	@NameBasedOn nvarchar(300), 
	@NameBasedOnFk uniqueidentifier, 
	@NameConservedAgainst nvarchar(300), 
	@NameConservedAgainstFk uniqueidentifier, 
	@NameHomonymOf nvarchar(300), 
	@NameHomonymOfFk uniqueidentifier, 
	@NameReplacementFor nvarchar(300), 
	@NameReplacementForFk uniqueidentifier, 
	@nameBlocking nvarchar(300),
	@nameBlockingFk uniqueidentifier,
	@NameInCitation bit,
	@NameInvalid bit, 
	@NameIllegitimate bit, 
	@NameMisapplied bit, 
	@NameProParte bit, 
	@NameNomNotes nvarchar(2000), 
	@NameStatusNotes ntext,
	@NameNotes ntext,
	@NameCounter int,
	@user nvarchar(50)
AS

	if (@NameGuid is null) set @nameGuid = newid()
	
	insert tblName
	select @NameGUID, 
		@NameLSID, 
		@NameFull, 
		@NameRank, 
		@NameRankFk, 
		@NameParentFk,
		@NameParentName,
		@NamePreferredFk,
		@NamePreferredName,
		@NameCanonical, 
		@NameAuthors, 
		@NameBasionymAuthors, 
		@NameCombinationAuthors, 
		@NamePublishedIn, 
		@NameReferenceFk, 
		@NameYear, 
		@NameMicroReference, 
		@NameTypeVoucher, 
		@NameTypeName, 
		@NameTypeNameFk, 
		@NameOrthography, 
		@NameBasionym, 
		@NameBasionymFk, 
		@NameBasedOn, 
		@NameBasedOnFk, 
		@NameConservedAgainst, 
		@NameConservedAgainstFk, 
		@NameHomonymOf, 
		@NameHomonymOfFk, 
		@NameReplacementFor, 
		@NameReplacementForFk, 		
		@NameInCitation,
		@NameInvalid, 
		@NameIllegitimate, 
		@NameMisapplied, 
		@NameProParte, 		
		@NameNomNotes, 
		@NameStatusNotes,
		@NameNotes,
		getdate(), 
		@user, 
		null, null,
		@NameCounter,
		@nameBlocking,
		@nameBlockingFk

		
	--update flat name
    INSERT tblFlatName
    EXEC p_sprSelect_Name_ToRoot_003 @NameGuid


GO


GRANT EXEC ON sprInsert_Name TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_Name')
	BEGIN
		DROP  Procedure  sprUpdate_Name
	END

GO

CREATE Procedure sprUpdate_Name
	@NameGUID uniqueidentifier, 
	@NameLSID nvarchar(300), 
	@NameFull nvarchar(300), 
	@NameRank nvarchar(50), 
	@NameRankFk int, 
	@NameParentFk uniqueidentifier,
	@NameParentName nvarchar(300),
	@NamePreferredFk uniqueidentifier,
	@NamePreferredName nvarchar(300),
	@NameCanonical nvarchar(300), 
	@NameAuthors nvarchar(300), 
	@NameBasionymAuthors nvarchar(300), 
	@NameCombinationAuthors nvarchar(300), 
	@NamePublishedIn nvarchar(1000), 
	@NameReferenceFk uniqueidentifier, 
	@NameYear nvarchar(20), 
	@NameMicroReference nvarchar(150), 
	@NameTypeVoucher ntext, 
	@NameTypeName nvarchar(300), 
	@NameTypeNameFk uniqueidentifier, 
	@NameOrthography nvarchar(300), 
	@NameBasionym nvarchar(300), 
	@NameBasionymFk uniqueidentifier, 
	@NameBasedOn nvarchar(300), 
	@NameBasedOnFk uniqueidentifier, 
	@NameConservedAgainst nvarchar(300), 
	@NameConservedAgainstFk uniqueidentifier, 
	@NameHomonymOf nvarchar(300), 
	@NameHomonymOfFk uniqueidentifier, 
	@NameReplacementFor nvarchar(300), 
	@NameReplacementForFk uniqueidentifier, 
	@NameBlocking nvarchar(300),
	@NameBlockingFk uniqueidentifier,
	@NameInCitation bit,
	@NameInvalid bit, 
	@NameIllegitimate bit, 
	@NameMisapplied bit, 
	@NameProParte bit, 
	@NameNomNotes nvarchar(2000),  
	@NameStatusNotes ntext,
	@NameNotes ntext,
	@NameCounter int,
	@user nvarchar(50)
AS
	
	update tblName
	set NameLSID = @NameLSID, 
		NameFull = @NameFull, 
		NameRank = @NameRank, 
		NameRankFk = @NameRankFk, 
		NameParentFk = @NameParentFk,
		NameParent = @NameParentName,
		NamePreferredFk = @NamePreferredFk,
		NamePreferred = @NamePreferredName,
		NameCanonical = @NameCanonical, 
		NameAuthors = @NameAuthors, 
		NameBasionymAuthors = @NameBasionymAuthors, 
		NameCombinationAuthors = @NameCombinationAuthors, 
		NamePublishedIn = @NamePublishedIn, 
		NameReferenceFk = @NameReferenceFk, 
		NameYear = @NameYear, 
		NameMicroReference = @NameMicroReference, 
		NameTypeVoucher = @NameTypeVoucher, 
		NameTypeName = @NameTypeName, 
		NameTypeNameFk = @NameTypeNameFk, 
		NameOrthography = @NameOrthography, 
		NameBasionym = @NameBasionym, 
		NameBasionymFk = @NameBasionymFk, 
		NameBasedOn = @NameBasedOn, 
		NameBasedOnFk = @NameBasedOnFk, 
		NameConservedAgainst = @NameConservedAgainst, 
		NameConservedAgainstFk = @NameConservedAgainstFk, 
		NameHomonymOf = @NameHomonymOf, 
		NameHomonymOfFk = @NameHomonymOfFk, 
		NameReplacementFor = @NameReplacementFor, 
		NameReplacementForFk = @NameReplacementForFk, 
		NameBlocking = @NameBlocking,
		NameBlockingFk = @NameBlockingFk,
		NameInCitation = @NameInCitation,
		NameInvalid = @NameInvalid, 
		NameIllegitimate = @NameIllegitimate, 
		NameMisapplied = @NameMisapplied, 
		NameProParte = @NameProParte, 
		NameNomNotes = @NameNomNotes, 
		NameStatusNotes = @NameStatusNotes,
		NameNotes = @NameNotes,
		NameUpdatedDate = getdate(), 
		NameUpdatedBy = @user,
		NameCounter = @NameCounter
	where NameGuid = @NameGuid

	--name full
	update tblName
	set NameFull = dbo.fnGetFullName(NameGuid, 0, 0, 1, 0, 0)
	where NameGuid = @nameGuid
	
	--update flat name
    INSERT tblFlatName
    EXEC p_sprSelect_Name_ToRoot_003 @NameGuid

GO


GRANT EXEC ON sprUpdate_Name TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_DistributionTable')
	BEGIN
		DROP  Procedure  sprUpdate_DistributionTable
	END

GO

CREATE PROCEDURE [dbo].[sprUpdate_DistributionTable]
AS

	truncate table tblDistribution

	insert tblDistribution
	select distinct nameguid, 
		OD.data.value('./@L1', 'nvarchar(100)') as L1,
		OD.data.value('./@L2', 'nvarchar(100)') as L2,
		OD.data.value('./@L3', 'nvarchar(100)') as L3,
		OD.data.value('./@L4', 'nvarchar(100)') as L4,
		OD.data.value('./@region', 'nvarchar(100)') as Region, 
		OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence
	from 
	tblName n
	inner join tblOtherData on RecordFk = n.NameGUID 
	cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 

go

GRANT EXEC ON [sprUpdate_DistributionTable] TO PUBLIC

GO

if not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDistribution')
begin 
	CREATE TABLE [dbo].[tblDistribution](
		[NameGuid] [uniqueidentifier] NOT NULL,
		[L1] [nvarchar](100) NULL,
		[L2] [nvarchar](100) NULL,
		[L3] [nvarchar](100) NULL,
		[L4] [nvarchar](100) NULL,
		[GeoRegion] [nvarchar](200) NULL,
		[Occurrence] [nvarchar](50) NULL
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_NameGuid] ON [dbo].[tblDistribution] 
	(
		[NameGuid] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_Region] ON [dbo].[tblDistribution] 
	(
		[GeoRegion] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	exec sprupdate_distributiontable
end
go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherData')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherData
	END

GO

CREATE Procedure sprInsertUpdate_OtherData
	@otherDataPk uniqueidentifier,
	@otherDataTypeFk int,
	@recordFk nvarchar(300),
	@xml nvarchar(max),
	@data nvarchar(max),
	@user nvarchar(50)
AS

	if (@otherDataPk is null or not exists(select * from tblOtherData where OtherDataPk = @otherDataPk))
	begin
		--check if a record for this name and data type already exists
		select @otherDataPk = OtherDataPk from tblOtherData where RecordFk = @recordFk and OtherDataTypeFk = @otherDataTypeFk
		
		if (@otherDataPk is null)
		begin
			set @otherDataPk = newid()
			
			insert tblOtherData
			select @otherDataPk,
				@otherDataTypeFk,
				@recordFk,
				@xml, 
				@data,
				@user,
				getdate(),
				null, null					
		end
		else
		begin
			update tblOtherData
			set OtherDataTypeFk = @otherDataTypeFk,
				RecordFk = @recordFk,
				OtherDataXml = @Xml,
				OtherDataData = @data,
				UpdatedBy = @user,
				UpdatedDate = getdate()
			where OtherDataPk = @otherDataPk
		end
	end
	else
	begin
		update tblOtherData
		set OtherDataTypeFk = @otherDataTypeFk,
			RecordFk = @recordFk,
			OtherDataXml = @Xml,
			OtherDataData = @data,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where OtherDataPk = @otherDataPk
			
	end
	
	
	--all standard output for this name and type will point to this record
	update so
	set OtherDataFk = @otherDataPk
	from tblStandardOutput so	
	inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
	where pn.PNNameFk = @recordFk and so.OtherTypeFk = @otherDataTypeFk
	
	--update distribution table
	set arithabort on
	delete 	tblDistribution where nameguid = @recordFk

	insert tblDistribution
	select distinct recordFk, 
		OD.data.value('./@L1', 'nvarchar(100)') as L1,
		OD.data.value('./@L2', 'nvarchar(100)') as L2,
		OD.data.value('./@L3', 'nvarchar(100)') as L3,
		OD.data.value('./@L4', 'nvarchar(100)') as L4,
		OD.data.value('./@region', 'nvarchar(100)') as Region, 
		OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence
	from tblOtherData 
	cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 
	where RecordFk = @recordFk
	

	select * from tblOtherData where OtherDataPk = @otherDataPk

GO


GRANT EXEC ON sprInsertUpdate_OtherData TO PUBLIC

GO


