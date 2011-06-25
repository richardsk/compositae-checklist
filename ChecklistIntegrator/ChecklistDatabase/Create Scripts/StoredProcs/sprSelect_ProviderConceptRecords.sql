 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRecords')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRecords
	END

GO

CREATE Procedure sprSelect_ProviderConceptRecords
	@conceptPk int
AS
	select p.ProviderName,
		PCName1, 
		PCAccordingTo, 
		PCConceptVersion,
		PCLinkStatus, 
		PCMatchScore, 
		PCConceptId, 
		PCName1Id, 
		PCAccordingToId, 
		PCConceptFk, 
		p.ProviderPk,
		p.ProviderIsEditor,
		PCPk, 
		PCProviderImportFk, 
		PCCreatedDate, 
		PCCreatedBy, 
		PCUpdatedDate, 
		PCUpdatedBy,
		pr.PRReferenceFk
	from tblProviderConcept pc
	inner join tblProviderImport pim on pim.ProviderImportPk = pc.PCProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	left join tblProviderReference pr on pr.PRReferenceId = pc.PCAccordingToId 
	left join tblProviderImport prim on prim.ProviderImportPk = pr.PRProviderImportFk and p.providerpk = prim.ProviderImportProviderFk
	where PCConceptFk = @conceptPk

GO


GRANT EXEC ON sprSelect_ProviderConceptRecords TO PUBLIC

GO


