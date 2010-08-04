IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Transformation')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Transformation
	END

GO

CREATE Procedure sprTransferInsertUpdate_Transformation
	@transformationPk int,
	@name nvarchar(50),
	@description nvarchar(max),
	@xslt xml,
	@updatedBy nvarchar(50),
	@updatedDate datetime
AS

	if exists(select * from tblTransformation where TransformationPk = @transformationPk)
	begin		
		update tblTransformation
		set Name = @name,
			Description = @description,
			Xslt = @xslt,
			UpdatedBy = @updatedBy,
			UpdatedDate = @updatedDate
		where TransformationPk = @transformationPk
	end
	else
	begin
		set identity_insert tbltransformation on
		
		insert tblTransformation(TransformationPk, Name, Description, Xslt, UpdatedBy, UpdatedDate)
		select @transformationPk, @name, @description, @xslt, @updatedBy, @updatedDate
		
		set identity_insert tbltransformation off
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_Transformation TO PUBLIC

GO


