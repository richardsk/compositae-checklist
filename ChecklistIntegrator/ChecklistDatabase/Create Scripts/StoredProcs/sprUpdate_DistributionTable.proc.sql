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


