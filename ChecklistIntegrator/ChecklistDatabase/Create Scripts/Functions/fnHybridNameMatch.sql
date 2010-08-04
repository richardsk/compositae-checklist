IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnHybridNameMatch')
	BEGIN
		DROP  Function fnHybridNameMatch
	END

GO

CREATE Function fnHybridNameMatch
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS
begin

	declare @strX nvarchar(1000), @strY nvarchar(1000), @strT nvarchar(1000), @strU nvarchar(1000)
	declare @strTmp nvarchar(1000)
	
	set @strT = replace(@strA, '  ', ' ')
	
	set @strX = '@' + ltrim(rtrim(replace(@strA, '×', '')))
	set @strX = @strX + '@' + ltrim(rtrim(replace(@strA, ' x ', '')))
	
	if (substring(@strT, 0, 1) = 'x')
	begin
		if (ascii(@strT) = ascii('x')) 
		begin
			set @strX = @strX + '@' + rtrim(substring(@strT, 2, len(@strT)))
		end
		else
		begin
			set @strTmp = replace(substring(@strT, 1, 3), ' ', '')
			set @strTmp = substring(@strTmp, 2, 1)
			if (ascii(@strTmp) = ascii(upper(@strTmp)))
			begin
				--2 capital letters - assume hybrid
				set @strX = @strX + '@' + rtrim(substring(@strT, 2, len(@strT)))
			end
		end
	end
		
	set @strX = @strx + '@'
	
	set @strY = replace(@strB, '  ', ' ')
	
	set @strU = '@' + ltrim(rtrim(replace(@strB, '×', '')))	
	if (charindex(@strU, @strX) <> 0) goto MatchExit
	set @strU = '@' + ltrim(rtrim(replace(@strB, ' x ', '')))
	if (charindex(@strU, @strX) <> 0) goto MatchExit
	
	if (substring(@strY, 0, 1) = 'x')
	begin
		if (ascii(@strY) = ascii('x')) 
		begin
			set @strU = '@' + rtrim(substring(@strY, 2, len(@strY)))
			if (charindex(@strU, @strX) <> 0) goto MatchExit
		end
		else
		begin
			set @strTmp = replace(substring(@strY, 1, 3), ' ', '')
			set @strTmp = substring(@strTmp, 2, 1)
			if (ascii(@strTmp) = ascii(upper(@strTmp)))
			begin
				--2 capital letters - assume hybrid
				set @strU = '@' + rtrim(substring(@strY, 2, len(@strY)))
				if (charindex(@strU, @strX) <> 0) goto MatchExit
			end
		end
	end
	
	return 0
	
	MatchExit:
	
	return 100
	
end

GO


GRANT EXEC ON fnHybridNameMatch TO PUBLIC

GO


   