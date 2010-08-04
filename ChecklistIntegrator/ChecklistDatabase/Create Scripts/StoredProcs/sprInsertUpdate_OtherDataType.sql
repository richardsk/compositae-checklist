IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherDataType')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherDataType
	END

GO

CREATE Procedure sprInsertUpdate_OtherDataType
	@otherDataTypePk int,
	@name nvarchar(100),
	@webTransFk int,
	@consensusTransFk int,
	@webSequence int,
	@displayTab nvarchar(50),
	@user nvarchar(50)
AS

	if (@otherDataTypePk is null or @otherDataTypePk <= 0) 
	begin
		insert tblOtherDataType
		select @name, @consensusTransFk, @webTransFk, @webSequence, @displayTab, @user, getdate()
		
		select @@identity
	end
	else
	begin
		update tblOtherDataType
		set Name = @name,
			ConsensusTransformationFk = @consensusTransFk,
			WebTransformationFk = @webTransFk,
			WebSequence = @webSequence,
			DisplayTab = @displayTab,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where OtherDataTypePk = @otherDataTypePk
		
		select @otherDataTypePk
	end

GO


GRANT EXEC ON sprInsertUpdate_OtherDataType TO PUBLIC

GO


