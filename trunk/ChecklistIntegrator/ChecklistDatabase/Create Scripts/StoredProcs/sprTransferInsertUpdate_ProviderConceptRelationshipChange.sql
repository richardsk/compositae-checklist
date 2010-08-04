IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderConceptRelationshipChange')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderConceptRelationshipChange
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderConceptRelationshipChange
	@PCRPk int, 
	@PCRProviderImportFk int,
	@PCRLinkStatus nvarchar(20),
	@PCRMatchScore int,
	@PCRConceptRelationshipFk uniqueidentifier,
	@PCRConcept1Id nvarchar(300),
	@PCRConcept2Id nvarchar(300),
	@PCRIsPreferredConcept bit,
	@PCRId nvarchar(200),
	@PCRRelationship nvarchar(300),
	@PCRRelationshipId nvarchar(300),
	@PCRRelationshipFk int,
	@PCRHybridOrder int,
	@PCRVersion nvarchar(200),
	@PCRCreatedDate datetime,
	@PCRCreatedBy nvarchar(50),
	@PCRUpdatedDate datetime,
	@PCRUpdatedBy nvarchar(50),
	@changedDate datetime,
	@changedBy nvarchar(50)
	
AS

	delete tblProviderConceptRelationship_Change where PCRPk = @PCRPk and ChangedDate = @ChangedDate and ChangedBy = @ChangedBy

	insert tblProviderConceptRelationship_Change
	select @PCRPk,
		@PCRProviderImportFk,
		@PCRLinkStatus,
		@PCRMatchScore,
		@PCRConceptRelationshipFk,
		@PCRConcept1Id,
		@PCRConcept2Id,
		@PCRIsPreferredConcept,
		@PCRId,
		@PCRRelationship,
		@PCRRelationshipId,
		@PCRRelationshipFk,
		@PCRHybridOrder,
		@PCRVersion,
		@PCRcreateddate,
		@PCRcreatedBy,
		@PCRupdatedDate,
		@PCRupdatedBy,
		@changedDate,
		@changedBy
			


GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderConceptRelationshipChange TO PUBLIC

GO


