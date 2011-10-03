IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameConceptLinks')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameConceptLinks
	END

GO

CREATE Procedure sprUpdate_ProviderNameConceptLinks
	@PNPk int,
	@user nvarchar(50)
AS

	--update consensus concept name links to point to the correct names
	--this will be done after a provider name has been linked, so the concepts need to follow the link
	-- this sp is called when there was no previous PCName1Fk, ie first link up, so we cannot update the 
	-- links based on Name1Fk

	declare @updates table(counter int identity, nameGuid uniqueidentifier)
	
	insert @updates
	select distinct c.ConceptName1Fk 
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.pcpk = pc.pcpk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc2.ProviderPk
	where pn.PNPk = @PNPk
	
	insert @updates
	select distinct ConceptName1Fk 
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = pcr.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc2.ProviderPk
	where pn.PNPk = @PNPk and not exists(select * from @updates where nameGuid = c.ConceptName1Fk)
	
	
	--do updates 
	
	update c
	set ConceptName1Fk = pn.PNNameFk,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @PNPk
	
	update c
	set ConceptName1Fk = pn.PNNameFk,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = pcr.ProviderPk
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept1Id and pc2.ProviderPk = pcr.ProviderPk
	inner join vwProviderName pn on pn.PNNameId = pc2.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @PNPk


	--return all affected names
	select nameguid from @updates

GO


GRANT EXEC ON sprUpdate_ProviderNameConceptLinks TO PUBLIC

GO


