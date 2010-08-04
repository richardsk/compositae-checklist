IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedOtherDataCount')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedOtherDataCount
	END

GO

CREATE Procedure sprSelect_UnlinkedOtherDataCount
	@providerPk int
AS
	
	--get other data where the provider other data has changed after the consensus other data
	
	select  count(StandardOutputPk)
	from (select distinct so.StandardOutputPk, PNNameFk, pod.POtherDataType
		from tblStandardOutput so
		left join tblOtherData od on od.OtherDataPk = so.OtherDataFk
		inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
		inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
		where (so.OtherDataFk is null or so.StandardDate > isnull(od.UpdatedDate, od.CreatedDate))
			and (@providerPk is null or pod.ProviderPk = @providerPk)
			and so.UseForConsensus = 1) s

GO


GRANT EXEC ON sprSelect_UnlinkedOtherDataCount TO PUBLIC

GO


