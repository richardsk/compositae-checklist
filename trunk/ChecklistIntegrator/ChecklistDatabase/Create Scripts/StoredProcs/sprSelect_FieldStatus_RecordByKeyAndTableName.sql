IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FieldStatus_RecordByKeyAndTableName')
	BEGIN
		DROP  Procedure  sprSelect_FieldStatus_RecordByKeyAndTableName
	END

GO

CREATE PROCEDURE dbo.sprSelect_FieldStatus_RecordByKeyAndTableName

@FieldStatusRecordFK				varchar(50),
@FieldStatusIdentifierTableName		varchar(50)

AS
	/* SET NOCOUNT ON */
	
	SELECT fs.FieldStatusCreatedBy as AddedBy,
        fs.FieldStatusCreatedDate as FieldStatusAddedDate,
        fs.FieldStatusComment,
        fs.FieldStatusCounterPK,
        fs.FieldStatusIdentifierFK,
        fs.FieldStatusLevelFK,
        FieldStatusRecordFk,
        fs.FieldStatusUpdatedDate,
        fs.FieldStatusUpdatedBy as UpdatedBy,
        fsi.*, 
        fsl.*        
	FROM tblFieldStatus fs
	LEFT JOIN tblFieldStatusIdentifier fsi ON fs.FieldStatusIdentifierFK = fsi.FieldStatusIdentifierCounterPK
	LEFT JOIN tblFieldStatusLevel fsl ON fs.FieldStatusLevelFK = fsl.FieldStatusLevelCounterPK
	WHERE FieldStatusRecordFK = @FieldStatusRecordFK
	AND fsi.FieldStatusIdentifierTableName = @FieldStatusIdentifierTableName
	
	RETURN @@ERROR


GO

