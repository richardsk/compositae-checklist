IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_MoveNameChildren')
	BEGIN
		DROP  Procedure  sprUpdate_MoveNameChildren
	END

GO

CREATE Procedure sprUpdate_MoveNameChildren
	@fromNameGuid uniqueidentifier,
	@toNameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	declare @pn nvarchar(3000)
	select @pn = namefull from tblname where nameguid = @toNameGuid
	
	update tblName
	set nameparentfk = @toNameGuid,
		nameparent = @pn,
		nameupdateddate = getdate(),
		nameupdatedby = @user
	where nameparentfk = @fromNameGuid
		

GO


GRANT EXEC ON sprUpdate_MoveNameChildren TO PUBLIC

GO


