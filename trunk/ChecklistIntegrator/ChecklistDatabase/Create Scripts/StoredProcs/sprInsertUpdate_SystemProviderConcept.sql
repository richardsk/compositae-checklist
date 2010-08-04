IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_SystemProviderConcept')
	BEGIN
		DROP  Procedure  sprInsertUpdate_SystemProviderConcept
	END

GO

CREATE Procedure sprInsertUpdate_SystemProviderConcept
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

	--for system record we need to set all text fields to the source provider name/ref details
	declare @provFk int
	select @provFk = ProviderImportProviderFk 
	from tblProviderImport
	where ProviderImportPk = @pcproviderImportfk
	
	select @PCName1 = NameFull 
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	where PNNameId = @PCName1Id and ProviderPk = @provFk
	
	select @PCAccordingTo = ReferenceCitation 
	from vwProviderReference pr
	inner join tblReference r on r.ReferenceGuid = pr.PRReferenceFk
	where PRReferenceId = @PCAccordingToId and ProviderPk = @provFk
	
		
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


GRANT EXEC ON sprInsertUpdate_SystemProviderConcept TO PUBLIC

GO


