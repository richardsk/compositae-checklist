IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Name')
	BEGIN
		DROP  Procedure  sprDelete_Name
	END

GO

CREATE Procedure sprDelete_Name
	@nameLsid nvarchar(300),
	@newNameLsid nvarchar(300),
	@user nvarchar(50)
AS

	declare @nameGuid uniqueidentifier 
	select @nameGuid = NameGuid from tblName where NameLsid = @nameLsid

	insert into tblDeprecated 
	select @NameLSID, @newNameLsid, 'tblName', getdate(), @user
	
	delete tblName
	where NameLsid = @nameLsid


	delete tblFieldStatus where FieldStatusRecordFk = cast(@nameGuid as varchar(38))
	
GO


GRANT EXEC ON sprDelete_Name TO PUBLIC

GO


