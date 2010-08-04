IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameChildren')
	BEGIN
		DROP  Procedure  sprSelect_NameChildren
	END

GO

CREATE Procedure sprSelect_NameChildren
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
		NameUpdatedBy
	from tblName 
	where NameParentFk = @nameGuid

GO


GRANT EXEC ON sprSelect_NameChildren TO PUBLIC

GO


