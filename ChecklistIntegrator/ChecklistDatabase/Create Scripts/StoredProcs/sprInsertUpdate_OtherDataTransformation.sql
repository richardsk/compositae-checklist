IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherDataTransformation')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherDataTransformation
	END

GO

CREATE Procedure sprInsertUpdate_OtherDataTransformation
	@provImportFk int,
	@otherDataType nvarchar(100),
	@useXml bit,
	@transFk int,
	@addRoot bit,
	@outTypeFk int,
	@runDate datetime,
	@user nvarchar(50)
	
AS

	delete tblOtherDataTransformation where ProviderImportFk = @provImportFk and POtherDataType = @otherDataType and OutputTypeFk = @outTypeFk
	
	insert tblOtherDataTransformation 
	select @provImportFk,
		@otherDataType,
		@useXml, 
		@transFk,
		@addRoot,
		@outTypeFk,
		@runDate,
		@user,
		getdate()
				

GO


GRANT EXEC ON sprInsertUpdate_OtherDataTransformation TO PUBLIC

GO


