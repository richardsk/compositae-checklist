IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderConceptStatus')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderConceptStatus
	END

GO

CREATE Procedure sprUpdate_ProviderConceptStatus
	@PCPk int,
	@Status nvarchar(20),
	@user nvarchar(50)
AS

	exec sprInsert_ProviderConceptChange @pcpk, @user
	
	update tblProviderConcept
	set PCLinkStatus = @status, PCUpdatedBy = @user, PCUpdatedDate = getdate()
	where PCPk = @PCPk
	

GO


GRANT EXEC ON sprUpdate_ProviderConceptStatus TO PUBLIC

GO


