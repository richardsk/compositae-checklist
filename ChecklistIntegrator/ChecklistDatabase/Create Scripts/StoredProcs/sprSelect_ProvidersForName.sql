IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProvidersForName')
	BEGIN
		DROP  Procedure  sprSelect_ProvidersForName
	END

GO

CREATE Procedure sprSelect_ProvidersForName
	@nameGuid uniqueidentifier
AS

	select p.*
	from tblProvider p
	inner join (select distinct p.ProviderPk
		from tblProvider p
		inner join tblProviderImport pim on pim.ProviderImportProviderFk = p.ProviderPk
		inner join tblProviderName pn on pn.PNProviderImportFk = pim.ProviderImportPk
		where pn.PNNameFk = @nameGuid and pn.PNLinkStatus <> 'Discarded') ps on ps.ProviderPk = p.ProviderPk

GO


GRANT EXEC ON sprSelect_ProvidersForName TO PUBLIC

GO


