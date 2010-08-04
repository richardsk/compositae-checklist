IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_MergedReferenceLinks')
	BEGIN
		DROP  Procedure  sprUpdate_MergedReferenceLinks
	END

GO

CREATE Procedure sprUpdate_MergedReferenceLinks
	@referenceGuid uniqueidentifier,
	@mergedReferenceGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--merge any concepts that are now equivalent because of the merged refs
	--update any namereferencefks to point at new reference
	
	declare @concepts table(conceptPk1 int, conceptPk2 int, row int identity)
	declare @rels table(relGuid1 uniqueidentifier, relGuid2 uniqueidentifier, row int identity)
	
	declare @crpk1 uniqueidentifier, @crpk2 uniqueidentifier
		
	insert @concepts
	select distinct c.ConceptPk, c2.ConceptPk
	from tblConcept c
	inner join tblConcept c2 on c2.ConceptName1Fk = c.ConceptName1Fk and c.ConceptPk <> c2.ConceptPk
	where c.ConceptAccordingToFk = @referenceGuid and c2.ConceptAccordingToFk = @mergedReferenceGuid
	
	declare @pos int, @count int, @cpk1 int, @cpk2 int
	declare @oldLSID nvarchar(300), @newLSID nvarchar(300)
	
	select @pos = 1, @count = count(*) from @concepts
	
	while (@pos <= @count)
	begin
		select @cpk1 = conceptPk1, @cpk2 = conceptPk2 from @concepts where row = @pos
		
		update tblProviderConcept
		set PCConceptFk = @cpk1, PCLinkStatus = 'Merge', PCUpdatedDate = getdate(), PCUpdatedBy = @user		
		where PCConceptFk = @cpk2
		
		update tblConceptRelationship
		set ConceptRelationshipConcept1Fk = @cpk1, 
			ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user		
		where ConceptRelationshipConcept1Fk = @cpk2
		
		update tblConceptRelationship
		set ConceptRelationshipConcept2Fk = @cpk1, 
			ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user		
		where ConceptRelationshipConcept2Fk = @cpk2
		
		select @newLSID = ConceptLSID from tblConcept where ConceptPk = @cpk1
		select @oldLSID = ConceptLSID from tblConcept where ConceptPk = @cpk2
		
		exec sprDelete_Concept @oldLSID, @newLSID, @user
		
		
		--now merge any concept relationships that are now equivalent because of the merges
		
		delete @rels
				
		insert @rels
		select distinct 
			case when (cr.ConceptRelationshipGuid > cr2.ConceptRelationshipGuid) then cr.ConceptRelationshipGuid else cr2.ConceptRelationshipGuid end,
			case when (cr.ConceptRelationshipGuid > cr2.ConceptRelationshipGuid) then cr2.ConceptRelationshipGuid else cr.ConceptRelationshipGuid end
		from tblConceptRelationship cr
		inner join tblConceptRelationship cr2 on cr2.ConceptRelationshipConcept1Fk = cr.ConceptRelationshipConcept1Fk 
			and cr2.ConceptRelationshipConcept2Fk = cr.ConceptRelationshipConcept2Fk 
			and cr2.ConceptRelationshipRelationshipFk = cr.ConceptRelationshipRelationshipFk
			and isnull(cr2.ConceptRelationshipHybridOrder, '') = isnull(cr.ConceptRelationshipHybridOrder, '')
			and cr2.ConceptRelationshipGuid <> cr.ConceptRelationshipGuid
		where cr.ConceptRelationshipConcept1Fk = @cpk1 or cr2.ConceptRelationshipConcept1Fk = @cpk1 
		
		declare @relPos int, @relCount int
		select @relPos = 1, @relCount = count(*) from @rels
		
		while (@relPos <= @relCount)
		begin
			select @crpk1 = relGuid1, @crpk2 = relGuid2 from @rels where row = @relPos
			
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = @crpk1, PCRLinkStatus = 'Merge', PCRUpdatedDate = getdate(), PCRUpdatedBy = @user		
			where PCRConceptRelationshipFk = @crpk2
					
			select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @crpk1
			select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @crpk2
			
			exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
			
			set @relPos = @relPos + 1
		end
	
		set @pos = @pos + 1
	end
	
		
	--update namereferencefks
	update tblname
	set NameReferenceFk = @referenceGuid,
		NamePublishedIn = (select ReferenceCitation from tblReference where ReferenceGuid = @referenceGuid)
	where NameReferenceFk = @mergedReferenceGuid
	
	update tblprovidername
	set PNReferenceFk = @referenceGuid,
		PNPublishedIn = (select ReferenceCitation from tblReference where ReferenceGuid = @referenceGuid)
	where PNReferenceFk = @mergedReferenceGuid
	

GO


GRANT EXEC ON sprUpdate_MergedReferenceLinks TO PUBLIC

GO


