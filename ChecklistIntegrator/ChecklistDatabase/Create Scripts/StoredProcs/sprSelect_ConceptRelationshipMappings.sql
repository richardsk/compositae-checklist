IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptRelationshipMappings')
	BEGIN
		DROP  Procedure  sprSelect_ConceptRelationshipMappings
	END

GO

CREATE Procedure sprSelect_ConceptRelationshipMappings

AS

	select * from tblConceptRelationshipMapping

GO


GRANT EXEC ON sprSelect_ConceptRelationshipMappings TO PUBLIC

GO


  