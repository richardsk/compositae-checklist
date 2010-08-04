IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_CleanOtherData')
	BEGIN
		DROP  Procedure  sprUpdate_CleanOtherData
	END

GO

CREATE Procedure sprUpdate_CleanOtherData
	
AS

	--delete transformations where there is no longer a type for it
	delete odt
	from tblOtherDataTransformation odt
	where not exists(select * from tblOtherDataType where OtherDataTypePk = odt.OutputTypeFk)
	

	--delete std output for this transf.
	delete so 
	from tblStandardOutput so 
	inner join tblproviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	left join tblOtherDataTransformation odt on odt.POtherDataType = pod.POtherDataType and odt.OutputTypeFk = so.OtherTypeFk and odt.ProviderImportFk = pod.POtherDataProviderImportFk
	where odt.ProviderImportFk is null --ie has been deleted
	
	--delete other data for thatose std output
	delete tblOtherData
	where not exists(select * from tblStandardOutput where OtherDataFk = OtherDataPk)

GO


GRANT EXEC ON sprUpdate_CleanOtherData TO PUBLIC

GO


