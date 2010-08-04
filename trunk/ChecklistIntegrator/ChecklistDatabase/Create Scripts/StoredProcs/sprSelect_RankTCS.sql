IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RankTCS')
	BEGIN
		DROP  Procedure  sprSelect_RankTCS
	END

GO

CREATE Procedure sprSelect_RankTCS
	@rankPk int
AS

	select RankTCS
	from tblRank
	where RankPk = @rankPk

GO


GRANT EXEC ON sprSelect_RankTCS TO PUBLIC

GO


