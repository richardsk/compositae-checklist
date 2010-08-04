IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_StandardXmlForConsensus')
	BEGIN
		DROP  Procedure  sprSelect_StandardXmlForConsensus
	END

GO

CREATE Procedure sprSelect_StandardXmlForConsensus
	@nameGuid uniqueidentifier,
	@otherDataTypeFk int
AS


	select Provider.ProviderPK id, Provider.ProviderName as [name],
		(select so2.StandardXML from tblStandardOutput so2 where so2.StandardOutputPK = so.StandardOutputPK)
	from tblProvider Provider 
		inner join tblProviderImport pri on Provider.ProviderPK = pri.ProviderImportProviderFK
		inner join tblProviderName pn on pn.PNProviderImportFK = pri.ProviderImportPK
		inner join vwProviderOtherData po on pn.PNNameId = po.POtherDataRecordId and provider.ProviderPK = po.ProviderPk and po.OutputTypeFk = @otherDataTypeFk
		inner join tblStandardOutput so on po.POtherDataTextPk = so.POtherDataFK		
	where pn.pnnamefk=@nameGuid and so.othertypefk = @otherDataTypeFk
	for xml auto, root('DataSet'), type

GO


GRANT EXEC ON sprSelect_StandardXmlForConsensus TO PUBLIC

GO
	
