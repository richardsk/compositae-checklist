IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderReference')
	BEGIN
		DROP  Procedure  sprSelect_ProviderReference
	END

GO

CREATE Procedure sprSelect_ProviderReference
	@PRPk int
AS


	select *
	from vwProviderReference
	where PRPk = @PRPk 
	

GO


GRANT EXEC ON sprSelect_ProviderReference TO PUBLIC

GO


