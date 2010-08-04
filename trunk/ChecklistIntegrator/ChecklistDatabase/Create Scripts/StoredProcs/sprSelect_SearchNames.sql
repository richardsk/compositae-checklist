IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SearchNames')
	BEGIN
		DROP  Procedure  sprSelect_SearchNames
	END

GO

CREATE Procedure sprSelect_SearchNames
	@searchText nvarchar(200),
	@maxResults int
AS

	declare @searchLen int
	set @searchText = lower(ltrim(rtrim(@searchText)))
	set @searchLen = len(@searchText)
	
	declare @recs table(NameGuid uniqueidentifier, counter int identity)
	insert @recs
	select NameGuid
	from tblName 
	where lower(substring(NameCanonical, 1, @searchLen)) = @searchText
			
	delete @recs 	
	where counter > @maxResults
	
	
	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		n.NameLSID, 
		n.NameFull, 
		n.NameRank, 
		n.NameRankFk, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
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
		n.NameOrthography, 
		n.NameBasionym, 
		cast(n.NameBasionymFk as varchar(38)) as NameBasionymFk, 
		n.NameBasedOn, 
		cast(n.NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		n.NameConservedAgainst, 
		cast(n.NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		n.NameHomonymOf, 
		cast(n.NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		n.NameReplacementFor, 
		cast(n.NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
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
		NameCounter
	from tblName n
	inner join @recs r on r.NameGuid = n.NameGuid

GO


GRANT EXEC ON sprSelect_SearchNames TO PUBLIC

GO


