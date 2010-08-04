IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Concept')
	BEGIN
		DROP  Procedure  sprSelect_Concept
	END

GO

CREATE Procedure sprSelect_Concept
	@conceptPk int
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
	where ConceptPk = @conceptPk

GO


GRANT EXEC ON sprSelect_Concept TO PUBLIC

GO


  