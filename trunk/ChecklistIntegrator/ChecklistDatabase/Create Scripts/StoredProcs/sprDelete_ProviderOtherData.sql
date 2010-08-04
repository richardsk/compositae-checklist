IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_ProviderOtherData')
	BEGIN
		DROP  Procedure  sprDelete_ProviderOtherData
	END

GO

CREATE Procedure sprDelete_ProviderOtherData
	@providerPk int,
	@otherDataId nvarchar(300)
AS

	delete od
	from tblProviderOtherData od
	inner join tblProviderImport pim on pim.ProviderImportPk = od.POtherDataProviderImportFk
	where POtherDataRecordId = @otherDataId and pim.ProviderImportProviderFk = @providerPk

GO


GRANT EXEC ON sprDelete_ProviderOtherData TO PUBLIC

GO


