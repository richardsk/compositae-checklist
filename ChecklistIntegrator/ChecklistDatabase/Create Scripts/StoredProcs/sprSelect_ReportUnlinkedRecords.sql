IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportUnlinkedRecords')
	BEGIN
		DROP  Procedure  sprSelect_ReportUnlinkedRecords
	END

GO

CREATE Procedure sprSelect_ReportUnlinkedRecords

AS

	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	insert @res
	select cast(PNPk as varchar(300)), PNNameFull, 'ProviderName', 'tblProviderName'
	from vwProviderName
	where PNNameFk is null and PNLinkStatus <> 'Discarded'
		
	insert @res
	select cast(PCRPk as varchar(300)), PCName1 + ' ' + PCRRelationship + ' ' + PCName2, 'ProviderConcept', 'tblProviderConceptRelationship'
	from vwProviderConceptRelationship
	where PCRConceptRelationshipFk is null 
	
	insert @res
	select cast(PRPk as varchar(300)), isnull(PRCitation, PRFullCitation), 'ProviderReference', 'tblProviderReference'
	from vwProviderReference
	where PRReferenceFk is null and PRLinkStatus <> 'Discarded'
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportUnlinkedRecords TO PUBLIC

GO


