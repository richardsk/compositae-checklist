IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SystemProviderConceptRelationship')
	BEGIN
		DROP  Procedure  sprSelect_SystemProviderConceptRelationship
	END

GO

CREATE Procedure sprSelect_SystemProviderConceptRelationship
	@sysProvImportFk int,
	@concept1Id nvarchar(300),
	@concept2Id nvarchar(300),
	@relTypeFk int
AS

	select pcr.*
	from vwProviderConceptRelationship pcr 
	where pcr.PCRProviderImportFk = @sysProvImportFk and 
		pcr.PCRConcept1Id = @concept1Id and
		pcr.PCRConcept2Id = @concept2Id and
		pcr.PCRRelationshipFk = @relTypeFk
		

GO


GRANT EXEC ON sprSelect_SystemProviderConceptRelationship TO PUBLIC

GO


