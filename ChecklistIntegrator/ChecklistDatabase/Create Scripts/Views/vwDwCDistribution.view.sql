 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'v' AND name = 'vwDwcDistribution')
	BEGIN
		DROP  view  dbo.vwDwcDistribution
	END
go

CREATE VIEW [dbo].[vwDwCDistribution]
AS 
select distinct n.nameguid as TaxonID,
	OD.data.value('./@code', 'nvarchar(100)') as LocalityId,
    OD.data.value('./@region', 'nvarchar(100)') as Locality, 
    OD.data.value('./@Occurrence', 'nvarchar(100)') as OccurrenceStatus, 
    OD.data.value('./@Origin', 'nvarchar(100)') as EstablishmentMeans,
	prov.val as source 
    from tblname n
    inner join (select OtherDataPk, OtherDataTypeFk, OtherDataXml, fn.FlatNameSeedName from tblOtherData  
    inner join tblflatname cn on cn.flatnamenameufk = recordfk 
    inner join tblflatname fn on cn.flatnamenameufk = fn.flatnameseedname) ox on ox.FlatNameSeedName = n.NameGUID
 cross apply ox.OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 
 cross apply 
	(select distinct 
	OD.data.value('.', 'nvarchar(100)') + '; ' as [text()]
	from tblOtherData 
	cross apply OtherDataXml.nodes('/DataSet/Biostat/Providers/Provider') as OD(data) 
	where OtherDataPk = ox.OtherDataPk for xml path('')) as prov(val)
 where ox.OtherDataTypeFk = 2

 