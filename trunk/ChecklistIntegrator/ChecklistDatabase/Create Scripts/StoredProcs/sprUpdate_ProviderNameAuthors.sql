IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameAuthors')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameAuthors
	END

GO

CREATE Procedure sprUpdate_ProviderNameAuthors
	@PNPk int,
	@user nvarchar(50) 
AS

	--OBSOLETE - done in code
			
	--find author ids where they match the provider name authors
	-- eg where Smith = 1, Jones = 2, Smth = 3 
	--   Smith = '1'
	--   Smith & Jones = '1 2'
	--   Smith ex Jones = '2'
	--   Smth & Jones = '3 2'
		
	declare @nameBasAuth nvarchar(300), @nameCombAuth nvarchar(300), @basAuthorId int, @combAuthorId int
	declare @pos int, @endPos int, @endPos1 int, @endPos2 int, @auth nvarchar(300), @authId int
	declare @authors nvarchar(100)
		
	-- delete old authors
	delete tblProviderNameAuthors where PNAProviderNameFk = @PNPk and PNAIsCorrected = 0 --todo ??
	
	select @nameBasAuth = PNBasionymAuthors, @nameCombAuth = PNCombinationAuthors
	from tblProviderName
	where PNPk = @PNPk
	
	--basionym author
	
	--exact match
	select top 1 @basAuthorId = AuthorPk
	from tblAuthors
	where Abbreviation = @nameBasAuth
	
	if (@basAuthorId is not null)
	begin
		insert tblProviderNameAuthors
		select @PNPk, cast(@basAuthorId as varchar(100)), null, 0, getdate(), @user
	end
	else
	--parse authors
	begin
		--remove 'in citation', 'ex' etc
		
		set @pos = charindex('  ', @nameBasAuth)
		while (@pos > 0)
		begin
			set @nameBasAuth = replace(@nameBasAuth, '  ', ' ')
			set @pos = charindex('  ', @nameBasAuth)
		end
		
		set @nameBasAuth = replace(@nameBasAuth, ' et ', ' & ')
		
		if (charindex(' ex ', @nameBasAuth) <> 0)
		begin
			set @pos = charindex(' ex ', @nameBasAuth)
			if (@pos <> 0) set @nameBasAuth = substring(@nameBasAuth, @pos + 4, len(@nameBasAuth))
		end
		
		if (charindex('in citation', @nameBasAuth) <> 0)
		begin
			set @pos = charindex('in citation', @nameBasAuth)
			if (@pos <> 0) set @nameBasAuth = substring(@nameBasAuth, 0, @pos) --todo?
		end
		
		if (charindex(' in ', @nameBasAuth) <> 0)
		begin
			set @pos = charindex(' in ', @nameBasAuth)
			if (@pos <> 0) set @nameBasAuth = substring(@nameBasAuth, 0, @pos) --todo?
		end
		
		set @nameBasAuth = ltrim(@nameBasAuth)
		
		if (len(@nameBasAuth) > 0)
		begin
			set @authors = ''
			
			--split by '&' ',' 
			set @pos = 1
			set @endPos1 = charindex('&', @nameBasAuth)
			set @endPos2 = charindex(',', @nameBasAuth)
			set @endPos = dbo.fnmin(@endPos1, @endPos2)			
			if (@endPos = 0) set @endPos = dbo.fnmax(@endPos1, @endPos2)
						
			while (@pos <> 0)
			begin
				if (@endPos = 0)
					set @auth = ltrim(rtrim(substring(@nameBasAuth, @pos, len(@nameBasAuth))))
				else
					set @auth = ltrim(rtrim(substring(@nameBasAuth, @pos, @endPos - @pos)))
				
				if (len(@auth) > 0)
				begin
					set @authId = null
					select @authId = AuthorPk
					from tblAuthors
					where Abbreviation = @auth
					
					if (@authId is null)
					begin
						--not found insert into author table
						insert tblAuthors
						select null, null, @auth, null, null, null, null, null, null, getdate(), @user, null, null
						
						set @authId = @@identity
						
						update tblAuthors 
						set CorrectAuthorFk = @authId,
							UpdatedDate = getdate(),
							UpdatedBy = @user
						where AuthorPk = @authId
					end
					
					set @authors = @authors + cast(@authId as nvarchar(10)) + ' '
				end
				
				if (@endPos = 0)
				begin
					set @pos = 0 --end
				end
				else
				begin
					set @pos = @endPos + 1
					set @endPos1 = charindex('&', @nameBasAuth, @pos)
					set @endPos2 = charindex(',', @nameBasAuth, @pos)
					set @endPos = dbo.fnmin(@endPos1, @endPos2)			
					if (@endPos = 0) set @endPos = dbo.fnmax(@endPos1, @endPos2)
				end
			end
			
			set @authors = rtrim(@authors)
			
			print (@authors)
			
			insert tblProviderNameAuthors
			select @PNPk, @authors, null, 0, getdate(), @user
		end
	end
	
	
	--combination author
	
	--exact match
	select top 1 @combAuthorId = AuthorPk
	from tblAuthors
	where Abbreviation = @nameCombAuth
	
	if (@combAuthorId is not null)
	begin
	
		if (not exists (select * from tblProviderNameAuthors where PNAProviderNameFk = @PNPK))
		begin
			insert tblProviderNameAuthors
			select @PNPk, null, cast(@combAuthorId as varchar(100)), 0, getdate(), @user
		end
		else
		begin
			update tblProviderNameAuthors
			set PNACombinationAuthors = cast(@combAuthorId as varchar(100)),
				PNACreatedDate = getdate(),
				PNACreatedBy = @user
			where PNAProviderNameFk = @PNPk
		end
	end
	else
	--parse authors
	begin
		--remove 'in citation', 'ex' etc
		
		set @pos = charindex('  ', @nameCombAuth)
		while (@pos > 0)
		begin
			set @nameCombAuth = replace(@nameCombAuth, '  ', ' ')
			set @pos = charindex('  ', @nameCombAuth)
		end
		
		set @nameCombAuth = replace(@nameCombAuth, ' et ', ' & ')
		
		if (charindex(' ex ', @nameCombAuth) <> 0)
		begin
			set @pos = charindex(' ex ', @nameCombAuth)
			if (@pos <> 0) set @nameCombAuth = substring(@nameCombAuth, @pos + 4, len(@nameCombAuth))
		end
		
		if (charindex('in citation', @nameCombAuth) <> 0)
		begin
			set @pos = charindex('in citation', @nameCombAuth)
			if (@pos <> 0) set @nameCombAuth = substring(@nameCombAuth, 0, @pos) --todo?
		end
		
		if (charindex(' in ', @nameCombAuth) <> 0)
		begin
			set @pos = charindex(' in ', @nameCombAuth)
			if (@pos <> 0) set @nameCombAuth = substring(@nameCombAuth, 0, @pos) --todo?
		end
		
		set @nameCombAuth = ltrim(@nameCombAuth)
		
		print (@nameCombAuth)
		
		if (len(@nameCombAuth) > 0)
		begin
			set @authors = ''
			
			--split by '&' ',' 
			set @pos = 1
			set @endPos1 = charindex('&', @nameCombAuth)
			set @endPos2 = charindex(',', @nameCombAuth)
			set @endPos = dbo.fnmin(@endPos1, @endPos2)			
			if (@endPos = 0) set @endPos = dbo.fnmax(@endPos1, @endPos2)
								
			while (@pos <> 0)
			begin
				if (@endPos = 0)
					set @auth = ltrim(rtrim(substring(@nameCombAuth, @pos, len(@nameCombAuth))))
				else
					set @auth = ltrim(rtrim(substring(@nameCombAuth, @pos, @endPos - @pos)))
				
				if (len(@auth) > 0)
				begin
					set @authId = null
					select @authId = AuthorPk
					from tblAuthors
					where Abbreviation = @auth
					
					if (@authId is null)
					begin
						--not found insert into author table
						insert tblAuthors
						select null, null, @auth, null, null, null, null, null, null, getdate(), @user, null, null
						
						set @authId = @@identity
						
						update tblAuthors 
						set CorrectAuthorFk = @authId,
							UpdatedDate = getdate(),
							UpdatedBy = @user
						where AuthorPk = @authId						
					end
			
					set @authors = @authors	+ cast(@authId as nvarchar(10)) + ' '
				end
				
				if (@endPos = 0)
				begin
					set @pos = 0 --end
				end
				else
				begin
					set @pos = @endPos + 1
					set @endPos1 = charindex('&', @nameCombAuth, @pos)
					set @endPos2 = charindex(',', @nameCombAuth, @pos)
					set @endPos = dbo.fnmin(@endPos1, @endPos2)			
					if (@endPos = 0) set @endPos = dbo.fnmax(@endPos1, @endPos2)
				end
			end
			
			set @authors = rtrim(@authors)
			
			if (not exists (select * from tblProviderNameAuthors where PNAProviderNameFk = @PNPK))
			begin
				insert tblProviderNameAuthors
				select @PNPk, null, @authors, 0, getdate(), @user
			end
			else
			begin
				update tblProviderNameAuthors
				set PNACombinationAuthors = @authors,
					PNACreatedDate = getdate(),
					PNACreatedBy = @user
				where PNAProviderNameFk = @PNPk
			end
		end
	end	

GO


GRANT EXEC ON sprUpdate_ProviderNameAuthors TO PUBLIC

GO


