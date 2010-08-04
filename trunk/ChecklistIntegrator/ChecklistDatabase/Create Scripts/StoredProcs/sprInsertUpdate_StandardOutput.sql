IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_StandardOutput')
	BEGIN
		DROP  Procedure  sprInsertUpdate_StandardOutput
	END

GO

CREATE Procedure sprInsertUpdate_StandardOutput
	@stdOutputPk int,
	@POtherDataFk int,
	@OtherDataTypeFk int,
	@StdXml nvarchar(max),
	@date datetime, 
	@useForConsensus bit,
	@otherDataFk uniqueidentifier,
	@user nvarchar(50)
AS

	if (@stdOutputPk is null or @stdOutputPk <= 0)
	begin
		insert tblStandardOutput
		select @potherDataFk,
			@OtherDataTypeFk,
			@StdXml,
			@date,
			@useForConsensus,
			@otherDataFk,
			@user,
			getdate()
			
		select @@identity
	end
	else
	begin
		update tblStandardOutput
		set POtherDataFk = @potherdatafk,
			OtherTypeFk = @otherDataTypeFk,
			StandardXml = @stdXml,
			StandardDate = @date,
			UseForConsensus = @useForConsensus,
			OtherDataFk = @otherDataFk,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where StandardOutputPk = @stdOutputPk
		
		select @stdOutputPk
	end

GO


GRANT EXEC ON sprInsertUpdate_StandardOutput TO PUBLIC

GO


