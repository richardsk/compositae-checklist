IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderRISByReferenceGuid')
	BEGIN
		DROP  Procedure  sprSelect_ProviderRISByReferenceGuid
	END

GO

CREATE Procedure sprSelect_ProviderRISByReferenceGuid
	@referenceGuid uniqueidentifier
AS

	select r.*
	from vwProviderRIS r
	where r.PRReferenceFk = @referenceGuid

GO


GRANT EXEC ON sprSelect_ProviderRISByReferenceGuid TO PUBLIC

GO


