IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProvidersForReference')
	BEGIN
		DROP  Procedure  sprSelect_ProvidersForReference
	END

GO

CREATE Procedure sprSelect_ProvidersForReference
	@referenceGuid uniqueidentifier
AS

	
	select p.*
	from tblProvider p
	inner join (select distinct p.ProviderPk
		from tblProvider p
		inner join tblProviderImport pim on pim.ProviderImportProviderFk = p.ProviderPk
		inner join tblProviderReference pr on pr.PRProviderImportFk = pim.ProviderImportPk
		where pr.PRReferenceFk = @referenceGuid and PRLinkStatus <> 'Discarded') ps on ps.ProviderPk = p.ProviderPk

GO

GRANT EXEC ON sprSelect_ProvidersForReference TO PUBLIC

GO


