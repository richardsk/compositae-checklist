IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderRIS')
	BEGIN
		DROP  Procedure  sprSelect_ProviderRIS
	END

GO

CREATE Procedure sprSelect_ProviderRIS
	@PRISPk int
AS

	select * from tblProviderRIS
	where PRISPk = @PRISPk

GO


GRANT EXEC ON sprSelect_ProviderRIS TO PUBLIC

GO


