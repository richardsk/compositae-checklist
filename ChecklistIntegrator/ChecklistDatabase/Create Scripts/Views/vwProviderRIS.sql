IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderRIS')
	BEGIN
		DROP  View vwProviderRIS
	END
GO

CREATE View vwProviderRIS AS

	select  p.ProviderPk,
		p.ProviderName,
		p.ProviderIsEditor,
		cast(pr.PRReferenceFk as varchar(38)) as PRReferenceFk,		
		pris.*
	from tblProviderRIS pris
	inner join tblProviderReference pr on pr.prpk = pris.PRISProviderReferenceFk
	left join tblProviderImport pim on pim.ProviderImportPk = pr.PRProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk


GO


GRANT SELECT ON vwProviderRIS TO PUBLIC

GO

