IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_OtherDataTransformation')
	BEGIN
		DROP  Procedure  sprDelete_OtherDataTransformation
	END

GO

CREATE Procedure sprDelete_OtherDataTransformation
	@provImportFk int,
	@otherDataType nvarchar(100),
	@outputTypeFk int
AS
	
	delete tblOtherDataTransformation 
	where ProviderImportFk = @provImportFk and POtherDataType = @otherDataType 
		and isnull(OutputTypeFk, 0) = isnull(@outputTypeFk, 0)

	exec sprupdate_cleanotherdata --delete other data no longer valid 
	
GO


GRANT EXEC ON sprDelete_OtherDataTransformation TO PUBLIC

GO


