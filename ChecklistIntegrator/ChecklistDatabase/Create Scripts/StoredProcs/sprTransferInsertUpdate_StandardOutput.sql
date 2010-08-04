IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_StandardOutput')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_StandardOutput
	END

GO

CREATE Procedure sprTransferInsertUpdate_StandardOutput
	@stdOutputPk int,
	@potherdatafk int,
	@otherTypeFk int,
	@stdXml xml,
	@stdDate datetime,
	@useForConsensus bit,
	@otherDataFk uniqueidentifier,
	@updatedBy nvarchar(50),
	@updatedDate datetime
	
AS

	if not exists(select * from tblStandardOutput where StandardOutputPk = @stdOutputPk)
	begin
		set identity_insert tblstandardoutput on	
		insert tblStandardOutput(StandardOutputPk, POtherDataFk, OtherTypeFk, StandardXml, StandardDate, UseForConsensus, OtherDataFk, UpdatedBy, UpdatedDate)
		select @stdOutputPk,
			@potherDataFk,
			@OtherTypeFk,
			@StdXml,
			@stddate,
			@useForConsensus,
			@otherDataFk,
			@updatedBy,
			@updatedDate
			
		set identity_insert tblstandardoutput on
	end
	else
	begin
		update tblStandardOutput
		set POtherDataFk = @potherdatafk,
			OtherTypeFk = @otherTypeFk,
			StandardXml = @stdXml,
			StandardDate = @stddate,
			UseForConsensus = @useForConsensus,
			OtherDataFk = @otherDataFk,
			UpdatedBy = @updatedBy,
			UpdatedDate = @updatedDate
		where StandardOutputPk = @stdOutputPk
		
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_StandardOutput TO PUBLIC

GO


