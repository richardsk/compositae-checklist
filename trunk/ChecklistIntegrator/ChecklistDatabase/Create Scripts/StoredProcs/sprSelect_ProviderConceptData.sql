IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptData')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderConceptData
	END

GO

CREATE Procedure dbo.sprSelect_ProviderConceptData
	@pnpk int
AS
	--get concepts to and from this provider name
	
	--from
	select pn.PNPk, pc.* 
	from vwProviderConcept pc
	inner join vwProviderConcept vpc on vpc.PCPk = pc.PCPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	where PNPk = @pnpk	
	union	
	--to
	select pn.PNPk, pc.* 
	from vwProviderName pn
	inner join vwProviderConcept vpc on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	inner join vwProviderConceptRelationship vpcr on vpcr.PCRConcept1Id = vpc.PCConceptId and vpcr.ProviderPk = vpc.ProviderPk
	inner join vwProviderConcept pc on pc.PCConceptId = vpcr.PCRConcept2Id and pc.ProviderPk = vpcr.ProviderPk
	where PNPk = @pnpk
	
	--from
	select vpc.PCPk,
		pcr.PCRPk,
		pc2.PCPk as PCPk2, 
		pcr.PCRProviderImportFk, 
		pcr.PCRLinkStatus, 
		pcr.PCRMatchScore, 
		cast(pcr.PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		pcr.PCRConcept1Id, 
		pcr.PCRConcept2Id, 
		pcr.PCRIsPreferredConcept, 
		pcr.PCRId, 
		pcr.PCRRelationship, 
		pcr.PCRRelationshipId, 
		pcr.PCRRelationshipFk, 
		pcr.PCRHybridOrder, 
		pcr.PCRVersion, 
		pcr.PCRCreatedDate, 
		pcr.PCRCreatedBy, 
		pcr.PCRUpdatedDate, 
		pcr.PCRUpdatedBy
	from vwProviderConceptRelationship pcr 
	inner join vwProviderConcept vpc on vpc.PCPk = pcr.PCPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	inner join vwProviderConcept pc2 on pc2.ProviderPk = pcr.ProviderPk and pc2.PCConceptId = pcr.PCRConcept2Id
	where PNPk = @pnpk
	union
	--to	
	select vpc.PCPk,
		pcr.PCRPk, 
		pc2.PCPk as PCPk2, 
		pcr.PCRProviderImportFk, 
		pcr.PCRLinkStatus, 
		pcr.PCRMatchScore, 
		cast(pcr.PCRConceptRelationshipFk as varchar(38)) as PCRConceptRelationshipFk, 
		pcr.PCRConcept1Id, 
		pcr.PCRConcept2Id, 
		pcr.PCRIsPreferredConcept, 
		pcr.PCRId, 
		pcr.PCRRelationship, 
		pcr.PCRRelationshipId, 
		pcr.PCRRelationshipFk, 
		pcr.PCRHybridOrder, 
		pcr.PCRVersion, 
		pcr.PCRCreatedDate, 
		pcr.PCRCreatedBy, 
		pcr.PCRUpdatedDate, 
		pcr.PCRUpdatedBy
	from vwProviderConceptRelationship pcr 
	inner join vwProviderConcept vpc on vpc.PCConceptId = pcr.PCRConcept2Id and vpc.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = vpc.PCName1Id and pn.ProviderPk = vpc.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk 
	where PNPk = @pnpk

GO


GRANT EXEC ON dbo.sprSelect_ProviderConceptData TO PUBLIC

GO


