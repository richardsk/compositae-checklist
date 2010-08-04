IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ConceptRelationship')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ConceptRelationship
	END

GO

CREATE Procedure sprTransferInsertUpdate_ConceptRelationship
	@CRGuid uniqueidentifier,
	@CRLSID nvarchar(300),
	@CRConcept1Fk int,
	@CRConcept2Fk int,
	@CRRelationship nvarchar(300),
	@CRRelationshipFk int,
	@CRHybridOrder int,
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
AS

	if (@CRGuid is null or not exists(select * from tblConceptRelationship where ConceptRelationshipGuid = @CRGuid))
	begin
		insert tblConceptRelationship
		select @CRGuid,
			@CRLSID,
			@CRConcept1Fk,
			@CRConcept2Fk,
			@CRRelationship,
			@CRRelationshipFk,
			@CRHybridOrder,
			@createddate,
			@createdBy,
			@updatedDate,
			@updatedBy
			
		select @CRGuid
	end
	else
	begin
		
		update tblConceptRelationship
		set ConceptRelationshipConcept1Fk = @CRConcept1Fk,
			ConceptRelationshipConcept2Fk = @CRConcept2Fk,
			ConceptRelationshipRelationship = @CRRelationship,
			ConceptRelationshipRelationshipFk = @CRRelationshipFk,
			ConceptRelationshipHybridOrder = @CRHybridOrder,
			ConceptRelationshipCreatedDate = @createdDate,
			ConceptRelationshipCreatedBy = @createdBy,
			ConceptRelationshipUpdatedDate = @updatedDate,
			ConceptRelationshipUpdatedBy = @updatedBy
		where ConceptRelationshipGuid = @CRGuid
		
		select @CRGuid
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_ConceptRelationship TO PUBLIC

GO


