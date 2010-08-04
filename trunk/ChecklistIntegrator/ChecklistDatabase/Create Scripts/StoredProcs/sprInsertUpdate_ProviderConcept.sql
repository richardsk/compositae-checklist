IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderConcept')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderConcept
	END

GO

CREATE Procedure sprInsertUpdate_ProviderConcept
	@PCPk int,
	@PCProviderImportFk int,
	@PCLinkStatus nvarchar(20),
	@PCMatchScore int,
	@PCConceptFk int,
	@PCConceptId nvarchar(300),
	@PCName1 nvarchar(4000),
	@PCName1Id nvarchar(300),
	@PCAccordingTo nvarchar(4000),
	@PCAccordingToId nvarchar(300),
	@PCConceptVersion nvarchar(200),
	@user nvarchar(50)
AS
	
	if (@PCPk = -1)
	begin
		insert tblProviderConcept
		select @PCProviderImportFk,
			@PCLinkStatus,
			@PCMatchScore,
			@PCConceptFk,
			@PCConceptId,
			@PCName1,
			@PCName1Id,
			@PCAccordingTo,
			@PCAccordingToId,
			@PCConceptVersion,
			getdate(),
			@user,
			null, null
			
		select @@identity
	end
	else
	begin
	
		exec sprInsert_ProviderConceptChange @pcpk, @user
	
		update tblProviderConcept
		set  PCProviderImportFk = @PCProviderImportFk,
			PCLinkStatus = @PCLinkStatus,
			PCMatchScore = @PCMatchScore,
			PCConceptFk = @PCConceptFk,
			PCConceptId = @PCConceptId,
			PCName1 = @PCName1,
			PCName1Id = @PCName1Id,
			PCAccordingTo = @PCAccordingTo,
			PCAccordingToId = @PCAccordingToId,
			PCConceptVersion = @PCConceptVersion,
			PCUpdatedDate = getdate(),
			PCUpdatedBy = @user
		where PCPk = @PCPk
		
		select @PCPk
	end

GO


GRANT EXEC ON sprInsertUpdate_ProviderConcept TO PUBLIC

GO


