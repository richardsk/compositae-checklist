IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_MergeNameConcepts')
	BEGIN
		DROP  Procedure  sprUpdate_MergeNameConcepts
	END

GO

CREATE Procedure sprUpdate_MergeNameConcepts
	@name1Guid uniqueidentifier, --id of name to keep
	@name2Guid uniqueidentifier,
	@user nvarchar(50)
AS

	--merge any concepts that are the same
	--from name2guid
	declare @ids table(rowNum int identity, conceptId int, name1Id uniqueidentifier, accTo nvarchar(3400), lsid nvarchar(300))
	insert @ids
	select ConceptPk, ConceptName1Fk, ConceptAccordingTo, ConceptLSID
	from tblConcept 
	where ConceptName1Fk = @name2Guid
	
	declare @pos int, @count int, @cpk int, @id int, @lsid nvarchar(300), @newlsid nvarchar(300)
	declare @name1Id uniqueidentifier, @accTo nvarchar(4000)
	
	select @pos = 1, @count = count(*) from @ids
	while (@pos <= @count)
	begin
		select @id = conceptId, @name1Id = name1Id, @accTo = accTo, @lsid = lsid
		from @ids where rowNum = @pos
		
		set @cpk = null
		select @cpk = ConceptPk, @newlsid = ConceptLSID 
		from tblconcept 
		where conceptname1Fk = @name1Guid and isnull(ConceptAccordingTo,'') = isnull(@accTo, '')
			
		print(@id)
		print(@cpk)
		
		if (@cpk is not null)
		begin
			--change all concept relationships from matched concepts to point at the concept for the merged name
			update tblConceptRelationship
			set ConceptRelationshipConcept1Fk = @cpk, ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user
			where ConceptRelationshipConcept1Fk = @id
			
			update tblConceptRelationship
			set ConceptRelationshipConcept2Fk = @cpk, ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = @user
			where ConceptRelationshipConcept2Fk = @id
						
			--change provider concept to point at concept for the merged to name
			update tblProviderConcept
			set PCConceptFk = @cpk, PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCConceptFk = @id
			
			--delete concept
			exec sprDelete_Concept @lsid, @newLsid, @user
			
		end
				
		
		set @pos = @pos + 1
	end
	
	--merge concept relationships
	declare @crids table(rowNum int identity, conceptRelId uniqueidentifier, concept1Id int, concept2Id int, relFk int, lsid nvarchar(300))
	insert @crids
	select ConceptRelationshipGuid, ConceptRelationshipConcept1Fk, ConceptRelationshipConcept2Fk, ConceptRelationshipRelationshipFk, ConceptRelationshipLSID
	from tblConceptRelationship
	inner join tblConcept on ConceptPk = ConceptRelationshipConcept1Fk
	where ConceptName1Fk = @name1Guid
	
	declare @crpk uniqueidentifier, @id2 uniqueidentifier
	declare @cr1Id int, @cr2Id int, @relFk int
	
	select @pos = 1, @count = count(*) from @crids
	while (@pos <= @count)
	begin
		select @id2 = conceptRelId, @cr1Id = concept1Id, @cr2Id = concept2Id, @relFk = relFk, @lsid = lsid
		from @crids where rowNum = @pos
		
		set @crpk = null
		select @crpk = ConceptRelationshipGuid, @newlsid = ConceptRelationshipLSID 
		from tblConceptRelationship
		where ConceptRelationshipConcept1Fk = @cr1Id and ConceptRelationshipConcept2Fk = @cr2Id
			and ConceptRelationshipRelationshipFk = @relFk 
			and ConceptRelationshipGuid <> @id2
			
		print(@id2)
		print(@crpk)
		
		if (@crpk is not null)
		begin
			--change provider concept rels to point at mathced concept rel 
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = @crpk, PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
			where PCRConceptRelationshipFk = @id2
			
			--delete concept rel
			exec sprDelete_ConceptRelationship @lsid, @newLsid, @user
			
		end				
		
		set @pos = @pos + 1
	end
	
	--update remaining concepts for this name to point to the new consensus name
	
	update tblConcept
	set ConceptName1Fk = @name1Guid,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	where ConceptName1Fk = @name2Guid
	

GO


GRANT EXEC ON sprUpdate_MergeNameConcepts TO PUBLIC

GO


