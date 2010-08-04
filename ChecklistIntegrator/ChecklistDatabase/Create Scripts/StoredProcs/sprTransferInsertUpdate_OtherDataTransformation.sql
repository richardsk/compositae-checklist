IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_OtherDataTransformation')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_OtherDataTransformation
	END

GO

CREATE Procedure sprTransferInsertUpdate_OtherDataTransformation
	@providerImportFk int,
	@potherdataType nvarchar(100),
	@useDataXml bit,
	@transformationFk int,
	@addRoot bit,
	@outputTypeFk int,
	@runDate datetime,
	@updatedBy nvarchar(50),
	@updatedDate datetime
AS

	delete tblOtherDataTransformation where ProviderImportFk = @providerImportFk and POtherDataType = @potherDataType

	insert tblOtherDataTransformation 
	select @providerImportFk,
		@potherDataType,
		@useDataXml, 
		@transformationFk,
		@addRoot,
		@outputTypeFk,
		@runDate,
		@updatedBy,
		@updatedDate

GO


GRANT EXEC ON sprTransferInsertUpdate_OtherDataTransformation TO PUBLIC

GO


