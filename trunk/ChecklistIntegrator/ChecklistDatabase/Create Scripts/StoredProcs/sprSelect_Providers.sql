IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Providers')
	BEGIN
		DROP  Procedure  sprSelect_Providers
	END

GO

CREATE Procedure sprSelect_Providers
	
AS

select * from tblProvider
order by ProviderName

GO

GRANT EXEC ON sprSelect_Providers TO PUBLIC

GO

