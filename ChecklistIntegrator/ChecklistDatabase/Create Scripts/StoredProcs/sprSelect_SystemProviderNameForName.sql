IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SystemProviderNameForName')
	BEGIN
		DROP  Procedure  sprSelect_SystemProviderNameForName
	END

GO

CREATE Procedure sprSelect_SystemProviderNameForName
	@nameGuid uniqueidentifier
AS

	select *
	from vwProviderName v
	where ProviderIsEditor = 1 and v.PNNameFk = @nameGuid and PNLinkStatus <> 'Discarded'

GO


GRANT EXEC ON sprSelect_SystemProviderNameForName TO PUBLIC

GO


