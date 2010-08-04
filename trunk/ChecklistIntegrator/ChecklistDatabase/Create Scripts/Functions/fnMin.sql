 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnMin')
	BEGIN
		DROP  Function fnMin
	END

GO

CREATE Function fnMin
(
	@num1 int,
	@num2 int
)
returns int

AS
begin
	if (@num1 < @num2) return @num1
	return @num2
end

GO


GRANT EXEC ON fnMin TO PUBLIC

GO


 