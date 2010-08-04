IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_OtherDataIntegrationOrder')
	BEGIN
		DROP  Procedure  sprInsert_OtherDataIntegrationOrder
	END

GO

CREATE Procedure sprInsert_OtherDataIntegrationOrder
	@providerPk int	
AS

	--delete all other data where provider other data/std output no longer exists
	delete od
	from tblOtherData od
	left join tblStandardOutput so on so.OtherDataFk = od.OtherDataPk
	where so.StandardOutputPk is null
	

	delete tmpIntegration
	
	dbcc checkident(tmpIntegration, RESEED, 0)
	
	insert tmpIntegration(RecordId)
	select StandardOutputPk
	from (select distinct so.StandardOutputPk, PNNameFk, pod.POtherDataType
		from tblStandardOutput so
		left join tblOtherData od on od.OtherDataPk = so.OtherDataFk
		inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
		inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
		where (so.OtherDataFk is null or so.StandardDate > isnull(od.UpdatedDate, od.CreatedDate))
			and (@providerPk is null or pod.ProviderPk = @providerPk)
			and so.UseForConsensus = 1 and PNNameFk is not null) s

GO


GRANT EXEC ON sprInsert_OtherDataIntegrationOrder TO PUBLIC

GO


