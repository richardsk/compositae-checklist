IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithAuthors')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithAuthors
	END

GO

CREATE Procedure sprSelect_NamesWithAuthors
	@providerNamePk int,
	@threshold int
AS

	if ((select count(*) from tblProviderNameAuthors where PNAProviderNameFk = @providerNamePk) = 0)
	begin
		--succeed (no authors)
		return
	end

	
	declare @combAuthors nvarchar(100), @basAuthors nvarchar(100)
	select @combAuthors = rtrim(ltrim(lower(PNACombinationAuthors))),
		@basAuthors = rtrim(ltrim(lower(PNABasionymAuthors))) 
	from tblProviderNameAuthors 
	where PNAProviderNameFk = @providerNamePk
		
	declare @correctCombAuth nvarchar(100), @correctBasAuth nvarchar(100), @pos int, @endPos int
	declare @authPk int
	
	set @correctCombAuth = ''
	if (@combAuthors is not null)
	begin		
		set @pos = 1
		set @endPos = charindex(' ', @combAuthors)
		while(@endPos <> 0)
		begin
			select @authPk = CorrectAuthorFk
			from tblAuthors 
			where AuthorPk = cast(substring(@combAuthors, @pos, @endPos - @pos) as int)
			if (@authPk is not null) set @correctCombAuth = @correctCombAuth + cast(@authPk as nvarchar(10)) + ' '
			
			set @pos = @endPos
			set @endPos = charindex(' ', @combAuthors, @pos + 1)
		end

		--add last one		
		select @authPk = CorrectAuthorFk
		from tblAuthors 
		where AuthorPk = cast(substring(@combAuthors, @pos, len(@combAuthors)) as int)
		if (@authPk is not null) set @correctCombAuth = @correctCombAuth + cast(@authPk as nvarchar(10)) 
		
		set @correctCombAuth = rtrim(@correctCombAuth)
	end
	
	set @correctBasAuth = ''
	if (@basAuthors is not null)
	begin				
		set @pos = 1
		set @endPos = charindex(' ', @basAuthors)
		while(@endPos <> 0)
		begin
			select @authPk = CorrectAuthorFk
			from tblAuthors 
			where AuthorPk = cast(substring(@basAuthors, @pos, @endPos - @pos) as int)
			if (@authPk is not null) set @correctBasAuth = @correctBasAuth + cast(@authPk as nvarchar(10)) + ' '
			
			set @pos = @endPos
			set @endPos = charindex(' ', @basAuthors, @pos + 1)
		end

		--add last one		
		select @authPk = CorrectAuthorFk
		from tblAuthors 
		where AuthorPk = cast(substring(@basAuthors, @pos, len(@basAuthors)) as int)
		if (@authPk is not null) set @correctBasAuth = @correctBasAuth + cast(@authPk as nvarchar(10)) 
		
		set @correctBasAuth = rtrim(@correctBasAuth)
	end
		
	print(@correctCombAuth)
	print(@correctBasAuth)
	
	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, 100
		from tblName
		left join tblNameAuthors on NameAuthorsNameFk = Nameguid
		where isnull(NameAuthorsCombinationAuthors, @correctCombAuth) = @correctCombAuth
			and isnull(NameAuthorsBasionymAuthors, @correctBasAuth) = @correctBasAuth
	end
	else
	begin
		--special case - if there are no matching names with the specified authors, then 
		-- also check the provider name authors for matches
		if ((select count(*) from tmpmatchresults m
			inner join tblName n on n.NameGuid = m.MatchResultRecordId
			left join tblNameAuthors na on na.NameAuthorsNameFk = n.Nameguid
			where isnull(NameAuthorsCombinationAuthors,@correctCombAuth) = @correctCombAuth
				and isnull(NameAuthorsBasionymAuthors,@correctBasAuth)= @correctBasAuth) = 0)
		begin
			delete m
			from tmpMatchResults m
			where not exists( select * 
				from tblprovidername pn
				left join tblProviderNameAuthors pna on pna.PNAProviderNameFk = pn.PNPk
				where pn.pnnamefk = m.MatchResultRecordId 
					and isnull(PNACombinationAuthors, '-1') = isnull(@correctCombAuth, '-1')
					and isnull(PNABasionymAuthors, '-1') = isnull(@correctBasAuth, '-1') ) 
				
			print('Provider Name Author Match')
		end
		else
		begin
			delete m
			from tmpMatchResults m
			inner join tblName n on n.NameGuid = m.MatchResultRecordId
			left join tblNameAuthors na on na.NameAuthorsNameFk = n.Nameguid
			where isnull(NameAuthorsCombinationAuthors,@correctCombAuth) <> @correctCombAuth
				or isnull(NameAuthorsBasionymAuthors,@correctBasAuth) <> @correctBasAuth
		end
	end
		

GO


GRANT EXEC ON sprSelect_NamesWithAuthors TO PUBLIC

GO


