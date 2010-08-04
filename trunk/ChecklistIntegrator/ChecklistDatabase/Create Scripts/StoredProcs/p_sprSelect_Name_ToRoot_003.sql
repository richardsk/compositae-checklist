IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'p_sprSelect_Name_ToRoot_003')
	BEGIN
		DROP  Procedure  [p_sprSelect_Name_ToRoot_003]
	END

GO

CREATE PROCEDURE [dbo].[p_sprSelect_Name_ToRoot_003]
      @StartNameGuid          uniqueidentifier

AS

      SET NOCOUNT ON
      DECLARE @tableResults   TABLE(NameGuid uniqueidentifier, NameLevel int )
      DECLARE @ParentGuid           uniqueidentifier
      DECLARE @NameGuid       uniqueidentifier
      DECLARE @intCount       int
      DECLARE @GrandParent    uniqueidentifier

      DECLARE @intLevel       int


      SELECT @ParentGuid = NameParentFk, @NameGuid = NameGuid
      FROM         tblName
      WHERE NameGuid = @StartNameGuid


      SET @intLevel = 0

      SELECT @intCount = COUNT(*) FROM @tableResults WHERE NameGuid = @ParentGuid

      WHILE @intCount < 1
      AND (NOT @NameGuid IS NULL)
      BEGIN


            INSERT INTO @tableResults VALUES(@NameGuid, @intLevel)
            SELECT @GrandParent = NameParentFk
            FROM         tblName
            WHERE NameGuid = @ParentGuid


            SET @NameGuid = @ParentGuid
            SET @ParentGuid = @GrandParent

            SET @intLevel = @intLevel + 1
            
            SELECT @intCount = COUNT(*) FROM @tableResults WHERE NameGuid = @NameGuid

      END


      SELECT
            a.NameParentFk AS FlatNameNameParentFk,
            cast(a.NameGuid as varchar(38)) AS FlatNameNameFk,
            a.NameCanonical AS FlatNameCanonical,
            tr.RankPk AS FlatNameTaxonRankFk,
            tr.RankName AS FlatNameRankName,
            b.NameLevel AS FlatNameNameDepth, 
            cast(@StartNameGuid as varchar(38)) as FlatNameSeedName
      FROM  @tableResults b JOIN tblName a ON a.NameGuid = b.NameGuid
            LEFT JOIN tblRank tr ON a.NameRankFk = tr.RankPk
      ORDER BY b.NameLevel DESC


      RETURN @@error

 
GO


GRANT EXEC ON [p_sprSelect_Name_ToRoot_003] TO PUBLIC

GO


