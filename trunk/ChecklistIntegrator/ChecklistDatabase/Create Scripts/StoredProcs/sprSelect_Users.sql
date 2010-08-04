IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Users')
	BEGIN
		DROP  Procedure  sprSelect_Users
	END

GO

CREATE Procedure sprSelect_Users
	
AS

	select * from tblUser
GO


GRANT EXEC ON sprSelect_Users TO PUBLIC

GO


