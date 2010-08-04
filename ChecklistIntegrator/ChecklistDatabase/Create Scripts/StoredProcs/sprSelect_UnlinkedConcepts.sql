IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedConcepts')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedConcepts
	END

GO

CREATE Procedure sprSelect_UnlinkedConcepts
	@providerPk int
AS

	--get all unlinked concepts whether names can be matched or not - ie just for a counter/progress
	--so shouldnt be used to actually insert concepts (nned to check if names have been integrated first)
	select  *
	from vwProviderConceptRelationship pcr
	inner join vwProviderName pn on pn.pnnameid = pcr.pcname1id and pn.providerpk = pcr.providerpk
	--inner join vwProviderName pn2 on pn2.pnnameid = pcr.pcname2id and pn2.providerpk = pcr.providerpk
	left join tblRank r on r.RankPk = pn.PNNameRankFk 
	--where pn.PNNameFk is not null and pn2.PNNameFk is not null 
	where PCRConceptRelationshipFk is null and PCRLinkStatus <> 'Discarded'
		and (@providerPk is null or pcr.ProviderPk = @providerPk)
	order by r.RankSort

GO


GRANT EXEC ON sprSelect_UnlinkedConcepts TO PUBLIC

GO


