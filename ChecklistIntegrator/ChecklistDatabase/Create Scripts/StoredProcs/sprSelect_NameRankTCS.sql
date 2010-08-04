IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameRankTCS')
	BEGIN
		DROP  Procedure  sprSelect_NameRankTCS
	END

GO

CREATE Procedure sprSelect_NameRankTCS
	@nameGuid uniqueidentifier
AS

	select RankTCS
	from tblName
	inner join tblRank on RankPk = NameRankFk
	where NameGuid = @nameGuid

GO


GRANT EXEC ON sprSelect_NameRankTCS TO PUBLIC

GO


