IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Reference')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Reference
	END

GO

CREATE Procedure sprTransferInsertUpdate_Reference
	@referenceGuid uniqueidentifier,
	@referenceLSID nvarchar(300),
	@referenceCitation nvarchar(4000),
	@referenceFullCitation ntext,
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
AS

	if (not exists(select * from tblReference where ReferenceGuid = @referenceGuid))
	begin
		insert tblReference
		select @referenceGuid,
			@referenceLSID,
			@referenceCitation,
			@referenceFullCitation,
			@createdDate,
			@createdBy,
			@updatedDate,
			@updatedBy
	end
	else
	begin
		update tblReference
		set ReferenceLSID = @referenceLSID,
			ReferenceCitation = @referenceCitation,
			ReferenceFullCitation = @referenceFullCitation,
			ReferenceCreatedDate = @createdDate,
			ReferenceCreatedBy = @createdBy,
			ReferenceUpdatedDate = @updatedDate,
			ReferenceUpdatedBy = @updatedBy
		where ReferenceGuid = @referenceGuid
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_Reference TO PUBLIC

GO


