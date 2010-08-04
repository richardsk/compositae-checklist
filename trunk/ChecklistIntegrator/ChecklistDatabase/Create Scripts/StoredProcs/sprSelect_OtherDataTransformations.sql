IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_OtherDataTransformations')
	BEGIN
		DROP  Procedure  sprSelect_OtherDataTransformations
	END

GO

CREATE Procedure sprSelect_OtherDataTransformations

AS

	select * from tblOtherDataTransformation

GO


GRANT EXEC ON sprSelect_OtherDataTransformations TO PUBLIC

GO


