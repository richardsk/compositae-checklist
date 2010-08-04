 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConceptRecords')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConceptRecords
	END

GO

CREATE Procedure sprSelect_ProviderConceptRecords
	@conceptPk int
AS

	select pc.*, pr.PRReferenceFk
	from vwProviderConcept pc
	left join vwProviderReference pr on pr.PRReferenceId = pc.PCAccordingToId and pr.ProviderPk = pc.ProviderPk
	where PCConceptFk = @conceptPk

GO


GRANT EXEC ON sprSelect_ProviderConceptRecords TO PUBLIC

GO


