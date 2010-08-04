IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ImportTypes')
	BEGIN
		DROP  Procedure  sprSelect_ImportTypes
	END

GO

CREATE Procedure sprSelect_ImportTypes
	
AS

	select * from tblImportType

GO

GRANT EXEC ON sprSelect_ImportTypes TO PUBLIC

GO


