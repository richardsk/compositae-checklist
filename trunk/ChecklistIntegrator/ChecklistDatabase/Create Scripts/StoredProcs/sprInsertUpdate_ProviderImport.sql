IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderImport')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderImport
	END

GO

CREATE Procedure sprInsertUpdate_ProviderImport
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
    @user nvarchar(50)

AS

	if (@providerImportPk = -1)
	begin
		insert tblProviderImport
		select @providerFk,
			@importTypeFk,
			@fileName,
			@importStatus,
			@importDate,
			@notes,
			@higherNameId,
			@higherPNId,
			@genusNameId,
			@genusPNId,
			getdate(),
			@user,
			null, null
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
			ProviderImportUpdatedDate = getdate(),
			ProviderImportUpdatedBy = @user
		where ProviderImportPk = @providerImportPk
	end

	select @@identity

GO


GRANT EXEC ON sprInsertUpdate_ProviderImport TO PUBLIC

GO


