IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Deprecated')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Deprecated
	END

GO

CREATE Procedure sprTransferInsertUpdate_Deprecated
	@LSID nvarchar(300),
	@newLSID nvarchar(300),
	@tableName nvarchar(100),
	@deprecatedDate datetime,
	@deprecatedBy nvarchar(50)
AS

	if not exists(select * from tblDeprecated where DeprecatedLSID = @LSID and DeprecatedNewLSID = @newLSID)
	begin
		insert tblDeprecated
		select @LSID, @newLSID, @tableName, @deprecatedDate, @deprecatedBy
		
		--actually delete from tables too	
		if (@tableName = 'tblName')
		begin
			declare @nameGuid uniqueidentifier 
			select @nameGuid = NameGuid from tblName where NameLsid = @Lsid
			
			delete tblName
			where NameLsid = @Lsid


			delete tblFieldStatus where FieldStatusRecordFk = cast(@nameGuid as varchar(38))
		end
		if (@tableName = 'tblReference')
		begin
			declare @refGuid uniqueidentifier 
			select @refGuid = ReferenceGuid from tblReference where ReferenceLsid = @Lsid
	
			delete tblReference
			where ReferenceLsid = @Lsid


			delete tblFieldStatus where FieldStatusRecordFk = cast(@refGuid as varchar(300))
		end
	end

GO


GRANT EXEC ON sprTransferInsertUpdate_Deprecated TO PUBLIC

GO


