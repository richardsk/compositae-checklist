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


