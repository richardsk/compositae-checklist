IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderReference')
	BEGIN
		DROP  View vwProviderReference
	END
GO

CREATE View vwProviderReference AS

select p.ProviderName,
		PRCitation,
		PRFullCitation,
		PRReferenceId,
		PRLinkStatus,
		PRXML,
		PRReferenceVersion,
		PRPk,
		PRProviderImportFk,
		cast(PRReferenceFk as varchar(38)) as PRReferenceFk,
		p.ProviderPk,
		p.ProviderIsEditor,
		PRCreatedDate,
		PRCreatedBy,
		PRUpdatedDate,
		PRUpdatedBy
	from tblProviderReference pr
	left join tblProviderImport pim on pim.ProviderImportPk = pr.PRProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk


GO


GRANT SELECT ON vwProviderReference TO PUBLIC

GO

