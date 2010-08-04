IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_OtherDataType')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_OtherDataType
	END

GO

CREATE Procedure sprTransferInsertUpdate_OtherDataType
	@otherDataTypePk int,
	@name nvarchar(100),
	@consTransformationFk int,
	@webTransformationFk int,
	@webSequence int,
	@displayTab nvarchar(50),
	@updatedBy nvarchar(50),
	@updatedDate datetime
AS

	if not exists(select * from tblOtherDataType where OtherDataTypePk = @otherDataTypePk)
	begin
		set identity_insert tblOtherDataType on
		
		insert tblOtherDataType(OtherDataTypePk, Name, ConsensusTransformationFk, WebTransformationFk, WebSequence, DisplayTab, UpdatedBy, UpdatedDate)
		select @otherDataTypePk, @name, @consTransformationFk, @webTransformationFk, @webSequence, @displayTab, @updatedBy, @updatedDate
		
		set identity_insert tblOtherDataType off
	end
	else
	begin
		update tblOtherDataType
		set Name = @name,
			ConsensusTransformationFk = @consTransformationFk,
			WebTransformationFk = @webTransformationFk,
			WebSequence = @webSequence,
			DisplayTab = @displayTab,
			UpdatedBy = @updatedBy,
			UpdatedDate = @updatedDate
		where OtherDataTypePk = @otherDataTypePk
		
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_OtherDataType TO PUBLIC

GO


