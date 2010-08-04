IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_Reference')
	BEGIN
		DROP  Procedure  sprInsert_Reference
	END

GO

CREATE Procedure sprInsert_Reference
	@referenceGuid uniqueidentifier,
	@referenceLSID nvarchar(300),
	@referenceCitation nvarchar(4000),
	@referenceFullCitation ntext,
	@user nvarchar(50)
AS

	insert tblReference
	select @referenceGuid,
		@referenceLSID,
		@referenceCitation,
		@referenceFullCitation,
		getdate(),
		@user,
		null, null

GO

	

GRANT EXEC ON sprInsert_Reference TO PUBLIC

GO


