IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderRIS')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderRIS
	END

GO

CREATE Procedure sprInsertUpdate_ProviderRIS
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
	@RefId nvarchar(300), --PRReferenceId for the assoc ref
	@user nvarchar(50)

AS
	
	if (@PRISPk = -1)
	begin
		--link to provider reference
		if (@PRISProviderReferenceFk is null)
		begin
			select @PRISProviderReferenceFk = PRPk
			from tblProviderReference
			where PRReferenceId = @RefId
		end
		
		insert tblProviderRIS
		select @PRISProviderReferenceFK, 		
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
			getdate(),
			@user,
			null, null
			
			select @@identity
	end
	else
	begin
	
		exec sprInsert_ProviderRISChange @prispk, @user
	
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
			PRISUpdatedDate = getdate(),
			PRISUpdatedBy = @user
		where PRISPk = @PRISPk
		
		select @PRISPk
	end

GO


GRANT EXEC ON sprInsertUpdate_ProviderRIS TO PUBLIC

GO


