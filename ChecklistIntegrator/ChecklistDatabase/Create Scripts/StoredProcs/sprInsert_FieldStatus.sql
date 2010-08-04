IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spInsert_FieldStatus')
	BEGIN
		DROP  Procedure  spInsert_FieldStatus
	END

GO

CREATE Procedure spInsert_FieldStatus
	@recordId nvarchar(300),
	@tableName nvarchar(300),
	@fieldName nvarchar(300),
	@statusLevelFk int,
	@user nvarchar(50)
AS

	declare @statusId int
	select @statusId = FieldStatusIdentifierCounterPk 
	from tblFieldStatusIdentifier 
	where FieldStatusIdentifierTableName = @tableName and
		FieldStatusIdentifierFieldName = @fieldName
		
	delete tblFieldStatus where FieldStatusIdentifierFk = @statusId and FieldStatusRecordFk = @recordId
	
	insert tblFieldStatus(FieldStatusIdentifierFk, FieldStatusLevelFk, FieldStatusRecordFk, FieldStatusCreatedDate, FieldStatusCreatedBy)
	select @statusId, @statusLevelFk, @recordId, getdate(), @user

GO


GRANT EXEC ON spInsert_FieldStatus TO PUBLIC

GO


