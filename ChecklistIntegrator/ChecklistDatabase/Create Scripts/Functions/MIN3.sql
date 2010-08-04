IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'MIN3')
	BEGIN
		DROP  Function MIN3
	END

GO

CREATE Function MIN3( @val1 int, @val2 int, @val3 int )
returns int
AS

begin

	if (@val1 < @val2 and @val1 < @val3) return @val1
	if (@val2 < @val1 and @val2 < @val3) return @val2
	return @val3
end

GO


GRANT EXEC ON MIN3 TO PUBLIC

GO


