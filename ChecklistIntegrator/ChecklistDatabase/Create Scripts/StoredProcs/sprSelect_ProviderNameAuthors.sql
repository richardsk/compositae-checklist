IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameAuthors')
	BEGIN
		DROP  Procedure  sprSelect_ProviderNameAuthors
	END

GO

CREATE Procedure sprSelect_ProviderNameAuthors
	@nameGuid uniqueidentifier
AS

	select * 
	from vwProviderName
	inner join tblProviderNameAuthors on PNAProviderNameFk = PNPk
	where PNNameFk = @nameGuid

GO


GRANT EXEC ON sprSelect_ProviderNameAuthors TO PUBLIC

GO


