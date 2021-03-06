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
			and pn.NamePreferredFk = pn.NameGUID and (n.NamePreferredFk is null or n.NamePreferredFk <> n.NameGUID)
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
			and pn.NamePreferredFk is not null

	--find names that have infraspecific child names but no autonym child
	select distinct n.NameGUID, n.NameFull, n.NameCanonical, n.namebasionymauthors, n.namecombinationauthors,
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


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'v' AND name = 'vwDwcTaxon')
	BEGIN
		DROP  view  dbo.vwDwCTaxon
	END

GO

CREATE VIEW [dbo].[vwDwCTaxon]
	AS 	
select c.ConceptLSID as taxonID,
	NameLSID as scientificNameID,
	'urn:lsid:compositae.org:concepts:' + cast(prcr.ConceptRelationshipConcept2Fk as varchar(20)) as acceptedNameUsageID,
	NamePreferred as acceptedNameUsage,
	'urn:lsid:compositae.org:concepts:' + cast(pcr.ConceptRelationshipConcept2Fk as varchar(20)) as parentNameUsageID,
	NameParent as parentNameUsage,
	case when n.namebasionymfk is not null then
		(select top 1 ConceptLSID from tblconcept where ConceptName1Fk = n.NameBasionymFk) 
	when n.namereplacementforfk is not null then 
		(select top 1 ConceptLSID from tblconcept where ConceptName1Fk = n.namereplacementforfk) 
	else null end as originalNameUsageID,
	case when n.namebasionymfk is not null then n.NameBasionym 
		when n.namereplacementforfk is not null then n.namereplacementfor
	else null end as originalNameUsage,
	NameFull as scientificName,
	NamePublishedIn as namePublishedIn,
	NameReferenceFk,
	--c.ConceptAccordingToFk as nameAccordingToID,
	--c.ConceptAccordingTo as nameAccordingTo,
	(select top 1 p.ProviderName
		from tblProviderConceptRelationship pcr
		inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
		inner join tblprovider p on p.providerpk = pim.ProviderImportProviderFk
		where pcr.pcrconceptrelationshipfk = prcr.conceptrelationshipguid
		order by providerpreferredconceptranking) as nameAccordingTo,
	c.ConceptLSID as taxonConceptID,
	c.ConceptPk,
	'Plantae' as kingdom,
	'Compositae' as family,
	gn.flatnamecanonical as genus,
	sgn.flatnamecanonical as subgenus,
	sn.flatnamecanonical as specificEpithet,
	--isn.flatnamecanonical as infraspecificEpithet,
	case when r.ranksort > 4200 then n.namecanonical else '' end as infraspecificEpithet,
	r.RankName as TaxonRank,
	n.NameRank as VerbatimTaxonRank,
	n.NameAuthors as ScientificNameAuthorship,
	'ICBN' as NomenclaturalCode,
	case when n.namepreferredfk = n.nameguid then 'accepted' else 'synonym' end as TaxonomicStatus,
	case when n.nameinvalid = 1 then 'nom. inval.; ' else '' end +
	case when n.nameillegitimate = 1 then 'nom. illeg.; ' else '' end +
	case when n.namenomnotes is null then '' else n.namenomnotes end
	as NomenclaturalStatus,
	cast(n.NameNotes as nvarchar(4000)) as TaxonRemarks,
	n.NameUpdatedDate as Modified,
	'en' as Language,
	'All proprietary rights to the intellectual property in the Data remain with the Provider as its sole property. All proprietary rights to the intellectual property in the Combined Data remain with the Global Compositae Checklist project, The International Compositae Alliance and all Providers as their sole property.' as Rights,
	'Global Compositae Checklist, The International Compositae Alliance' as RightsHolder,
	'These data can be used with due attribution to Global Compositae Checklist and the data providers from which the data was sourced.' as AccessRights,
	'Flann, C (ed) 2009+ Global Compositae Checklist Accessed: [date]' as BibliographicCitation,
	'GCC' as DatasetID,
	'Global Compositae Checklist' as DatasetName,
	'http://lcrwebservices.landcareresearch.co.nz/compositaewebservice/ticachecklistservice.asmx/GetTICANameRecordTCS?ticaLSID=urn:lsid:compositae.org:names:' + CAST(n.nameguid as varchar(38)) as Source
from tblName n
inner join tblRank r on r.RankPk = n.NameRankFk
inner join tblConcept c on c.ConceptName1Fk = n.NameGUID
left join tblConceptRelationship prcr on prcr.ConceptRelationshipConcept1Fk = c.ConceptPk and prcr.ConceptRelationshipRelationshipFk = 15
left join tblConceptRelationship pcr on pcr.ConceptRelationshipConcept1Fk = c.ConceptPk and pcr.ConceptRelationshipRelationshipFk = 6
left join tblflatname gn on gn.flatnameseedname = n.NameGUID and gn.flatnamerankname = 'genus'
left join tblflatname sgn on sgn.flatnameseedname = n.NameGUID and sgn.flatnamerankname = 'subgenus'
left join tblflatname sn on sn.flatnameseedname = n.NameGUID and sn.flatnamerankname = 'species'
--left join tblflatname isn on isn.flatnameseedname = n.NameGUID and isn.flatnamerankname in 
--	('biovar','cultivar','forma','forma specialis','graft hybrid','hybrid formula','intergen hybrid','intragen hybrid','phagovar','pathovar','serovar','ß','subforma','subspecies','subvariety','variety','α','γ','δ','tax. infrasp.','nothosubspecies','nothovariety','lus','e','proles','[infrasp.unranked]','convar','race','pars.','nm.','mut.')

go

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
	
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier, isEditor bit)
	declare @isEd bit

	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	set @done = 0
	
	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk, pcr.ProviderIsEditor
		from tblName
		inner join vwProviderName pn on PNNameFk = NameGUID
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId 
				and (pcr.ProviderPk = pn.ProviderPk or pcr.provideriseditor = 1)
				and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		left join vwProviderName p2 on p2.PNNameId = pcr.PCName2Id 
				and (p2.ProviderPk = pcr.ProviderPk or p2.provideriseditor = 1)
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select COUNT(pnpk) from @recs where providerpk = @prefProv and isEditor = 1) = 1)
		begin
			select @prefFk = prefnamefk from @recs where providerpk = @prefProv
			return @preffk
		end

		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @isEd = iseditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv
			if (@isEd = 1)
			begin
				select @prefFk = prefnamefk from @recs where providerpk = @prefProv
				return @preffk
			end
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(distinct prefNameFk) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @isEd = iseditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv and ispref = 1
				if (@isEd = 1)
				begin
					select @prefFk = prefnamefk from @recs where providerpk = @prefProv
					return @preffk
				end
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
				
		if (@prefFk is null or @prefFk = @nameGuid) set @done = 1
		else
		begin
			set @allPrefNames = @allPrefNames + ' ' + cast(@prefFk as varchar(38)) + ' '
						
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk or
				charindex(' ' + cast(@prefpreffk as varchar(38)) + ' ', @allPrefNames) <> 0) 
					set @done = 1
			else 
			begin
				set @nameGuid = @prefPrefFk
				set @allPrefNames = @allPrefNames + ' ' + cast(@prefprefFk as varchar(38)) + ' '
			end
		end
	end
	
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid and nameguid <> namepreferredfk
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
	
	--check all names related to the same basionym
	-- get the highest ranking preferred name (ranking from provider table)
	-- of the set
	
	return @prefFk
end

GO


GRANT EXEC ON fnGetPreferredName TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredNameReason')
	BEGIN
		DROP  Function  fnGetPreferredNameReason
	END

GO

CREATE Function fnGetPreferredNameReason
(
	@nameGuid uniqueidentifier
)
returns nvarchar(200)
AS
begin
	--get the reason the preferred name has been set
	
	declare @reason nvarchar(200)
		
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier, isEditor bit)
	declare @isEd bit

	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	set @done = 0
	set @reason = 'Unknown'

	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk, pcr.provideriseditor
		from tblName
		inner join vwProviderName pn on PNNameFk = NameGUID
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId 
				and (pcr.ProviderPk = pn.ProviderPk or pcr.provideriseditor = 1)
				and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		left join vwProviderName p2 on p2.PNNameId = pcr.PCName2Id 
				and (p2.ProviderPk = pcr.ProviderPk or p2.provideriseditor = 1)
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select COUNT(pnpk) from @recs where providerpk = @prefProv and isEditor = 1) = 1)
		begin
			set @reason = 'Editor Record'
			return @reason		
		end
		
		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @isEd = isEditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv
			set @reason = 'Most Preferred Provider'
			if (@isEd = 1) 
			begin
				set @reason = 'Editor Record'
				return @reason
			end
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(*) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @prefFk = prefnamefk, @isEd = isEditor from @recs where providerpk = @prefProv and ispref = 1
				if (@prefFk is not null) set @reason = 'Most Preferred Provider Concept'
				if (@isEd = 1) 
				begin
					set @reason = 'Editor Record'
					return @reason
				end
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				

				if (@prefFk is not null) set @reason = 'Most Recent Provider Concept'
			end
		end
				
		if (@prefFk is null or @prefFk = @nameGuid) set @done = 1
		else
		begin
			set @allPrefNames = @allPrefNames + ' ' + cast(@prefFk as varchar(38)) + ' '
						
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk or
				charindex(' ' + cast(@prefpreffk as varchar(38)) + ' ', @allPrefNames) <> 0) 
					set @done = 1
			else 
			begin
				set @nameGuid = @prefPrefFk
				set @allPrefNames = @allPrefNames + ' ' + cast(@prefprefFk as varchar(38)) + ' '
				set @reason = 'Preferred Name of Preferred Name'
			end
		end
	end
	
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid and nameguid <> namepreferredfk

		if (@prefFk is not null) set @reason = 'Names point to this name as preferred name'
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
			set @reason = 'A child name is an accepted name'
		end
	end
	
	--check all names related to the same basionym
	-- get the highest ranking preferred name (ranking from provider table)
	-- of the set
	
	return @reason
end

GO


GRANT EXEC ON fnGetPreferredNameReason TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Name')
	BEGIN
		DROP  Procedure  sprSelect_Name
	END

GO

CREATE Procedure dbo.sprSelect_Name
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
		dbo.fngetpreferrednamereason(NameGuid) as NamePreferredReason,
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


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ConceptRelationship')
	BEGIN
		DROP  Procedure  dbo.sprInsert_ConceptRelationship
	END

GO

CREATE Procedure dbo.sprInsert_ConceptRelationship
	@PCRPk int,
	@user nvarchar(50),
	@conceptRelGuid uniqueidentifier output
AS 
	--inserts a ConceptRelationship if an equivalent doesnt already exist
	-- inserts Concepts for the relationship if they dont exist
	-- if the PCR was already pointing at a consensus CR then it may need to be unlinked

	declare @concept1Id nvarchar(300), @concept2Id nvarchar(300), @providerPk int
	declare @relationship nvarchar(300), @relationshipFk int, @oldCRGuid uniqueidentifier
	declare @hybridOrder int
	declare @name1 nvarchar(4000), @name2 nvarchar(4000) 
	declare @accordingTo nvarchar(4000) 
	declare @name1Fk uniqueidentifier, @name2Fk uniqueidentifier, @accToFk uniqueidentifier
	declare @PCPk1 int, @PCPk2 int
	declare @conceptPk int, @conceptToPk int
	declare @pcLinkStatus nvarchar(20), @pcToLinkStatus nvarchar(20), @pcrLinkStatus nvarchar(20)
	declare @oldLSID nvarchar(300), @newLSID nvarchar(300)
	set @pcLinkStatus = 'Matched'
	set @pcToLinkStatus = 'Matched'
	set @pcrLinkStatus = 'Matched'
		
	select @concept1Id = PCRConcept1Id, @concept2Id = PCRConcept2Id, @relationship = PCRRelationship,
		@relationshipFk = PCRRelationshipFk, @hybridOrder = PCRHybridOrder, @providerPk = ProviderPk,
		@oldCRGuid = PCRConceptRelationshipFk
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk
	
	--get fks for names and ref (the ProviderName and Providerref Ids are passed into this SP)
	select @name1Fk = PNNameFk, @name1 = NameFull, @PCPk1 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
	
	select @name2Fk = PNNameFk, @name2 = NameFull, @PCPk2 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept2Id and pc.ProviderPk = @providerPk
	
	select @accToFk = PRReferenceFk, @accordingto = PCAccordingTo
	from vwProviderReference pr
	inner join vwProviderConcept pc on (pc.ProviderPk = pr.ProviderPk or pc.provideriseditor = 1) and pc.PCAccordingToId = pr.PRReferenceId
	where pc.PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
		
	--only insert if names have been inserted
	-- or name 2 is null, for non-parent rels (eg pref name pointing to 'nothing')
	if (@name1Fk is not null and (@name2Fk is not null or @relationshipFk <> 6))
	begin
		
		declare @tmpId uniqueidentifier
		set @tmpId = newid()
		
		select top 1 @conceptPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name1Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
		
		select top 1 @conceptToPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name2Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
			
		if (@conceptPk is null)
		begin
			insert tblConcept
			select null,
				@name1,
				@name1Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptPk = @@identity
			set @pcLinkStatus = 'Inserted'
		end
		
		if (@conceptToPk is null and @name2Fk is not null)
		begin
			insert tblConcept
			select null,
				@name2,
				@name2Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptToPk = @@identity
			set @pcToLinkStatus = 'Inserted'
		end
		
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptPk as nvarchar(20))
		where ConceptPk = @conceptPk
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptToPk as nvarchar(20))
		where ConceptPk = @conceptToPk
		
		
		--insert concept relationship?
			
		select top 1 @conceptRelGuid = ConceptRelationshipGuid 
		from tblConceptRelationship 
		where ConceptRelationshipConcept1Fk = @conceptPk and isnull(ConceptRelationshipConcept2Fk,0) = isnull(@conceptToPk,0)
			and ConceptRelationshipRelationshipFk = @relationshipFk
		
		if (@conceptRelGuid is null)
		begin
			set @conceptRelGuid = newid()	
		
			insert tblConceptRelationship
			select @conceptRelGuid, 'urn:lsid:compositae.org:concept-relationship:' + cast(@conceptRelGuid as varchar(38)), 
				@conceptPk, @conceptToPk, @relationship, @relationshipFk, @hybridorder, 
				getdate(), @user, null, null
				
			set @pcrLinkStatus = 'Inserted'
		end	
				
		--set provider Fks to point to consensus records
		update tblProviderConceptRelationship
		set PCRConceptRelationshipFk = @conceptRelGuid, PCRLinkStatus = @pcrLinkStatus, PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
		where PCRPk = @PCRPk
		
		update tblProviderConcept
		set PCConceptFk = @conceptPk, PCLinkStatus = @pcLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk1
		
		update tblProviderConcept
		set PCConceptFk = @conceptToPk, PCLinkStatus = @pcToLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk2
			
		--delete old concept rel?
		if (@oldCRGuid is not null and not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
		begin			
			select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid
			select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @conceptRelGuid

			exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
		end
			
		--if this is a parent or preferred concept then update the assoc. tblname fields
		if (@relationshipFk = 6 or @relationshipFk = 15)
		begin
			exec sprUpdate_NameRelationData @name1Fk, @user
		end
		
	end
	else
	begin
		--unlink?
		if (@oldCRGuid is not null)
		begin
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = null, PCRLinkStatus = 'Unmatched', PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
			where PCRPk = @PCRPk
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk1
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk2
			
			--delete old concept rel?
			if (not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
			begin				
				select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid

				exec sprDelete_ConceptRelationship @oldLSID, 'Unlinked', @user
			end
		end
	end
	
	
	select cast(ConceptRelationshipgUID as varchar(38)) as ConceptRelationshipGuid,
		ConceptRelationshipLSID,
		ConceptRelationshipConcept1Fk,
		ConceptRelationshipConcept2Fk,
		ConceptRelationshipRelationship,
		ConceptRelationshipRelationshipFk,
		ConceptRelationshipHybridOrder,
		ConceptRelationshipCreatedDate,
		ConceptRelationshipCreatedBy,
		ConceptRelationshipUpdatedDate,
		ConceptRelationshipUpdatedBy
	from tblConceptRelationship 
	where ConceptRelationshipGuid = @conceptRelGuid 

GO


GRANT EXEC ON dbo.sprInsert_ConceptRelationship TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameConceptLinks')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameConceptLinks
	END

GO

CREATE Procedure sprUpdate_ProviderNameConceptLinks
	@PNPk int,
	@user nvarchar(50)
AS

	--update consensus concept name links to point to the correct names
	--this will be done after a provider name has been linked, so the concepts need to follow the link
	-- this sp is called when there was no previous PCName1Fk, ie first link up, so we cannot update the 
	-- links based on Name1Fk

	declare @updates table(counter int identity, nameGuid uniqueidentifier)
	
	insert @updates
	select distinct c.ConceptName1Fk 
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.pcpk = pc.pcpk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc2.ProviderPk
	where pn.PNPk = @PNPk
	
	insert @updates
	select distinct ConceptName1Fk 
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = pcr.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc2.ProviderPk
	where pn.PNPk = @PNPk and not exists(select * from @updates where nameGuid = c.ConceptName1Fk)
	
	
	--do updates 
	
	update c
	set ConceptName1Fk = pn.PNNameFk,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @PNPk
	
	update c
	set ConceptName1Fk = pn.PNNameFk,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = pcr.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @PNPk


	--return all affected names
	select nameguid from @updates

GO


GRANT EXEC ON sprUpdate_ProviderNameConceptLinks TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptLinks')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptLinks
	END

GO

CREATE Procedure sprUpdate_ConceptLinks
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update concept name links to point to the correct names
	--this will be done after a provider name has been relinked, or unliniked, 
	--	so the concepts need to follow the relink

	declare @updates table(counter int identity, PCRPk int)
		
	insert @updates
	select distinct PCRPk
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	where c.ConceptName1Fk = @nameGuid 
	union
	select distinct PCRPk
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = pc.PCConceptId and pcr.ProviderPk = pc.ProviderPk
	left join vwProviderConcept pc2 on pc2.PCPk = pcr.PCPK 
	where c.ConceptName1Fk = @nameGuid 
	
	declare @conceptPk int, @conceptToPk int, @pos int, @count int, @crid uniqueidentifier
	declare @provPk int, @concept1Id nvarchar(300), @concept2Id nvarchar(300)
	declare @PCRPk int
	declare @oldCRID uniqueidentifier, @newCRID uniqueidentifier, @oldLSID nvarchar(300), @newLSID nvarchar(300)
	declare @name1Fk uniqueidentifier, @name2Fk uniqueidentifier
	
	select @pos = 1, @count = count(*) from @updates
	
	while (@pos <= @count)
	begin
		select @provPk = ProviderPk, @PCRPk = pcr.PCRPk, @oldCRID = PCRConceptRelationshipFk
		from vwProviderConceptRelationship pcr
		inner join @updates u on u.PCRPk = pcr.PCRPk
		where u.counter = @pos
		
		select @name1Fk = PNNamefk
		from vwProviderName pn
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId and pn.ProviderPk = pcr.ProviderPk
		where PCRPk = @PCRPk
		
		select @name2Fk = PNNamefk
		from vwProviderName pn
		inner join vwProviderConceptRelationship pcr on pcr.PCName2Id = pn.PNNameId and pn.ProviderPk = pcr.ProviderPk
		where PCRPk = @PCRPk

		if (@name1Fk is not null and @name2Fk is not null)
		begin
			--insert/update concept for these provider details
			exec sprInsert_ConceptRelationship @PCRPk, @user, @newCRID output
			
			--delete old concept rel?
			if (@oldCRID is not null and (not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRID)))
			begin
				select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRID
				select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @newCRID

				exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
			end
		end
		
		set @pos = @pos + 1
	end
		
	
GO


GRANT EXEC ON sprUpdate_ConceptLinks TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameConcepts')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNameConcepts
	END

GO

CREATE Procedure sprSelect_ProviderNameConcepts
	@pnpk int
AS
	
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
		left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		where pn.PNPk = @PNPk
		union
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = pc.PCConceptId and pcr.ProviderPk = pc.ProviderPk
		left join vwProviderConcept pc2 on pc2.PCPk = pcr.PCPK 
		where pn.PNPk = @PNPk

GO


GRANT EXEC ON sprSelect_ProviderNameConcepts TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptData')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderConceptData
	END

GO

CREATE Procedure dbo.sprSelect_ProviderConceptData
	@pnpk int
AS
	--get concepts to and from this provider name
	
	--from
	select pn.PNPk, pc.* 
	from vwProviderConcept pc
	inner join vwProviderConcept vpc on vpc.PCPk = pc.PCPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	where PNPk = @pnpk	
	union	
	--to
	select pn.PNPk, pc.* 
	from vwProviderName pn
	inner join vwProviderConcept vpc on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	inner join vwProviderConceptRelationship vpcr on vpcr.PCRConcept1Id = vpc.PCConceptId and vpcr.ProviderPk = vpc.ProviderPk
	inner join vwProviderConcept pc on pc.PCConceptId = vpcr.PCRConcept2Id and pc.ProviderPk = vpcr.ProviderPk
	where PNPk = @pnpk
	
	--from
	select vpc.PCPk,
		pcr.PCRPk,
		pc2.PCPk as PCPk2, 
		pcr.PCRProviderImportFk, 
		pcr.PCRLinkStatus, 
		pcr.PCRMatchScore, 
		cast(pcr.PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		pcr.PCRConcept1Id, 
		pcr.PCRConcept2Id, 
		pcr.PCRIsPreferredConcept, 
		pcr.PCRId, 
		pcr.PCRRelationship, 
		pcr.PCRRelationshipId, 
		pcr.PCRRelationshipFk, 
		pcr.PCRHybridOrder, 
		pcr.PCRVersion, 
		pcr.PCRCreatedDate, 
		pcr.PCRCreatedBy, 
		pcr.PCRUpdatedDate, 
		pcr.PCRUpdatedBy
	from vwProviderConceptRelationship pcr 
	inner join vwProviderConcept vpc on vpc.PCPk = pcr.PCPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	inner join vwProviderConcept pc2 on pc2.ProviderPk = pcr.ProviderPk and pc2.PCConceptId = pcr.PCRConcept2Id
	where PNPk = @pnpk
	union
	--to	
	select vpc.PCPk,
		pcr.PCRPk, 
		pc2.PCPk as PCPk2, 
		pcr.PCRProviderImportFk, 
		pcr.PCRLinkStatus, 
		pcr.PCRMatchScore, 
		cast(pcr.PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		pcr.PCRConcept1Id, 
		pcr.PCRConcept2Id, 
		pcr.PCRIsPreferredConcept, 
		pcr.PCRId, 
		pcr.PCRRelationship, 
		pcr.PCRRelationshipId, 
		pcr.PCRRelationshipFk, 
		pcr.PCRHybridOrder, 
		pcr.PCRVersion, 
		pcr.PCRCreatedDate, 
		pcr.PCRCreatedBy, 
		pcr.PCRUpdatedDate, 
		pcr.PCRUpdatedBy
	from vwProviderConceptRelationship pcr 
	inner join vwProviderConcept vpc on vpc.PCConceptId = pcr.PCRConcept2Id and vpc.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk 
	where PNPk = @pnpk

GO


GRANT EXEC ON dbo.sprSelect_ProviderConceptData TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRelationshipsForCR')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRelationshipsForCR
	END

GO

CREATE Procedure sprSelect_ProviderConceptRelationshipsForCR
	@CRGuid uniqueidentifier
AS

	select pcr.*, pc1.PCConceptFk as PCConcept1Fk, pc2.PCConceptFk as PCConcept2Fk
	from vwProviderConceptRelationship pcr
	inner join vwProviderConcept pc1 on pc1.PCConceptId = pcr.PCRConcept1Id and pc1.ProvideRPk = pcr.ProviderPk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProvideRPk = pcr.ProviderPk
	where PCRConceptRelationshipFk = @CRGuid and PCRLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_ProviderConceptRelationshipsForCR TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportStatistics')
	BEGIN
		DROP  Procedure  sprSelect_ReportStatistics
	END

GO

CREATE Procedure sprSelect_ReportStatistics
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	declare @total int, @guidValid int, @confCount int, @unlinked int, @provCount int, @compl real
	declare @sysCount int

	declare @ranks table(row int identity, id int, rankname nvarchar(255))
	insert @ranks
	select rankpk, rankname 
	from tblrank
	order by ranksort
	
	select @provCount = count(*)
	from tblProviderName 
	where PNLinkStatus <> 'Discarded'
	
	/*select @provCount = @provCount + count(*)
	from tblProviderConcept
	where PCLinkStatus <> 'Discarded'
	
	select @provCount = @provCount + count(*)
	from tblProviderReference
	where PRLinkStatus <> 'Discarded'*/
	
	insert @res select null, 'Total Provider Records : ' + cast(@provCount as nvarchar(100)), null, null

	select @sysCount = count(*)
	from vwProviderName
	where ProviderName = 'SYSTEM'
	insert @res select null, 'Total SYSTEM Records : ' + cast(@sysCount as nvarchar(100)), null, null

	--editor records
	select @sysCount = count(*)
	from vwProviderName
	where ProviderIsEditor = 1
	insert @res select null, 'Total Editor Records : ' + cast(@sysCount as nvarchar(100)), null, null

	
	--total cons. names
	select @total = count(*) from tblname where NameFull <> 'root'
	
	insert @res select null, 'Total consensus Names : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	declare @pos int, @rankname nvarchar(200), @rankid int
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid
		
		if (@total > 0)
			insert @res select null, 'Total consensus Names (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--total accepted names
	select @total = count(*) from tblname where NameFull <> 'root'
		and namepreferredfk = nameguid
	
	insert @res select null, 'Total accepted Names : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid 
			and namepreferredfk = nameguid
		
		if (@total > 0)
			insert @res select null, 'Total accepted Names (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--total synonyms
	select @total = count(*) from tblname where NameFull <> 'root'
		and namepreferredfk <> nameguid
	
	insert @res select null, 'Total synonyms : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid 
			and namepreferredfk <> nameguid
		
		if (@total > 0)
			insert @res select null, 'Total synonyms (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	--average prov names
	declare @avg int
	select @avg = avg(res.c) from (select count(pnpk) as c
		from tblname 
		inner join tblprovidername on pnnamefk = nameguid
		group by nameguid) res
		
	
	insert @res select null, 'Total average prov. names : ' + cast(@avg as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @avg = avg(res.c) from (select count(pnpk) as c
			from tblname 
			inner join tblprovidername on pnnamefk = nameguid
			where namerankfk = @rankid
			group by nameguid) res
		
		if (@total > 0)
			insert @res select null, 'Total average prov. names (at Rank ' + @rankname + ') : ' + cast(@avg as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	--average synonyms
	select @avg = avg(res.c) from (select count(s.nameguid) as c
		from tblname n
		inner join tblname s on s.namepreferredfk = n.nameguid
		where n.namepreferredfk = n.nameguid
		group by n.nameguid) res
	
	insert @res select null, 'Total average prov. names : ' + cast(@avg as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @avg = avg(res.c) from (select count(s.nameguid) as c
			from tblname n
			inner join tblname s on s.namepreferredfk = n.nameguid
			where n.namepreferredfk = n.nameguid and n.namerankfk = @rankid			
			group by n.nameguid) res
		
		if (@total > 0)
			insert @res select null, 'Total average prov. names (at Rank ' + @rankname + ') : ' + cast(@avg as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--AUTHORS - TODO - check they are correct
	select @total = count(nameguid)
	from tblname
	inner join tblnameauthors on nameauthorsnamefk = nameguid
	inner join tblprovidername on pnnamefk = nameguid
	inner join tblprovidernameauthors on pnaprovidernamefk = pnpk
	where isnull(nameauthorsbasionymauthors,'') <> isnull(pnabasionymauthors,'')
		or isnull(nameauthorscombinationauthors,'') <> isnull(pnacombinationauthors,'')
	
	insert @res select null, 'Total names with corrected authors : ' + cast(@total as nvarchar(100)), null, null
	
	
	select @total = count(n.nameguid)	
	/*select n.nameguid, n.namefull, n.namecanonical, par.namefull as Parent, 
		pn.pnnamefull, pn.pnnamecanonical, pn2.pnnamefull as provParent*/
	from tblname n
	inner join tblName par on par.nameguid = n.nameparentfk
	inner join vwprovidername pn on pn.pnnamecanonical = n.namecanonical and pn.pnnamerankfk = n.namerankfk
	inner join vwproviderconceptrelationship pcr on pcr.pcname1id = pn.pnnameid 
		and pcr.providerpk = pn.providerpk
	inner join vwprovidername pn2 on pn2.pnnameid = pcr.pcname2id 
		and pn2.providerpk = pcr.providerpk
	where pn2.pnnamecanonical = par.namecanonical and pn2.pnnamerankfk = par.namerankfk
		and pn.pnnamefk <> n.nameguid and n.nameauthors <> pn.pnnameauthors
	
	insert @res select null, 'Total names with un-corrected authors : ' + cast(@total as nvarchar(100)), null, null
	
	
	--number of homonyms
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(n.nameguid) / 2
			from tblname n
			inner join tblname p on p.nameguid = n.nameparentfk
			inner join tblname n2 on n2.namecanonical = n.namecanonical and n2.nameguid <> n.nameguid
			inner join tblname p2 on p2.nameguid = n2.nameparentfk and p2.namecanonical = p.namecanonical
			where n.namerankfk = @rankid and n2.namerankfk = @rankid
		
		insert @res select null, 'Total homonyms (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--names with dist. data
	
	select @total = count(distinct nameguid)
	from tblname 
	inner join tblotherdata on recordfk = nameguid
	where otherdatatypefk = 2	
	
	insert @res select null, 'Number of names with distribution data : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(otherdatapk)
			from tblname n
			inner join tblotherdata on recordfk = nameguid
			where n.namerankfk = @rankid and otherdatatypefk = 2
		
		insert @res select null, 'Total count of distribution data (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--concept conflicts	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(n.nameguid)
		from tblname n
		inner join tblconcept c1 on c1.conceptname1fk = n.nameguid
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk
		left join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where conceptrelationshiprelationship = 'is child of' 
			and c2.conceptname1fk <> nameparentfk
			and n.namerankfk = @rankid 
			
		select @total = @total + count(n.nameguid)
		from tblname n
		inner join tblconcept c1 on c1.conceptname1fk = n.nameguid
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk
		left join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where conceptrelationshiprelationship = 'has preferred name' 
			and c2.conceptname1fk <> namepreferredfk
			and n.namerankfk = @rankid 
		
		insert @res select null, 'Total names with concept conflict (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportStatistics TO PUBLIC

GO


  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_MergedReferenceLinks')
	BEGIN
		DROP  Procedure  sprUpdate_MergedReferenceLinks
	END

GO

CREATE Procedure sprUpdate_MergedReferenceLinks
	@referenceGuid uniqueidentifier,
	@mergedReferenceGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--merge any concepts that are now equivalent because of the merged refs
	--update any namereferencefks to point at new reference
	
	declare @concepts table(conceptPk1 int, conceptPk2 int, row int identity)
	declare @rels table(relGuid1 uniqueidentifier, relGuid2 uniqueidentifier, row int identity)
	
	declare @crpk1 uniqueidentifier, @crpk2 uniqueidentifier
		
	insert @concepts
	select distinct c.ConceptPk, c2.ConceptPk
	from tblConcept c
	inner join tblConcept c2 on c2.ConceptName1Fk = c.ConceptName1Fk and c.ConceptPk <> c2.ConceptPk
	where c.ConceptAccordingToFk = @referenceGuid and c2.ConceptAccordingToFk = @mergedReferenceGuid
	
	declare @pos int, @count int, @cpk1 int, @cpk2 int
	declare @oldLSID nvarchar(300), @newLSID nvarchar(300)
	
	select @pos = 1, @count = count(*) from @concepts
	
	while (@pos <= @count)
	begin
		select @cpk1 = conceptPk1, @cpk2 = conceptPk2 from @concepts where row = @pos
		
		update tblProviderConcept
		set PCConceptFk = @cpk1, PCLinkStatus = 'Merge', PCUpdatedDate = getdate(), PCUpdatedBy = @user		
		where PCConceptFk = @cpk2
		
		update tblConceptRelationship
		set ConceptRelationshipConcept1Fk = @cpk1, 
			ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user		
		where ConceptRelationshipConcept1Fk = @cpk2
		
		update tblConceptRelationship
		set ConceptRelationshipConcept2Fk = @cpk1, 
			ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user		
		where ConceptRelationshipConcept2Fk = @cpk2
		
		select @newLSID = ConceptLSID from tblConcept where ConceptPk = @cpk1
		select @oldLSID = ConceptLSID from tblConcept where ConceptPk = @cpk2
		
		exec sprDelete_Concept @oldLSID, @newLSID, @user
		
		
		--now merge any concept relationships that are now equivalent because of the merges
		
		delete @rels
				
		insert @rels
		select distinct 
			case when (cr.ConceptRelationshipGuid > cr2.ConceptRelationshipGuid) then cr.ConceptRelationshipGuid else cr2.ConceptRelationshipGuid end,
			case when (cr.ConceptRelationshipGuid > cr2.ConceptRelationshipGuid) then cr2.ConceptRelationshipGuid else cr.ConceptRelationshipGuid end
		from tblConceptRelationship cr
		inner join tblConceptRelationship cr2 on cr2.ConceptRelationshipConcept1Fk = cr.ConceptRelationshipConcept1Fk 
			and cr2.ConceptRelationshipConcept2Fk = cr.ConceptRelationshipConcept2Fk 
			and cr2.ConceptRelationshipRelationshipFk = cr.ConceptRelationshipRelationshipFk
			and isnull(cr2.ConceptRelationshipHybridOrder, '') = isnull(cr.ConceptRelationshipHybridOrder, '')
			and cr2.ConceptRelationshipGuid <> cr.ConceptRelationshipGuid
		where cr.ConceptRelationshipConcept1Fk = @cpk1 or cr2.ConceptRelationshipConcept1Fk = @cpk1 
		
		declare @relPos int, @relCount int
		select @relPos = 1, @relCount = count(*) from @rels
		
		while (@relPos <= @relCount)
		begin
			select @crpk1 = relGuid1, @crpk2 = relGuid2 from @rels where row = @relPos
			
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = @crpk1, PCRLinkStatus = 'Merge', PCRUpdatedDate = getdate(), PCRUpdatedBy = @user		
			where PCRConceptRelationshipFk = @crpk2
					
			select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @crpk1
			select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @crpk2
			
			exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
			
			set @relPos = @relPos + 1
		end
	
		set @pos = @pos + 1
	end
	
		
	--update namereferencefks
	update tblname
	set NameReferenceFk = @referenceGuid,
		NamePublishedIn = (select ReferenceCitation from tblReference where ReferenceGuid = @referenceGuid)
	where NameReferenceFk = @mergedReferenceGuid
	
	update tblprovidername
	set PNReferenceFk = @referenceGuid,
		PNPublishedIn = (select ReferenceCitation from tblReference where ReferenceGuid = @referenceGuid)
	where PNReferenceFk = @mergedReferenceGuid
	

GO


GRANT EXEC ON sprUpdate_MergedReferenceLinks TO PUBLIC

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
	left join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept1fk
	inner join @names n on n.nameguid = c.conceptname1fk
	where c.conceptname1fk <> c2.conceptname1fk 
	
	insert @moreNames
	select distinct c.conceptname1fk
	from tblconcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept1fk = c.conceptpk
	left join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept2fk
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


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameConceptRelationships')
	BEGIN
		DROP  Procedure  sprSelect_NameConceptRelationships
	END

GO

CREATE Procedure sprSelect_NameConceptRelationships
	@nameGuid uniqueidentifier,
	@incToConcepts bit
AS

	if (@incToConcepts = 1)
	begin
		select distinct cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
			cr.ConceptRelationshipConcept1Fk,
			cr.ConceptRelationshipConcept2Fk,
			cr.ConceptRelationshipRelationship,
			cr.ConceptRelationshipRelationshipFk,
			c.ConceptName1, 
			cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
			cto.ConceptName1 as ConceptToName1, 
			cast(cto.ConceptName1Fk as varchar(38)) as ConceptToName1Fk, 
			c.ConceptAccordingTo, 
			cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk,
			cto.ConceptAccordingTo as ConceptToAccordingTo,
			cast(cto.ConceptAccordingToFk as varchar(38)) as ConceptToAccordingToFk,
			cr.ConceptRelationshipHybridOrder,
			cr.ConceptRelationshipLSID
		from tblConceptRelationship cr
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		left join tblConcept cto on cto.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where c.ConceptName1Fk = @nameGuid
		union		
		select distinct cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
			cr.ConceptRelationshipConcept1Fk,
			cr.ConceptRelationshipConcept2Fk,
			cr.ConceptRelationshipRelationship,
			cr.ConceptRelationshipRelationshipFk,
			c.ConceptName1, 
			cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
			cto.ConceptName1 as ConceptToName1, 
			cast(cto.ConceptName1Fk as varchar(38)) as ConceptToName1Fk, 
			c.ConceptAccordingTo, 
			cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk,
			cto.ConceptAccordingTo as ConceptToAccordingTo,
			cast(cto.ConceptAccordingToFk as varchar(38)) as ConceptToAccordingToFk,
			cr.ConceptRelationshipHybridOrder,
			cr.ConceptRelationshipLSID
		from tblConceptRelationship cr
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		left join tblConcept cto on cto.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where cto.ConceptName1Fk = @nameGuid
		order by cr.ConceptRelationshipRelationshipFk
	end
	else
	begin		
		select cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
			cr.ConceptRelationshipConcept1Fk,
			cr.ConceptRelationshipConcept2Fk,
			cr.ConceptRelationshipRelationship,
			cr.ConceptRelationshipRelationshipFk,
			c.ConceptName1, 
			cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
			cto.ConceptName1 as ConceptToName1, 
			cast(cto.ConceptName1Fk as varchar(38)) as ConceptToName1Fk, 
			c.ConceptAccordingTo, 
			cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk,
			cto.ConceptAccordingTo as ConceptToAccordingTo,
			cast(cto.ConceptAccordingToFk as varchar(38)) as ConceptToAccordingToFk,
			cr.ConceptRelationshipHybridOrder,
			cr.ConceptRelationshipLSID
		from tblConceptRelationship cr
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		left join tblConcept cto on cto.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where c.ConceptName1Fk = @nameGuid		
		order by cr.ConceptRelationshipRelationshipFk, cto.ConceptName1
	end
	
GO

	
GRANT EXEC ON sprSelect_NameConceptRelationships TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptRelationshipMatches')
	BEGIN
		DROP  Procedure  sprSelect_ConceptRelationshipMatches
	END

GO

CREATE Procedure sprSelect_ConceptRelationshipMatches
	@PCRPk int
AS

	declare @name1Id nvarchar(300), @name2Id nvarchar(300), @relFk int, @accToId nvarchar(4000), @accToFk uniqueidentifier
	declare @name2Fk uniqueidentifier, @name1Fk uniqueidentifier, @provPk int
		
	
	select @name1Id = pcr.PCName1Id, @name2Id = pcr.PCName2Id, @relFk = PCRRelationshipFk, @accToId = pc.PCAccordingToId,
		@provPk = pcr.ProviderPk
	from vwProviderConceptRelationship pcr
	inner join tblProviderConcept pc on pc.PCPk = pcr.PCPk
	where PCRPk = @PCRPk
	
	select @name1Fk = PNNameFk from vwProviderName where PNNameId = @name1Id and ProviderPk = @provPk
	select @name2Fk = PNNameFk from vwProviderName where PNNameId = @name2Id and ProviderPk = @provPk
	select @accToFk = PRReferenceFk from tblProviderReference where PRReferenceId = @accToId
		
	if (@name2Fk is not null and @relFk is not null)
	begin
		select cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
			cr.ConceptRelationshipConcept1Fk,
			cr.ConceptRelationshipConcept2Fk,
			cr.ConceptRelationshipRelationship,
			cr.ConceptRelationshipRelationshipFk,
			c1.ConceptName1, 
			c1.ConceptName1Fk, 
			c2.ConceptName1 as ConceptToName1, 
			c2.ConceptName1Fk as ConceptToName1Fk, 
			c1.ConceptAccordingTo, 
			c1.ConceptAccordingToFk, 
			c2.ConceptAccordingTo as ConceptToAccordingTo,
			c2.ConceptAccordingToFk as ConceptToAccordingToFk,
			cr.ConceptRelationshipHybridOrder,
			cr.ConceptRelationshipLSID
		from tblConceptRelationship cr
		inner join tblConcept c1 on c1.ConceptPk = cr.ConceptRelationshipConcept1Fk
		left join tblConcept c2 on c2.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where c1.ConceptName1Fk = @name1Fk and isnull(cast(c2.ConceptName1Fk as varchar(38)),'') = cast(@name2Fk as varchar(38))
				and ConceptRelationshipRelationshipFk = @relFk and 
				((@accToFk is null and c1.ConceptAccordingToFk is null) or (c1.ConceptAccordingToFk = @accToFk))
	end
	
GO


GRANT EXEC ON sprSelect_ConceptRelationshipMatches TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_ConceptRelationship
	END

GO

CREATE Procedure sprSelect_ConceptRelationship
	@conceptRelGuid uniqueidentifier
AS

	select cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
		cr.ConceptRelationshipConcept1Fk,
		cr.ConceptRelationshipConcept2Fk,
		cr.ConceptRelationshipRelationship,
		cr.ConceptRelationshipRelationshipFk,
		c.ConceptName1, 
		cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
		cto.ConceptName1 as ConceptToName1, 
		cast(cto.ConceptName1Fk as varchar(38)) as ConceptToName1Fk, 
		c.ConceptAccordingTo, 
		cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk, 
		cto.ConceptAccordingTo as ConceptToAccordingTo,
		cast(cto.ConceptAccordingToFk as varchar(38)) as ConceptToAccordingToFk,
		cr.ConceptRelationshipHybridOrder,
		cr.ConceptRelationshipLSID
	from tblConceptRelationship cr
	inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
	left join tblConcept cto on cto.ConceptPk = cr.ConceptRelationshipConcept2Fk
	where ConceptRelationshipGuid = @conceptRelGuid

GO


GRANT EXEC ON sprSelect_ConceptRelationship TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SystemProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_SystemProviderConceptRelationship
	END

GO

CREATE Procedure sprSelect_SystemProviderConceptRelationship
	@sysProvImportFk int,
	@concept1Id nvarchar(300),
	@concept2Id nvarchar(300),
	@relTypeFk int
AS

	select pcr.*
	from vwProviderConceptRelationship pcr 
	where pcr.PCRProviderImportFk = @sysProvImportFk and 
		pcr.PCRConcept1Id = @concept1Id and
		isnull(pcr.PCRConcept2Id,'') = isnull(@concept2Id,'') and
		pcr.PCRRelationshipFk = @relTypeFk
		

GO


GRANT EXEC ON sprSelect_SystemProviderConceptRelationship TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderConceptRelationship')
	BEGIN
		DROP  View dbo.vwProviderConceptRelationship
	END
GO

CREATE View dbo.vwProviderConceptRelationship AS

	
	select p.ProviderName,
		pc1.PCName1,
		PCRRelationship,
		pc2.PCName1 as PCName2, 
		pc1.PCAccordingTo,		
		PCRLinkStatus, 
		PCRMatchScore, 
		pc1.PCName1Id, 
		pc2.PCName1Id as PCName2Id,
		PCRConcept1Id,
		PCRConcept2Id,
		pc1.PCAccordingToId,
		PCRHybridOrder,
		PCRId,
		PCRIsPreferredConcept,
		PCRVersion,
		PCRRelationshipId,
		PCRRelationshipFk,
		cast(PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		p.ProviderPk,
		p.ProviderIsEditor,
		PCRPk, 
		pc1.PCPk,
		PCRProviderImportFk, 
		PCRCreatedDate, 
		PCRCreatedBy, 
		PCRUpdatedDate, 
		PCRUpdatedBy
	from tblProviderConceptRelationship pcr
	inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	inner join vwProviderConcept pc1 on pc1.PCConceptId = pcr.PCRConcept1Id and pc1.ProviderPk = p.ProviderPk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = p.ProviderPk


GO


GRANT SELECT ON dbo.vwProviderConceptRelationship TO PUBLIC

GO

