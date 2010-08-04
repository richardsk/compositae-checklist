IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Reports')
	BEGIN
		DROP  Procedure  sprSelect_Reports
	END

GO

CREATE Procedure sprSelect_Reports
(
	@forWeb bit
)
AS

	select *
	from tblReport
	where ReportIsForWeb = @forWeb

GO


GRANT EXEC ON sprSelect_Reports TO PUBLIC

GO


