IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLevenshteinPercentWords')
	BEGIN
		DROP  Function fnLevenshteinPercentWords
	END

GO

CREATE Function fnLevenshteinPercentWords
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS

begin

	declare @max int, @lev int, @a nvarchar(1000), @b nvarchar(1000)
	
	set @a = replace(@strA, '  ', ' ')
	set @b = replace(@strB, '  ', ' ')
	
	if (isnull(@a,'') = '' or isnull(@b,'') = '') return 0
	
	set @max = dbo.fnMax( dbo.fnWordCount(@a), dbo.fnWordCount(@b) )
	set @lev = dbo.fnLevenshteinDistanceWords(@a, @b)
	
	return 100 - (@lev * 100 / @max)
end

GO


GRANT EXEC ON fnLevenshteinPercentWords TO PUBLIC

GO


 