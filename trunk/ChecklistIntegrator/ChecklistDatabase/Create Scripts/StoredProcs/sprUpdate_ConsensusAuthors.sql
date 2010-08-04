IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConsensusAuthors')
	BEGIN
		DROP  Procedure  sprUpdate_ConsensusAuthors
	END

GO

CREATE Procedure sprUpdate_ConsensusAuthors
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--OBSOLETE - done in code
	
	declare @basAuthors nvarchar(200)
	declare @combAuthors nvarchar(200)
	declare @first int, @second int, @pnpk int
	declare @hasBasConflict bit
	declare @hasCombConflict bit, @isSys bit
	
	declare @corrBasAuthors nvarchar(200), @corrCombAuthors nvarchar(200)
	declare @basAuthStr nvarchar(300), @combAuthStr nvarchar(300), @authorStr nvarchar(300)
	declare @basEx nvarchar(300), @combEx nvarchar(300), @exAuth nvarchar(300)
	
	set @hasBasConflict = 0
	set @hasCombConflict = 0
	set @isSys = 0
	

	--update editor prov name authors?
	select @pnpk = PNPk	
	from vwProviderName v
	where ProviderIsEditor = 1 and v.PNNameFk = @nameGuid and PNLinkStatus <> 'Discarded'
	
	if (@pnpk is not null) exec sprUpdate_providernameauthors @pnpk, @user
		
			
	--get majority authors from prov names (un corrected)
	
	create table #vals(val nvarchar(4000), pk int, isSystem bit)

	--bas authors
	insert #vals 
	select cast(PNABasionymAuthors as nvarchar(1000)), PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderNameAuthors pna on pna.PNAProviderNameFk = PNPk
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNABasionymAuthors is not null 
		and len(PNABasionymAuthors) > 0 and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk, @basEx = PNBasionymAuthors
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
		
		
		select top 1 @basAuthors = PNABasionymAuthors
		from tblProviderNameAuthors pna 		
		where PNAProviderNameFk = @pnpk
		
		if (charindex(' ex ', @basEx) <> 0)
		begin			
			set @basEx = substring(@basEx, 0, charindex(' ex ', @basEx) + 4)
		end
		else
		begin
			set @basEx = null
		end
	end
	else
	begin
		create table #top2(counter int identity(1,1), val nvarchar(1000), number int)
		
		insert into #top2(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2 where counter = 1
		select @second = number from #top2 where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @basAuthors = val from #top2
		end
		else
		begin
			set @hasBasConflict = 1
		end		
		
		drop table #top2	
	end
	
	
	delete #vals
		
	
	--comb authors
	insert #vals 
	select cast(PNACombinationAuthors as nvarchar(1000)), PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderNameAuthors pna on pna.PNAProviderNameFk = PNPk
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNACombinationAuthors is not null 
		and len(PNACombinationAuthors) > 0 and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk, @combEx = PNCombinationAuthors
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
			
		select top 1 @combAuthors = PNACombinationAuthors
		from tblProviderNameAuthors pna 
		where PNAProviderNameFk = @pnpk
		
		if (charindex(' ex ', @combEx) <> 0)
		begin			
			set @combEx = substring(@combEx, 0, charindex(' ex ', @combEx) + 4)
		end
		else
		begin
			set @combEx = null
		end
	end
	else
	begin
		create table #top2a(counter int identity(1,1), val nvarchar(1000), number int)
	
		insert into #top2a(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2a where counter = 1
		select @second = number from #top2a where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @combAuthors = val from #top2a
		end
		else
		begin
			set @hasCombConflict = 1
		end		
		
		drop table #top2a	
	end
		
	
	-- get corrected values
	
	select @corrBasAuthors = dbo.fnGetCorrectedAuthors(@basAuthors)
	
	select @corrCombAuthors = dbo.fnGetCorrectedAuthors(@combAuthors)


	--update name author ids
	if (not exists (select * from tblNameAuthors where NameAuthorsNameFk = @nameGuid))
	begin
		insert tblNameAuthors
		select @nameGuid, @corrBasAuthors, @corrCombAuthors, 1, getdate(), @user
	end
	else
	begin
		update tblNameAuthors
		set NameAuthorsBasionymAuthors = @corrBasAuthors,
			NameAuthorsCombinationAuthors = @corrCombAuthors,
			NameAuthorsCreatedDate = getdate(),
			NameAuthorsCreatedBy = @user
		where NameAuthorsNameFk = @nameGuid
	end
	
	-- ex authors?
	delete #vals		
	
	insert #vals 
	select cast(substring(PNNameAuthors, 0, charindex(' ex ', PNNameAuthors) + 4) as nvarchar(1000)), 
		PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNNameAuthors is not null 
		and len(PNNameAuthors) > 0 and charindex(' ex ', PNNameAuthors) <> 0
		and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
		
		select top 1 @exAuth = substring(PNNameAuthors, 0, charindex(' ex ', PNNameAuthors) + 4)
		from tblProviderName pn 
		where PNPk = @pnpk
	end
	else 
	begin
		create table #top2c(counter int identity(1,1), val nvarchar(1000), number int)
	
		insert into #top2c(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2c where counter = 1
		select @second = number from #top2c where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @exAuth = val from #top2c
		end		
		
		drop table #top2c
	end
	
	delete #vals		
	
	insert #vals 
	select cast(substring(PNBasionymAuthors, 0, charindex(' ex ', PNBasionymAuthors) + 4) as nvarchar(1000)), 
		PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNBasionymAuthors is not null 
		and len(PNBasionymAuthors) > 0 and charindex(' ex ', PNBasionymAuthors) <> 0
		and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
		
		select top 1 @basEx = substring(PNBasionymAuthors, 0, charindex(' ex ', PNBasionymAuthors) + 4)
		from tblProviderName pn 
		where PNPk = @pnpk
		
	end
	else 
	begin
		create table #top2d(counter int identity(1,1), val nvarchar(1000), number int)
	
		insert into #top2d(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2d where counter = 1
		select @second = number from #top2d where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @basEx = val from #top2d
		end		
		
		drop table #top2d
	end
	
	delete #vals		
	
	insert #vals 
	select cast(substring(PNCombinationAuthors, 0, charindex(' ex ', PNCombinationAuthors) + 4) as nvarchar(1000)), 
		PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNCombinationAuthors is not null 
		and len(PNCombinationAuthors) > 0 and charindex(' ex ', PNCombinationAuthors) <> 0
		and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
		
		select top 1 @combEx = substring(PNCombinationAuthors, 0, charindex(' ex ', PNCombinationAuthors) + 4)
		from tblProviderName pn 
		where PNPk = @pnpk
	end
	else 
	begin
		create table #top2e(counter int identity(1,1), val nvarchar(1000), number int)
	
		insert into #top2e(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2e where counter = 1
		select @second = number from #top2e where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @combEx = val from #top2e
		end		
		
		drop table #top2e
	end
	
	-- get authors strings
		
	select @basAuthStr = dbo.fnGetAuthorString(@corrBasAuthors, null, 0)
	select @combAuthStr = dbo.fnGetAuthorString(null, @corrCombAuthors, 0)
	select @authorStr = dbo.fnGetAuthorString(@corrBasAuthors, @corrCombAuthors, 1)
	
	--only update full authors if both are not null (or prov auth were null)
	if (@hasBasConflict = 1 or @hasCombConflict = 1)
	begin
		set @authorStr = null
	end 
	
	--editor record for authors?
	delete #vals		
	
	insert #vals 
	select cast(PNNameAuthors as nvarchar(1000)), PNPk, isnull(ProviderIsEditor,0)
	from tblProviderName pn 
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk 
	where PNNameFk = @nameGuid and PNNameAuthors is not null 
		and len(PNNameAuthors) > 0 and PNLinkStatus <> 'Discarded'
		
		
	if (exists(select * from #vals where isSystem = 1))
	begin
		select top 1 @pnpk = PNPk
		from tblProviderName pn 
		inner join #vals v on v.pk = pn.PNPk 
		where v.isSystem = 1 
		order by pnupdateddate desc
		
		select top 1 @authorStr = PNNameAuthors
		from tblProviderName pn 
		where PNPk = @pnpk
				
		set @isSys = 1
	end
	/*else if (@authorStr is null or len(@authorStr) = 0) --no editor entered authors and no corrected authors
	begin
		create table #top2b(counter int identity(1,1), val nvarchar(1000), number int)
	
		insert into #top2b(val, number) 
		select top 2 val, count(*)
		from #vals where val is not null 
		group by val 
		order by count(*) desc 
		
		set @first = null
		set @second = null				
		select @first = number from #top2b where counter = 1
		select @second = number from #top2b where counter = 2
		
		if (@second is null or @first > @second) 
		begin
			select top 1 @authorStr = val from #top2b
		end		
		
		drop table #top2b
	end*/
	
	
	
	
	--update consensus author values
	if (@isSys = 0 and @exAuth is not null and len(@exAuth) > 0) 
	begin
		if (substring(@exAuth, 1, 1) = '(') set @exAuth = substring(@exAuth, 2, len(@exAuth))
		if (substring(@authorStr, 1, 1) = '(') 
		begin
			set @authorStr = '(' + @exAuth + substring(@authorStr, 2, len(@authorStr)) 
		end
		else
		begin
			set @authorStr = @exAuth + @authorStr
		end
	end
	
	print(@basEx)
	print(@basAuthStr)
	
	if (@basEx is not null and len(@basEx) > 0) set @basAuthStr = @basEx + @basAuthStr
	if (@combEx is not null and len(@combEx) > 0) set @combAuthStr = @combEx + @combAuthStr
	
	print(@basAuthStr)
	
	update tblName
	set NameAuthors = @authorStr,
		NameBasionymAuthors = @basAuthStr, 
		NameCombinationAuthors = @combAuthStr,
		NameUpdatedDate = getdate(),
		NameUpdatedBy = @user
	where NameGuid = @nameGuid
	
	--update full name
	update tblName 
	set NameFull = dbo.fnGetFullName(NameGuid, 0, 0, 1, 0, 0)
	where NameGuid = @nameGuid
	
GO


GRANT EXEC ON sprUpdate_ConsensusAuthors TO PUBLIC

GO


