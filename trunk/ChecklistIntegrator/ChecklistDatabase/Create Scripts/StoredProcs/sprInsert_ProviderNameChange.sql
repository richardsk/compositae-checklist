IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ProviderNameChange')
	BEGIN
		DROP  Procedure  sprInsert_ProviderNameChange
	END

GO

CREATE Procedure sprInsert_ProviderNameChange
	@pnpk int,
	@user nvarchar(50)
AS

	insert tblProviderName_Change
	select *, getdate(), @user
	from tblProviderName
	where PNPk = @pnpk

GO


GRANT EXEC ON sprInsert_ProviderNameChange TO PUBLIC

GO


