IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RelationshipTypes')
	BEGIN
		DROP  Procedure  sprSelect_RelationshipTypes
	END

GO

CREATE Procedure sprSelect_RelationshipTypes

AS

	select * 
	from tblRelationshipType
	where RelationshipTypeName is not null

GO


GRANT EXEC ON sprSelect_RelationshipTypes TO PUBLIC

GO


