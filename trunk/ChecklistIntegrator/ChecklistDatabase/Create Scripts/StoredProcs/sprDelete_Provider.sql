IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Provider')
	BEGIN
		DROP  Procedure  sprDelete_Provider
	END

GO

CREATE Procedure sprDelete_Provider
	@providerPk int
AS

	delete tblProvider where ProviderPk = @providerPk

GO


GRANT EXEC ON sprDelete_Provider TO PUBLIC

GO


