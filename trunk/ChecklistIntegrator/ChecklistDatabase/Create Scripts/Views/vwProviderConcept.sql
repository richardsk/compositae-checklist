IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderConcept')
	BEGIN
		DROP  View dbo.vwProviderConcept
	END
GO

CREATE View dbo.vwProviderConcept AS

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
		PCUpdatedBy
	from tblProviderConcept pc
	inner join tblProviderImport pim on pim.ProviderImportPk = pc.PCProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk

GO


GRANT SELECT ON dbo.vwProviderConcept TO PUBLIC

GO

