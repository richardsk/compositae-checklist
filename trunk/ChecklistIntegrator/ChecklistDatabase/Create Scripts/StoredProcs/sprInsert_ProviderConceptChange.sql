IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ProviderConceptChange')
	BEGIN
		DROP  Procedure  sprInsert_ProviderConceptChange
	END

GO

CREATE Procedure sprInsert_ProviderConceptChange
	@pcpk int,
	@user nvarchar(50)
AS

	insert tblProviderConcept_Change
	select *, getdate(), @user
	from tblProviderConcept
	where PCPk = @pcpk

	--concept relationship
	insert tblProviderConceptRelationship_Change
	select pcr.*, getdate(), @user
	from tblProviderConceptRelationship pcr
	inner join vwProviderConceptRelationship vwpcr on vwpcr.PCRPk = pcr.PCRPk
	where PCPk = @pcpk
GO


GRANT EXEC ON sprInsert_ProviderConceptChange TO PUBLIC

GO


