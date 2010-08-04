IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NextUnlinkedName')
	BEGIN
		DROP  Procedure  sprSelect_NextUnlinkedName
	END

GO

CREATE Procedure sprSelect_NextUnlinkedName
	@index int
AS

	select pn.*
	from vwProviderName pn
	inner join tmpIntegration i on i.recordId = pn.pnpk
	where i.IntegOrder = @index

	--assumes ranks have been linked up
	--select top 1 *
	--from vwProviderName
	--inner join tblRank r on r.RankPk = PNNameRankFk
	--where PNNameFk is null and PNLinkStatus <> 'Discarded' and PNLinkStatus <> 'FailedCurrent'
	--order by r.RankSort

GO


GRANT EXEC ON sprSelect_NextUnlinkedName TO PUBLIC

GO


