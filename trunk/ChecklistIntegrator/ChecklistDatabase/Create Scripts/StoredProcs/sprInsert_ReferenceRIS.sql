IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ReferenceRIS')
	BEGIN
		DROP  Procedure  sprInsert_ReferenceRIS
	END

GO

CREATE Procedure sprInsert_ReferenceRIS
	@referenceGuid uniqueidentifier,	
	@PRPk int,
	@PRISPk int,
	@user nvarchar(50)
AS

	--delete any existing RIS record, so we dont end up with multiple
	delete tblReferenceRIS
	where RISReferenceFk = @referenceGuid


	--insert RIS values
	insert tblReferenceRIS
	select @referenceGuid, 
		PRISId,
		PRISType, 
		PRISTitle, 
		PRISAuthors, 
		PRISDate, 
		PRISNotes, 
		PRISKeywords, 
		PRISStartPage, 
		PRISEndPage, 
		PRISJournalName, 
		PRISStandardAbbreviation, 
		PRISVolume, 
		PRISIssue, 
		PRISCityOfPublication, 
		PRISPublisher, 
		PRISISSNNumber, 
		PRISWebUrl, 
		PRISTitle2, 
		PRISTitle3, 
		PRISAuthors2, 
		PRISAuthors3, 
		getdate(),
		@user,
		null, null 
	from tblProviderRIS
	where PRISProviderReferenceFk = @PRPk
	
	declare @newId int
	select @newId = @@identity	
	
	--update Provider RIS record
	update tblProviderRIS 
	set PRISRISFk = @newId
	where PRISPk = @PRISPk
	
	select @newId
	
GO


GRANT EXEC ON sprInsert_ReferenceRIS TO PUBLIC

GO


