IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderReference')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderReference
	END

GO

CREATE Procedure sprInsertUpdate_ProviderReference
	@PRPk int,
	@PRProviderImportFk int,
	@PRReferenceId nvarchar(4000),
	@PRReferenceFk uniqueidentifier,
	@PRLinkStatus nvarchar(20),
	@PRCitation nvarchar(4000),
	@PRFullCitation ntext,
	@PRXML ntext,
	@PRReferenceVersion nvarchar(200),
	@user nvarchar(50)	
	
AS
	
	if (@PRPk is null or @PRPk = -1)
	begin
		insert tblProviderReference
		select @PRProviderImportFk,
			@PRReferenceId,
			@PRReferenceFk,
			@PRLinkStatus,
			@PRCitation,
			@PRFullCitation,
			@PRXML,
			@PRReferenceVersion,
			getdate(),
			@user,
			null, null
	end
	else
	begin
	
		exec sprInsert_ProviderReferenceChange @prpk, @user
	
		update tblProviderReference
		set PRProviderImportFk = @PRProviderImportFk,
			PRReferenceId = @PRReferenceId,
			PRReferenceFk = @PRReferenceFk,
			PRLinkStatus = @PRLinkStatus,
			PRCitation = @PRCitation,
			PRFullCitation = @PRFullCitation,
			PRXML = @PRXML,
			PRReferenceVersion = @PRReferenceVersion,
			PRUpdatedDate = getdate(),
			PRUpdatedBy = @user
		where PRPk = @PRPk
	end

	select SCOPE_IDENTITY()
	
GO


GRANT EXEC ON sprInsertUpdate_ProviderReference TO PUBLIC

GO


