IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderImport')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderImport
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderImport
	@providerImportPk int,
    @providerFk int,
    @importTypeFk int,
    @fileName nvarchar(200),
    @importStatus nvarchar(20),
    @importDate datetime,
    @notes nvarchar(4000),
	@higherNameId uniqueidentifier,
	@higherPNId nvarchar(300),
	@genusNameId uniqueidentifier,
	@genusPNId nvarchar(300),
    @createdDate datetime,
    @createdBy nvarchar(50),
    @updatedDate datetime,
    @updatedBy nvarchar(50)

AS

	if (@providerImportPk = -1 or not exists(select * from tblProviderImport where ProviderImportPk = @providerImportPk))
	begin
		set identity_insert tblProviderImport on
		insert tblProviderImport(ProviderImportPk, ProviderImportProviderFk, ProviderImportImportTypeFk, ProviderImportFileName, ProviderImportStatus, ProviderImportDate, ProviderImportNotes, ProviderImportHigherNameId, ProviderImportHigherPNId, ProviderImportGenusNameId, ProviderImportGenusPNId, ProviderImportCreatedDate, ProviderImportCreatedBy, ProviderImportUpdatedDate, ProviderImportUpdatedBy)
		select @providerImportPk,
			@providerFk,
			@importTypeFk,
			@fileName,
			@importStatus,
			@importDate,
			@notes,
			@higherNameId,
			@higherPNId,
			@genusNameId,
			@genusPNId,
			@createdDate,
			@createdBy,
			@updatedDate,			
			@updatedBy
			
		set identity_insert tblProviderImport off
	end
	else
	begin
		update tblProviderImport
		set ProviderImportProviderFk = @providerFk,
			ProviderImportImportTypeFk = @importTypeFk,
			ProviderImportFileName = @fileName,
			ProviderImportStatus = @importStatus,
			ProviderImportDate = @importDate,
			ProviderImportNotes = @notes,
			ProviderImportHigherNameId = @higherNameId,
			ProviderImportHigherPNId = @higherPNId,
			ProviderImportGenusNameId = @genusNameId,
			ProviderImportGenusPNId = @genusPNId,
			ProviderImportCreatedDate = @createdDate,
			ProviderImportCreatedBy = @createdBy,			
			ProviderImportUpdatedDate = @updatedDate,
			ProviderImportUpdatedBy = @updatedBy
		where ProviderImportPk = @providerImportPk
	end


GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderImport TO PUBLIC

GO


