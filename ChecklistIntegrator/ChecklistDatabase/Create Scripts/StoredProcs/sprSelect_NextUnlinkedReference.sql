IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NextUnlinkedReference')
	BEGIN
		DROP  Procedure  sprSelect_NextUnlinkedReference
	END

GO

CREATE Procedure sprSelect_NextUnlinkedReference
	@index int
AS

	select pr.*
	from vwProviderReference pr
	inner join tmpIntegration i on i.recordid = pr.prpk
	where i.IntegOrder = @index

	--select  top 1 *
	--from vwProviderReference
	--where PRReferenceFk is null and PRLinkStatus <> 'Discarded' and PRLinkStatus <> 'FailedCurrent'

GO


GRANT EXEC ON sprSelect_NextUnlinkedReference TO PUBLIC

GO


