IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderConceptRelationship
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderConceptRelationship
	@PCRPk int, 
	@PCRProviderImportFk int,
	@PCRLinkStatus nvarchar(20),
	@PCRMatchScore int,
	@PCRConceptRelationshipFk uniqueidentifier,
	@PCRConcept1Id nvarchar(300),
	@PCRConcept2Id nvarchar(300),
	@PCRIsPreferredConcept bit,
	@PCRId nvarchar(300),
	@PCRRelationship nvarchar(300),
	@PCRRelationshipId nvarchar(300),
	@PCRRelationshipFk int,
	@PCRHybridOrder int,
	@PCRVersion nvarchar(200),
	@PCRCreatedDate datetime,
	@PCRCreatedBy nvarchar(50),
	@PCRUpdatedDate datetime,
	@PCRUpdatedBy nvarchar(50)
AS

	if (not exists(select * from tblProviderConceptRelationship where PCRPk = @PCRPk))
	begin
		set identity_insert tblProviderConceptRelationship on
		insert tblProviderConceptRelationship(PCRPk, PCRProviderImportFk, PCRLinkStatus, PCRMatchScore, PCRConceptRelationshipFk, PCRConcept1Id, PCRConcept2Id, PCRIsPreferredConcept, PCRId, PCRRelationship, PCRRelationshipId, PCRRelationshipFk, PCRHybridOrder, PCRVersion, PCRCreatedDate, PCRCreatedBy, PCRUpdatedDate, PCRUpdatedBy)
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
			@PCRupdatedBy
						
		set identity_insert tblProviderConceptRelationship on
	end
	else
	begin
		
		update tblProviderConceptRelationship
		set  PCRProviderImportFk = @PCRProviderImportFk,
			PCRLinkStatus = @PCRLinkStatus,
			PCRMatchScore = @PCRMatchScore,
			PCRConceptRelationshipFk = @PCRConceptRelationshipFk,
			PCRConcept1Id = @PCRConcept1Id,
			PCRConcept2Id = @PCRConcept2Id,
			PCRIsPreferredConcept = @PCRIsPreferredConcept,
			PCRId = @PCRId,
			PCRRelationship = @PCRRelationship,
			PCRRelationshipId = @PCRRelationshipId,
			PCRRelationshipFk = @PCRRelationshipFk,
			PCRHybridOrder = @PCRHybridOrder,
			PCRVersion = @PCRVersion,
			PCRCreatedDate = @PCRcreatedDate,
			PCRCreatedBy = @PCRcreatedBy,
			PCRUpdatedDate = @PCRupdatedDate,
			PCRUpdatedBy = @PCRupdatedBy
		where PCRPk = @PCRPk
		
	end

	select @PCRPk
	
GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderConceptRelationship TO PUBLIC

GO


