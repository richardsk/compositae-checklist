IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportMultipleParentMatches')
	BEGIN
		DROP  Procedure  sprSelect_ReportMultipleParentMatches
	END

GO

CREATE Procedure sprSelect_ReportMultipleParentMatches

AS

	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select cast(PNPk as varchar(300)), PNNameFull, 'ProviderName', 'tblProviderName'
	from vwProviderName
	where PNNameFk is null and PNLinkStatus = 'MultipleParent'
		
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportMultipleParentMatches TO PUBLIC

GO


