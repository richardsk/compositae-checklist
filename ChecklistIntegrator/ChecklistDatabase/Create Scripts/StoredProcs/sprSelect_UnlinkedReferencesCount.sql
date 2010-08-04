IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedReferencesCount')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedReferencesCount
	END

GO

CREATE Procedure sprSelect_UnlinkedReferencesCount
	@providerPk int
AS

	select  count(*)
	from vwProviderReference
	where PRReferenceFk is null and PRLinkStatus <> 'Discarded'
		and (@providerPk is null or ProviderPk = @providerPk)

GO


GRANT EXEC ON sprSelect_UnlinkedReferencesCount TO PUBLIC

GO


