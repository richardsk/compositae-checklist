IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportLowMatchScores')
	BEGIN
		DROP  Procedure  sprSelect_ReportLowMatchScores
	END

GO

CREATE Procedure sprSelect_ReportLowMatchScores
	
AS
	declare @minScore int, @maxScore int
	set @minScore = 85
	--set @maxScore = 90

	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select cast(PNPk as varchar(300)), PNNameFull, 'ProviderName', 'tblProviderName'
	from vwProviderName
	where PNNameFk is not null and PNNameMatchScore < @minScore --and PNNameMatchScore > @minScore
			
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportLowMatchScores TO PUBLIC

GO


