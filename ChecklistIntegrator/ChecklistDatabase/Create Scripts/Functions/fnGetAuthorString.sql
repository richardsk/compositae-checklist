IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetAuthorString')
	BEGIN
		DROP  Function  fnGetAuthorString
	END

GO

CREATE Function fnGetAuthorString
(
	@basAuthors nvarchar(200), -- space delimited corrected author Pks
	@combAuthors nvarchar(200), -- space delimited corrected author Pks
	@fullAuthors bit -- whether result is full authors (ie brackets around basionym authors)
)
returns nvarchar(300)
AS
begin

	declare @authors nvarchar(300)	
	set @authors = ''
			
	declare @correctCombAuth nvarchar(100), @correctBasAuth nvarchar(100), @pos int, @endPos int
	declare @authPk int, @delim nvarchar(10)
	set @delim = ''
	
	if (@combAuthors is not null)
	begin
		set @correctCombAuth = ''
		
		set @pos = 1
		set @endPos = charindex(' ', @combAuthors)
		while(@endPos <> 0)
		begin
			set @authPk = cast(substring(@combAuthors, @pos, @endPos - @pos) as int)
			if (@authPk is not null) 
			begin
				select @correctCombAuth = @correctCombAuth + @delim + Abbreviation 
				from tblAuthors where AuthorPk = @authPk
				
				set @delim = ', '
			end	
			
			set @pos = @endPos
			set @endPos = charindex(' ', @combAuthors, @pos + 1)
		end

		--add last one		
		select @authPk = cast(substring(@combAuthors, @pos, len(@combAuthors)) as int)
		if (@authPk is not null) 
		begin
			if (len(@correctCombAuth) > 0) set @correctCombAuth = @correctCombAuth + ' & '
			
			select @correctCombAuth = @correctCombAuth + Abbreviation 
				from tblAuthors where AuthorPk = @authPk
		end
		
		set @correctCombAuth = rtrim(@correctCombAuth)
	end
	
	if (@basAuthors is not null)
	begin
		set @correctBasAuth = ''
		
		set @pos = 1
		set @endPos = charindex(' ', @basAuthors)
		while(@endPos <> 0)
		begin
			set @authPk = cast(substring(@basAuthors, @pos, @endPos - @pos) as int)
			if (@authPk is not null) 
			begin
				select @correctBasAuth = @correctBasAuth + @delim + Abbreviation 
				from tblAuthors where AuthorPk = @authPk
				
				set @delim = ', '
			end	
			
			set @pos = @endPos
			set @endPos = charindex(' ', @basAuthors, @pos + 1)
		end

		--add last one		
		select @authPk = cast(substring(@basAuthors, @pos, len(@basAuthors)) as int)
		if (@authPk is not null) 
		begin
			if (len(@correctBasAuth) > 0) set @correctBasAuth = @correctBasAuth + ' & '
			select @correctBasAuth = @correctBasAuth + Abbreviation 
				from tblAuthors where AuthorPk = @authPk
		end 
		
		set @correctBasAuth = rtrim(@correctBasAuth)
	end
	
			
	set @authors = ''
	if (@correctBasAuth is not null or @correctCombAuth is not null)
	begin
		if (@correctBasAuth is not null and len(@correctBasAuth) > 0)
		begin
			if (@fullAuthors = 1) set @authors = '(' + @correctBasAuth + ')'
			else set @authors = @correctBasAuth 
			if (@correctCombAuth is not null and len(@CorrectCombAuth) > 0) set @authors = @authors + ' '			
		end
		
		if (@correctCombAuth is not null and len(@correctCombAuth) > 0) 
		begin
			set @authors = @authors + @correctCombAuth
		end
	end	
	
	if (len(@authors) = 0) set @authors = null
	
	return @authors

end

GO


GRANT EXEC ON fnGetAuthorString TO PUBLIC

GO


