IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnPartialAuthorTextMatch')
	BEGIN
		DROP  Function fnPartialAuthorTextMatch
	END

GO

CREATE Function fnPartialAuthorTextMatch
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS
begin

	declare @lenA int, @lenB int, @pos int
	
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
	
	set @strA = replace(@strA, ' et ', ' & ')
	set @strB = replace(@strB, ' et ', ' & ')
	
	if (charindex(' ex ', @strA) <> 0 or charindex(' ex ', @strB) <> 0)
	begin
		set @pos = charindex(' ex ', @strA)
		if (@pos <> 0) set @strA = substring(@strA, @pos + 4, len(@strA))
		
		set @pos = charindex(' ex ', @strB)
		if (@pos <> 0) set @strB = substring(@strB, @pos + 4, len(@strB))
	end
	
	if (@strA = @strB) return 100
	
	return dbo.fnLevenshteinPercentage(@strA, @strB)
		
end

GO


GRANT EXEC ON fnPartialAuthorTextMatch TO PUBLIC

GO


   