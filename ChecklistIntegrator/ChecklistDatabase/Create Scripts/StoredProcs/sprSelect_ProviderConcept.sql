IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConcept')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConcept
	END

GO

CREATE Procedure sprSelect_ProviderConcept
	@PCPk int
AS

	select * 
	from vwProviderConcept
	where PCPk = @PCPk

GO


GRANT EXEC ON sprSelect_ProviderConcept TO PUBLIC

GO


