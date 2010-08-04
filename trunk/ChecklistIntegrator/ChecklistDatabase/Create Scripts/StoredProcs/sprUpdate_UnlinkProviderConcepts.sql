IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_UnlinkProviderConcepts')
	BEGIN
		DROP  Procedure  sprUpdate_UnlinkProviderConcepts
	END

GO

CREATE Procedure sprUpdate_UnlinkProviderConcepts
	@pnpk int,
	@user nvarchar(50)
AS

	update pc
	set PCConceptFk = null,
		PCLinkStatus = 'Unmatched',
		PCMatchScore = null,
		PCUpdatedDate = getdate(),
		PCUpdatedBy = @user
	from vwProviderConcept pc
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
	where pn.PNPk = @PNPk
	
	
	update pcr
	set pcr.PCRConceptRelationshipFk = null,
		pcr.PCRLinkStatus = 'Unmatched',
		pcr.PCRMatchScore = null,
		pcr.PCRUpdatedDate = getdate(),
		pcr.PCRUpdatedBy = @user
	from tblProviderConceptRelationship pcr
	inner join vwProviderConceptRelationship vpcr on vpcr.PCRPk = pcr.PCRPk
	inner join vwProviderConcept pc on pc.PCConceptId = vpcr.PCRConcept1Id and pc.ProviderPk = vpcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
	where pn.PNPk = @PNPk
	
	update pcr
	set pcr.PCRConceptRelationshipFk = null,
		pcr.PCRLinkStatus = 'Unmatched',
		pcr.PCRMatchScore = null,
		pcr.PCRUpdatedDate = getdate(),
		pcr.PCRUpdatedBy = @user
	from tblProviderConceptRelationship pcr
	inner join vwProviderConceptRelationship vpcr on vpcr.pcrpk = pcr.pcrpk
	inner join vwProviderConcept pc on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = vpcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
	where pn.PNPk = @PNPk

GO


GRANT EXEC ON sprUpdate_UnlinkProviderConcepts TO PUBLIC

GO


