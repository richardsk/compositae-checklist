IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderImports')
	BEGIN
		DROP  Procedure  sprSelect_ProviderImports
	END

GO

CREATE Procedure sprSelect_ProviderImports
	@providerPk int
AS

	select ProviderImportPk, 
		ProviderImportProviderFk, 
		ProviderImportImportTypeFk, 
		ProviderImportFileName, 
		ProviderImportStatus, 
		ProviderImportDate, 
		ProviderImportNotes, 
		cast(ProviderImportHigherNameId as varchar(38)) as ProviderImportHigherNameId, 
		ProviderImportHigherPNId, 
		cast(ProviderImportGenusNameId as varchar(38)) as ProviderImportGenusNameId, 
		ProviderImportGenusPNId, 
		ProviderImportCreatedDate, 
		ProviderImportCreatedBy, 
		ProviderImportUpdatedDate, 
		ProviderImportUpdatedBy,
		ProviderName
	from tblProviderImport
	inner join tblProvider on ProviderPk = ProviderImportProviderFk
	where (ProviderImportProviderFk = @providerPk or @providerPk is null)
	order by ProviderImportDate desc

GO


GRANT EXEC ON sprSelect_ProviderImports TO PUBLIC

GO


