IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_NamesIntegrationOrder')
	BEGIN
		DROP  Procedure  sprInsert_NamesIntegrationOrder
	END

GO

CREATE Procedure sprInsert_NamesIntegrationOrder
	@providerPk int
AS

	delete tmpIntegration
	
	dbcc checkident(tmpIntegration, RESEED, 0)
	 
	insert tmpintegration(RecordId)
	select pnpk
	from vwProviderName 
	left join tblRank r on r.RankPk = PNNameRankFk
	where PNNameFk is null and PNLinkStatus <> 'Discarded' 
		and (@providerPk is null or ProviderPk = @providerPk)
	order by r.RankSort

GO


GRANT EXEC ON sprInsert_NamesIntegrationOrder TO PUBLIC

GO


