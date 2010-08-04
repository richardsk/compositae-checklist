IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ReferenceRIS')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ReferenceRIS
	END

GO

CREATE Procedure sprTransferInsertUpdate_ReferenceRIS
	@RISPk int, 
	@RISReferenceFk uniqueidentifier, 
	@RISId nvarchar(300), 
	@RISType nvarchar(50), 
	@RISTitle ntext, 
	@RISAuthors nvarchar(4000), 
	@RISDate nvarchar(50), 
	@RISNotes ntext, 
	@RISKeywords nvarchar(1000), 
	@RISStartPage nvarchar(100), 
	@RISEndPage nvarchar(100), 
	@RISJournalName nvarchar(500), 
	@RISStandardAbbreviation nvarchar(150), 
	@RISVolume nvarchar(50), 
	@RISIssue nvarchar(50), 
	@RISCityOfPublication nvarchar(200), 
	@RISPublisher nvarchar(500), 
	@RISSNNumber nvarchar(500), 
	@RISWebUrl nvarchar(1000), 
	@RISTitle2 ntext, 
	@RISTitle3 ntext, 
	@RISAuthors2 nvarchar(4000), 
	@RISAuthors3 nvarchar(4000), 
	@RISCreatedDate datetime, 
	@RISCreatedBy nvarchar(50), 
	@RISUpdatedDate datetime, 
	@RISUpdatedBy nvarchar(50)

AS

	if (not exists(select * from tblReferenceRIS where RISPk = @RISPk))
	begin
		set identity_insert tblReferenceRIS on
		insert tblReferenceRIS(RISPk, RISReferenceFk, RISId, RISType, RISTitle, RISAuthors, RISDate, RISNotes, RISKeywords, RISStartPage, RISEndPage, RISJournalName, RISStandardAbbreviation, RISVolume, RISIssue, RISCityOfPublication, RISPublisher, RISSNNumber, RISWebUrl, RISTitle2, RISTitle3, RISAuthors2, RISAuthors3, RISCreatedDate, RISCreatedBy, RISUpdatedDate, RISUpdatedBy)
		select @RISPk, 
			@RISReferenceFk, 
			@RISId,
			@RISType, 
			@RISTitle, 
			@RISAuthors, 
			@RISDate, 
			@RISNotes, 
			@RISKeywords, 
			@RISStartPage, 
			@RISEndPage, 
			@RISJournalName, 
			@RISStandardAbbreviation, 
			@RISVolume, 
			@RISIssue, 
			@RISCityOfPublication, 
			@RISPublisher, 
			@RISSNNumber, 
			@RISWebUrl, 
			@RISTitle2, 
			@RISTitle3, 
			@RISAuthors2, 
			@RISAuthors3, 
			@RISCreatedDate,
			@RISCreatedBy,
			@RISUpdatedDate,
			@RISUpdatedBy
			
		set identity_insert tblReferenceRIS off
	
	end
	else
	begin
		update tblReferenceRIS
		set RISReferenceFk = @RISReferenceFk, 
			RISId = @RISId,
			RISType = @RISType, 
			RISTitle = @RISTitle, 
			RISAuthors = @RISAuthors, 
			RISDate = @RISDate, 
			RISNotes = @RISNotes, 
			RISKeywords = @RISKeywords, 
			RISStartPage = @RISStartPage, 
			RISEndPage = @RISEndPage, 
			RISJournalName = @RISJournalName, 
			RISStandardAbbreviation = @RISStandardAbbreviation, 
			RISVolume = @RISVolume, 
			RISIssue = @RISIssue, 
			RISCityOfPublication = @RISCityOfPublication, 
			RISPublisher = @RISPublisher, 
			RISSNNumber = @RISSNNumber, 
			RISWebUrl = @RISWebUrl, 
			RISTitle2 = @RISTitle2, 
			RISTitle3 = @RISTitle3, 
			RISAuthors2 = @RISAuthors2, 
			RISAuthors3 = @RISAuthors3, 
			RISCreatedDate = @RISCreatedDate,
			RISCreatedBy = @RISCreatedBy,
			RISUpdatedDate = @RISUpdatedDate,
			RISUpdatedBy = @RISUpdatedBy
		where RISPk = @RISPk
	end
	
GO


GRANT EXEC ON sprTransferInsertUpdate_ReferenceRIS TO PUBLIC

GO


