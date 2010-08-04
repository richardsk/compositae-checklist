IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetCorrectedAuthors')
	BEGIN
		DROP  Function  fnGetCorrectedAuthors
	END

GO

CREATE Function fnGetCorrectedAuthors
(
	@unCorrectedAuthors nvarchar(200) --of space delimited corrected author Pks
)
returns nvarchar(200) --of space delimited corrected author Pks
AS
begin

	declare @authors nvarchar(200), @pos int, @endPos int, @authPk int
		
	if (@unCorrectedAuthors is not null)
	begin
		set @authors = ''
		
		set @pos = 1
		set @endPos = charindex(' ', @unCorrectedAuthors)
		while(@endPos <> 0)
		begin
			select @authPk = CorrectAuthorFk
			from tblAuthors 
			where AuthorPk = cast(substring(@unCorrectedAuthors, @pos, @endPos - @pos) as int)
			if (@authPk is not null) set @authors = @authors + cast(@authPk as nvarchar(10)) + ' '
			
			set @pos = @endPos
			set @endPos = charindex(' ', @unCorrectedAuthors, @pos + 1)
		end

		--add last one		
		select @authPk = CorrectAuthorFk
		from tblAuthors 
		where AuthorPk = cast(substring(@unCorrectedAuthors, @pos, len(@unCorrectedAuthors)) as int)
		if (@authPk is not null) set @authors = @authors + cast(@authPk as nvarchar(10)) 
		
		set @authors = rtrim(@authors)
	end
		
	return @authors
	
end

GO


GRANT EXEC ON fnGetCorrectedAuthors TO PUBLIC

GO


