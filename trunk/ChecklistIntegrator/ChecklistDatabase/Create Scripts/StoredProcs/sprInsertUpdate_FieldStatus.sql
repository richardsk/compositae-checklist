IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInsertUpdate_FieldStatus')
	BEGIN
		DROP  Procedure  spInsertUpdate_FieldStatus
	END

GO

CREATE Procedure spInsertUpdate_FieldStatus
	@recordId nvarchar(300), 
	@fieldStatusId int,
	@statusLevelFk int,
	@user nvarchar(50)
AS
	
	if exists(select * from tblFieldStatus where FieldStatusIdentifierFk = @fieldStatusId and FieldStatusRecordFk = @recordId)
	begin
		update tblFieldStatus
		set FieldStatusLevelFk = @statusLevelFk,
			FieldStatusUpdatedBy = @user,
			FieldStatusUpdatedDate = getdate()
		where FieldStatusIdentifierFk = @fieldStatusId and FieldStatusRecordFk = @recordId
	end
	else
	begin
		insert tblFieldStatus(FieldStatusIdentifierFk, FieldStatusLevelFk, FieldStatusRecordFk, FieldStatusCreatedDate, FieldStatusCreatedBy)
		select @fieldStatusId, @statusLevelFk, @recordId, getdate(), @user
	end
	
GO

GRANT EXEC ON spInsertUpdate_FieldStatus TO PUBLIC

GO


