IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Provider')
	BEGIN
		DROP  Procedure  sprSelect_Provider
	END

GO

CREATE Procedure sprSelect_Provider
	@providerPk int
	
AS

	select * from tblProvider
	where ProviderPk = @providerPk

GO


GRANT EXEC ON sprSelect_Provider TO PUBLIC

GO


