IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Transformation')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Transformation
	END

GO

CREATE Procedure sprInsertUpdate_Transformation
	@transPk int,
	@name nvarchar(50),
	@description nvarchar(max),
	@xslt xml,
	@user nvarchar(50)
AS

	if (@transPk is null or @transPk <= 0)
	begin
		insert tblTransformation
		select @name, @description, @xslt, @user, getdate()
		
		select @@identity
	end
	else
	begin
		update tblTransformation
		set Name = @name,
			Description = @description,
			Xslt = @xslt,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where TransformationPk = @transPk
		
		select @transPk
	end

GO


GRANT EXEC ON sprInsertUpdate_Transformation TO PUBLIC

GO


