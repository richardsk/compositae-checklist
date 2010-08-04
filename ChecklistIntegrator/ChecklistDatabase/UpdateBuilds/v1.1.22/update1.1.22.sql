IF not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblFlatName')
	BEGIN


	CREATE TABLE [dbo].[tblFlatName](
		  [FlatNamePk] [int] IDENTITY(1,1) NOT NULL,
		  [FlatNameNameParentUFk] [varchar](50) NULL,
		  [FlatNameNameUFk] [varchar](50) NULL,
		  [FlatNameCanonical] [nvarchar](100) NULL,
		  [FlatNameTaxonRankFk] [int] NULL,
		  [FlatNameRankName] [nvarchar](50) NULL,
		  [FlatNameNameDepth] [int] NULL,
		  [FlatNameSeedName] [varchar](50) NULL,
	 CONSTRAINT [PK_tblFlatName] PRIMARY KEY CLUSTERED
	(
		  [FlatNamePk] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]


end

GO
 
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


GRANT EXEC ON [p_sprSelect_Name_ToRoot_003] TO [compositae_user]

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'p_sprUpdate_FlatName_All_002')
	BEGIN
		DROP  Procedure  [p_sprUpdate_FlatName_All_002]
	END

GO
-- loads tblTempRanks with the ancestors of all nodes in the name table

CREATE PROCEDURE [dbo].[p_sprUpdate_FlatName_All_002]
AS


-- clear table
truncate table tblFlatName 

DECLARE @NamesGuid      uniqueidentifier

-- iterate through name table

DECLARE names_cursor   CURSOR FORWARD_ONLY FOR
SELECT  NameGuid FROM tblName
ORDER BY NameGuid


OPEN names_cursor

-- Perform the first fetch.
FETCH NEXT FROM names_cursor INTO @NamesGuid

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.

WHILE @@FETCH_STATUS = 0
      BEGIN

      --Ancestors INSERT INTO tblTempRank 
      --INSERT INTO @tblFlatName

      INSERT tblFlatName
      EXEC p_sprSelect_Name_ToRoot_003 @NamesGuid


      --PRINT @NamesId

      -- This is executed as long as the previous fetch succeeds.
      FETCH NEXT FROM names_cursor INTO @NamesGuid
      END

 

CLOSE names_cursor

DEALLOCATE names_cursor

RETURN @@ERROR



GO


GRANT EXEC ON [p_sprUpdate_FlatName_All_002] TO [Compositae_user]

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'p_sprUpdate_FlatName_ForDescendants_002')
	BEGIN
		DROP  Procedure  [p_sprUpdate_FlatName_ForDescendants_002]
	END

GO
 

-- breath first walk of descendant tree

CREATE PROCEDURE [dbo].[p_sprUpdate_FlatName_ForDescendants_002]

      @NameGuid         uniqueidentifier = NULL
      --,@CancelQuery   uniqueidentifier = null

AS

      /* SET NOCOUNT ON */
      -- table to store all descendants

      DECLARE @tblNameList    table(NameGuid    uniqueidentifier, Done  bit)
 

      -- Get Children of initial node and place them in a list

      INSERT INTO @tblNameList
      SELECT NameGuid, 0
      FROM tblName
      WHERE NameParentFk = @NameGuid


      -- Get a count of all those in the list that have not being done
      DECLARE @intNotDoneCount      int
      SELECT @intNotDoneCount = Count(*) FROM @tblNameList WHERE Done = 0


      WHILE @intNotDoneCount > 0 --AND dbo.IsCancelRequested(@CancelQuery) = 0
            BEGIN

            -- get next key
            DECLARE @CurrentGuid    uniqueidentifier

            SELECT top 1 @CurrentGuid  = NameGuid
            FROM @tblNameList
            WHERE Done = 0


            DELETE tblFlatName
            WHERE FlatNameSeedName = @CurrentGuid


            --INSERT INTO @tblFlatName
            INSERT tblFlatName
            EXEC p_sprSelect_Name_ToRoot_003 @CurrentGuid


            -- show this node has being done

            UPDATE @tblNameList
            SET Done = 1
            WHERE NameGuid = @CurrentGuid


            -- Get Children of this node and place them in a list

            INSERT INTO @tblNameList
            SELECT NameGuid, 0
            FROM tblName
            WHERE NameParentFk = @CurrentGuid
            AND NOT NameGuid IN (SELECT l.NameGuid FROM @tblNameList l)

            -- Get a count of all those in the list that have not being done
            SELECT @intNotDoneCount = Count(*) FROM @tblNameList WHERE Done = 0

            END

      RETURN @@ERROR

 
GO


GRANT EXEC ON [p_sprUpdate_FlatName_ForDescendants_002] TO [Compositae_User]

GO




 
 
 exec [p_sprUpdate_FlatName_All_002]
 
 
 