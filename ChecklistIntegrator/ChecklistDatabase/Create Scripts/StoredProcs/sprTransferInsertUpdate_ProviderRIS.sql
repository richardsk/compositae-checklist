IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderRIS')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderRIS
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderRIS
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
	@PRISUpdatedBy nvarchar(50)

AS
	
	if (@PRISPk = -1 or not exists(select * from tblProviderRIS where PRISPk = @PRISPk))
	begin
		
		set identity_insert tblProviderRIS on		
		insert tblProviderRIS(PRISPk, PRISProviderReferenceFK, PRISRISFk, PRISId, PRISType, PRISAuthors, PRISTitle, PRISDate, PRISNotes, PRISKeywords, PRISStartPage, PRISEndPage, PRISJournalName, PRISStandardAbbreviation, PRISVolume, PRISIssue, PRISCityOfPublication, PRISPublisher, PRISISSNNumber, PRISWebUrl, PRISTitle2, PRISTitle3, PRISAuthors2, PRISAuthors3, PRISCreatedDate, PRISCreatedBy, PRISUpdatedDate, PRISUpdatedBy)
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
			@PRISUpdatedBy
			
		set identity_insert tblProviderRIS off
	end
	else
	begin
		
		update tblProviderRIS
		set PRISProviderReferenceFK = @PRISProviderReferenceFK, 
			PRISRISFk = @PRISRISFk, 
			PRISId = @PRISId,
			PRISType = @PRISType, 
			PRISAuthors = @PRISAuthors,
			PRISTitle = @PRISTitle, 
			PRISDate = @PRISDate, 
			PRISNotes = @PRISNotes,
			PRISKeywords = @PRISKeywords,
			PRISStartPage = @PRISStartPage,
			PRISEndPage = @PRISEndPage,
			PRISJournalName = @PRISJournalName,
			PRISStandardAbbreviation = @PRISStandardAbbreviation,
			PRISVolume = @PRISVolume,
			PRISIssue = @PRISIssue,
			PRISCityOfPublication = @PRISCityOfPublication,
			PRISPublisher = @PRISPublisher,
			PRISISSNNumber = @PRISISSNNumber,
			PRISWebUrl = @PRISWebUrl,
			PRISTitle2 = @PRISTitle2,
			PRISTitle3 = @PRISTitle3,
			PRISAuthors2 = @PRISAuthors2,
			PRISAuthors3 = @PRISAuthors3,
			PRISCreatedDate = @PRISCreatedDate,
			PRISCreatedBy = @PRISCreatedBy,
			PRISUpdatedDate = @PRISUpdatedDate,
			PRISUpdatedBy = @PRISUpdatedBy
		where PRISPk = @PRISPk
		
	end



GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderRIS TO PUBLIC

GO


