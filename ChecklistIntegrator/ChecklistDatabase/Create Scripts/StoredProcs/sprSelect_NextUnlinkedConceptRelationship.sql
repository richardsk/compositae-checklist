IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NextUnlinkedConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_NextUnlinkedConceptRelationship
	END

GO

CREATE Procedure sprSelect_NextUnlinkedConceptRelationship
	@index int
AS

	select pcr.* 
	from vwProviderConceptRelationship pcr
	inner join tmpIntegration i on i.recordid = pcr.pcrpk
	where i.IntegOrder = @index
	

	--select  top 1 *
	--from vwProviderConcept pc
	--left join vwProviderName pn on pn.PNNameId = PCName1Id and pn.ProviderPk = pc.ProviderPk
	--left join tblRank r on r.RankPk = pn.PNNameRankFk 
	--where PCConceptFk is null and PCLinkStatus <> 'Discarded' and PCLinkStatus <> 'FailedCurrent'

GO


GRANT EXEC ON sprSelect_NextUnlinkedConceptRelationship TO PUBLIC

GO


