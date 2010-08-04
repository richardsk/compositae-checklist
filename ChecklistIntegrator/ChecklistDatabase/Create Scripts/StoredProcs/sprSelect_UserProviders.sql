IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_UserProviders')
	BEGIN
		DROP  Procedure  sprSelect_UserProviders
	END

GO

CREATE Procedure sprSelect_UserProviders
	@userPk int
AS

	select up.* 
	from tblUserProvider up
	inner join tblProvider p on p.ProviderPk = up.UserProviderProviderFk
	where UserProviderUserFk = @userPk
	order by p.ProviderCreatedDate desc

GO


GRANT EXEC ON sprSelect_UserProviders TO PUBLIC

GO


