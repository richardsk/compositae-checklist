IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedConceptsCount')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedConceptsCount
	END

GO

CREATE Procedure sprSelect_UnlinkedConceptsCount
	@providerPk int
AS

	--get all unlinked concepts whether names can be matched or not - ie just for a counter/progress
	select  count(distinct pcrpk)
	from vwProviderConceptRelationship pcr
	inner join vwProviderName pn on pn.pnnameid = pcr.pcname1id and pn.providerpk = pcr.providerpk
	--inner join vwProviderName pn2 on pn2.pnnameid = pcr.pcname2id and pn2.providerpk = pcr.providerpk
	left join tblRank r on r.RankPk = pn.PNNameRankFk 
	--where pn.PNNameFk is not null and pn2.PNNameFk is not null 
	where PCRConceptRelationshipFk is null and PCRLinkStatus <> 'Discarded'
		and (@providerPk is null or pcr.ProviderPk = @providerPk)
	
GO


GRANT EXEC ON sprSelect_UnlinkedConceptsCount TO PUBLIC

GO


