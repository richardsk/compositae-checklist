IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ProviderNameAuthors')
	BEGIN
		DROP  Procedure  sprDelete_ProviderNameAuthors
	END

GO

CREATE Procedure sprDelete_ProviderNameAuthors
	@pnpk int
AS

	delete tblProviderNameAuthors where PNAProviderNameFk = @PNPk 

GO


GRANT EXEC ON sprDelete_ProviderNameAuthors TO PUBLIC

GO


