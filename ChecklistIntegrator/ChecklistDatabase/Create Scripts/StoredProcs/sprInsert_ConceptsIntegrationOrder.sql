IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ConceptsIntegrationOrder')
	BEGIN
		DROP  Procedure  dbo.sprInsert_ConceptsIntegrationOrder
	END

GO

CREATE Procedure dbo.sprInsert_ConceptsIntegrationOrder
	@providerPk int
AS

	delete tmpIntegration

	dbcc checkident(tmpIntegration, RESEED, 0)
	
	insert tmpIntegration(RecordId)
	select distinct PCRPk
	from vwProviderConceptRelationship pcr
	inner join vwProviderName pn on pn.pnnameid = pcr.pcname1id and pn.providerpk = pcr.providerpk
	inner join vwProviderName pn2 on pn2.pnnameid = pcr.pcname2id and pn2.providerpk = pcr.providerpk
	--left join tblRank r on r.RankPk = pn.PNNameRankFk 	
	where pn.PNNameFk is not null and pn2.PNNameFk is not null
		and PCRConceptRelationshipFk is null and PCRLinkStatus <> 'Discarded' 
		and (@providerPk is null or pcr.ProviderPk = @providerPk)

GO


GRANT EXEC ON dbo.sprInsert_ConceptsIntegrationOrder TO PUBLIC

GO


