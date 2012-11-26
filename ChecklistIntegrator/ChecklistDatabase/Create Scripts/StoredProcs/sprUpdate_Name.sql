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
	delete tblFlatName where FlatNameSeedName = @nameGuid

    INSERT tblFlatName
    EXEC p_sprSelect_Name_ToRoot_003 @NameGuid

GO


GRANT EXEC ON sprUpdate_Name TO PUBLIC

GO


