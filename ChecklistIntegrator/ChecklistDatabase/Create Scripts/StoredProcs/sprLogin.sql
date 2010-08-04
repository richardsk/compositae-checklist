IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprLogin')
	BEGIN
		DROP  Procedure  sprLogin
	END

GO

CREATE Procedure sprLogin
	@userPk int,
	@pwd nvarchar(200)
AS

	declare @realPwd varchar(200)
	select @realPwd = cast(UserPassword as varchar(200))
	from tblUser 
	where UserPk = @userPk
	
	select case when @pwd is null and @realPwd is null then cast(1 as bit)
		when @realPwd = @pwd then cast(1 as bit) else cast(0 as bit) end

GO


GRANT EXEC ON sprLogin TO PUBLIC

GO


