IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnLevenshteinPercentage')
	BEGIN
		DROP  Function fnLevenshteinPercentage
	END

GO

CREATE Function fnLevenshteinPercentage
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS

begin

	declare @max int, @lev int
	
	if (isnull(@strA,'') = '' or isnull(@strB,'') = '') return 0
	
	set @max = dbo.fnMax(len(@strA), len(@strB))
	set @lev = dbo.fnLevenshteinDistance(@strA, @strB)
	
	return 100 - (@lev * 100 / @max)
end

GO


GRANT EXEC ON fnLevenshteinPercentage TO PUBLIC

GO


