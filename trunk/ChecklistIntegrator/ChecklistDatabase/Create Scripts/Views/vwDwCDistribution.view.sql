CREATE VIEW [dbo].[vwDwCDistribution]
AS 
select distinct n.nameguid as TaxonID,
    OD.data.value('./@region', 'nvarchar(100)') as Locality, 
    OD.data.value('./@Occurrence', 'nvarchar(100)') as OccurrenceStatus, 
    OD.data.value('./@Origin', 'nvarchar(100)') as EstablishmentMeans 
    from tblname n
    inner join (select OtherDataXml, fn.FlatNameSeedName from tblOtherData  
    inner join tblflatname cn on cn.flatnamenameufk = recordfk 
    inner join tblflatname fn on cn.flatnamenameufk = fn.flatnameseedname) ox on ox.FlatNameSeedName = n.NameGUID
 cross apply ox.OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 
 where OD.data.exist('/DataSet/Biostat[contains(@Occurrence, "Present")]') = 1 
 
