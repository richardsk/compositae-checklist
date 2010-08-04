IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Transformations')
	BEGIN
		DROP  Procedure  sprSelect_Transformations
	END

GO

CREATE Procedure sprSelect_Transformations
	
AS

	select * from tblTransformation

GO


GRANT EXEC ON sprSelect_Transformations TO PUBLIC

GO


