IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderReferenceById')
	BEGIN
		DROP  Procedure  sprSelect_ProviderReferenceById
	END

GO

CREATE Procedure sprSelect_ProviderReferenceById
	@providerPk int,
	@PRReferenceId nvarchar(300)
AS

	select *
	from vwProviderReference
	where PRReferenceId = @PRReferenceId and ProviderPk = @providerPk

GO


GRANT EXEC ON sprSelect_ProviderReferenceById TO PUBLIC

GO


