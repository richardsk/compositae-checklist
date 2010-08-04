IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_SystemProviderRIS')
	BEGIN
		DROP  Procedure  sprDelete_SystemProviderRIS
	END

GO

CREATE Procedure sprDelete_SystemProviderRIS
	@providerReferenceFk int
AS

	delete ris
	from vwProviderRIS pr
	inner join tblProviderRIS ris on ris.PRISPk = pr.PRISPk
	where pr.PRISProviderReferenceFk = @providerReferenceFk and pr.ProviderIsEditor = 1

GO


GRANT EXEC ON sprDelete_SystemProviderRIS TO PUBLIC

GO


