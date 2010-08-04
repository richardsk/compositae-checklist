IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UknownTaxaNode')
	BEGIN
		DROP  Procedure  sprSelect_UknownTaxaNode
	END

GO

CREATE Procedure sprSelect_UknownTaxaNode

AS

	select *
	from tblName
	where NameFull = 'Unknown'

GO


GRANT EXEC ON sprSelect_UknownTaxaNode TO PUBLIC

GO


