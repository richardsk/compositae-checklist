IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_OtherDataTypes')
	BEGIN
		DROP  Procedure  sprSelect_OtherDataTypes
	END

GO

CREATE Procedure sprSelect_OtherDataTypes
	
AS

	select * from tblOtherDataType

GO


GRANT EXEC ON sprSelect_OtherDataTypes TO PUBLIC

GO


