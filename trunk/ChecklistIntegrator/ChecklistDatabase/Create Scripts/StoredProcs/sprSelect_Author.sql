IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Author')
	BEGIN
		DROP  Procedure  sprSelect_Author
	END

GO

CREATE Procedure sprSelect_Author
	@authorPk int
AS

	select *
	from tblAuthors
	where AuthorPk = @authorPk

GO


GRANT EXEC ON sprSelect_Author TO PUBLIC

GO


