IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameOtherData')
	BEGIN
		DROP  Procedure  dbo.sprSelect_NameOtherData
	END

GO

CREATE Procedure dbo.sprSelect_NameOtherData
	@nameGuid uniqueidentifier
AS

	select od.*, odt.*, t.Xslt as WebXslt			
	from tblOtherData od
	inner join tblOtherDataType odt on odt.OtherDataTypePk = od.OtherDataTypeFk
	inner join tblTransformation t on t.TransformationPk = odt.WebTransformationFk
	where od.RecordFk = @nameGuid
	order by DisplayTab


	select pod.*
	from vwProviderOtherData pod
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pn.ProviderPk = pod.ProviderPk
	where pn.PNNameFk = @nameGuid
	
GO


GRANT EXEC ON dbo.sprSelect_NameOtherData TO PUBLIC

GO


