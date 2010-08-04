IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptById')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptById
	END

GO

CREATE Procedure sprSelect_ProviderConceptById
	@providerPk int,
	@PCConceptId nvarchar(300)
AS

	select *
	from vwProviderConcept
	where PCConceptId = @PCConceptId and ProviderPk = @providerPk

GO


GRANT EXEC ON sprSelect_ProviderConceptById TO PUBLIC

GO


