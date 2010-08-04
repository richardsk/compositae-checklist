IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RISMappings')
	BEGIN
		DROP  Procedure  sprSelect_RISMappings
	END

GO

CREATE Procedure sprSelect_RISMappings
	
AS

	select * from tblRISMapping

GO


GRANT EXEC ON sprSelect_RISMappings TO PUBLIC

GO


