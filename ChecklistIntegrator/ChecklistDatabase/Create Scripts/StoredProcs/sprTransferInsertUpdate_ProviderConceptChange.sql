IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderConceptChange')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderConceptChange
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderConceptChange
	@PCPk int,
	@PCProviderImportFk int,
	@PCLinkStatus nvarchar(20),
	@PCMatchScore int,
	@PCConceptFk int,
	@PCConceptId nvarchar(300),
	@PCName1 nvarchar(4000),
	@PCName1Id nvarchar(300),
	@PCAccordingTo nvarchar(4000),
	@PCAccordingToId nvarchar(300),
	@PCConceptVersion nvarchar(200),
	@PCCreatedDate datetime,
	@PCCreatedBy nvarchar(50),
	@PCUpdatedDate datetime,
	@PCUpdatedBy nvarchar(50),
	@ChangedDate datetime,
	@ChangedBy nvarchar(50)
AS
	
	delete tblProviderConcept_Change where PCPk = @PCPk and ChangedDate = @ChangedDate and ChangedBy = @ChangedBy
	
	insert tblProviderConcept_Change
	select @PCPk, 
		@PCProviderImportFk,
		@PCLinkStatus,
		@PCMatchScore,
		@PCConceptFk,
		@PCConceptId,
		@PCName1,
		@PCName1Id,
		@PCAccordingTo,
		@PCAccordingToId,
		@PCConceptVersion,
		@PCCreatedDate,
		@PCCreatedBy,
		@PCUpdatedDate,
		@PCUpdatedBy,
		@ChangedDate,
		@ChangedBy 

GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderConceptChange TO PUBLIC

GO


