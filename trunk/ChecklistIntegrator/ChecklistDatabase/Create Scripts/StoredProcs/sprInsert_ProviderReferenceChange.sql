IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ProviderReferenceChange')
	BEGIN
		DROP  Procedure  sprInsert_ProviderReferenceChange
	END

GO

CREATE Procedure sprInsert_ProviderReferenceChange
	@prpk int,
	@user nvarchar(50)
AS

	insert tblProviderReference_Change
	select *, getdate(), @user
	from tblProviderReference
	where PRPk = @prpk

GO


GRANT EXEC ON sprInsert_ProviderReferenceChange TO PUBLIC

GO


