IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderConcept')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderConcept
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderConcept
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
	@PCCreatedDate datetime,
	@PCCreatedBy nvarchar(50),
	@PCUpdatedDate datetime,
	@PCUpdatedBy nvarchar(50)
AS
	
	if (@PCPk = -1 or not exists(select * from tblProviderConcept where PCPk = @PCPk))
	begin
		set identity_insert tblProviderConcept on
		insert tblProviderConcept(PCPk, PCProviderImportFk, PCLinkStatus, PCMatchScore, PCConceptFk, PCConceptId, PCName1, PCName1Id, PCAccordingTo, PCAccordingToId, PCConceptVersion, PCCreatedDate, PCCreatedBy, PCUpdatedDate, PCUpdatedBy)
		select @PCPk, 
			@PCProviderImportFk,
			@PCLinkStatus,
			@PCMatchScore,
			@PCConceptFk,
			@PCConceptId,
			@PCName1,
			@PCName1Id,
			@PCAccordingTo,
			@PCAccordingToId,
			@PCConceptVersion,
			@PCCreatedDate,
			@PCCreatedBy,
			@PCUpdatedDate,
			@PCUpdatedBy
			
		set identity_insert tblProviderConcept off
	end
	else
	begin		
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
			PCCreatedDate = @PCCreatedDate,
			PCCreatedBy = @PCCreatedBy,
			PCUpdatedDate = @PCUpdatedDate,
			PCUpdatedBy = @PCUpdatedBy
		where PCPk = @PCPk
		
	end


GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderConcept TO PUBLIC

GO


