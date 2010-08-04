IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Transformation')
	BEGIN
		DROP  Procedure  sprSelect_Transformation
	END

GO

CREATE Procedure sprSelect_Transformation
	@transfPk int
AS

	select * from tblTransformation where TransformationPk = @transfPk

GO


GRANT EXEC ON sprSelect_Transformation TO PUBLIC

GO


