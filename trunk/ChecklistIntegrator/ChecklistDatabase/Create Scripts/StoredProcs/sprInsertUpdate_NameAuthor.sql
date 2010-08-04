IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_NameAuthor')
	BEGIN
		DROP  Procedure  sprInsertUpdate_NameAuthor
	END

GO

CREATE Procedure sprInsertUpdate_NameAuthor
	@nameAuthorPk int,
	@nameGuid uniqueidentifier,
	@basAuthors nvarchar(100),
	@combAuthors nvarchar(100),
	@basExAuth nvarchar(100),
	@combExAuth nvarchar(100),
	@isCorrected bit,
	@user nvarchar(50)
	
AS

	if (@nameAuthorPk is null or @nameAuthorPk = -1)
	begin
		insert tblNameAuthors
		select @nameGuid, @basAuthors, @combAuthors, @basExAuth, @combExAuth, @isCorrected, getdate(), @user
		
		select @nameAuthorPk = @@identity
	end
	else
	begin
		update tblNameAuthors
		set NameAuthorsNameFk = @nameGuid,
			NameAuthorsBasionymAuthors = @basAuthors,
			NameAuthorsCombinationAuthors = @combAuthors,
			NameAuthorsBasEx = @basExAuth,
			NameAuthorsCombEx = @combExAuth,
			NameAuthorsIsCorrected = @isCorrected
		where NameAuthorsPk = @nameAuthorPk
			
	end
	
	select * from tblNameAuthors where NameAuthorsPk = @nameAuthorPk

GO


GRANT EXEC ON sprInsertUpdate_NameAuthor TO PUBLIC

GO


