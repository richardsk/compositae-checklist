IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRelationship
	END

GO

CREATE Procedure sprSelect_ProviderConceptRelationship
	@PCRPk int
AS

	select *
	from vwProviderConceptRelationship 
	where PCRPk = @PCRPk

GO


GRANT EXEC ON sprSelect_ProviderConceptRelationship TO PUBLIC

GO


