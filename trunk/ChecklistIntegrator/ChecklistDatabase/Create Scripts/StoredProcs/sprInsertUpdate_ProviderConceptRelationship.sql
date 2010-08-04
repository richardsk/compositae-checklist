 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderConceptRelationship
	END

GO

CREATE Procedure sprInsertUpdate_ProviderConceptRelationship
	@PCPk int, --provider concept pk	
	@PCRPk int, --provider concept relationship pk
	@PCRProviderImportFk int,
	@PCRLinkStatus nvarchar(20),
	@PCRMatchScore int,
	@PCRConceptRelationshipFk uniqueidentifier,
	@PCRId nvarchar(300),
	@PCRConcept1Id nvarchar(300),
	@PCRConcept2Id nvarchar(300),
	@PCRRelationship nvarchar(300),
	@PCRRelationshipId nvarchar(300),
	@PCRRelationshipFk int,
	@PCRHybridOrder int,
	@PCRIsPreferredConcept bit,
	@PCRVersion nvarchar(200),
	@user nvarchar(50)
AS
	
	declare @oldFk uniqueidentifier
	
	if (@PCRPk = -1)
	begin
		insert tblProviderConceptRelationship
		select @PCRProviderImportFk,
			@PCRLinkStatus,
			@PCRMatchScore,
			@PCRConceptRelationshipFk,
			@PCRConcept1Id,
			@PCRConcept2Id,
			@PCRIsPreferredConcept,
			@PCRId,
			@PCRRelationship,
			@PCRRelationshipId,
			@PCRRelationshipFk,
			@PCRHybridOrder,
			@PCRVersion,
			getdate(),
			@user,
			null, null
			
		select @@identity
	end
	else
	begin
		select @oldFk = PCRConceptRelationshipFk from tblProviderConceptRelationship where PCRPk = @PCRPk
		
		exec sprInsert_ProviderConceptChange @pcpk, @user
	
		update tblProviderConceptRelationship
		set  PCRProviderImportFk = @PCRProviderImportFk,
			PCRLinkStatus = @PCRLinkStatus,
			PCRMatchScore = @PCRMatchScore,
			PCRConceptRelationshipFk = @PCRConceptRelationshipFk,
			PCRConcept1Id = @PCRConcept1Id,
			PCRConcept2Id = @PCRConcept2Id,
			PCRIsPreferredConcept = @PCRIspreferredConcept,
			PCRRelationship = @PCRRelationship,
			PCRRelationshipId = @PCRRelationshipId,
			PCRRelationshipFk = @PCRRelationshipFk,
			PCRHybridOrder = @PCRHybridOrder,
			PCRVersion = @PCRVersion,
			PCRUpdatedDate = getdate(),
			PCRUpdatedBy = @user
		where PCRPk = @PCRPk
		
		select @PCRPk
	end

	--check to see if PC concept fks need updating
	--this will happen when this PCR has been matched to an existing CR, so the PCs need to also be hooked up
	if (@PCRConceptRelationshipFk is not null and (@oldFk is null or @oldFk <> @PCRConceptRelationshipFk))
	begin
		--hook PCs to associated Concepts
		update pc
		set PCConceptFk = ConceptRelationshipConcept1Fk,
			PCLinkStatus = @PCRLinkStatus,
			PCUpdatedDate = getdate(),
			PCUpdatedBy = @user
		from tblProviderConcept pc
		inner join vwProviderConcept vpc on vpc.pcpk = pc.pcpk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = vpc.PCConceptId and vpc.providerpk = pcr.providerpk
		inner join tblConceptRelationship on ConceptRelationshipGuid = PCRConceptRelationshipFk
		where ConceptRelationshipGuid = @PCRConceptRelationshipFk
		
		update pc
		set PCConceptFk = ConceptRelationshipConcept2Fk,
			PCLinkStatus = @PCRLinkStatus,
			PCUpdatedDate = getdate(),
			PCUpdatedBy = @user
		from tblProviderConcept pc
		inner join vwProviderConcept vpc on vpc.pcpk = pc.pcpk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = vpc.PCConceptId and vpc.providerpk = pcr.providerpk
		inner join tblConceptRelationship on ConceptRelationshipGuid = PCRConceptRelationshipFk
		where ConceptRelationshipGuid = @PCRConceptRelationshipFk
		
	end
	

GO


GRANT EXEC ON sprInsertUpdate_ProviderConceptRelationship TO PUBLIC

GO


