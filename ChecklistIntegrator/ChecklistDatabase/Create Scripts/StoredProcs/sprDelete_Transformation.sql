IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Transformation')
	BEGIN
		DROP  Procedure  sprDelete_Transformation
	END

GO

CREATE Procedure sprDelete_Transformation
	@transPk int
AS

	delete tblTransformation
	where TransformationPk = @transPk

GO


GRANT EXEC ON sprDelete_Transformation TO PUBLIC

GO


