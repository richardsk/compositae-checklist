IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NoNames')
	BEGIN
		DROP  Procedure  sprSelect_NoNames
	END

GO

CREATE Procedure sprSelect_NoNames
	@providerNamePk int,
	@threshold int
AS

	--test sp to fake a mismatch
	delete tmpMatchResults

GO


GRANT EXEC ON sprSelect_NoNames TO PUBLIC

GO


