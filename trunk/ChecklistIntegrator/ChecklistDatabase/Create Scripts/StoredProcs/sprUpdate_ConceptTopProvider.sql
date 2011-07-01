IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptTopProvider')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptTopProvider
	END

GO


CREATE PROCEDURE [sprUpdate_ConceptTopProvider]
AS
	
	delete tblConceptTopProvider

	
	insert tblConceptTopProvider
	select ConceptPk,
		(select top 1 p.providerpk
		from tblProviderConceptRelationship pcr
		inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
		inner join tblprovider p on p.providerpk = pim.ProviderImportProviderFk
		where pcr.pcrconceptrelationshipfk = cr.conceptrelationshipguid
		order by providerpreferredconceptranking),
		(select top 1 p.ProviderName
		from tblProviderConceptRelationship pcr
		inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
		inner join tblprovider p on p.providerpk = pim.ProviderImportProviderFk
		where pcr.pcrconceptrelationshipfk = cr.conceptrelationshipguid
		order by providerpreferredconceptranking)
	from tblConcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept1fk = c.conceptpk and conceptrelationshiprelationshipfk = 15
	

	delete tblConceptTopProvider where ProviderPk is null		