IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AllNamesForUpdate')
	BEGIN
		DROP  Procedure  sprSelect_AllNamesForUpdate
	END

GO

CREATE Procedure sprSelect_AllNamesForUpdate

AS

	--all names except root name

	select cast(n.NameGUID as varchar(38)) as NameGuid
	from tblName n
	where NameFull <> 'ROOT' and namefull <> 'unknown'

GO


GRANT EXEC ON sprSelect_AllNamesForUpdate TO PUBLIC

GO


