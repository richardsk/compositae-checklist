IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptMappings')
	BEGIN
		DROP  Procedure  sprSelect_ConceptMappings
	END

GO

CREATE Procedure sprSelect_ConceptMappings

AS

	select * from tblConceptMapping

GO


GRANT EXEC ON sprSelect_ConceptMappings TO PUBLIC

GO


 