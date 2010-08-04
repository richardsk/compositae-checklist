IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLevenshteinDistanceWords')
	BEGIN
		DROP  Function fnLevenshteinDistanceWords
	END

GO

CREATE Function fnLevenshteinDistanceWords
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS
begin

	declare @i int, @j int, @loc int, @pos int, @lenA int, @lenB int, @count int, @endPos int
	
	set @strA = replace(@strA, '  ', ' ')
	set @strB = replace(@strB, '  ', ' ')
	
	if (isnull(@strA,'') = '' or isnull(@strB,'') = '') return len(@strA) + len(@strB)
	
	select @lenA = dbo.fnWordCount(@strA) + 1 
	select @lenB = dbo.fnWordCount(@strB) + 1
	
	--table representing double array, eg position 2,5 in array is row number 2*5 = 10
	declare @d table(counter int identity(0,1), val int)
	declare @AW table(counter int identity, val nvarchar(1000))
	declare @BW table(counter int identity, val nvarchar(1000))
	
	set @pos = 1
	set @endPos = charindex(' ', @strA)
	while (@pos <> 0)
	begin
		set @endPos = charindex(' ', @strA, @pos + 1)
		if (@endPos = 0) 
		begin
			insert @AW select substring(@strA, @pos, len(@strA)) 			
		end
		else 
		begin
			insert @AW select substring(@strA, @pos, @endPos - @pos)
		end
		if (@endPos = 0) set @pos = 0
		else set @pos = @endPos + 1
	end
	
	set @pos = 1
	set @endPos = charindex(' ', @strB)
	while (@pos <> 0)
	begin
		set @endPos = charindex(' ', @strB, @pos + 1)
		if (@endPos = 0) 
		begin
			insert @BW select substring(@strB, @pos, len(@strB)) 			
		end
		else 
		begin
			insert @BW select substring(@strB, @pos, @endPos - @pos)
		end
		if (@endPos = 0) set @pos = 0
		else set @pos = @endPos + 1
	end
	
	declare @insert_penalty int, @delete_penalty int, @subs_penalty int
	set @insert_penalty = 1
	set @delete_penalty = 1
	set @subs_penalty = 1
	
	--set up table/array
	set @pos = 0
	while (@pos <= ((@lenA) * @lenB))
	begin
		insert @d select 0
		set @pos = @pos +1
	end
	-- now element x,y = (x * @lenA) + y
	
	set @pos = 0
	while (@pos < @lenB)
	begin
		set @loc = (@pos * @lenA) -- + 0
		update @d set val = @pos where counter = @loc
		set @pos = @pos + 1
	end
	
	set @pos = 0
	while (@pos < @lenA)
	begin
		set @loc = @pos -- (0 * @lenA) + @pos
		update @d set val = @pos where counter = @loc
		set @pos = @pos + 1
	end
	
	declare @LA nvarchar(1000)
	declare @LB nvarchar(1000)
	declare @cost int
	declare @cost1 int, @cost2 int, @cost3 int
	declare @posB int
	
	set @pos = 1
	while (@pos < @lenA)
	begin
		select @LA = val from @AW where counter = @pos
		
		set @posB = 1
		while (@posB < @lenB)
		begin
			select @LB = val from @BW where counter = @posB
						
			if (@LA = @LB) set @cost = 0
			else set @cost = @subs_penalty
						
			set @loc = ((@posB - 1) * @lenA) + @pos
			select @cost1 = val + @insert_penalty
			from @d where counter = @loc
			set @loc = (@posB * @lenA) + @pos - 1
			select @cost2 = val + @delete_penalty
			from @d where counter = @loc
			set @loc = ((@posB - 1) * @lenA) + @pos - 1
			select @cost3 = val + @cost
			from @d where counter = @loc
			
			update @d set val = dbo.fnMin( dbo.fnMin( @cost1, @cost2 ), @cost3 )
			where counter = ((@posB * @lenA) + @pos)
			
			set @posB = @posB + 1
		end
		
		set @pos = @pos + 1
	end
	
	declare @result int
	
	select @result = val from @d where counter = ((@lenA * @lenB) - 1)
	
	return @result
end

GO


GRANT EXEC ON fnLevenshteinDistanceWords TO PUBLIC

GO


  