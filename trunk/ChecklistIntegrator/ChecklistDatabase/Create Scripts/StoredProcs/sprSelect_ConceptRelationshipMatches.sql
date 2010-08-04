IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptRelationshipMatches')
	BEGIN
		DROP  Procedure  sprSelect_ConceptRelationshipMatches
	END

GO

CREATE Procedure sprSelect_ConceptRelationshipMatches
	@PCRPk int
AS

	declare @name1Id nvarchar(300), @name2Id nvarchar(300), @relFk int, @accToId nvarchar(4000), @accToFk uniqueidentifier
	declare @name2Fk uniqueidentifier, @name1Fk uniqueidentifier, @provPk int
		
	
	select @name1Id = pcr.PCName1Id, @name2Id = pcr.PCName2Id, @relFk = PCRRelationshipFk, @accToId = pc.PCAccordingToId,
		@provPk = pcr.ProviderPk
	from vwProviderConceptRelationship pcr
	inner join tblProviderConcept pc on pc.PCPk = pcr.PCPk
	where PCRPk = @PCRPk
	
	select @name1Fk = PNNameFk from vwProviderName where PNNameId = @name1Id and ProviderPk = @provPk
	select @name2Fk = PNNameFk from vwProviderName where PNNameId = @name2Id and ProviderPk = @provPk
	select @accToFk = PRReferenceFk from tblProviderReference where PRReferenceId = @accToId
		
	if (@name2Fk is not null and @relFk is not null)
	begin
		select cast(cr.ConceptRelationshipGuid as varchar(38)) as ConceptRelationshipGuid, 
			cr.ConceptRelationshipConcept1Fk,
			cr.ConceptRelationshipConcept2Fk,
			cr.ConceptRelationshipRelationship,
			cr.ConceptRelationshipRelationshipFk,
			c1.ConceptName1, 
			c1.ConceptName1Fk, 
			c2.ConceptName1 as ConceptToName1, 
			c2.ConceptName1Fk as ConceptToName1Fk, 
			c1.ConceptAccordingTo, 
			c1.ConceptAccordingToFk, 
			c2.ConceptAccordingTo as ConceptToAccordingTo,
			c2.ConceptAccordingToFk as ConceptToAccordingToFk,
			cr.ConceptRelationshipHybridOrder,
			cr.ConceptRelationshipLSID
		from tblConceptRelationship cr
		inner join tblConcept c1 on c1.ConceptPk = cr.ConceptRelationshipConcept1Fk
		inner join tblConcept c2 on c2.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where c1.ConceptName1Fk = @name1Fk and c2.ConceptName1Fk = @name2Fk 
				and ConceptRelationshipRelationshipFk = @relFk and 
				((@accToFk is null and c1.ConceptAccordingToFk is null) or (c1.ConceptAccordingToFk = @accToFk))
	end
	
GO


GRANT EXEC ON sprSelect_ConceptRelationshipMatches TO PUBLIC

GO


