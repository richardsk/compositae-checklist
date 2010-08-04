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


GRANT EXEC ON [p_sprUpdate_FlatName_ForDescendants_002] TO PUBLIC

GO


