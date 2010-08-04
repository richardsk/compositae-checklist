IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetAuthorIds')
	BEGIN
		DROP  Function  fnGetAuthorIds
	END

GO

CREATE Function fnGetAuthorIds
(
	@authors nvarchar(300)
)
returns nvarchar(100) --of author ids
AS
begin
	
	--select all author ids where they match the authors
	-- eg where Smith = 1, Jones = 2, Smth = 3 but correct id = 1
	--   Smith = '1'
	--   Smith & Jones = '1 2'
	--   Smith ex Jones = '2'
	--   Smth & Jones = '1 2'
		
	@authorId int
		
	
	--linking table for authors, seq, isOriginalorcorrected
	
	--use basionym author and combin. author
	
	--abbrev field
	
	--remove 'in citation', 'ex' etc
	
	--not found insert into author table
	
	
	
end

GO


GRANT EXEC ON fnGetAuthorIds TO PUBLIC

GO


