if not exists(select * from tblReport where ReportName = 'Phantom Names')
begin
	insert tblreport
	select 'Phantom Names', 'Find all names where their parent does not exist, and therefore cannot be displayed in the tree.', 'sprSelect_ReportPhantoms', 'PhantomNamesReport.xslt', 0
end

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportPhantoms')
	BEGIN
		DROP  Procedure  sprSelect_ReportPhantoms
	END

GO

CREATE Procedure sprSelect_ReportPhantoms
	
AS

	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res	
	select cast(n.NameGuid as varchar(300)), 'Provider count: ' + cast(count(pnpk) as varchar(100)) +
		'; Child count: ' + cast(count(cn.nameguid) as varchar(100)) + '; FullName : ' + isnull(n.NameFull, '[null]'),
		'Name', 'tblName'
	from tblName n
	left join tblName pn on pn.NameGUID = n.NameParentFk
	left join tblProviderName on PNNameFk = n.NameGUID
	left join tblName cn on cn.NameParentFk = n.NameGUID
	where (pn.NameGUID is null or pn.nameguid = n.nameguid) and (n.NameFull is null or n.NameFull <> 'root')
	group by n.NameFull, n.NameGUID
	order by n.namefull
	
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordDetails

GO


GRANT EXEC ON sprSelect_ReportPhantoms TO PUBLIC

GO


  