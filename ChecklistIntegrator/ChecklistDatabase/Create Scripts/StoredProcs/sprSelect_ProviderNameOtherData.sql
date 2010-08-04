IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameOtherData')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderNameOtherData
	END

GO

CREATE Procedure dbo.sprSelect_ProviderNameOtherData
	@nameGuid uniqueidentifier
AS

	select od.*, pn.PNNameFk 
	from vwProviderOtherData od
	inner join vwProviderName pn on pn.PNNameId = od.POtherDataRecordId and pn.ProviderPk = od.ProviderPk
	where pn.PNNameFk = @nameGuid

GO


GRANT EXEC ON dbo.sprSelect_ProviderNameOtherData TO PUBLIC

GO


