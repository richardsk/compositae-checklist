IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnMax')
	BEGIN
		DROP  Function fnMax
	END

GO

CREATE Function fnMax
(
	@num1 int,
	@num2 int
)
returns int

AS
begin
	if (@num1 > @num2) return @num1
	return @num2
end

GO


GRANT EXEC ON fnMax TO PUBLIC

GO


 