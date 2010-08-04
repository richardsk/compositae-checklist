IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FieldStatusIdentifiers')
	BEGIN
		DROP  Procedure  sprSelect_FieldStatusIdentifiers
	END

GO

CREATE PROCEDURE dbo.sprSelect_FieldStatusIdentifiers

AS
	/* SET NOCOUNT ON */
	
	SELECT * 
	FROM tblFieldStatusIdentifier
	ORDER BY FieldStatusIdentifierGroup, FieldStatusIdentifierFieldName
	
	RETURN @@ERROR


GO

