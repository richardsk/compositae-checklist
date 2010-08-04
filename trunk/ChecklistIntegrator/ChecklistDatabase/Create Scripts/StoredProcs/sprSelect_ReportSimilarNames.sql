IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportSimilarNames')
	BEGIN
		DROP  Procedure  sprSelect_ReportSimilarNames
	END

GO

CREATE Procedure sprSelect_ReportSimilarNames
	
AS
	
	declare @unknown uniqueidentifier
	declare @distRows table(ids varchar(76), namefull nvarchar(300), id1 uniqueidentifier, id2 uniqueidentifier)
	
	select @unknown = nameguid from tblname where namefull = 'Unknown'
	
	insert into @distRows
	select distinct top 1000 
		case when n.nameguid < an.nameguid then cast(n.nameguid as char(38)) + cast(an.nameguid as char(38))
		else cast(an.nameguid as char(38)) + cast(n.nameguid as char(38)) end,
		case when n.nameguid < an.nameguid then n.namefull
		else an.namefull end as nf,
		null, null
	from tblname n
	inner join tblname an on an.namecanonical = n.namecanonical and n.nameguid <> an.nameguid and n.namerankfk = an.namerankfk
	where n.nameparentfk <> @unknown and (an.nameparentfk = n.nameparentfk or n.namerankfk = 8) --exception for genus - show similar names even if diff parents
	order by nf
		
	update @distRows
	set id1 = cast(substring(ids, 1, 38) as uniqueidentifier), id2 = cast(substring(ids, 39, 38) as uniqueidentifier)
		
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
		
	insert @res
	select distinct top 1000 n.nameguid, n.namefull + ' SAME AS ' + an.namefull, 'Name', 'tblName'
	from @distRows dr
	inner join tblName n on n.NameGuid = dr.id1
	inner join tblname an on an.nameguid = dr.id2
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordDetails

GO


GRANT EXEC ON sprSelect_ReportSimilarNames TO PUBLIC

GO


  