IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportConflictingData')
	BEGIN
		DROP  Procedure  sprSelect_ReportConflictingData
	END

GO

CREATE Procedure sprSelect_ReportConflictingData
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select cast(PNPk as varchar(300)), PNNameFull, 'ProviderName', 'tblProviderName'
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	where PNLinkStatus <> 'Discarded' and 
		(isnull(PNNameFull, NameFull) collate SQL_Latin1_General_CP1_CI_AI <> NameFull or
		isnull(PNNameRank, NameRank) <> NameRank or
		isnull(PNNameCanonical, NameCanonical) <> NameCanonical or 
		isnull(PNNameAuthors, NameAuthors) <> NameAuthors or
		isnull(PNBasionymAuthors, NameBasionymAuthors) <> NameBasionymAuthors or
		isnull(PNCombinationAuthors, NameCombinationAuthors) <> NameCombinationAuthors or
		isnull(PNPublishedIn, NamePublishedIn) <> NamePublishedIn or
		isnull(PNYear, NameYear) <> NameYear or
		isnull(PNMicroReference, NameMicroReference) <> NameMicroReference or
		isnull(PNTypeVoucher, NameTypeVoucher) like NameTypeVoucher or
		isnull(PNTypeName, NameTypeName) <> NameTypeName or
		isnull(PNOrthography, NameOrthography) <> NameOrthography or
		isnull(PNBasionym, NameBasionym) <> NameBasionym or
		isnull(PNBasedOn, NameBasedOn) <> NameBasedOn or
		isnull(PNConservedAgainst, NameConservedAgainst) <> NameConservedAgainst or
		isnull(PNHomonymOf, NameHomonymOf) <> NameHomonymOf or
		isnull(PNReplacementFor, NameReplacementFor) <> NameReplacementFor or
		isnull(PNBlocking, NameBlocking) <> NameBlocking or
		isnull(PNInCitation, NameInCitation) <> NameInCitation or
		isnull(PNInvalid, NameInvalid) <> NameInvalid or
		isnull(PNIllegitimate, NameIllegitimate) <> NameIllegitimate or
		isnull(PNMisapplied, NameMisapplied) <> NameMisapplied or
		isnull(PNProParte, NameProParte) <> NameProParte) 

			
	insert @res
	select cast(PRPk as varchar(300)), isnull(PRCitation, PRFullCitation), 'ProviderReference', 'tblProviderReference'
	from vwProviderReference pr
	inner join vwProviderRIS pris on pris.PRISProviderReferenceFk = pr.PRPk
	inner join tblReferenceRIS ris on ris.RISPk = pris.PRISRISFk
	where PRLinkStatus <> 'Discarded' and 
		(isnull(PRISType, RISType) <> RISType or
		isnull(PRISAuthors, RISAuthors) <> RISAuthors or
		isnull(PRISTitle, RISTitle) like RISTitle or
		isnull(PRISDate, RISDate) <> RISDate or
		isnull(PRISNotes, RISNotes) like RISNotes or
		isnull(PRISKeywords, RISKeywords) <> RISKeywords or
		isnull(PRISStartPage, RISStartPage) <> RISStartPage or
		isnull(PRISEndPage, RISEndPage) <> RISEndPage or
		isnull(PRISJournalName, RISJournalName) <> RISJournalName or
		isnull(PRISStandardAbbreviation, RISStandardAbbreviation) <> RISStandardAbbreviation or
		isnull(PRISVolume, RISVolume) <> RISVolume or
		isnull(PRISIssue, RISIssue) <> RISIssue or
		isnull(PRISCityOfPublication, RISCityOfPublication) <> RISCityOfPublication or
		isnull(PRISPublisher, RISPublisher) <> RISPublisher or
		isnull(PRISISSNNumber, RISSNNumber) <> RISSNNumber or
		isnull(PRISWebUrl, RISWebUrl) <> RISWebUrl or 
		isnull(PRISTitle2, RISTitle2) like RISTitle2 or
		isnull(PRISTitle3, RISTitle3) like RISTitle3 or
		isnull(PRISAuthors2, RISAuthors2) <> RISAuthors2 or
		isnull(PRISAuthors3, RISAuthors3) <> RISAuthors3 )
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportConflictingData TO PUBLIC

GO


