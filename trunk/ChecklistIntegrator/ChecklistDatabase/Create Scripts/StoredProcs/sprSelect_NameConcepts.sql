IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameConcepts')
	BEGIN
		DROP  Procedure  sprSelect_NameConcepts
	END

GO

CREATE Procedure sprSelect_NameConcepts
	@nameGuid uniqueidentifier
AS

	select ConceptPk, 
		ConceptLSID, 
		ConceptName1, 
		cast(ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
		ConceptAccordingTo, 
		cast(ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk, 
		ConceptCreatedDate, 
		ConceptCreatedBy, 
		ConceptUpdatedDate, 
		ConceptUpdatedBy
	from tblConcept
	where ConceptName1Fk = @nameGuid
	union
	select c.ConceptPk, 
		c.ConceptLSID, 
		c.ConceptName1, 
		cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
		c.ConceptAccordingTo, 
		cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk, 
		c.ConceptCreatedDate, 
		c.ConceptCreatedBy, 
		c.ConceptUpdatedDate, 
		c.ConceptUpdatedBy
	from tblConcept c2 
	inner join tblConceptRelationship cr on cr.ConceptRelationshipConcept1Fk = c2.ConceptPk
	inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept2Fk
	where c2.ConceptName1Fk = @nameGuid
	
	
	select cast(ConceptRelationshipgUID as varchar(38)) as ConceptRelationshipGuid,
		ConceptRelationshipLSID,
		ConceptRelationshipConcept1Fk,
		ConceptRelationshipConcept2Fk,
		ConceptRelationshipRelationship,
		ConceptRelationshipRelationshipFk,
		ConceptRelationshipHybridOrder,
		ConceptRelationshipCreatedDate,
		ConceptRelationshipCreatedBy,
		ConceptRelationshipUpdatedDate,
		ConceptRelationshipUpdatedBy
	from tblConceptRelationship cr
	inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
	where ConceptName1Fk = @nameGuid
	union 
	select cast(ConceptRelationshipgUID as varchar(38)) as ConceptRelationshipGuid,
		ConceptRelationshipLSID,
		ConceptRelationshipConcept1Fk,
		ConceptRelationshipConcept2Fk,
		ConceptRelationshipRelationship,
		ConceptRelationshipRelationshipFk,
		ConceptRelationshipHybridOrder,
		ConceptRelationshipCreatedDate,
		ConceptRelationshipCreatedBy,
		ConceptRelationshipUpdatedDate,
		ConceptRelationshipUpdatedBy
	from tblConcept c 
	inner join tblConceptRelationship cr on cr.ConceptRelationshipConcept2Fk = c.ConceptPk
	where c.ConceptName1Fk = @nameGuid
	
GO

	
GRANT EXEC ON sprSelect_NameConcepts TO PUBLIC

GO


