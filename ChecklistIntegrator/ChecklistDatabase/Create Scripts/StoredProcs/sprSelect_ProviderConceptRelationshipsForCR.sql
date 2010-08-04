IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRelationshipsForCR')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRelationshipsForCR
	END

GO

CREATE Procedure sprSelect_ProviderConceptRelationshipsForCR
	@CRGuid uniqueidentifier
AS

	select pcr.*, pc1.PCConceptFk as PCConcept1Fk, pc2.PCConceptFk as PCConcept2Fk
	from vwProviderConceptRelationship pcr
	inner join vwProviderConcept pc1 on pc1.PCConceptId = pcr.PCRConcept1Id and pc1.ProvideRPk = pcr.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProvideRPk = pcr.ProviderPk
	where PCRConceptRelationshipFk = @CRGuid and PCRLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_ProviderConceptRelationshipsForCR TO PUBLIC

GO


 