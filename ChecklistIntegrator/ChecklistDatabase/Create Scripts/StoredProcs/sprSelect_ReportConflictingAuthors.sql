 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportConflictingAuthors')
	BEGIN
		DROP  Procedure  sprSelect_ReportConflictingAuthors
	END

GO

CREATE Procedure sprSelect_ReportConflictingAuthors
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select distinct cast(n.NameGuid as varchar(300)), n.NameFull, 'Name', 'tblName'
	from tblname n
	inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
	left join tblprovidername pn on pn.pnnamefk = n.nameguid and pn.pnproviderimportfk = 3
	inner join tblprovidername pn2 on pn2.pnnamefk = n.nameguid and pn2.pnproviderimportfk <> 3
	inner join tblprovidernameauthors pna on pna.pnaprovidernamefk = pn2.pnpk
	where pn.pnpk is null and 			
		((pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is not null 
			and dbo.fngetcorrectedauthors(pna.pnabasionymauthors) <> na.nameauthorsbasionymauthors)
		or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is not null 
			and dbo.fngetcorrectedauthors(pna.pnacombinationauthors) <> na.nameauthorscombinationauthors)
		or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is null) 
		or (pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is null) )

	/*from vwProviderName pn
	inner join tblprovidernameauthors pna on pnaprovidernamefk = pnpk
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
	left join vwProviderName edPn on edPn.PNNameFk = n.NameGuid and edPn.ProviderIsEditor = 1
	where pn.PNLinkStatus <> 'Discarded' and	
		edPn.PNPk is null and	
		(select count(*) from tblproviderName 
			inner join tblproviderimport on providerimportpk = pnproviderimportfk
			where pnnamefk = n.NameGuid and providerimportstatus <> 'system') > 1 and
		(isnull(dbo.fnGetCorrectedAuthors(pna.PNaBasionymAuthors), '') <> isnull(na.NameAuthorsBasionymAuthors, '') or
		isnull(dbo.fnGetCorrectedAuthors(pna.PNaCombinationAuthors), '') <> isnull(na.NameAuthorsCombinationAuthors,''))*/
		

	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportConflictingAuthors TO PUBLIC

GO


