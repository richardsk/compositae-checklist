IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Name')
	BEGIN
		DROP  Procedure  sprSelect_Name
	END

GO

CREATE Procedure dbo.sprSelect_Name
	@nameGuid uniqueidentifier
AS

	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		n.NameLSID, 
		n.NameFull, 
		n.NameRank, 
		n.NameRankFk, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
		--dbo.fngetpreferrednamereason(NameGuid) as NamePreferredReason,
		dbo.fnGetFullName(n.NamePreferredFk, 1,0,1,0,0) as NamePreferredFormatted,
		n.NameCanonical, 
		n.NameAuthors, 
		n.NameBasionymAuthors, 
		n.NameCombinationAuthors, 
		n.NamePublishedIn, 
		cast(n.NameReferenceFk as varchar(38)) as NameReferenceFk, 
		n.NameYear, 
		n.NameMicroReference, 
		n.NameTypeVoucher, 
		n.NameTypeName, 
		cast(n.NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		dbo.fnGetFullName(n.NameTypeNameFk, 1,0,1,0,0) as NameTypeNameFormatted,
		n.NameOrthography, 
		n.NameBasionym, 
		cast(n.NameBasionymFk as varchar(38)) as NameBasionymFk, 
		dbo.fnGetFullName(n.NameBasionymFk, 1,0,1,0,0) as NameBasionymFormatted,
		n.NameBasedOn, 
		cast(n.NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		dbo.fnGetFullName(n.NameBasedOnFk, 1,0,1,0,0) as NameBasedOnFormatted,
		n.NameConservedAgainst, 
		cast(n.NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		dbo.fnGetFullName(n.NameConservedAgainstFk, 1,0,1,0,0) as NameConservedAgainstFormatted,
		n.NameHomonymOf, 
		cast(n.NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		dbo.fnGetFullName(n.NameHomonymOfFk, 1,0,1,0,0) as NameHomonymOfFormatted,
		n.NameReplacementFor, 
		cast(n.NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		dbo.fnGetFullName(n.NameReplacementForFk, 1,0,1,0,0) as NameReplacementForFormatted,
		n.NameBlocking, 
		cast(n.NameBlockingFk as varchar(38)) as NameBlockingFk,
		dbo.fnGetFullName(n.NameBlockingFk, 1,0,1,0,0) as NameBlockingFormatted,
		n.NameInCitation,
		n.NameInvalid, 
		n.NameIllegitimate, 
		n.NameMisapplied, 
		n.NameProParte, 
		n.NameNomNotes, 
		n.NameStatusNotes,
		n.NameNotes,
		n.NameCreatedDate, 
		n.NameCreatedBy, 
		n.NameUpdatedDate, 
		n.NameUpdatedBy,
		dbo.fnGetFullName(n.NameGuid, 1,0,1,0,0) as NameFullFormatted,
		n.NameCounter,		
		r.RankSort,
		case when n.nameguid = n.namepreferredfk then 'ACCEPTED' when c.conceptpk is null then 'INFERRED ACCEPTED' else 'SYNONYM' end as [Status]
	from tblName n
	left join tblName cn on cn.nameguid = n.namepreferredfk
	LEFT join tblConcept c on c.ConceptName1Fk = cn.nameguid
	inner join tblrank r on r.rankpk = n.namerankfk
	where n.NameGuid = @nameGuid

GO


GRANT EXEC ON sprSelect_Name TO PUBLIC

GO


