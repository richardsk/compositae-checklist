IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderConceptRelationship')
	BEGIN
		DROP  View dbo.vwProviderConceptRelationship
	END
GO

CREATE View dbo.vwProviderConceptRelationship AS

	
	select p.ProviderName,
		pc1.PCName1,
		PCRRelationship,
		pc2.PCName1 as PCName2, 
		pc1.PCAccordingTo,		
		PCRLinkStatus, 
		PCRMatchScore, 
		pc1.PCName1Id, 
		pc2.PCName1Id as PCName2Id,
		PCRConcept1Id,
		PCRConcept2Id,
		pc1.PCAccordingToId,
		PCRHybridOrder,
		PCRId,
		PCRIsPreferredConcept,
		PCRVersion,
		PCRRelationshipId,
		PCRRelationshipFk,
		cast(PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		p.ProviderPk,
		p.ProviderIsEditor,
		PCRPk, 
		pc1.PCPk,
		PCRProviderImportFk, 
		PCRCreatedDate, 
		PCRCreatedBy, 
		PCRUpdatedDate, 
		PCRUpdatedBy
	from tblProviderConceptRelationship pcr
	inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	inner join vwProviderConcept pc1 on pc1.PCConceptId = pcr.PCRConcept1Id and pc1.ProviderPk = p.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = p.ProviderPk


GO


GRANT SELECT ON dbo.vwProviderConceptRelationship TO PUBLIC

GO

