IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_OtherDataToUpdate')
	BEGIN
		DROP  Procedure  sprSelect_OtherDataToUpdate
	END

GO

CREATE Procedure sprSelect_OtherDataToUpdate
	@providerPk int
AS

	--delete all standard output where provider other data no longer exists
	delete so
	from tblStandardOutput so
	left join tblProviderOtherData pod on pod.potherdatatextpk = so.potherdatafk
	where pod.potherdatatextpk is null
	
	
	--get all standard output records for other data where they have an xslt, and the prov other data has been updated more recently
	-- or a new mapping has been added/updated since the last run
	-- dont get the xslt for every row as this will cause out of memory errors
	select cast(isnull(UseForConsensus, 1) as bit) as UseForConsensus,
		ProviderName,
		ProviderIsEditor,
		od.POtherDataType, 
		POtherDataName, 
		POtherDataXML, 
		StandardXml,
		StandardDate,
		POtherDataData, 
		POtherDataVersion, 
		POtherDataRecordId, 
		POtherDataTextPk, 
		ProviderPk,
		POtherDataProviderImportFk, 
		POtherDataCreatedDate, 
		POtherDataCreatedBy, 
		POtherDataUpdatedDate, 
		POtherDataUpdatedBy,
		odtr.UseDataXml,
		OutputTypeFk,
		AddRoot,
		StandardOutputPk,
		OtherDataFk,
		odtr.TransformationFk
	from tblproviderotherdata od
	inner join tblproviderimport pim on pim.providerimportpk = od.potherdataproviderimportfk
	left join tblprovider p on p.providerpk = pim.providerimportproviderfk
	left join tblstandardoutput so on so.potherdatafk = od.potherdatatextpk
	left join tblOtherDataTransformation odtr on odtr.POtherDataType = od.POtherDataType and odtr.ProviderImportFk = od.POtherDataProviderImportFk 
	left join tbltransformation t on t.transformationpk = odtr.transformationfk
	where (StandardOutputPk is null or StandardDate < isnull(POtherDataUpdatedDate, POtherDataCreatedDate) or StandardDate < odtr.UpdatedDate) 
		and xslt is not null 
		and (@providerPk is null or @providerPk = ProviderPk)

	
GO


GRANT EXEC ON sprSelect_OtherDataToUpdate TO PUBLIC

GO


