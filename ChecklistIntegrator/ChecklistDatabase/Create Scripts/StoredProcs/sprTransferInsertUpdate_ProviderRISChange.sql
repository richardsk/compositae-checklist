IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderRISChange')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderRISChange
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderRISChange
	@PRISPk int,
	@PRISProviderReferenceFK int, 
	@PRISRISFk int, 
	@PRISId nvarchar(300),
	@PRISType nvarchar(50), 
	@PRISAuthors nvarchar(4000), 
	@PRISTitle ntext, 
	@PRISDate char(10), 
	@PRISNotes ntext, 
	@PRISKeywords nvarchar(1000), 
	@PRISStartPage nvarchar(100), 
	@PRISEndPage nvarchar(100), 
	@PRISJournalName nvarchar(500), 
	@PRISStandardAbbreviation nvarchar(150), 
	@PRISVolume nvarchar(50), 
	@PRISIssue nvarchar(50), 
	@PRISCityOfPublication nvarchar(200), 
	@PRISPublisher nvarchar(500), 
	@PRISISSNNumber nvarchar(500), 
	@PRISWebUrl nvarchar(1000), 
	@PRISTitle2 ntext, 
	@PRISTitle3 ntext, 
	@PRISAuthors2 nvarchar(4000), 
	@PRISAuthors3 nvarchar(4000), 
	@PRISCreatedDate datetime,
	@PRISCreatedBy nvarchar(50),
	@PRISUpdatedDate datetime,
	@PRISUpdatedBy nvarchar(50),
	@ChangedDate datetime,
	@ChangedBy nvarchar(50)

AS
	
	delete tblProviderRIS_Change where PRISPk = @PRISPk and ChangedDate = @ChangedDate and ChangedBy = @ChangedBy
		
	insert tblProviderRIS_Change(PRISPk, PRISProviderReferenceFK, PRISRISFk, PRISId, PRISType, PRISAuthors, PRISTitle, PRISDate, PRISNotes, PRISKeywords, PRISStartPage, PRISEndPage, PRISJournalName, PRISStandardAbbreviation, PRISVolume, PRISIssue, PRISCityOfPublication, PRISPublisher, PRISISSNNumber, PRISWebUrl, PRISTitle2, PRISTitle3, PRISAuthors2, PRISAuthors3, PRISCreatedDate, PRISCreatedBy, PRISUpdatedDate, PRISUpdatedBy, ChangedDate, ChangedBy)
	select @PRISPk,
		@PRISProviderReferenceFK, 		
		@PRISRISFk, 
		@PRISId,
		@PRISType, 
		@PRISAuthors,
		@PRISTitle, 
		@PRISDate, 
		@PRISNotes,
		@PRISKeywords,
		@PRISStartPage,
		@PRISEndPage,
		@PRISJournalName,
		@PRISStandardAbbreviation,
		@PRISVolume,
		@PRISIssue,
		@PRISCityOfPublication,
		@PRISPublisher,
		@PRISISSNNumber,
		@PRISWebUrl,
		@PRISTitle2,
		@PRISTitle3,
		@PRISAuthors2,
		@PRISAuthors3,
		@PRISCreatedDate,
		@PRISCreatedBy,
		@PRISUpdatedDate,
		@PRISUpdatedBy,
		@ChangedDate, 
		@ChangedBy
			
	
GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderRISChange TO PUBLIC

GO


