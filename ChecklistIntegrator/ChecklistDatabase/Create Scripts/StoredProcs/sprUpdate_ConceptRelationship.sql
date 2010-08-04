 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptRelationship')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptRelationship
	END

GO

CREATE Procedure sprUpdate_ConceptRelationship
	@crGuid uniqueidentifier,
	@crLSID nvarchar(300),
	@crConcept1Fk int,
	@crConcept2Fk int,
	@crRelationship nvarchar(300),
	@crRelationshipFk int,
	@crHybridOrder int,
	@user nvarchar(50)
AS

	update tblConceptRelationship
	set ConceptRelationshipLSID = @crLSID,
		ConceptRelationshipConcept1Fk = @crConcept1Fk,
		ConceptRelationshipConcept2Fk = @crConcept2Fk,
		ConceptRelationshipRelationship = @crRelationship,
		ConceptRelationshipRelationshipFk = @crRelationshipFk,
		ConceptRelationshipHybridOrder = @crHybridOrder,
		ConceptRelationshipUpdatedDate = getdate(),
		ConceptRelationshipUpdatedBy = @user
	where ConceptRelationshipGuid = @crGuid

GO


GRANT EXEC ON sprUpdate_ConceptRelationship TO PUBLIC

GO


