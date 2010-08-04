IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_ProviderOtherData')
	BEGIN
		DROP  Procedure  sprInsertUpdate_ProviderOtherData
	END

GO

CREATE Procedure sprInsertUpdate_ProviderOtherData
	@otherDataPk int,
	@providerImportFk int,
	@dataType nvarchar(100),
	@dataName nvarchar(100),
	@dataRecordId nvarchar(300),
	@dataVersion nvarchar(200),
	@data ntext,
	@xml ntext,
	@user nvarchar(50)
AS

	if (@otherDataPk = -1)
	begin
		insert tblProviderOtherData
		select @providerImportFk,
			@dataType, 
			@dataName,
			@dataRecordId,
			@dataVersion,
			@data,
			@xml,
			getdate(),
			@user,
			null, null			
	end
	else
	begin
		update tblProviderOtherData
		set POtherDataProviderImportFk = @providerImportFk,
			POtherDataType = @dataType,
			POtherDataName = @dataName,
			POtherDataRecordId = @dataRecordId,
			POtherDataVersion = @dataVersion,
			POtherDataData = @data,
			POtherDataXml = @xml,
			POtherDataUpdatedDate = getdate(),
			POtherDataUpdatedBy = @user
		where POtherDataTextPk = @otherDataPk
	end

GO


GRANT EXEC ON sprInsertUpdate_ProviderOtherData TO PUBLIC

GO


