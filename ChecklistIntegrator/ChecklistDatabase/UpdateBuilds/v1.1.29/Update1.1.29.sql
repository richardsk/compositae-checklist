-- =============================================
-- Script Template
-- =============================================

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_DistributionTable')
	BEGIN
		DROP  Procedure  sprUpdate_DistributionTable
	END

GO

CREATE PROCEDURE [dbo].[sprUpdate_DistributionTable]
AS

	truncate table tblDistribution

	insert tblDistribution
	select distinct nameguid, 
		OD.data.value('./@L1', 'nvarchar(100)') as L1,
		OD.data.value('./@L2', 'nvarchar(100)') as L2,
		OD.data.value('./@L3', 'nvarchar(100)') as L3,
		OD.data.value('./@L4', 'nvarchar(100)') as L4,
		OD.data.value('./@region', 'nvarchar(100)') as Region, 
		OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence
	from 
	tblName n
	inner join tblOtherData on RecordFk = n.NameGUID 
	cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 

go

GRANT EXEC ON [sprUpdate_DistributionTable] TO PUBLIC

GO


if not EXISTS (SELECT * FROM sysobjects WHERE type = 'U' AND name = 'tblDistribution')
begin 
	CREATE TABLE [dbo].[tblDistribution](
		[NameGuid] [uniqueidentifier] NOT NULL,
		[L1] [nvarchar](100) NULL,
		[L2] [nvarchar](100) NULL,
		[L3] [nvarchar](100) NULL,
		[L4] [nvarchar](100) NULL,
		[GeoRegion] [nvarchar](200) NULL,
		[Occurrence] [nvarchar](50) NULL
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_NameGuid] ON [dbo].[tblDistribution] 
	(
		[NameGuid] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_Region] ON [dbo].[tblDistribution] 
	(
		[GeoRegion] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


	exec sprupdate_distributiontable
end
go


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredName')
	BEGIN
		DROP  Function  fnGetPreferredName
	END

GO

CREATE Function fnGetPreferredName
(
	@nameGuid uniqueidentifier
)
returns uniqueidentifier
AS
begin
	--get preferred name
	-- if that name has a diff preferred name then use that one
	-- to avoid inconsistencies
	
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier, isEditor bit)
	declare @isEd bit, @basId uniqueidentifier

	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	-- also check all names related to the same basionym
	select @basId = NameBasionymFk from tblName where NameGuid = @nameGuid

	set @done = 0
	
	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk, pcr.ProviderIsEditor
		from tblName
		inner join tblProviderName pn on PNNameFk = NameGUID
		inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId 
				and (pcr.ProviderPk = pim.ProviderImportProviderFk or pcr.provideriseditor = 1)
				and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		left join tblProviderName p2 on p2.PNNameId = pcr.PCName2Id 
		left join tblProviderImport pim2 on pim2.ProviderImportPk = p2.PNProviderImportFk
		left join tblProvider pr2 on pr2.ProviderPk = pim2.ProviderImportPk
				and (pim2.ProviderImportProviderFk = pcr.ProviderPk or pr2.provideriseditor = 1)
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid or NameBasionymFk = @basId
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select COUNT(pnpk) from @recs where providerpk = @prefProv and isEditor = 1) = 1)
		begin
			select @prefFk = prefnamefk from @recs where providerpk = @prefProv
			return @preffk
		end

		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @isEd = iseditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv
			if (@isEd = 1)
			begin
				select @prefFk = prefnamefk from @recs where providerpk = @prefProv
				return @preffk
			end
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(distinct prefNameFk) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @isEd = iseditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv and ispref = 1
				if (@isEd = 1)
				begin
					select @prefFk = prefnamefk from @recs where providerpk = @prefProv
					return @preffk
				end
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				
			end
		end
				
		if (@prefFk is null or @prefFk = @nameGuid) set @done = 1
		else
		begin
			set @allPrefNames = @allPrefNames + ' ' + cast(@prefFk as varchar(38)) + ' '
						
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk or
				charindex(' ' + cast(@prefpreffk as varchar(38)) + ' ', @allPrefNames) <> 0) 
					set @done = 1
			else 
			begin
				set @nameGuid = @prefPrefFk
				set @allPrefNames = @allPrefNames + ' ' + cast(@prefprefFk as varchar(38)) + ' '
			end
		end
	end
	
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid and nameguid <> namepreferredfk
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
		end
	end
		
	return @prefFk
end

GO


GRANT EXEC ON fnGetPreferredName TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ProviderNameOtherDataToUpdate')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ProviderNameOtherDataToUpdate
	END

GO

CREATE Procedure dbo.sprSelect_ProviderNameOtherDataToUpdate
	@nameGuid uniqueidentifier
AS

	select distinct od.OtherDataFk, POtherDataType, OutputTypeFk, pn.PNNameFk 
	from vwProviderOtherData od
	inner join vwProviderName pn on pn.PNNameId = od.POtherDataRecordId and pn.ProviderPk = od.ProviderPk
	left join tblStandardOutput so on so.POtherDataFk = od.POtherDataTextPk
	where pn.PNNameFk = @nameGuid and od.OutputTypeFk is not null and
		(od.StandardOutputPk is null or od.OtherDataFk is null or OtherDataTransUpdatedDate > so.UpdatedDate
			or isnull(POtherDataUpdatedDate, POTherDataCreatedDate) > so.UpdatedDate
			or isnull(pn.PNUpdatedDate, pn.PNCreatedDate) > so.UpdatedDate)

GO


GRANT EXEC ON dbo.sprSelect_ProviderNameOtherDataToUpdate TO PUBLIC

GO


