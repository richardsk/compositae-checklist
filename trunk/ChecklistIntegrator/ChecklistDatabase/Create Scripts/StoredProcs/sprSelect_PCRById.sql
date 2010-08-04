IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_PCRById')
	BEGIN
		DROP  Procedure  sprSelect_PCRById
	END

GO

CREATE Procedure sprSelect_PCRById
	@providerPk int,
	@PCRId nvarchar(300)
AS

	select *
	from vwProviderConceptRelationship
	where PCRId = @pcrId and ProviderPk = @ProviderPk
	

GO


GRANT EXEC ON sprSelect_PCRById TO PUBLIC

GO


 