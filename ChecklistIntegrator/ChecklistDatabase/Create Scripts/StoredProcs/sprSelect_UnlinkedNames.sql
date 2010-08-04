IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedNames')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedNames
	END

GO

CREATE Procedure sprSelect_UnlinkedNames
	@providerPk int
AS
	
	--assumes ranks have been linked up
	select *
	from vwProviderName
	left join tblRank r on r.RankPk = PNNameRankFk
	where PNNameFk is null and PNLinkStatus <> 'Discarded'
		and (@providerPk is null or ProviderPk = @providerPk)
	order by r.RankSort

GO


GRANT EXEC ON sprSelect_UnlinkedNames TO PUBLIC

GO


