IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderNameAuthor')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderNameAuthor
	END

GO

CREATE Procedure sprInsertUpdate_ProviderNameAuthor
	@PNAuthorPk int,
	@pnpk int,
	@basAuthors nvarchar(100),
	@combAuthors nvarchar(100),
	@basExAuth nvarchar(100),
	@combExAuth nvarchar(100),
	@isCorrected bit,
	@user nvarchar(50)
	
AS

	if (@PNAuthorPk is null or @PNAuthorPk = -1)
	begin
		insert tblProviderNameAuthors
		select @pnpk, @basAuthors, @combAuthors, @basExAuth, @combExAuth, @isCorrected, getdate(), @user
		
		select @PNAuthorPk = @@identity
	end
	else
	begin
		update tblProviderNameAuthors
		set PNAProviderNameFk = @pnpk,
			PNABasionymAuthors = @basAuthors,
			PNACombinationAuthors = @combAuthors,
			PNABasExAuthors = @basExAuth,
			PNACombExAuthors = @combExAuth,
			PNAIsCorrected = @isCorrected
		where PNAPk = @PNAuthorPk
			
	end
	
	select * from tblProviderNameAuthors where PNAPk = @PNAuthorPk

GO


GRANT EXEC ON sprInsertUpdate_ProviderNameAuthor TO PUBLIC

GO


