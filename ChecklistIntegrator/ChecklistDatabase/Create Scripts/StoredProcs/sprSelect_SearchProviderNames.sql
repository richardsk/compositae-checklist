IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SearchProviderNames')
	BEGIN
		DROP  Procedure  sprSelect_SearchProviderNames
	END

GO

CREATE Procedure sprSelect_SearchProviderNames
	@providerPk int,
	@linkType nvarchar(10),
	@filterText nvarchar(100),
	@maxRecords int
AS

	declare @filterLen int, @unknownId uniqueidentifier
	set @filterText = lower(ltrim(rtrim(@filterText)))
	set @filterLen = len(@filterText)
	
	if (@filterLen = 0) set @filterText = null
	if (@maxRecords is null) set @maxRecords = 200
		
	select @unknownId = NameGuid
	from tblName
	where NameFull = 'Unknown'
	
	declare @recs table(PNPk int, counter int identity)
	insert @recs
	select PNPk 
	from tblProviderName pn
	left join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk
	left join tblName n on n.NameGuid = pn.PNNameFk
	where (@providerPk is null or p.ProviderPk = @providerPk) and
		(@linkType = 'any' or @linkType = 'unknown' or pn.PNNameFk is null) and
		(@linkType = 'any' or @linkType = 'unlinked' or n.NameParentFk = @unknownId) and
		(@filterText is null or lower(substring(PNNameCanonical, 1, @filterLen)) = @filterText) and
		PNLinkStatus <> 'Discarded'
	
	delete @recs 	
	where counter > @maxRecords
	
	
	select pn.*
	from vwProviderName pn
	inner join @recs r on r.PNPk = pn.PNPk
	
GO


GRANT EXEC ON sprSelect_SearchProviderNames TO PUBLIC

GO


