IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UnlinkedNamesCount')
	BEGIN
		DROP  Procedure  sprSelect_UnlinkedNamesCount
	END

GO

CREATE Procedure sprSelect_UnlinkedNamesCount
	@providerPk int
AS

	--assumes ranks have been linked up
	select count(*)
	from vwProviderName
	where PNNameFk is null and PNLinkStatus <> 'Discarded' 
		and (@providerPk is null or ProviderPk = @providerPk)
	
GO


GRANT EXEC ON sprSelect_UnlinkedNamesCount TO PUBLIC

GO


