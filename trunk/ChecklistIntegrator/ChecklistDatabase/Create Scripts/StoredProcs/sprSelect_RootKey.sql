 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RootKey')
	BEGIN
		PRINT 'Dropping Procedure sprSelect_RootKey'
		DROP  Procedure  sprSelect_RootKey
	END

GO

PRINT 'Creating Procedure sprSelect_RootKey'
GO
CREATE Procedure dbo.sprSelect_RootKey
AS

/******************************************************************************
**		File: 
**		Name: sprSelect_RootKey
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/

select cast(NameGuid as varchar(38)) from tblName where NameFull = 'ROOT'


GO

GRANT EXEC ON sprSelect_RootKey TO PUBLIC

GO
