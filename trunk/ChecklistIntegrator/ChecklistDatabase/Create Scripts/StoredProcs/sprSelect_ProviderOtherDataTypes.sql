IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderOtherDataTypes')
	BEGIN
		DROP  Procedure  sprSelect_ProviderOtherDataTypes
	END

GO

CREATE Procedure sprSelect_ProviderOtherDataTypes
AS

	select distinct POtherDataProviderImportFk, POtherDataType
	from tblProviderOtherData

GO


GRANT EXEC ON sprSelect_ProviderOtherDataTypes TO PUBLIC

GO


