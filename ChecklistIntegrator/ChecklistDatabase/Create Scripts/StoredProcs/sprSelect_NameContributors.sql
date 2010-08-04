IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameContributors')
	BEGIN
		DROP  Procedure  sprSelect_NameContributors
	END

GO

CREATE Procedure sprSelect_NameContributors
	@nameGuid uniqueidentifier 
AS

select distinct userfullname
from tblprovidername_change
inner join tbluser on userlogin = changedby 
where pnnamefk = @nameGuid

GO


GRANT EXEC ON sprSelect_NameContributors TO PUBLIC

GO


