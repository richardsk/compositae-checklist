IF EXISTS (SELECT * FROM sysobjects WHERE type	= 'FN' AND name = 'fnGetProviderNameParentMatch')
	BEGIN
		DROP  Function  fnGetProviderNameParentMatch
	END

GO

CREATE Function fnGetProviderNameParentMatch
(
	@providerNamePk int
)
returns uniqueidentifier
as
begin

	declare @nameFk uniqueidentifier, @parentFk uniqueidentifier, @provPk int, @pos int, @nm nvarchar(300)
	declare @rankPk int, @fullName nvarchar(300), @canonical nvarchar(300), @rankSort int, @rnk nvarchar(100)
	declare @defNameId uniqueidentifier, @defPNId int, @provImportFk int, @cnt int, @auth nvarchar(1000)
	declare @defGenNameId uniqueidentifier, @defGenPNId nvarchar(300), @highNameId uniqueidentifier, @genNameId nvarchar(300)
	
	--find parent based on rank and full name
	-- if multiple matches then we cant choose between them so fail
	
	select @nameFk = PNNameFk, @rankSort = RankSort, @rnk = RankName, @provImportFk = PNProviderImportFk,
		@rankPk = PNNameRankFk, @canonical = PNNameCanonical, @fullname = PNNameFull, @auth = pnnameauthors
	from tblProviderName
	inner join tblRank on RankPk = PNNameRankFk
	where PNPk = @providerNamePk
	
	select @defNameId = ProviderImportHigherNameId, 
		@defPNId = ProviderImportHigherPNId,
		@defGenNameId = ProviderImportGenusNameId, 
		@defGenPNId = ProviderImportGenusPNId
	from tblProviderImport
	where ProviderImportPk = @provImportFk
	
	set @highNameId = @defNameId
	set @genNameId = @defGenNameId
	
	if (@defPNId is not null)
	begin
		select @highNameId = isnull(PNNameFk, @highNameId) 
		from vwProviderName 
		where PNNameId = @defPNId and ProviderPk = @provPk		
	end
	
	if (@defGenPNId is not null)
	begin
		select @genNameId = isnull(PNNameFk, @genNameId) 
		from vwProviderName 
		where PNNameId = @defGenPNId and ProviderPk = @provPk
	end
	
		
	if (@rankSort <= 2000) --family or above, use higher name id
	begin
		if (@highNameId is not null)
		begin
			select @parentFk = @highNameId
		end
		else
		begin
			select @parentFk = NameGuid from tblName where NameFull = 'Plantae'
		end
	end
	else if (@rankSort < 3000) --infra family
	begin
		if (charindex(' subfam', @fullName) <> 0 or 
			charindex(' supertrib', @fullName) <> 0 or
			charindex(' trib', @fullName) <> 0 or
			charindex(' subtrib', @fullName) <> 0)
		begin
			set @pos = charindex(' ', @fullName)
			set @nm = substring(@fullName, 0, @pos)
			
			select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 7 
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameCanonical = @nm and NameRankFk = 7
			end
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 7 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameCanonical = @nm and NameRankFk = 7 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				
				--see if a sibling name has one of these as a parent
				--if (@cnt = 0 or @cnt > 1)
				--begin
				--	select top 1 @parentFk = NameGuid
				--	from tblName n
				--	inner join vwProviderName pn on pn.PNNameFk = n.NameGuid
				--	inner join vwProviderName pn2 on pn2.
				--	where pn.PNNameFk = NameCanonical = @nm and NameRankFk = 7 
				--end
				
				if (@cnt > 1 or @parentFk is null) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end		
	end
	else if (@rankSort = 3000) --genus
	begin
		if (@genNameId is not null)
		begin
			select @parentFk = @genNameId
		end
		else
		begin
			select @parentFk = NameGuid from tblName where NameCanonical = 'Compositae'
		end 
	end
	else if (@rankSort < 4200) --infra generic
	begin
		if (charindex(' subgen', @fullName) <> 0 or 
			charindex(' sect', @fullName) <> 0 or
			charindex(' subsect', @fullName) <> 0 or
			charindex(' ser', @fullName) <> 0)
		begin
			set @pos = charindex(' ', @fullName)
			set @nm = substring(@fullName, 0, @pos)
			
			select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 8 
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameCanonical = @nm and NameRankFk = 8
			end 			
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 8 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameCanonical = @nm and NameRankFk = 8 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 8 
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 8 
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end	
	end
	else if (@rankSort = 4200) --species
	begin
		set @pos = charindex(' ', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		
		select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 8 
		if (@cnt = 1)
		begin
			select @parentFk = NameGuid
			from tblName
			where NameCanonical = @nm and NameRankFk = 8		
		end
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName where NameCanonical = @nm and NameRankFk = 8 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameCanonical = @nm and NameRankFk = 8 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			else if (@cnt > 1)
			begin	
				--check children of multiple parent	matches to see if there is an exact match
				select @cnt = count(n.nameguid) 
				from tblName n
				inner join tblname cn on cn.nameparentfk = n.nameguid
				where n.NameCanonical = @nm and n.NameRankFk = 8 
					and cn.namecanonical = @canonical 
					and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					
				if (@cnt = 1)
				begin
					select @parentFk = n.nameguid
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 8 
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
				end
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
		
		--try prov names
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblProviderName 
			where PNNameCanonical = @nm 
				and PNNameRankFk = 8
				and PNNameFk is not null
			if (@cnt > 0)
			begin
				select top 1 @parentFk = PNNameFk
				from tblProviderName
				where PNNameCanonical = @nm
					and PNNameRankFk = 8
					and PNNameFk is not null
			end
		end

	end
	else if (@rankSort = 4400) --subspecies
	begin
		set @pos = charindex(' subsp', @fullName)
		if (@pos = 0) set @pos = charindex(' ssp', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		
		select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 
		
		if (@cnt = 1)
		begin 
			select @parentFk = NameGuid
			from tblName
			where NameFull = @nm and NameRankFk = 24		
		end
		
		if (@cnt = 0 and @parentfk is null)
		begin
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 
						
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24
			end
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			else if (@cnt > 1)
			begin	
				--check children of multiple parent	matches to see if there is an exact match
				select @cnt = count(n.nameguid) 
				from tblName n
				inner join tblname cn on cn.nameparentfk = n.nameguid
				where n.NameCanonical = @nm and n.NameRankFk = 24
					and cn.namecanonical = @canonical 
					and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					
				if (@cnt = 1)
				begin
					select @parentFk = n.nameguid
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
				end
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
		
		--try prov names
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblProviderName 
			where PNNameFull = @nm 
				and PNNameRankFk = 24
				and PNNameFk is not null
			if (@cnt > 0)
			begin
				select top 1 @parentFk = PNNameFk
				from tblProviderName
				where PNNameFull = @nm
					and PNNameRankFk = 24
					and PNNameFk is not null
			end
		end

		--try without authors
		if (@cnt = 0 and @parentfk is null)
		begin		
			set @pos = charindex('(', @fullName)
			if (@pos <> 0)
			begin
				set @nm = RTRIM(substring(@fullName, 0, @pos))
					
				select @cnt = count(*) from tblProviderName 
				where (PNNameFull = @nm or PNNameFull like @nm + ' %')
					and PNNameRankFk = 24
					and PNNameFk is not null
				if (@cnt > 0)
				begin
					select top 1 @parentFk = PNNameFk
					from tblProviderName
					where (PNNameFull = @nm or PNNameFull like @nm + ' %')
						and PNNameRankFk = 24
						and PNNameFk is not null
				end
			end
		end
	end
	else if (@rankSort = 4600) --variety
	begin
		if (charindex(' var', @fullName) <> 0)
		begin		
			set @pos = charindex(' var', @fullName)
			set @nm = substring(@fullName, 0, @pos)
			
			select @cnt = count(*) from tblName 
			where NameFull = @nm and (NameRankFk = 35 or NameRankFk = 24)
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull = @nm and (NameRankFk = 35 or NameRankFk = 24)
			end
			
			if (@cnt = 0 and @parentfk is null)
			begin		
				select @cnt = count(*) from tblName 
				where NameFull like @nm + ' %' and (NameRankFk = 35 or NameRankFk = 24)
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and (NameRankFk = 35 or NameRankFk = 24)
				end
				if (@cnt > 0)
				begin
					select @cnt = count(*) from tblName 
					where NameFull like @nm + ' %' 
						and (NameRankFk = 35 or NameRankFk = 24)
						and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
					if (@cnt = 1)
					begin
						select @parentFk = NameGuid
						from tblName
						where NameFull like @nm + ' %' 
						and (NameRankFk = 35 or NameRankFk = 24)
						and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
					end
					
					if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
				end 
			end
			
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName 
				where NameFull like @nm + ' %' 
				and (NameRankFk = 35 or NameRankFk = 24)
				and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %'					
					and (NameRankFk = 35 or NameRankFk = 24)
					and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and (n.NameRankFk = 24 or n.namerankfk = 35)
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and (n.NameRankFk = 24 or n.namerankfk = 35)
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
			
			--try prov names
			if (@cnt = 0 and @parentfk is null)
			begin		
				select @cnt = count(*) from tblProviderName 
				where PNNameFull = @nm 
					and (PNNameRankFk = 35 or PNNameRankFk = 24)
					and PNNameFk is not null
				if (@cnt > 0)
				begin
					select top 1 @parentFk = PNNameFk
					from tblProviderName
					where PNNameFull = @nm
						and (PNNameRankFk = 35 or PNNameRankFk = 24)
						and PNNameFk is not null
				end
			end
			
			--try without authors
			if (@cnt = 0 and @parentfk is null)
			begin		
				set @pos = charindex('(', @fullName)
				if (@pos <> 0)
				begin
					set @nm = RTRIM(substring(@fullName, 0, @pos))
						
					select @cnt = count(*) from tblProviderName 
					where (PNNameFull = @nm or PNNameFull like @nm + ' %')
						and (PNNameRankFk = 35 or PNNameRankFk = 24)
						and PNNameFk is not null
					if (@cnt > 0)
					begin
						select top 1 @parentFk = PNNameFk
						from tblProviderName
						where (PNNameFull = @nm or PNNameFull like @nm + ' %')
							and (PNNameRankFk = 35 or PNNameRankFk = 24)
							and PNNameFk is not null
					end
				end
			end
		end
	end
	else if (charindex(' subvar', @fullName) <> 0)
	begin		
		set @pos = charindex(' subvar', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		
		select @cnt = count(*) from tblName 
		where NameFull = @nm and (NameRankFk = 35 or NameRankFk = 24)
		if (@cnt = 1)
		begin
			select @parentFk = NameGuid
			from tblName
			where NameFull = @nm and (NameRankFk = 35 or NameRankFk = 24)
		end
		
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblName 
			where NameFull like @nm + ' %' and (NameRankFk = 35 or NameRankFk = 24)
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and (NameRankFk = 35 or NameRankFk = 24)
			end
			if (@cnt > 0)
			begin
				select @cnt = count(*) from tblName 
				where NameFull like @nm + ' %' 
					and (NameRankFk = 35 or NameRankFk = 24)
					and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' 
					and (NameRankFk = 35 or NameRankFk = 24)
					and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 24 
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName 
			where NameFull like @nm + ' %'
			and (NameRankFk = 35 or NameRankFk = 24)
			and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %'
				and (NameRankFk = 35 or NameRankFk = 24)
				and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			else if (@cnt > 1)
			begin	
				--check children of multiple parent	matches to see if there is an exact match
				select @cnt = count(n.nameguid) 
				from tblName n
				inner join tblname cn on cn.nameparentfk = n.nameguid
				where n.NameCanonical = @nm and n.NameRankFk = 24
					and cn.namecanonical = @canonical 
					and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					
				if (@cnt = 1)
				begin
					select @parentFk = n.nameguid
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
				end
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
		
		--try prov names
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblProviderName 
			where PNNameFull = @nm 
				and (PNNameRankFk = 35 or PNNameRankFk = 24)
				and PNNameFk is not null
			if (@cnt > 0)
			begin
				select top 1 @parentFk = PNNameFk
				from tblProviderName
				where PNNameFull = @nm
					and (PNNameRankFk = 35 or PNNameRankFk = 24)
					and PNNameFk is not null
			end
		end
		
		--try without authors
		if (@cnt = 0 and @parentfk is null)
		begin		
			set @pos = charindex('(', @fullName)
			if (@pos <> 0)
			begin
				set @nm = RTRIM(substring(@fullName, 0, @pos))
					
				select @cnt = count(*) from tblProviderName 
				where (PNNameFull = @nm or PNNameFull like @nm + ' %')
					and (PNNameRankFk = 35 or PNNameRankFk = 24)
					and PNNameFk is not null
				if (@cnt > 0)
				begin
					select top 1 @parentFk = PNNameFk
					from tblProviderName
					where (PNNameFull = @nm or PNNameFull like @nm + ' %')
						and (PNNameRankFk = 35 or PNNameRankFk = 24)
						and PNNameFk is not null
				end
			end
		end
	end
	else if (charindex(' lus ', @fullName) <> 0)
	begin
		set @pos = charindex(' lus ', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		
		select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 
		if (@cnt = 1)
		begin
			select @parentFk = NameGuid
			from tblName
			where NameFull = @nm and NameRankFk = 24		
		end
		
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24
			end
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 24 
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' 
				and NameRankFk = 24 
				and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' 
				and NameRankFk = 24 
				and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
	end
	else if (charindex(' f.', @fullName) <> 0)
	begin
		set @pos = charindex(' f.', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		 
		select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 
		if (@cnt = 1)
		begin
			select @parentFk = NameGuid
			from tblName
			where NameFull = @nm and NameRankFk = 24		
		end
		
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24
			end
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 24 
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
	end
	else if (charindex(' forma ', @fullName) <> 0)
	begin
		set @pos = charindex(' forma ', @fullName)
		set @nm = substring(@fullName, 0, @pos)
		 
		select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 
		if (@cnt = 1)
		begin
			select @parentFk = NameGuid
			from tblName
			where NameFull = @nm and NameRankFk = 24		
		end
		
		if (@cnt = 0 and @parentfk is null)
		begin		
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24
			end
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 24 
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
				
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		
		if (@cnt > 1)
		begin
			select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull like @nm + ' %' and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			else if (@cnt > 1)
			begin	
				--check children of multiple parent	matches to see if there is an exact match
				select @cnt = count(n.nameguid) 
				from tblName n
				inner join tblname cn on cn.nameparentfk = n.nameguid
				where n.NameCanonical = @nm and n.NameRankFk = 24
					and cn.namecanonical = @canonical 
					and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					
				if (@cnt = 1)
				begin
					select @parentFk = n.nameguid
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 24 
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
				end
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
	end
	
	return @parentFk
end
GO


GRANT EXEC ON fnGetProviderNameParentMatch TO PUBLIC

GO


