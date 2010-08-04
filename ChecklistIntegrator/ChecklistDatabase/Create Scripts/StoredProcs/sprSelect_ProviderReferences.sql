IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderReferences')
	BEGIN
		DROP  Procedure  sprSelect_ProviderReferences
	END

GO

CREATE Procedure sprSelect_ProviderReferences
	@referenceGuid uniqueidentifier
AS

	select *
	from vwProviderReference
	where PRReferenceFk = @referenceGuid and PRLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_ProviderReferences TO PUBLIC

GO


