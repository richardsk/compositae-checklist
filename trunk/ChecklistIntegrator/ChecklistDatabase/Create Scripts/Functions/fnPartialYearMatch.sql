IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnPartialYearMatch')
	BEGIN
		DROP  Function fnPartialYearMatch
	END

GO

CREATE Function fnPartialYearMatch
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS
begin

	declare @lenA int, @lenB int, @pos int, @endPos int, @replace varchar(50)
	
	set @pos = charindex('  ', @strA)
	while (@pos > 0)
	begin
		set @strA = replace(@strA, '  ', ' ')
		set @pos = charindex('  ', @strA)
	end
	
	set @pos = charindex('  ', @strB)
	while (@pos > 0)
	begin
		set @strB = replace(@strB, '  ', ' ')
		set @pos = charindex('  ', @strB)
	end
	
	if (@strA = @strB) return 100
	
	
	set @strA = replace(@strA, '?', '')
	set @strB = replace(@strB, '?', '')
	
	if (@strA = @strB) return 100
	
	
	if (charindex('[', @strA) <> 0 )
	begin
		set @pos = charindex('[', @strA)
		set @endPos = charindex(']', @strA, @pos)
		if @endPos = 0 set @endPos = len(@strA)
		set @replace = substring(@strA, @pos, @endPos - @pos+1)
		
		set @strA = replace(@strA, @replace, '')
	end
	
	if (charindex('[', @strB) <> 0 )
	begin
		set @pos = charindex('[', @strB)
		set @endPos = charindex(']', @strB, @pos)
		if @endPos = 0 set @endPos = len(@strB)
		set @replace = substring(@strB, @pos, @endPos - @pos +1)
		
		set @strB = replace(@strB, @replace, '')
	end
	
	if (@strA = @strB) return 100
	
	
	if (charindex('"', @strA) <> 0 )
	begin
		set @pos = charindex('"', @strA)
		set @endPos = charindex('"', @strA, @pos+1)
		if @endPos = 0 set @endPos = len(@strA)
		set @replace = substring(@strA, @pos, @endPos - @pos+1)
		
		set @strA = replace(@strA, @replace, '')
	end
	
	if (charindex('"', @strB) <> 0 )
	begin
		set @pos = charindex('"', @strB)
		set @endPos = charindex('"', @strB, @pos+1)
		if @endPos = 0 set @endPos = len(@strB)
		set @replace = substring(@strB, @pos, @endPos - @pos+1)
		
		set @strB = replace(@strB, @replace, '')
	end
		
	if (@strA = @strB) return 100
	
	if (isdate(@strA) = 1 and isdate(@strB) = 1)
	begin
		if (datediff(year, cast(@strA as datetime), cast(@strB as datetime)) < 2) return 95		
	end
	
		
	return 0
end

GO


GRANT EXEC ON fnPartialYearMatch TO PUBLIC

GO


   