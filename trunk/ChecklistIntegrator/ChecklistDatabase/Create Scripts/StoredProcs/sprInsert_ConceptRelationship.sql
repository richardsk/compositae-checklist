IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ConceptRelationship')
	BEGIN
		DROP  Procedure  dbo.sprInsert_ConceptRelationship
	END

GO

CREATE Procedure dbo.sprInsert_ConceptRelationship
	@PCRPk int,
	@user nvarchar(50),
	@conceptRelGuid uniqueidentifier output
AS 
	--inserts a ConceptRelationship if an equivalent doesnt already exist
	-- inserts Concepts for the relationship if they dont exist
	-- if the PCR was already pointing at a consensus CR then it may need to be unlinked

	declare @concept1Id nvarchar(300), @concept2Id nvarchar(300), @providerPk int
	declare @relationship nvarchar(300), @relationshipFk int, @oldCRGuid uniqueidentifier
	declare @hybridOrder int
	declare @name1 nvarchar(4000), @name2 nvarchar(4000) 
	declare @accordingTo nvarchar(4000) 
	declare @name1Fk uniqueidentifier, @name2Fk uniqueidentifier, @accToFk uniqueidentifier
	declare @PCPk1 int, @PCPk2 int
	declare @conceptPk int, @conceptToPk int
	declare @pcLinkStatus nvarchar(20), @pcToLinkStatus nvarchar(20), @pcrLinkStatus nvarchar(20)
	declare @oldLSID nvarchar(300), @newLSID nvarchar(300)
	set @pcLinkStatus = 'Matched'
	set @pcToLinkStatus = 'Matched'
	set @pcrLinkStatus = 'Matched'
		
	select @concept1Id = PCRConcept1Id, @concept2Id = PCRConcept2Id, @relationship = PCRRelationship,
		@relationshipFk = PCRRelationshipFk, @hybridOrder = PCRHybridOrder, @providerPk = ProviderPk,
		@oldCRGuid = PCRConceptRelationshipFk
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk
	
	--get fks for names and ref (the ProviderName and Providerref Ids are passed into this SP)
	select @name1Fk = PNNameFk, @name1 = NameFull, @PCPk1 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
	
	select @name2Fk = PNNameFk, @name2 = NameFull, @PCPk2 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept2Id and pc.ProviderPk = @providerPk
	
	select @accToFk = PRReferenceFk, @accordingto = PCAccordingTo
	from vwProviderReference pr
	inner join vwProviderConcept pc on (pc.ProviderPk = pr.ProviderPk or pc.provideriseditor = 1) and pc.PCAccordingToId = pr.PRReferenceId
	where pc.PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
		
	--only insert if names have been inserted
	-- or name 2 is null, for non-parent rels (eg pref name pointing to 'nothing')
	if (@name1Fk is not null and (@name2Fk is not null or @relationshipFk <> 6))
	begin
		
		declare @tmpId uniqueidentifier
		set @tmpId = newid()
		
		select top 1 @conceptPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name1Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
		
		select top 1 @conceptToPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name2Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
			
		if (@conceptPk is null)
		begin
			insert tblConcept
			select null,
				@name1,
				@name1Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptPk = @@identity
			set @pcLinkStatus = 'Inserted'
		end
		
		if (@conceptToPk is null and @name2Fk is not null)
		begin
			insert tblConcept
			select null,
				@name2,
				@name2Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptToPk = @@identity
			set @pcToLinkStatus = 'Inserted'
		end
		
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptPk as nvarchar(20))
		where ConceptPk = @conceptPk
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptToPk as nvarchar(20))
		where ConceptPk = @conceptToPk
		
		
		--insert concept relationship?
			
		select top 1 @conceptRelGuid = ConceptRelationshipGuid 
		from tblConceptRelationship 
		where ConceptRelationshipConcept1Fk = @conceptPk and isnull(ConceptRelationshipConcept2Fk,0) = isnull(@conceptToPk,0)
			and ConceptRelationshipRelationshipFk = @relationshipFk
		
		if (@conceptRelGuid is null)
		begin
			set @conceptRelGuid = newid()	
		
			insert tblConceptRelationship
			select @conceptRelGuid, 'urn:lsid:compositae.org:concept-relationship:' + cast(@conceptRelGuid as varchar(38)), 
				@conceptPk, @conceptToPk, @relationship, @relationshipFk, @hybridorder, 
				getdate(), @user, null, null
				
			set @pcrLinkStatus = 'Inserted'
		end	
				
		--set provider Fks to point to consensus records
		update tblProviderConceptRelationship
		set PCRConceptRelationshipFk = @conceptRelGuid, PCRLinkStatus = @pcrLinkStatus, PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
		where PCRPk = @PCRPk
		
		update tblProviderConcept
		set PCConceptFk = @conceptPk, PCLinkStatus = @pcLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk1
		
		update tblProviderConcept
		set PCConceptFk = @conceptToPk, PCLinkStatus = @pcToLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk2
			
		--delete old concept rel?
		if (@oldCRGuid is not null and not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
		begin			
			select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid
			select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @conceptRelGuid

			exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
		end
			
		--if this is a parent or preferred concept then update the assoc. tblname fields
		if (@relationshipFk = 6 or @relationshipFk = 15)
		begin
			exec sprUpdate_NameRelationData @name1Fk, @user
		end
		
	end
	else
	begin
		--unlink?
		if (@oldCRGuid is not null)
		begin
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = null, PCRLinkStatus = 'Unmatched', PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
			where PCRPk = @PCRPk
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk1
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk2
			
			--delete old concept rel?
			if (not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
			begin				
				select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid

				exec sprDelete_ConceptRelationship @oldLSID, 'Unlinked', @user
			end
		end
	end
	
	
	select cast(ConceptRelationshipgUID as varchar(38)) as ConceptRelationshipGuid,
		ConceptRelationshipLSID,
		ConceptRelationshipConcept1Fk,
		ConceptRelationshipConcept2Fk,
		ConceptRelationshipRelationship,
		ConceptRelationshipRelationshipFk,
		ConceptRelationshipHybridOrder,
		ConceptRelationshipCreatedDate,
		ConceptRelationshipCreatedBy,
		ConceptRelationshipUpdatedDate,
		ConceptRelationshipUpdatedBy
	from tblConceptRelationship 
	where ConceptRelationshipGuid = @conceptRelGuid 

GO


GRANT EXEC ON dbo.sprInsert_ConceptRelationship TO PUBLIC

GO


