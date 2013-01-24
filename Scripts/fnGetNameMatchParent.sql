 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetNameParentMatch')
	BEGIN
		DROP  Function  fnGetNameParentMatch
	END

GO

CREATE Function fnGetNameParentMatch
(
	@nameGuid uniqueidentifier
)
returns uniqueidentifier
as
begin

	declare @parentFk uniqueidentifier, @pos int, @nm nvarchar(300)
	declare @rankPk int, @fullName nvarchar(300), @canonical nvarchar(300), @rankSort int, @rnk nvarchar(100)
	declare @highNameId uniqueidentifier, @cnt int, @auth nvarchar(1000)
	declare @genNameId uniqueidentifier
	
	--find parent based on rank and full name
	-- if multiple matches then we cant choose between them so fail
	
	select @rankSort = RankSort, @rnk = RankName, @rankPk = NameRankFk, 
		@canonical = NameCanonical, @fullname = NameFull,
		@auth = nameauthors
	from tblName
	inner join tblRank on RankPk = NameRankFk
	where NameGuid = @nameGuid
	
	select @highNameId = ProviderImportHigherNameId, 
		@genNameId = ProviderImportGenusNameId		
	from tblProviderImport
	inner join tblProvider on providerpk = providerimportproviderfk
	where ProviderName = 'SYSTEM'
		
		
	if (@rankSort = 400)
	begin
		select @parentFk = NameGuid from tblName where NameFull = 'ROOT'
	end
	else if (@rankSort <= 2000) --family or above, use higher name id
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
	end
	else if (@rankSort = 4400) --subspecies
	begin
		set @pos = charindex(' subsp', @fullName)
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
			select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull = @nm and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
			end
			
			if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
		end 
	end
	else if (@rankSort = 4600) --variety
	begin
		if (charindex(' subsp', @fullName) <> 0)
		begin		
			set @pos = charindex(' var', @fullName)
			set @nm = substring(@fullName, 0, @pos)
			
			select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 35
			if (@cnt = 1)
			begin
				select @parentFk = NameGuid
				from tblName
				where NameFull = @nm and NameRankFk = 35
			end
			
			if (@cnt = 0 and @parentfk is null)
			begin		
				select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 35 
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull like @nm + ' %' and NameRankFk = 35
				end
				if (@cnt > 1)
				begin
					select @cnt = count(*) from tblName where NameFull like @nm + ' %' and NameRankFk = 35 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
					if (@cnt = 1)
					begin
						select @parentFk = NameGuid
						from tblName
						where NameFull like @nm + ' %' and NameRankFk = 35 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
					end
					
					if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
				end 
			end
			
			if (@cnt > 1)
			begin
				select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 35 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull = @nm and NameRankFk = 35 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				end
				else if (@cnt > 1)
				begin	
					--check children of multiple parent	matches to see if there is an exact match
					select @cnt = count(n.nameguid) 
					from tblName n
					inner join tblname cn on cn.nameparentfk = n.nameguid
					where n.NameCanonical = @nm and n.NameRankFk = 35
						and cn.namecanonical = @canonical 
						and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
						
					if (@cnt = 1)
					begin
						select @parentFk = n.nameguid
						from tblName n
						inner join tblname cn on cn.nameparentfk = n.nameguid
						where n.NameCanonical = @nm and n.NameRankFk = 35
							and cn.namecanonical = @canonical 
							and isnull(cn.nameauthors,isnull(@auth,'')) = isnull(@auth,'')
					end
				end
								
				if (@cnt > 1) set @parentFk = '00000000-0000-0000-0000-000000000000'
			end 
		end
		else
		begin
			set @pos = charindex(' var', @fullName)
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
				select @cnt = count(*) from tblName where NameFull = @nm and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
				if (@cnt = 1)
				begin
					select @parentFk = NameGuid
					from tblName
					where NameFull = @nm and NameRankFk = 24 and isnull(NameInvalid, 0) = 0 and isnull(NameIllegitimate, 0) = 0
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
	end
	
	return @parentFk
end
GO


GRANT EXEC ON fnGetNameParentMatch TO PUBLIC

GO


