IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SearchProviderRefs')
	BEGIN
		DROP  Procedure  sprSelect_SearchProviderRefs
	END

GO

CREATE Procedure sprSelect_SearchProviderRefs
	@providerPk int,
	@linkType nvarchar(10),
	@filterText nvarchar(100),
	@maxRecords int
AS

	declare @filterLen int
	set @filterText = lower(ltrim(rtrim(@filterText)))
	set @filterLen = len(@filterText)
	
	if (@filterLen = 0) set @filterText = null
	if (@maxRecords is null) set @maxRecords = 200
		
	declare @recs table(PRPk int, counter int identity)
	insert @recs
	select PRPk 
	from tblProviderReference pr
	left join tblProviderImport pim on pim.ProviderImportPk = pr.PRProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	where (@providerPk is null or p.ProviderPk = @providerPk) and
		(@linkType = 'any' or pr.PRReferenceFk is null) and
		(@filterText is null or lower(substring(PRFullCitation, 1, @filterLen)) = @filterText) and
		PRLinkStatus <> 'Discarded'
	
	delete @recs 	
	where counter > @maxRecords
	
	
	select *
	from vwProviderReference pr
	inner join @recs r on r.PRPk = pr.PRPk
	

GO


GRANT EXEC ON sprSelect_SearchProviderRefs TO PUBLIC

GO


