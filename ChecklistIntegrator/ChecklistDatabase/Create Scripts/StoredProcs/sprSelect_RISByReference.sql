IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RISByReference')
	BEGIN
		DROP  Procedure  sprSelect_RISByReference
	END

GO

CREATE Procedure sprSelect_RISByReference
	@refGuid uniqueidentifier
AS

	select RISPk, 
		cast(RISReferenceFk as varchar(38)) as RISReferenceFk, 
		RISId, 
		RISType, 
		RISTitle, 
		RISAuthors, 
		RISDate, 
		RISNotes, 
		RISKeywords, 
		RISStartPage, 
		RISEndPage, 
		RISJournalName, 
		RISStandardAbbreviation, 
		RISVolume, 
		RISIssue, 
		RISCityOfPublication, 
		RISPublisher, 
		RISSNNumber, 
		RISWebUrl, 
		RISTitle2, 
		RISTitle3, 
		RISAuthors2, 
		RISAuthors3, 
		RISCreatedDate, 
		RISCreatedBy, 
		RISUpdatedDate, 
		RISUpdatedBy
	from tblReferenceRIS
	where RISReferenceFk = @refGuid

GO


GRANT EXEC ON sprSelect_RISByReference TO PUBLIC

GO


