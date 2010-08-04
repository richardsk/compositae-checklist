IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_StandardOutputUseForConsensus')
	BEGIN
		DROP  Procedure  sprUpdate_StandardOutputUseForConsensus
	END

GO

CREATE Procedure sprUpdate_StandardOutputUseForConsensus
	@stdOutputPk int,
	@useForConsensus bit,
	@user nvarchar(50)
AS

	update tblStandardOutput
	set UseForConsensus = @useForConsensus,
		UpdatedBy = @user,
		UpdatedDate = getdate()
	where StandardOutputPk = @stdOutputPk

GO


GRANT EXEC ON sprUpdate_StandardOutputUseForConsensus TO PUBLIC

GO


