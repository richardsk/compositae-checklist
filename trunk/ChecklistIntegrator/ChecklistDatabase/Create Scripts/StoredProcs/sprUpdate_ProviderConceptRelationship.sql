IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderConceptRelationship
	END

GO

CREATE Procedure sprUpdate_ProviderConceptRelationship
	@PCRPk int,
	@user nvarchar(50)
AS
	--update ProviderConceptRelationship RelationshipFks to point to relationship in tblReltationshipType table
	
	declare @pcpk int
	select @pcpk = pcpk
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk
	
	exec sprInsert_ProviderConceptChange @pcpk, @user
	
	declare @pcrRel nvarchar(100), @curRelFk int, @setRel int
									
	select @pcrRel = lower(PCRRelationship), @curRelFk = PCRRelationshipFk
	from tblProviderConceptRelationship
	where PCRPk = @PCRPk
	
	if (@curRelFk is null) 
	begin				
		declare @rels table(Counter int identity, RelPk int, Rel nvarchar(300), Inverse nvarchar(300))
					
		insert into @rels
		select RelationshipTypePk, RelationshipTypeName, RelationshipTypeInverse
		from tblRelationshipType
			
		
		declare @pos int, @count int, @rel nvarchar(300), @inverse nvarchar(300), @pk int
		select @pos = 1, @count = count(*) from @rels
		
		while (@pos < @count + 1)
		begin
			select @rel = Rel, @inverse = Inverse, @pk = RelPk from @rels where Counter = @pos
			
			if (@pcrRel = @rel)
			begin
				update tblProviderConceptRelationship
				set PCRRelationshipFk = @Pk, PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
				where PCRPk = @pcrpk
				
				set @setRel = @Pk
				set @count = -1 --end loop			
			end
			
			if (@pcrRel = @inverse) --inverse relationship - swap concept ids
			begin
				declare @concept1ID nvarchar(300), @concept2ID nvarchar(300)
				select @concept1ID = PCRConcept1Id, @concept2Id = PCRConcept2Id
				from tblProviderConceptRelationship
				where PCRPk = @pcrpk
				
				update tblProviderConceptRelationship
				set PCRRelationshipFk = @pk,
					PCRConcept1Id = @concept2Id,
					PCRConcept2Id = @concept1Id,
					PCRUpdatedDate = getdate(), 
					PCRUpdatedBy = @user		
				where PCRPk = @PCRPk
				
				
				set @setRel = @Pk
				set @count = -1 --end loop	
			end
				
			set @pos = @pos + 1
		end
	end		
	else
	begin
		set @setRel = @curRelFk
	end
		
	select @setRel
	
GO


GRANT EXEC ON sprUpdate_ProviderConceptRelationship TO PUBLIC

GO


