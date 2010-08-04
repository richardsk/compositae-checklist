IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportProgress')
	BEGIN
		DROP  Procedure  sprSelect_ReportProgress
	END

GO

CREATE Procedure sprSelect_ReportProgress
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	declare @total int, @guidValid int, @confCount int, @unlinked int, @provCount int, @compl real
	
	select @total = count(*) from tblname where NameFull <> 'root'
	insert @res select null, 'Total consensus Names : ' + cast(@total as nvarchar(100)), null, null
	
	select @guidValid = count(*) 
	from tblFieldStatus 
	where FieldStatusIdentifierFk = 86
	insert @res select null, 'Fully validated Name records : ' + cast(@guidValid as nvarchar(100)), null, null

	declare @confNames table(nameguid uniqueidentifier)
	
	insert @confNames
	select distinct nameguid
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	where PNLinkStatus <> 'Discarded' and 
		(isnull(PNNameFull, NameFull) collate SQL_Latin1_General_CP1_CI_AI <> NameFull or
		isnull(PNNameRank, NameRank) <> NameRank or
		isnull(PNNameCanonical, NameCanonical) <> NameCanonical or 
		isnull(PNNameAuthors, NameAuthors) <> NameAuthors or
		isnull(PNBasionymAuthors, NameBasionymAuthors) <> NameBasionymAuthors or
		isnull(PNCombinationAuthors, NameCombinationAuthors) <> NameCombinationAuthors or
		isnull(PNPublishedIn, NamePublishedIn) <> NamePublishedIn or
		isnull(PNYear, NameYear) <> NameYear or
		isnull(PNMicroReference, NameMicroReference) <> NameMicroReference or
		isnull(PNTypeVoucher, NameTypeVoucher) like NameTypeVoucher or
		isnull(PNTypeName, NameTypeName) <> NameTypeName or
		isnull(PNOrthography, NameOrthography) <> NameOrthography or
		isnull(PNBasionym, NameBasionym) <> NameBasionym or
		isnull(PNBasedOn, NameBasedOn) <> NameBasedOn or
		isnull(PNConservedAgainst, NameConservedAgainst) <> NameConservedAgainst or
		isnull(PNHomonymOf, NameHomonymOf) <> NameHomonymOf or
		isnull(PNReplacementFor, NameReplacementFor) <> NameReplacementFor or
		isnull(PNBlocking, NameBlocking) <> NameBlocking or
		isnull(PNInCitation, NameInCitation) <> NameInCitation or
		isnull(PNInvalid, NameInvalid) <> NameInvalid or
		isnull(PNIllegitimate, NameIllegitimate) <> NameIllegitimate or
		isnull(PNMisapplied, NameMisapplied) <> NameMisapplied or
		isnull(PNProParte, NameProParte) <> NameProParte) 
		
	select @confCount = count(*) from @confNames
	insert @res select null, 'Name records with no conflicts : ' + cast((@total - @confCount) as nvarchar(100)), null, null
	
	declare @valConf int --conflicting names that have been validated
	select @valConf = count(distinct cn.nameguid) 
	from @confNames cn
	inner join tblprovidername pn on pn.pnnamefk = cn.nameguid
	inner join tblFieldStatus on FieldStatusRecordFk = PNPk and FieldStatusIdentifierFk = 86
	where FieldStatusCounterPk is not null
		
	set @compl = cast((@valConf + (@total - @confCount)) * 100 as real) / @total
	insert @res select null, 'Completed Name records (validated + no conflicts) : ' + cast(@compl as nvarchar(100)) + '%', null, null

	select @unlinked = count(*) from tblproviderName where PNNameFk is null and PNLinkStatus <> 'Discarded'
	insert @res select null, 'Total names (consensus Name records + Unlinked Provider Names) : ' + cast((@total + @unlinked) as nvarchar(100)), null, null					
	insert @res select null, 'Completed Name records as a precentage of Total names : ' + cast(((@compl * @total) / (@total + @unlinked)) as nvarchar(100)) + '%', null, null
	
	select @provCount = count(*)
	from tblProviderName 
	where PNLinkStatus <> 'Discarded'
	insert @res select null, 'Total Provider Names : ' + cast(@provCount as nvarchar(100)), null, null

	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportProgress TO PUBLIC

GO


 