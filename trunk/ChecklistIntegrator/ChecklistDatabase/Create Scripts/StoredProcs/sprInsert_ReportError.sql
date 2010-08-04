 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ReportError')
	BEGIN
		DROP  Procedure  sprInsert_ReportError
	END

GO

CREATE Procedure sprInsert_ReportError
	@reportFk int,
	@tableName nvarchar(100),
	@recordId nvarchar(300),
	@statusFk int,
	@comment nvarchar(4000)
AS

	insert tblReportError
	select @tableName, 
		@recordId,
		@reportFk,
		@statusFk,
		@comment

GO

	

GRANT EXEC ON sprInsert_ReportError TO PUBLIC

GO


