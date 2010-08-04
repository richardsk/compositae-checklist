IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ParentProviderName')
	BEGIN
		DROP  Procedure  sprSelect_ParentProviderName
	END

GO

CREATE Procedure sprSelect_ParentProviderName
	@PNPk int
AS
	--select parent concept of provider name, using the concepts
	
	select p.* 
	from vwProviderName pn
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.providerPk 
	inner join vwProviderConceptRelationship pcr on pcr.ProviderPk = pc.ProviderPk 
		and pcr.PCRConcept1Id = pc.PCConceptId and pcr.PCRRelationshipFk = 6 --parent
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc2.ProviderPk
	where pn.PNPk = @PNPk  

GO


GRANT EXEC ON sprSelect_ParentProviderName TO PUBLIC

GO


