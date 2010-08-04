IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConflictingConcepts')
	BEGIN
		DROP  Procedure  sprSelect_ConflictingConcepts
	END

GO

CREATE Procedure sprSelect_ConflictingConcepts
	@nameGuid uniqueidentifier,
	@nameTo nvarchar(300)
AS

		select pcr.*
		from vwProviderConceptRelationship pcr
		inner join tblConceptRelationship cr on cr.ConceptRelationshipGuid = pcr.pcrconceptrelationshipfk
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		where ConceptName1Fk = @nameGuid and PCRLinkStatus <> 'Discarded' and PCName2 <> @nameTo
		order by pcr.PCRRelationshipFk, PCName2

GO


GRANT EXEC ON sprSelect_ConflictingConcepts TO PUBLIC

GO


