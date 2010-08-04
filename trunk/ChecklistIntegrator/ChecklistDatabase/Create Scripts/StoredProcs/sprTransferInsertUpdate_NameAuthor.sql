IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_NameAuthor')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_NameAuthor
	END

GO

CREATE Procedure sprTransferInsertUpdate_NameAuthor
	@NameAuthorsPk int, 
	@NameAuthorsNameFk uniqueidentifier, 
	@NameAuthorsBasionymAuthors nvarchar(100), 
	@NameAuthorsCombinationAuthors nvarchar(100), 
	@NameAuthorsBasEx nvarchar(100), 
	@NameAuthorsCombEx nvarchar(100), 
	@NameAuthorsIsCorrected bit, 
	@NameAuthorsCreatedDate datetime, 
	@NameAuthorsCreatedBy nvarchar(50) 

AS

	delete tblNameAuthors where NameAuthorsPk = @nameAuthorsPk
	
	set identity_insert tblNameAuthors on
	
	insert tblNameAuthors(NameAuthorsPk, NameAuthorsNameFk, NameAuthorsBasionymAuthors, NameAuthorsCombinationAuthors, NameAuthorsBasEx, NameAuthorsCombEx, NameAuthorsIsCorrected, NameAuthorsCreatedDate, NameAuthorsCreatedBy)
	select @NameAuthorsPk, @NameAuthorsNameFk, @NameAuthorsBasionymAuthors, @NameAuthorsCombinationAuthors, @nameAuthorsBasEx, @nameAuthorsCombEx,
		@NameAuthorsIsCorrected, @NameAuthorsCreatedDate, @NameAuthorsCreatedBy
	
	set identity_insert tblNameAuthors off

GO


GRANT EXEC ON sprTransferInsertUpdate_NameAuthor TO PUBLIC

GO


