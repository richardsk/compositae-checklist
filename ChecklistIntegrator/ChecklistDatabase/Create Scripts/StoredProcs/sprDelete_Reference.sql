IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Reference')
	BEGIN
		DROP  Procedure  sprDelete_Reference
	END

GO

CREATE Procedure sprDelete_Reference
	@refLsid nvarchar(300),
	@newRefLsid nvarchar(300),
	@user nvarchar(50)
AS

	declare @refGuid uniqueidentifier 
	select @refGuid = ReferenceGuid from tblReference where ReferenceLsid = @refLsid

	insert into tblDeprecated 
	select @refLSID, @newRefLsid, 'tblReference', getdate(), @user
	
	delete tblReference
	where ReferenceLsid = @refLsid


	delete tblFieldStatus where FieldStatusRecordFk = cast(@refGuid as varchar(300))
	
GO


GRANT EXEC ON sprDelete_Reference TO PUBLIC

GO


