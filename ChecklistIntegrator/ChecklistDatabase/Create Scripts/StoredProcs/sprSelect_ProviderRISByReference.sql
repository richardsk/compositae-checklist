IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderRISByReference')
	BEGIN
		DROP  Procedure  sprSelect_ProviderRISByReference
	END

GO

CREATE Procedure sprSelect_ProviderRISByReference
	@PRPk int
AS

	select *
	from tblProviderRIS
	where PRISProviderReferenceFk = @PRPk

GO


GRANT EXEC ON sprSelect_ProviderRISByReference TO PUBLIC

GO


