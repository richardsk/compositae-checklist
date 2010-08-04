IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RISTypes')
	BEGIN
		DROP  Procedure  sprSelect_RISTypes
	END

GO

CREATE Procedure sprSelect_RISTypes

AS

	select * from tblRISType

GO


GRANT EXEC ON sprSelect_RISTypes TO PUBLIC

GO


