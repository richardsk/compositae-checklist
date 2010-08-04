IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderOtherData')
	BEGIN
		DROP  View vwProviderOtherData
	END
GO

CREATE View vwProviderOtherData AS

	select 
		cast(isnull(so.UseForConsensus, 1) as bit) as UseForConsensus,
		p.ProviderName,
		p.ProviderIsEditor,
		od.POtherDataType, 
		POtherDataName, 
		POtherDataXML, 
		so.StandardXml,
		so.StandardDate,
		POtherDataData, 
		POtherDataVersion, 
		POtherDataRecordId, 
		POtherDataTextPk, 
		p.ProviderPk,
		POtherDataProviderImportFk, 
		POtherDataCreatedDate, 
		POtherDataCreatedBy, 
		POtherDataUpdatedDate, 
		POtherDataUpdatedBy,
		wt.Xslt as WebXslt,
		ct.Xslt as ConsensusXslt,
		odtr.UseDataXml,
		odtr.OutputTypeFk,
		odtr.UpdatedDate as OtherDataTransUpdatedDate,
		t.Xslt,
		odtr.AddRoot,
		so.StandardOutputPk,
		so.OtherDataFk
	from tblProviderOtherData od
	inner join tblProviderImport pim on pim.ProviderImportPk = od.POtherDataProviderImportFk
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	left join tblOtherDataTransformation odtr on odtr.POtherDataType = od.POtherDataType and odtr.ProviderImportFk = od.POtherDataProviderImportFk 
	left join tblStandardOutput so on so.POtherDataFk = od.POtherDataTextPk and so.OtherTypeFk = odtr.OutputTypeFk
	left join tblOtherDataType odt on odt.OtherDataTypePk = odtr.OutputTypeFk
	left join tblTransformation wt on wt.TransformationPk = odt.WebTransformationFk
	left join tblTransformation ct on ct.TransformationPk = odt.ConsensusTransformationFk
	left join tblTransformation t on t.TransformationPk = odtr.TransformationFk

GO


GRANT SELECT ON vwProviderOtherData TO PUBLIC

GO

