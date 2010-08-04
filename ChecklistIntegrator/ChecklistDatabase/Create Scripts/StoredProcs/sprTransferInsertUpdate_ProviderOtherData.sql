IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderOtherData')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderOtherData
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderOtherData
	@otherDataPk int,
	@providerImportFk int,
	@dataType nvarchar(100),
	@dataName nvarchar(100),
	@dataRecordId nvarchar(300),
	@dataVersion nvarchar(200),
	@data ntext,
	@xml ntext,
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
AS

	if (@otherDataPk = -1 or not exists(select * from tblProviderOtherData where POtherDataTextPk = @otherDataPk))
	begin
		set identity_insert tblProviderOtherData on
		insert tblProviderOtherData(POtherDataTextPk, POtherDataProviderImportFk, POtherDataType, POtherDataName, POtherDataRecordId, POtherDataVersion, POtherDataData, POtherDataXML, POtherDataCreatedDate, POtherDataCreatedBy, POtherDataUpdatedDate, POtherDataUpdatedBy)
		select @otherDataPk,
			@providerImportFk,
			@dataType, 
			@dataName,
			@dataRecordId,
			@dataVersion,
			@data,
			@xml,
			@createdDate,
			@createdBy,                                                                             
			@updatedDate,
			@updatedBy
		
		set identity_insert tblProviderOtherData off	
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
			POtherDataCreatedDate = @createdDate,
			POtherDataCreatedBy = @createdBy,
			POtherDataUpdatedDate = @updatedDate,
			POtherDataUpdatedBy = @updatedBy
		where POtherDataTextPk = @otherDataPk
	end



GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderOtherData TO PUBLIC

GO


