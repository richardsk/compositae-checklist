IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Ranks')
	BEGIN
		DROP  Procedure  sprSelect_Ranks
	END

GO

CREATE Procedure sprSelect_Ranks
	
AS

	select * from tblRank
	order by RankSort

GO


GRANT EXEC ON sprSelect_Ranks TO PUBLIC

GO


