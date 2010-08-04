IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_LinkedProviderReferences')
	BEGIN
		DROP  Procedure  sprUpdate_LinkedProviderReferences
	END

GO

CREATE Procedure sprUpdate_LinkedProviderReferences
	@fromRefGuid uniqueidentifier,
	@toRefGuid uniqueidentifier,
	@linkStatus nvarchar(20),
	@user nvarchar(50)
AS

	--insert change records
	declare @prs table(PRPk int, counter int identity)
	insert @prs
	select PRPk 
	from tblProviderReference
	where PRReferenceFk = @fromRefGuid and PRLinkStatus <> 'Discarded'
	
	declare @pos int, @count int, @pk int
	select @pos = 1, @count = count(*) from @prs
	while (@pos <= @count)
	begin
		select @pk = PRPk from @prs where counter = @pos
		exec sprInsert_ProviderReferenceChange @pk, @user
		set @pos = @pos + 1
	end

	update tblProviderReference
	set PRReferenceFk = @toRefGuid,
		PRLinkStatus = @linkStatus,
		PRUpdatedDate = getdate(),
		PRUpdatedBy = @user	
	where PRReferenceFk = @fromRefGuid and PRLinkStatus <> 'Discarded'
	
	--insert ris record if none exitst, but a prov ris exists
	if exists(select * from tblProviderRIS 
				inner join tblProviderReference on PRPk = PRISProviderReferenceFk
				where PRReferenceFk = @toRefGuid) and
		not exists(select * from tblReferenceRIS
				inner join tblReference on ReferenceGuid = RISReferenceFk
				where ReferenceGuid = @toRefGuid)
	begin
		insert tblReferenceRIS(RISReferenceFk, RISCreatedDate, RISCreatedBy)
		select @toRefGuid, getdate(), @user
	end
				
	
GO


GRANT EXEC ON sprUpdate_LinkedProviderReferences TO PUBLIC

GO


