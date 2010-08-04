IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportNoParent')
	BEGIN
		DROP  Procedure  sprSelect_ReportNoParent
	END

GO

CREATE Procedure sprSelect_ReportNoParent
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select cast(NameGuid as varchar(300)), NameFull + ' [Parent = ' + NameParent + ']', 'Name', 'tblName'
	from tblName
	where NameParentFk is null and namefull <> 'root'
	order by namefull
			
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordDetails

GO


GRANT EXEC ON sprSelect_ReportNoParent TO PUBLIC

GO


 