IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SystemProviderRefForRef')
	BEGIN
		DROP  Procedure  sprSelect_SystemProviderRefForRef
	END

GO

CREATE Procedure sprSelect_SystemProviderRefForRef
	@refGuid uniqueidentifier
AS

	
	select p.ProviderPk,
		p.ProviderName,
		p.ProviderIsEditor,
		PRPk,
		PRProviderImportFk,
		PRReferenceId,
		cast(PRReferenceFk as varchar(38)) as PRReferenceFk,
		PRLinkStatus,
		PRCitation,
		PRFullCitation,
		PRXML,
		PRCreatedDate,
		PRCreatedBy,
		PRUpdatedDate,
		PRUpdatedBy
	from tblProviderReference pr
	left join tblProviderImport pim on pim.ProviderImportPk = pr.PRProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	where PRReferenceFk = @refGuid and p.ProviderIsEditor = 1 and PRLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_SystemProviderRefForRef TO PUBLIC

GO


