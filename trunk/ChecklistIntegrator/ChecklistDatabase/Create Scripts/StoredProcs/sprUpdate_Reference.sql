IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_Reference')
	BEGIN
		DROP  Procedure  sprUpdate_Reference
	END

GO

CREATE Procedure sprUpdate_Reference
	@referenceGuid uniqueidentifier,
	@referenceLSID nvarchar(300),
	@referenceCitation nvarchar(4000),
	@referenceFullCitation ntext,
	@user nvarchar(50)
AS

	update tblReference
	set ReferenceLSID = @referenceLSID,
		ReferenceCitation = @referenceCitation,
		ReferenceFullCitation = @referenceFullCitation,
		ReferenceUpdatedDate = getdate(),
		ReferenceUpdatedBy = @user
		
GO


GRANT EXEC ON sprUpdate_Reference TO PUBLIC

GO


