IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FieldStatusLevels')
	BEGIN
		DROP  Procedure  sprSelect_FieldStatusLevels
	END

GO

CREATE PROCEDURE dbo.sprSelect_FieldStatusLevels

AS
	/* SET NOCOUNT ON */
	
	SELECT *
	FROM tblFieldStatusLevel
	
	RETURN @@ERROR


GO

