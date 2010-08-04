IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedReferences')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedReferences
	END

GO

CREATE Procedure sprSelect_UnlinkedReferences
	@providerPk int
AS

	select  *
	from vwProviderReference
	where PRReferenceFk is null and PRLinkStatus <> 'Discarded'
		and (@providerPk is null or ProviderPk = @providerPk)
	

GO


GRANT EXEC ON sprSelect_UnlinkedReferences TO PUBLIC

GO


