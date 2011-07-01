IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameOtherDataToUpdate')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderNameOtherDataToUpdate
	END

GO

CREATE Procedure dbo.sprSelect_ProviderNameOtherDataToUpdate
	@nameGuid uniqueidentifier
AS

	select od.*, pn.PNNameFk 
	from vwProviderOtherData od
	inner join vwProviderName pn on pn.PNNameId = od.POtherDataRecordId and pn.ProviderPk = od.ProviderPk
	left join tblStandardOutput so on so.POtherDataFk = od.POtherDataTextPk
	where pn.PNNameFk = @nameGuid and od.OutputTypeFk is not null and
		(od.StandardOutputPk is null or od.OtherDataFk is null or OtherDataTransUpdatedDate > so.UpdatedDate
			or isnull(POtherDataUpdatedDate, POTherDataCreatedDate) > so.UpdatedDate
			or isnull(pn.PNUpdatedDate, pn.PNCreatedDate) > so.UpdatedDate)

GO


GRANT EXEC ON dbo.sprSelect_ProviderNameOtherDataToUpdate TO PUBLIC

GO


