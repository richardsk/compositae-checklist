IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedOtherData')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedOtherData
	END

GO

CREATE Procedure sprSelect_UnlinkedOtherData
	@providerPk int
AS

	select pod.*
	from tblStandardOutput so
	left join tblOtherData od on od.OtherDataPk = so.OtherDataFk
	inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
	where (so.OtherDataFk is null or so.StandardDate > isnull(od.UpdatedDate, od.CreatedDate))
		and (@providerPk is null or pod.ProviderPk = @providerPk)
		and so.UseForConsensus = 1

GO


GRANT EXEC ON sprSelect_UnlinkedOtherData TO PUBLIC

GO


