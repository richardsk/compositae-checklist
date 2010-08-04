IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ConceptRelationship')
	BEGIN
		DROP  Procedure  dbo.sprDelete_ConceptRelationship
	END

GO

CREATE Procedure dbo.sprDelete_ConceptRelationship
	@conceptRelLSID nvarchar(300),
	@newConceptRelLSID nvarchar(300),
	@user nvarchar(50)
AS
	
	declare @conceptPk int, @conceptRelGuid uniqueidentifier, @newRelGuid uniqueidentifier
	
	select @conceptPk = ConceptRelationshipConcept1Fk, @conceptRelGuid = ConceptRelationshipGuid
	from tblConceptRelationship 
	where ConceptRelationshipLsid = @conceptRelLsid

	select @newRelGuid = ConceptRelationshipGuid
	from tblConceptRelationship 
	where ConceptRelationshipLsid = @newConceptRelLsid
	
	
	insert into tblDeprecated 
	select @conceptRelLSID, @newConceptRelLsid, 'tblConceptRelationship', getdate(), @user
	
	delete tblConceptRelationship
	where ConceptRelationshipLsid = @conceptRelLsid

	--delete any old system prov rel records
	--delete SYSTEM prov concept if no relationships left for it	
	delete pc
	from vwproviderconcept vpc
	inner join tblProviderConcept pc on pc.pcpk = vpc.pcpk
	where not exists( select * from vwproviderconceptrelationship pcr where pcr.pcrconcept1id = pc.pcconceptid 
			and pcr.providerpk = vpc.providerpk ) 
		and not exists( select * from vwproviderconceptrelationship pcr where pcr.pcrconcept2id = pc.pcconceptid 
			and pcr.providerpk = vpc.providerpk )  
		and (ProviderIsEditor = 1 or ProviderName = 'SYSTEM')
		
	delete pcr
	from vwProviderConceptRelationship vpcr
	inner join tblProviderConceptRelationship pcr on pcr.pcrpk = vpcr.pcrpk
	where pcr.PCRConceptRelationshipFk = @conceptRelGuid
		and (ProviderIsEditor = 1 or ProviderName = 'SYSTEM')
	
	update tblProviderConceptRelationship
	set PCRConceptRelationshipFk = @newRelGuid
	where PCRConceptRelationshipFk = @conceptRelGuid
	
		
	/*if not exists(select * from tblConceptRelationship where ConceptRelationshipConcept1Fk = @conceptPk)
	begin
		declare @oldLsid nvarchar(300), @newLsid nvarchar(300)
		select @oldLsid = ConceptLsid from tblConcept where ConceptPk = @conceptPk
		select @newLsid = ConceptLsid 
		from tblConcept c
		inner join tblConceptRelationship cr on cr.ConceptRelationshipConcept1Fk = c.ConceptPk
		where cr.ConceptRelationshipLsid = @newConceptRelLsid
		
		--delete concept as well
		insert into tblDeprecated
		select @oldLsid, @newLsid, 'tblConcept', getdate(), @user
	end*/

	
GO

GO


GRANT EXEC ON dbo.sprDelete_ConceptRelationship TO PUBLIC

GO


