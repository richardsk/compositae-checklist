IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ProviderRISChange')
	BEGIN
		DROP  Procedure  sprInsert_ProviderRISChange
	END

GO

CREATE Procedure sprInsert_ProviderRISChange
	@prispk int,
	@user nvarchar(50)
AS

	insert tblProviderRIS_Change
	select *, getdate(), @user
	from tblProviderRIS
	where PRISPk = @prispk

GO


GRANT EXEC ON sprInsert_ProviderRISChange TO PUBLIC

GO


