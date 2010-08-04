IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelectRoleKeyByRoleName')
	BEGIN
		DROP  Procedure  sprSelectRoleKeyByRoleName
	END

GO

CREATE Procedure sprSelectRoleKeyByRoleName
	@nvcRoleName	nvarchar(100),
	@intRoleKey int = NULL OUTPUT 
AS
		
	--SELECT @intRoleKey = RolePk
	--FROM tblRole
	--WHERE RoleName = @nvcRoleName

	select 1

GO


GRANT EXEC ON sprSelectRoleKeyByRoleName TO PUBLIC

GO


