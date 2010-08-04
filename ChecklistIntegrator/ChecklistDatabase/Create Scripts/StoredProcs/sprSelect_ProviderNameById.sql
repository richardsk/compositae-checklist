IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameById')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNameById
	END

GO

CREATE Procedure sprSelect_ProviderNameById
	@providerPk int,
	@PNNameId nvarchar(300)
AS

	
	select *
	from vwProviderName
	where PNNameId = @PNNameId and ProviderPk = @providerPk
	

GO


GRANT EXEC ON sprSelect_ProviderNameById TO PUBLIC

GO


