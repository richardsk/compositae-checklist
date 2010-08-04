IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameMatchScore')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameMatchScore
	END

GO

CREATE Procedure sprUpdate_ProviderNameMatchScore
	@PNPk int,
	@MatchScore int,
	@user nvarchar(50)
AS

	update tblProviderName 
	set PNNameMatchScore = @MatchScore, PNUpdatedDate = getdate(), PNUpdatedBy = @user
		where PNPk = @PNPk
	
	
GO


GRANT EXEC ON sprUpdate_ProviderNameMatchScore TO PUBLIC

GO


