IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameChildCount')
	BEGIN
		DROP  Procedure  sprSelect_NameChildCount
	END

GO

CREATE Procedure sprSelect_NameChildCount
(
	@nameGuid uniqueidentifier
)
AS

	select count(nameguid) from tblname where nameparentfk = @nameguid

GO


GRANT EXEC ON sprSelect_NameChildCount TO PUBLIC

GO


