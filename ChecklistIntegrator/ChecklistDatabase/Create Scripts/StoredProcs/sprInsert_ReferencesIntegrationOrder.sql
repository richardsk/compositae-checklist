IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ReferencesIntegrationOrder')
	BEGIN
		DROP  Procedure  sprInsert_ReferencesIntegrationOrder
	END

GO

CREATE Procedure sprInsert_ReferencesIntegrationOrder
	@providerPk int
AS
	delete tmpIntegration
	
	dbcc checkident(tmpIntegration, RESEED, 0)
	
	insert tmpIntegration(RecordId)
	select PRPk
	from vwproviderreference 
	where PRReferenceFk is null and PRLinkStatus <> 'Discarded' 
		and (@providerPk is null or ProviderPk = @providerPk)

GO


GRANT EXEC ON sprInsert_ReferencesIntegrationOrder TO PUBLIC

GO


