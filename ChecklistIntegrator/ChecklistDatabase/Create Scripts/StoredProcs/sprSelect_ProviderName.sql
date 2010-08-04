IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderName')
	BEGIN
		DROP  Procedure  sprSelect_ProviderName
	END

GO

CREATE Procedure sprSelect_ProviderName
	@PNPk int
	
AS

	select *
	from vwProviderName
	where PNPk = @PNPk

GO


GRANT EXEC ON sprSelect_ProviderName TO PUBLIC

GO


