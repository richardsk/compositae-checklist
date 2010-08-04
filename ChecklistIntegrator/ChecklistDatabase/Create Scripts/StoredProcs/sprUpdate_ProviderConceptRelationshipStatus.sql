IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderConceptRelationshipStatus')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderConceptRelationshipStatus
	END

GO

CREATE Procedure sprUpdate_ProviderConceptRelationshipStatus
	@PCRPk int,
	@Status nvarchar(20),
	@user nvarchar(50)
AS

	declare @pcpk int
	select @pcpk = pcpk
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk
	
	exec sprInsert_ProviderConceptChange @pcpk, @user
	
	update tblProviderConceptRelationship
	set PCRLinkStatus = @status, PCRUpdatedBy = @user, PCRUpdatedDate = getdate()
	where PCRPk = @PCRPk
	

GO


GRANT EXEC ON sprUpdate_ProviderConceptRelationshipStatus TO PUBLIC

GO


