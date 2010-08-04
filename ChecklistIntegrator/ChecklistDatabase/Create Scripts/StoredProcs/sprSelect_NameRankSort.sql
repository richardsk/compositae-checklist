IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameRankSort')
	BEGIN
		DROP  Procedure  sprSelect_NameRankSort
	END

GO

CREATE Procedure sprSelect_NameRankSort
	@nameGuid uniqueidentifier
AS

	select RankSort
	from tblName
	inner join tblRank on RankPk = NameRankFk
	where NameGuid = @nameGuid

GO


GRANT EXEC ON sprSelect_NameRankSort TO PUBLIC

GO


