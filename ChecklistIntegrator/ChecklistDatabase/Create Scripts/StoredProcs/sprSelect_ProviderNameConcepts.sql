IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameConcepts')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNameConcepts
	END

GO

CREATE Procedure sprSelect_ProviderNameConcepts
	@pnpk int
AS
	
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
		inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		where pn.PNPk = @PNPk
		union
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = pc.PCConceptId and pcr.ProviderPk = pc.ProviderPk
		inner join vwProviderConcept pc2 on pc2.PCPk = pcr.PCPK 
		where pn.PNPk = @PNPk

GO


GRANT EXEC ON sprSelect_ProviderNameConcepts TO PUBLIC

GO


