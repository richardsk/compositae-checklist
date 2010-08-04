IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AuthorByName')
	BEGIN
		DROP  Procedure  sprSelect_AuthorByName
	END

GO

CREATE Procedure sprSelect_AuthorByName
	@author nvarchar(300)
AS

	select *
	from tblAuthors
	where Abbreviation = @author

GO


GRANT EXEC ON sprSelect_AuthorByName TO PUBLIC

GO


