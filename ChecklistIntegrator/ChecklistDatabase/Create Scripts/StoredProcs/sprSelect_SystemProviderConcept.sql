IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SystemProviderConcept')
	BEGIN
		DROP  Procedure  sprSelect_SystemProviderConcept
	END

GO

CREATE Procedure sprSelect_SystemProviderConcept
	@sysProvImportFk int,
	@name1Guid uniqueidentifier,
	@accToFk uniqueidentifier
AS

	select *
	from vwProviderConcept pc
	inner join vwProviderName pn1 on pn1.PNNameId = pc.PCName1Id and pn1.ProviderPk = pc.ProviderPk
	left join vwProviderReference pr on pr.PRReferenceId = pc.PCAccordingToId and pr.ProviderPk = pc.ProviderPk
	where PCProviderImportFk = @sysProvImportFk and 
		isnull(cast(PRReferenceFk as varchar(38)), '') = isnull(cast(@accToFk as varchar(38)), '') and
		pn1.PNNameFk = @name1Guid 
	
		

GO


GRANT EXEC ON sprSelect_SystemProviderConcept TO PUBLIC

GO


