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

	

GO


GRANT EXEC ON sprInsert_Name TO PUBLIC

GO


