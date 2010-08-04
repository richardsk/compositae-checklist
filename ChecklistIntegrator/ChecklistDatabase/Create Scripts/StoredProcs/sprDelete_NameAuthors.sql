IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_NameAuthors')
	BEGIN
		DROP  Procedure  sprDelete_NameAuthors
	END

GO

CREATE Procedure sprDelete_NameAuthors
	@nameGuid uniqueidentifier
AS

	delete tblNameAuthors where NameAuthorsNameFk = @nameGuid

GO


GRANT EXEC ON sprDelete_NameAuthors TO PUBLIC

GO


