IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ProviderName')
	BEGIN
		DROP  Procedure  sprDelete_ProviderName
	END

GO

CREATE Procedure sprDelete_ProviderName
	@PNPk int
AS

	delete tblProviderName
	where PNPk = @PNPk

GO


GRANT EXEC ON sprDelete_ProviderName TO PUBLIC

GO


