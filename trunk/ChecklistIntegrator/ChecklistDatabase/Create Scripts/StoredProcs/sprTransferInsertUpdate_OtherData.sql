IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_OtherData')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_OtherData
	END

GO

CREATE Procedure sprTransferInsertUpdate_OtherData
	@otherDataPk uniqueidentifier,
	@otherDataTypeFk int,
	@recordFk nvarchar(300),
	@xml xml,
	@data nvarchar(max),
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
AS

	if (not exists(select * from tblOtherData where OtherDataPk = @otherDataPk))
	begin
		insert tblOtherData
		select @otherDataPk,
			@otherDataTypeFk,
			@recordFk,
			@xml, 
			@data,
			@createdBy,
			@createdDate,
			@updatedBy, 
			@updatedDate
	end
	else
	begin
		update tblOtherData
		set OtherDataTypeFk = @otherDataTypeFk,
			RecordFk = @recordFk,
			OtherDataXml = @Xml,
			OtherDataData = @data,
			CreatedBy = @createdBy,
			CreatedDate = @createdDate,
			UpdatedBy = @updatedBy,
			UpdatedDate = @updatedDate
		where OtherDataPk = @otherDataPk
			
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_OtherData TO PUBLIC

GO


