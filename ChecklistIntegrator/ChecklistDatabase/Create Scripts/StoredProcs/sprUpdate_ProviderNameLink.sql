IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameLink')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameLink
	END

GO

CREATE Procedure sprUpdate_ProviderNameLink
	@PNPK int,
	@PNNameFk uniqueidentifier,
	@PNLinkStatus nvarchar(20),
	@user nvarchar(50)
AS

	declare @oldNameFk uniqueidentifier, @oldLSID nvarchar(300), @newLSID nvarchar(300), @c int
	select @oldNameFk = PNNameFk, @oldLSID = NameLSID
	from tblProviderName 
	inner join tblName on NameGuid = PNNameFk
	where PNPk = @PNPk
	
	
	update tblProviderName
	set PNNameFk = @PNNameFk,
		PNLinkStatus = @PNLinkStatus,
		PNUpdatedDate = getdate(),
		PNUpdatedBy = @user
	where PNPk = @PNPk
	
	
	/*delete name if no provider names left
	select @c = count(*) from vwProviderName where PNNameFk = @oldNameFk and ProviderName <> 'SYSTEM'
	if (@c = 0)
	begin
		if (@PNNameFk is null) set @newLSID = 'unlinked'
		else select @newLSID = NameLSID from tblName where NameGuid = @PNNameFk
		
		exec sprDelete_Name @oldLSID, @newLSID, @user
	end*/

GO


GRANT EXEC ON sprUpdate_ProviderNameLink TO PUBLIC

GO


