 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnWordCount')
	BEGIN
		DROP  Function fnWordCount
	END

GO

CREATE Function fnWordCount
(
	@text nvarchar(4000)
)
returns int

AS
begin
	
	if (isnull(@text, '') = '') return 0
	
	set @text = replace(@text, '  ', ' ')
	
	if (@text = '') return 0
	
	declare @words int, @pos int
	set @words = 1
	set @pos = charindex(' ', @text)
	while (@pos <> 0)
	begin
		set @words = @words + 1
		set @pos = charindex(' ', @text, @pos + 1)
	end
	
	return @words
end

GO


GRANT EXEC ON fnWordCount TO PUBLIC

GO 