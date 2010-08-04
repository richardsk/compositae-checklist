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


GRANT EXEC ON [p_sprUpdate_FlatName_All_002] TO PUBLIC

GO


