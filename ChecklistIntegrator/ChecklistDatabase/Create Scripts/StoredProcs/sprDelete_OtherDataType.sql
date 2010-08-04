IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_OtherDataType')
	BEGIN
		DROP  Procedure  sprDelete_OtherDataType
	END

GO

CREATE Procedure sprDelete_OtherDataType
	@otherDataTypePk int
AS

	delete tblOtherDataType
	where OtherDataTypePk = @otherDataTypePk

	--clean up other data
	exec sprUpdate_CleanOtherData
GO


GRANT EXEC ON sprDelete_OtherDataType TO PUBLIC

GO


