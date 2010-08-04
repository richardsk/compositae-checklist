IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameRelatedIds')
	BEGIN
		DROP  Procedure  sprSelect_NameRelatedIds
	END

GO

CREATE Procedure sprSelect_NameRelatedIds
	@nameGuid uniqueidentifier
AS
	--two tables - consensus name guid and prov name ids
	
	select NameLSID, NameFull 
	from tblName 
	where NameGuid = @nameGuid

	select ProviderPk as ProviderId, ProviderName, PNNameId, PNNameFull
	from vwProviderName 
	where PNNameFk = @nameGuid
	
	
GO


GRANT EXEC ON sprSelect_NameRelatedIds TO PUBLIC

GO


