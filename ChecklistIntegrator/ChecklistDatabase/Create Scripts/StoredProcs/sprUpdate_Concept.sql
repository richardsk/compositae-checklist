 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_Concept')
	BEGIN
		DROP  Procedure  sprUpdate_Concept
	END

GO

CREATE Procedure sprUpdate_Concept
	@cPK int,
	@cLSID nvarchar(300),
	@cName1 nvarchar(4000),
	@cName1Fk uniqueidentifier,
	@cAccordingTo nvarchar(4000),
	@cAccordingToFk uniqueidentifier,
	@user nvarchar(50)
AS

		update tblConcept
		set ConceptLSID = @cLSID,
			ConceptName1 = @cName1,
			ConceptName1Fk = @cName1Fk,
			ConceptAccordingTo = @cAccordingTo,
			ConceptAccordingToFk = @cAccordingToFk,
			ConceptUpdatedDate = getdate(),
			ConceptUpdatedBy = @user
		where ConceptPk = @cPK

GO


GRANT EXEC ON sprUpdate_Concept TO PUBLIC

GO


 