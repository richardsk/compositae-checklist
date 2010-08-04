IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ProviderNameRecord')
	BEGIN
		DROP  Procedure  sprDelete_ProviderNameRecord
	END

GO

CREATE Procedure sprDelete_ProviderNameRecord
	@providerPk int,
	@providerNameId nvarchar(4000) --original providers id, not the PNPk
AS

	delete pn
	from tblProviderName pn
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk
	where ProviderImportProviderFk = @providerPk and PNNameId = @providerNameId

GO


GRANT EXEC ON sprDelete_ProviderNameRecord TO PUBLIC

GO


