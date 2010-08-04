IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_ConceptRelationship
	END

GO

CREATE Procedure sprSelect_ConceptRelationship
	@conceptRelGuid uniqueidentifier
AS

	select cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
		cr.ConceptRelationshipConcept1Fk,
		cr.ConceptRelationshipConcept2Fk,
		cr.ConceptRelationshipRelationship,
		cr.ConceptRelationshipRelationshipFk,
		c.ConceptName1, 
		cast(c.ConceptName1Fk as varchar(38)) as ConceptName1Fk, 
		cto.ConceptName1 as ConceptToName1, 
		cast(cto.ConceptName1Fk as varchar(38)) as ConceptToName1Fk, 
		c.ConceptAccordingTo, 
		cast(c.ConceptAccordingToFk as varchar(38)) as ConceptAccordingToFk, 
		cto.ConceptAccordingTo as ConceptToAccordingTo,
		cast(cto.ConceptAccordingToFk as varchar(38)) as ConceptToAccordingToFk,
		cr.ConceptRelationshipHybridOrder,
		cr.ConceptRelationshipLSID
	from tblConceptRelationship cr
	inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
	inner join tblConcept cto on cto.ConceptPk = cr.ConceptRelationshipConcept2Fk
	where ConceptRelationshipGuid = @conceptRelGuid

GO


GRANT EXEC ON sprSelect_ConceptRelationship TO PUBLIC

GO


