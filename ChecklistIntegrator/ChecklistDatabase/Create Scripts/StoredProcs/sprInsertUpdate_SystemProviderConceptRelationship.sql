IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_SystemProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprInsertUpdate_SystemProviderConceptRelationship
	END

GO

CREATE Procedure sprInsertUpdate_SystemProviderConceptRelationship
	@PCPk int, --provider concept pk	
	@PCRPk int, --provider concept relationship pk
	@PCRProviderImportFk int,
	@PCRLinkStatus nvarchar(20),
	@PCRMatchScore int,
	@PCRConceptRelationshipFk uniqueidentifier,
	@PCRConcept1Id nvarchar(300),
	@PCRConcept2Id nvarchar(300),
	@PCRIsPreferredConcept bit,
	@PCRId nvarchar(300),
	@PCRRelationship nvarchar(300),
	@PCRRelationshipId nvarchar(300),
	@PCRRelationshipFk int,
	@PCRHybridOrder int,
	@PCRVersion nvarchar(200),
	@user nvarchar(50)
AS
	
	if (@pcrId is null or len(@pcrId) = 0) set @pcrId = newid()
	
	--for system record we need to set all text fields to the source provider name/ref details
	declare @provFk int
	select @provFk = ProviderImportProviderFk 
	from tblProviderImport
	where ProviderImportPk = @pcrproviderImportfk
	
	select @PCRHybridOrder = ConceptRelationshipHybridOrder, @PCRRelationship = ConceptRelationshipRelationship
	from vwProviderConceptRelationship pcr
	inner join tblConceptRelationship cr on cr.ConceptRelationshipGuid = pcr.PCRConceptRelationshipFk
	where PCRConcept1Id = @PCRConcept1Id and ProviderPk = @provFk and PCRRelationshipFk = @PCRRelationshipFk
		
	if (@PCRRelationship is null and @PCRRelationshipFk is not null)
	begin
		select @PCRRelationship = RelationshipTypeName 
		from tblRelationshipType 
		where RelationshipTypePk = @PCRRelationshipFk
	end
	
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
			
		select @PCRPk = @@identity		
	end
	else
	begin
	
		exec sprInsert_ProviderConceptChange @pcpk, @user
	
		update tblProviderConceptRelationship
		set  PCRProviderImportFk = @PCRProviderImportFk,
			PCRLinkStatus = @PCRLinkStatus,
			PCRMatchScore = @PCRMatchScore,
			PCRConceptRelationshipFk = @PCRConceptRelationshipFk,
			PCRConcept1Id = @PCRConcept1Id,
			PCRConcept2Id = @PCRConcept2Id,
			PCRIsPreferredConcept = @PCRIsPreferredConcept,
			PCRId = @PCRId,
			PCRRelationship = @PCRRelationship,
			PCRRelationshipId = @PCRRelationshipId,
			PCRRelationshipFk = @PCRRelationshipFk,
			PCRHybridOrder = @PCRHybridOrder,
			PCRVersion = @PCRVersion,
			PCRUpdatedDate = getdate(),
			PCRUpdatedBy = @user
		where PCRPk = @PCRPk
		
	end
	
	select * 
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk

GO


GRANT EXEC ON sprInsertUpdate_SystemProviderConceptRelationship TO PUBLIC

GO

