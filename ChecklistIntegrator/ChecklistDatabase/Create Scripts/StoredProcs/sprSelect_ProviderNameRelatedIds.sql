IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameRelatedIds')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNameRelatedIds
	END

GO

CREATE Procedure sprSelect_ProviderNameRelatedIds
	@ProviderPk int,
	@ProviderNameId nvarchar(300)
AS

	--two tables - consensus name guid and prov name ids
	
	declare @nameGuid uniqueidentifier
	select @nameGuid = PNNameFk 
	from vwProviderName 
	where ProviderPk = @ProviderPk and PNNameId = @ProviderNameId
	
	
	select NameLSID, NameFull 
	from tblName 
	where NameGuid = @nameGuid	

	select ProviderPk as ProviderId, ProviderName, PNNameId, PNNameFull
	from vwProviderName 
	where PNNameFk = @nameGuid

GO


GRANT EXEC ON sprSelect_ProviderNameRelatedIds TO PUBLIC

GO


