IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderRISByReferenceId')
	BEGIN
		DROP  Procedure  sprSelect_ProviderRISByReferenceId
	END

GO

CREATE Procedure sprSelect_ProviderRISByReferenceId
	@ReferenceId nvarchar(300)
AS

	select * 
	from tblProviderRIS
	where PRISId = @referenceId

GO


GRANT EXEC ON sprSelect_ProviderRISByReferenceId TO PUBLIC

GO


