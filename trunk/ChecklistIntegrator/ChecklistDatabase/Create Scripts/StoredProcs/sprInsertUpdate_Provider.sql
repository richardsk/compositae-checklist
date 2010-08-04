IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Provider')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Provider
	END

GO

CREATE Procedure sprInsertUpdate_Provider
	@providerId int,
	@providerName nvarchar(250),
	@providerHomeUrl nvarchar(250),
	@providerProjectUrl nvarchar(250),
	@providerContactName nvarchar(100),
	@providerContactPhone nvarchar(100),
	@providerContactEmail nvarchar(200),
	@providerContactAddress nvarchar(250),
	@providerNameFull nvarchar(4000),
	@providerStatement ntext,
	@providerIsEditor bit,
	@providerUseForParentage bit,
	@providerPrefConceptRanking int,
	@user nvarchar(50)
AS

	if (@providerId = -1)
	begin
		insert tblProvider
		select @providerName,
			@providerHomeUrl,
			@providerProjectUrl,
			@providerContactName,
			@providerContactEmail,
			@providerContactPhone,
			@providerContactAddress,
			@providerNameFull,
			@providerStatement,
			@providerIsEditor,
			@providerUseForParentage,
			@providerPrefConceptRanking,
			getdate(),
			@user,
			null, null
			 
	end
	else
	begin
		update tblProvider
		set ProviderName = @providerName,
			ProviderHomeUrl = @providerHomeUrl,
			ProviderProjectUrl = @providerProjectUrl,
			ProviderContactName = @providerContactName,
			ProviderContactEmail = @providerContactEmail,
			ProviderContactPhone = @providerContactPhone,
			ProviderContactAddress = @providerContactAddress,
			ProviderNameFull = @providerNameFull,
			ProviderStatement = @providerStatement,
			ProviderIsEditor = @providerIsEditor,
			ProviderUseForParentage = @providerUseForParentage,
			ProviderPreferredConceptRanking = @providerPrefConceptRanking,
			ProviderUpdatedDate = getdate(),
			ProviderUpdatedBy = @user
		where ProviderPk = @providerId
	end

	select @@identity

GO


GRANT EXEC ON sprInsertUpdate_Provider TO PUBLIC

GO


