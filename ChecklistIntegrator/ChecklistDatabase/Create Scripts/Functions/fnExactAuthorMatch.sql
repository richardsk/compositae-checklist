IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnExactAuthorMatch')
	BEGIN
		DROP  Function fnExactAuthorMatch
	END

GO

CREATE Function fnExactAuthorMatch
(
	@strA nvarchar(1000),
	@strB nvarchar(1000)
)
returns int

AS
begin

	if (isnull(@strA,'') = '' or isnull(@strB,'') = '') return 99

	set @strA = replace(@strA, '  ', ' ')
	set @strB = replace(@strB, '  ', ' ')
	
	if (@strA = @strB) return 99
	
	return 0
	
end

GO


GRANT EXEC ON fnExactAuthorMatch TO PUBLIC

GO


 