IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderReference')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderReference
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderReference
	@PRPk int,
	@PRProviderImportFk int,
	@PRReferenceId nvarchar(4000),
	@PRReferenceFk uniqueidentifier,
	@PRLinkStatus nvarchar(20),
	@PRCitation nvarchar(4000),
	@PRFullCitation ntext,
	@PRXML ntext,
	@PRReferenceVersion nvarchar(200),
	@PRCreatedDate datetime,
	@PRCreatedBy nvarchar(50),
	@PRUpdatedDate datetime,
	@PRUpdatedBy nvarchar(50)
	
AS
	
	if (@PRPk = -1 or not exists(select * from tblProviderReference where PRPk = @PRPk))
	begin
		set identity_insert tblProviderReference on
		insert tblProviderReference(PRPk, PRProviderImportFK, PRReferenceId, PRReferenceFk, PRLinkStatus, PRCitation, PRFullCitation, PRXML, PRReferenceVersion, PRCreatedDate, PRCreatedBy, PRUpdatedDate, PRUpdatedBy)
		select @PRPk, 
			@PRProviderImportFk,
			@PRReferenceId,
			@PRReferenceFk,
			@PRLinkStatus,
			@PRCitation,
			@PRFullCitation,
			@PRXML,
			@PRReferenceVersion,
			@PRCreatedDate,
			@PRCreatedBy,
			@PRUpdatedDate,
			@PRUpdatedBy
			
		set identity_insert tblProviderReference off
	end
	else
	begin
		
		update tblProviderReference
		set PRProviderImportFk = @PRProviderImportFk,
			PRReferenceId = @PRReferenceId,
			PRReferenceFk = @PRReferenceFk,
			PRLinkStatus = @PRLinkStatus,
			PRCitation = @PRCitation,
			PRFullCitation = @PRFullCitation,
			PRXML = @PRXML,
			PRReferenceVersion = @PRReferenceVersion,
			PRCreatedDate = @PRCreatedDate,
			PRCreatedBy = @PRCreatedBy,
			PRUpdatedDate = @PRUpdatedDate,
			PRUpdatedBy = @PRUpdatedBy
		where PRPk = @PRPk
	end


GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderReference TO PUBLIC

GO


