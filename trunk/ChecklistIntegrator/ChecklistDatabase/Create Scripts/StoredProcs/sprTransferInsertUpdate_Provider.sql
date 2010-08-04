IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Provider')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Provider
	END

GO

CREATE Procedure sprTransferInsertUpdate_Provider
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
	@providerCreatedDate datetime,
	@providerCreatedBy nvarchar(50),
	@providerUpdatedDate datetime,
	@providerUpdatedBy nvarchar(50)
AS

	if (@providerId = -1 or not exists(select * from tblProvider where ProviderPk = @providerId))
	begin
	
		set identity_insert tblProvider on
		insert tblProvider(ProviderPk, ProviderName, ProviderHomeUrl, ProviderProjectUrl, ProviderContactName, ProviderContactEmail, ProviderContactPhone, ProviderContactAddress, ProviderNameFull, ProviderStatement, ProviderIsEditor, ProviderUseForParentage, ProviderPreferredConceptRanking, ProviderCreatedDate, ProviderCreatedBy, ProviderUpdatedDate, ProviderUpdatedBy)
		select @providerId,
			@providerName,
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
			@providerCreatedDate,
			@providerCreatedBy,
			@providerUpdatedDate,
			@providerUpdatedBy 
		set identity_insert tblProvider off
			 
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
			ProviderCreatedDate = @providerCreatedDate,
			ProviderCreatedBy = @providerCreatedBy,
			ProviderUpdatedDate = @providerUpdatedDate,
			ProviderUpdatedBy = @providerUpdatedBy 			
		where ProviderPk = @providerId
	end

	select @@identity


GO


GRANT EXEC ON sprTransferInsertUpdate_Provider TO PUBLIC

GO


