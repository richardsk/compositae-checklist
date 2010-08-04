IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNames')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNames
	END

GO

CREATE Procedure sprSelect_ProviderNames
	@nameGuid uniqueidentifier
	
AS

	
	
	select *
	from vwProviderName
	where PNNameFk = @nameGuid and PNLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_ProviderNames TO PUBLIC

GO


