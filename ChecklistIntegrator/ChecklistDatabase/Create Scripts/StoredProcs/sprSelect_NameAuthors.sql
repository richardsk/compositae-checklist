IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameAuthors')
	BEGIN
		DROP  Procedure  sprSelect_NameAuthors
	END

GO

CREATE Procedure sprSelect_NameAuthors
	@nameGuid uniqueidentifier
AS

	select *
	from tblNameAuthors
	where NameAuthorsNameFk = @nameGuid

GO


GRANT EXEC ON sprSelect_NameAuthors TO PUBLIC

GO


