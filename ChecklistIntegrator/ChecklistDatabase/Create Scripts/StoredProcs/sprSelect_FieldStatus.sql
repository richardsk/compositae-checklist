IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FieldStatus')
	BEGIN
		DROP  Procedure  sprSelect_FieldStatus
	END

GO

CREATE PROCEDURE dbo.sprSelect_FieldStatus

@FieldStatusCounterPK int

AS
	/* SET NOCOUNT ON */
	
	SELECT fs.*, fsi.*, fsl.*,
		fs.FieldStatusCreatedBy as AddedBy,
		fs.FieldStatusCreatedDate as FieldStatusAddedDate,
		fs.FieldStatusUpdatedBy as UpdatedBy
	FROM tblFieldStatus fs
	LEFT JOIN tblFieldStatusIdentifier fsi ON fs.FieldStatusIdentifierFK = fsi.FieldStatusIdentifierCounterPK
	LEFT JOIN tblFieldStatusLevel fsl ON fs.FieldStatusLevelFK = fsl.FieldStatusLevelCounterPK
	WHERE FieldStatusCounterPK = @FieldStatusCounterPK
	
	RETURN @@ERROR


GO

