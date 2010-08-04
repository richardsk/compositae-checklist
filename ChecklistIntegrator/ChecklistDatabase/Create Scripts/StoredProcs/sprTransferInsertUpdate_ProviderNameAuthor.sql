IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderNameAuthor')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderNameAuthor
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderNameAuthor
	@PNAPk int, 
	@PNAProviderNameFk int, 
	@PNABasionymAuthors nvarchar(100), 
	@PNACombinationAuthors nvarchar(100), 
	@PNABasExAuthors nvarchar(100), 
	@PNACombExAuthors nvarchar(100), 
	@PNAIsCorrected bit, 
	@PNACreatedDate datetime, 
	@PNACreatedBy nvarchar(50)

AS

	delete tblprovidernameauthors where pnapk = @pnapk
	
	set identity_insert tblProviderNameAuthors on
	
	insert tblProviderNameAuthors(PNAPk, PNAProviderNameFk, PNABasionymAuthors, PNACombinationAuthors, PNABasExAuthors, PNACombExAuthors, PNAIsCorrected, PNACreatedDate, PNACreatedBy)
	select @PNAPk, @PNAProviderNameFk, @PNABasionymAuthors, @PNACombinationAuthors, @pnaBasExAuthors, @pnaCombExAuthors, @PNAIsCorrected, 
		@PNACreatedDate, @PNACreatedBy

	set identity_insert tblProviderNameAuthors off

GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderNameAuthor TO PUBLIC

GO


