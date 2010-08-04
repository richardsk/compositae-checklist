IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Report')
	BEGIN
		DROP  Procedure  sprSelect_Report
	END

GO

CREATE Procedure sprSelect_Report
(
	@reportPk int
)
AS

	select * from tblReport
	where ReportPk = @reportPk

GO


GRANT EXEC ON sprSelect_Report TO PUBLIC

GO


