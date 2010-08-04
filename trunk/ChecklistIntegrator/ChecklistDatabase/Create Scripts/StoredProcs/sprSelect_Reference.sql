IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Reference')
	BEGIN
		DROP  Procedure  sprSelect_Reference
	END

GO

CREATE Procedure sprSelect_Reference
	@referenceGuid uniqueidentifier
AS

	select cast(ReferenceGUID as nvarchar(38)) as ReferenceGuid,
		ReferenceLSID,
		ReferenceCitation,
		ReferenceFullCitation,
		ReferenceCreatedDate,
		ReferenceCreatedBy,
		ReferenceUpdatedDate,
		ReferenceUpdatedBy
	from tblReference
	where ReferenceGuid = @referenceGuid

GO


GRANT EXEC ON sprSelect_Reference TO PUBLIC

GO


