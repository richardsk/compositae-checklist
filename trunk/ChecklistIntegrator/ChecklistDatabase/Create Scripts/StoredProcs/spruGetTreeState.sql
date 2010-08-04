IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spruGetTreeState')
	BEGIN
		DROP  Procedure  spruGetTreeState
	END

GO

CREATE PROCEDURE dbo.spruGetTreeState
	@intTreeStateKey			int,
	@intTreeStateSession		int OUTPUT,
	@datTreeStateDateAdded		datetime OUTPUT,
	@datTreeStateLastAccessed	datetime OUTPUT
	
AS
	
	SELECT	@intTreeStateSession =TreeStateSession,
			@datTreeStateDateAdded = TreeStateDateAdded,
			@datTreeStateLastAccessed = TreeStateLastAccessed
	FROM tblTreeState
	WHERE TreeStatePk = @intTreeStateKey
	
	SELECT TreeStateXml
	FROM tblTreeState
	WHERE TreeStatePk = @intTreeStateKey
	
	UPDATE tblTreeState
	SET TreeStateLastAccessed = GetDate()
	WHERE TreeStatePk = @intTreeStateKey
	
	RETURN @@ERROR

GO


GRANT EXEC ON spruGetTreeState TO PUBLIC

GO


