IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RankSort')
	BEGIN
		DROP  Procedure  sprSelect_RankSort
	END

GO

CREATE Procedure sprSelect_RankSort
	@rankPk int
AS

	select RankSort
	from tblRank 
	where RankPk = @rankPk

GO


GRANT EXEC ON sprSelect_RankSort TO PUBLIC

GO


