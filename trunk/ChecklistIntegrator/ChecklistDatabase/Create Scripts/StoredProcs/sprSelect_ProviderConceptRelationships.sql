IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRelationships')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRelationships
	END

GO

CREATE Procedure sprSelect_ProviderConceptRelationships
	@nameGuid uniqueidentifier,
	@inclToConcepts bit
AS

	if (@inclToConcepts = 1)
	begin
		select distinct pcr.*
		from vwProviderConceptRelationship pcr
		inner join tblConceptRelationship cr on cr.ConceptRelationshipGuid = pcr.pcrconceptrelationshipfk
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		where ConceptName1Fk = @nameGuid and PCRLinkStatus <> 'Discarded'
		union
		select pcr.*
		from vwProviderConceptRelationship pcr
		inner join tblConceptRelationship cr on cr.ConceptRelationshipGuid = pcr.pcrconceptrelationshipfk
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where ConceptName1Fk = @nameGuid and PCRLinkStatus <> 'Discarded'
		order by pcr.PCRRelationshipFk
	end
	else
	begin
		select pcr.*
		from vwProviderConceptRelationship pcr
		inner join tblConceptRelationship cr on cr.ConceptRelationshipGuid = pcr.pcrconceptrelationshipfk
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		where ConceptName1Fk = @nameGuid and PCRLinkStatus <> 'Discarded'
		order by pcr.PCRRelationshipFk, PCName2
	end

GO


GRANT EXEC ON sprSelect_ProviderConceptRelationships TO PUBLIC

GO


