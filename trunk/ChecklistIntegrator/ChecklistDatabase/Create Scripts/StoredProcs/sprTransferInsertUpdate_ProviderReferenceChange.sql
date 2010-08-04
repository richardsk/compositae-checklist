IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderReferenceChange')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderReferenceChange
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderReferenceChange
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
	@PRUpdatedBy nvarchar(50),
	@ChangedDate datetime,
	@ChangedBy nvarchar(50)
	
AS
	
	delete tblProviderReference_Change 
	where PRPk = @PRPk and ChangedDate = @changedDate and ChangedBy = @ChangedBy
	
	insert tblProviderReference_Change(PRPk, PRProviderImportFK, PRReferenceId, PRReferenceFk, PRLinkStatus, PRCitation, PRFullCitation, PRXML, PRReferenceVersion, PRCreatedDate, PRCreatedBy, PRUpdatedDate, PRUpdatedBy, ChangedDate, ChangedBy)
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
		@PRUpdatedBy,
		@ChangedDate,
		@ChangedBy
			
	

GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderReferenceChange TO PUBLIC

GO


