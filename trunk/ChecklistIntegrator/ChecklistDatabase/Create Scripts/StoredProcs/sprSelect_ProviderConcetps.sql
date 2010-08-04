IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderConcetps')
	BEGIN
		DROP  Procedure  sprSelect_ProviderConcetps
	END

GO

CREATE Procedure sprSelect_ProviderConcetps
	@nameGuid uniqueidentifier
AS

	select pc.*
	from vwProviderConcept pc
	inner join tblConcept c on c.ConceptPk = pc.pcconceptfk
	where ConceptName1Fk = @nameGuid and PCLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_ProviderConcetps TO PUBLIC

GO


