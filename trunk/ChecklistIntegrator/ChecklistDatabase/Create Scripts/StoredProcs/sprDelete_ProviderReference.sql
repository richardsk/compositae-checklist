IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ProviderReference')
	BEGIN
		DROP  Procedure  sprDelete_ProviderReference
	END

GO

CREATE Procedure sprDelete_ProviderReference
	@providerPk int,
	@providerReferenceId nvarchar(4000) --original provider's ref id
	
AS

	delete pr
	from tblProviderReference pr
	inner join tblProviderImport pim on pim.ProviderImportPk = pr.PRProviderImportFk
	where ProviderImportProviderFk = @providerPk and PRReferenceId = @providerReferenceId

GO


GRANT EXEC ON sprDelete_ProviderReference TO PUBLIC

GO


