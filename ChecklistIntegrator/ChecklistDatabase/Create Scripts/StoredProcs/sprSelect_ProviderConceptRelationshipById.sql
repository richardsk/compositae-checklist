IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRelationshipById')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRelationshipById
	END

GO

CREATE Procedure sprSelect_ProviderConceptRelationshipById
	@ProviderPk int,
	@Concept1Id nvarchar(300),
	@Concept2Id nvarchar(300),
	@relType nvarchar(300)
AS

	select *
	from vwProviderConceptRelationship
	where PCRConcept1Id = @Concept1Id and PCRConcept2Id = @Concept2Id and PCRRelationship = @relType
		and ProviderPk = @ProviderPk
	
GO


GRANT EXEC ON sprSelect_ProviderConceptRelationshipById TO PUBLIC

GO


