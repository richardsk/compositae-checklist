IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameMappings')
	BEGIN
		DROP  Procedure  sprSelect_NameMappings
	END

GO

CREATE Procedure sprSelect_NameMappings

AS

	select * from tblNameMapping

GO


GRANT EXEC ON sprSelect_NameMappings TO PUBLIC

GO


