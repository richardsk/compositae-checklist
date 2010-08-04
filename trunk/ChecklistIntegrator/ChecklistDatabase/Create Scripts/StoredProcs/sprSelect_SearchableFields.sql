 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SearchableFields')
	BEGIN
		DROP  Procedure  sprSelect_SearchableFields
	END

GO

CREATE Procedure sprSelect_SearchableFields
	@tableName varchar(50)
AS

	select * from tblSearchable
	where SearchableTableName = @tableName and SearchableIsSearchable = 1

GO


GRANT EXEC ON sprSelect_SearchableFields TO PUBLIC

GO


