IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_LSIDFromDeprecated')
	BEGIN
		DROP  Procedure  sprSelect_LSIDFromDeprecated
	END

GO

CREATE Procedure sprSelect_LSIDFromDeprecated
	@oldLSID nvarchar(300)
AS
	
	select DeprecatedNewLSID
	from tblDeprecated
	where DeprecatedLSID = @oldLSID

GO


GRANT EXEC ON sprSelect_LSIDFromDeprecated TO PUBLIC

GO


