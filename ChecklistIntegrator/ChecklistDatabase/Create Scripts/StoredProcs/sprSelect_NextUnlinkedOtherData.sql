IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NextUnlinkedOtherData')
	BEGIN
		DROP  Procedure  sprSelect_NextUnlinkedOtherData
	END

GO

CREATE Procedure sprSelect_NextUnlinkedOtherData
	@index int
AS

	select pn.PNNameFk, so.OtherTypeFk, so.OtherDataFk
	from tblStandardOutput so
	inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pn.ProviderPk = pod.ProviderPk	
	inner join tmpIntegration i on i.recordid = so.StandardOutputPk
	where i.IntegOrder = @index


GO


GRANT EXEC ON sprSelect_NextUnlinkedOtherData TO PUBLIC

GO


