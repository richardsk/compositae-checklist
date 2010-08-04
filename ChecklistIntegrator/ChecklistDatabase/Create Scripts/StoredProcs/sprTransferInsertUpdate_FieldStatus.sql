IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_FieldStatus')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_FieldStatus
	END

GO

CREATE Procedure sprTransferInsertUpdate_FieldStatus
	@FieldStatusCounterPK int, 
	@FieldStatusIdentifierFK int, 
	@FieldStatusLevelFK int, 
	@FieldStatusComment nvarchar(500), 
	@FieldStatusCreatedBy nvarchar(50), 
	@FieldStatusCreatedDate datetime, 
	@FieldStatusUpdatedBy nvarchar(50), 
	@FieldStatusUpdatedDate datetime, 
	@FieldStatusRecordFk varchar(300) 

AS

	if (@fieldStatusCounterPk = -1 or not exists(select * from tblFieldStatus where FieldStatusCounterPk = @fieldStatusCounterPk))
	begin
		set identity_insert tblFieldStatus on
		insert tblFieldStatus(FieldStatusCounterPK, FieldStatusIdentifierFK, FieldStatusLevelFK, FieldStatusComment, FieldStatusCreatedBy, FieldStatusCreatedDate, FieldStatusUpdatedBy, FieldStatusUpdatedDate, FieldStatusRecordFk)
		select @FieldStatusCounterPK, 
			@FieldStatusIdentifierFK, 
			@FieldStatusLevelFK, 
			@FieldStatusComment, 
			@FieldStatusCreatedBy, 
			@FieldStatusCreatedDate, 
			@FieldStatusUpdatedBy, 
			@FieldStatusUpdatedDate, 
			@FieldStatusRecordFk
		set identity_insert tblFieldStatus off
	end
	else
	begin
		update tblFieldStatus
		set FieldStatusIdentifierFK = @FieldStatusIdentifierFK, 
			FieldStatusLevelFK = @FieldStatusLevelFK, 
			FieldStatusComment = @FieldStatusComment, 
			FieldStatusCreatedBy = @FieldStatusCreatedBy, 
			FieldStatusCreatedDate = @FieldStatusCreatedDate, 
			FieldStatusUpdatedBy = @FieldStatusUpdatedBy, 
			FieldStatusUpdatedDate = @FieldStatusUpdatedDate, 
			FieldStatusRecordFk = @FieldStatusRecordFk
		where FieldStatusCounterPK = @FieldStatusCounterPK
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_FieldStatus TO PUBLIC

GO


