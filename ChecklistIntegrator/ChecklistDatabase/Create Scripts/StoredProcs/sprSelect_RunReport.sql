IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_RunReport')
	BEGIN
		DROP  Procedure  sprSelect_RunReport
	END

GO

CREATE Procedure sprSelect_RunReport
	@reportPk int
AS

	declare @sql nvarchar(1000), @sp nvarchar(300)
	
	select @sp = ReportStoredProc
	from tblReport 
	where ReportPk = @reportPk
	
	set @sql = 'exec ' + @sp  --todo add params to restrict report data

	exec(@sql)
GO


GRANT EXEC ON sprSelect_RunReport TO PUBLIC

GO


