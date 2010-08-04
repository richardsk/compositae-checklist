IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spriNewTreeState')
	BEGIN
		DROP  Procedure  spriNewTreeState
	END

GO

CREATE PROCEDURE dbo.spriNewTreeState
	@intTreeStateSession	int,
	@txtTreeStateXml		ntext,
	@intTreeStatePk			int OUTPUT	
AS
	SET NOCOUNT OFF;
	INSERT INTO tblTreeState(TreeStateSession, TreeStateXml, TreeStateDateAdded) 
	VALUES (@intTreeStateSession, @txtTreeStateXml, GetDate());
	SET @intTreeStatePk = @@IDENTITY
	RETURN @@ERROR


GO



GRANT EXEC ON spriNewTreeState TO PUBLIC

GO


