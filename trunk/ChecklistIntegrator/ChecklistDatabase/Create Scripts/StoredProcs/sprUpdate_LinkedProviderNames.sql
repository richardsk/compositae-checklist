IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_LinkedProviderNames')
	BEGIN
		DROP  Procedure  sprUpdate_LinkedProviderNames
	END

GO

CREATE Procedure sprUpdate_LinkedProviderNames
	@fromNameGuid uniqueidentifier,
	@toNameGuid uniqueidentifier,
	@linkStatus nvarchar(20),
	@user nvarchar(50)
AS

	--insert change records
	declare @pns table(PNPk int, counter int identity)
	insert @pns
	select PNPk 
	from tblProviderName
	where PNNameFk = @fromNameGuid and PNLinkStatus <> 'Discarded'
	
	declare @pos int, @count int, @pk int
	select @pos = 1, @count = count(*) from @pns
	while (@pos <= @count)
	begin
		select @pk = PNPk from @pns where counter = @pos
		exec sprInsert_ProviderNameChange @pk, @user
		set @pos = @pos + 1
	end

	update tblProviderName
	set PNNameFk = @toNameGuid,
		PNLinkStatus = @linkStatus,
		PNUpdatedDate = getdate(),
		PNUpdatedBy = @user	
	where PNNameFk = @fromNameGuid and PNLinkStatus <> 'Discarded'
	

GO


GRANT EXEC ON sprUpdate_LinkedProviderNames TO PUBLIC

GO


