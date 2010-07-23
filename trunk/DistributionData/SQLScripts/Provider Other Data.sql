use compositae
go

-- to get the list of distinct data types in other data by provider
select distinct p.ProviderPk, p.ProviderName,
	pri.ProviderImportPk,
	po.POtherDataType
	 from 
	tblprovider p
		inner join tblProviderImport pri on p.ProviderPk = pri.ProviderImportProviderFk
		inner join tblProviderOtherData po on pri.ProviderImportPk = po.POtherDataProviderImportFk
order by p.ProviderName

/*
 to look at values for a given and data type
 chance the value in POtherDataType and POtherDataProviderImportFk 
 to match the import of interest
*/
select POtherDataData, POtherDataXML 
	from tblProviderOtherData po
where po.POtherDataType = 'Distribution' and
	 po.POtherDataProviderImportFk = 46
	 
select POtherDataType, COUNT(*) from 
	tblProviderOtherData where POtherDataProviderImportFk = 46

-- check that all the records have distribution data...
-- run next two together
-- nb: does not take into account differences between current names and synonyms
select COUNT(*) as NoProviderNameRecords 
	from tblProviderName pn		
	where PNProviderImportFk = 8
	
SELECT     po.POtherDataType, COUNT(pn.PNNameId) AS NoPOtherDataRecords
FROM         tblProviderName AS pn INNER JOIN
                      tblProviderOtherData AS po ON pn.PNNameId = po.POtherDataRecordId INNER JOIN
                      tblProviderImport AS pim2 ON po.POtherDataProviderImportFk = pim2.ProviderImportPk INNER JOIN
                      tblProviderImport AS pim1 ON pim2.ProviderImportProviderFk = pim1.ProviderImportProviderFk AND 
                      pn.PNProviderImportFk = pim1.ProviderImportPk
GROUP BY po.POtherDataType, pim2.ProviderImportPk
HAVING      (pim2.ProviderImportPk = 8) 

/**
select providername,  POtherDataType, count(POtherDataRecordId)
	from tblProviderOtherData
		inner join tblProviderImport on POtherDataProviderImportFk = ProviderImportPk
		inner join tblProvider on ProviderImportProviderFk = ProviderPk
	where ProviderPk <> 12
	group by ProviderName, potherdatatype	
	order by providername

**/

-- look  at the distinct values inside the named element, messy
-- will need to change the path element in ('//Distribution/text()') 
	
select distinct
	cast(POtherDataXML.query('//Distribution/text()') as nvarchar(1500))
	from tblProviderOtherData
		inner join tblProviderImport on POtherDataProviderImportFk = ProviderImportPk
	where Providerimportpk = 56 and POtherDataType = 'Distribution'
	
/*  Helper functino if need to count records to check for missing data
-- replace the name in ('count(//<name>)')  with the element to be counted
select potherdataxml,
	cast(POtherDataXML.query('count(//Province)') as nvarchar(1500)),
	cast(POtherDataXML.query('count(//Country)') as nvarchar(1500))
	from tblProviderOtherData
		inner join tblProviderImport on POtherDataProviderImportFk = ProviderImportPk
		inner join tblProvider on ProviderImportProviderFk = ProviderPk
	where ProviderPk = 33
*/

-- unique combinations of regions for a specified
select distinct cast(#adw.valuexml.query('node()') as nvarchar(500))
	from tblProviderOtherData 
	cross apply POtherDataXML.nodes('//Distributions') as #adw(valuexml)
where POtherDataProviderImportFk = 56


select distinct cast(#adw.valuexml.query('text()') as nvarchar(50))
	from tblProviderOtherData 
	cross apply POtherDataXML.nodes('//Distribution') as #adw(valuexml)
where POtherDataProviderImportFk = 56

-- get the values for an xslt to convert the element.
select distinct '<xsl:when test="$pProv=''' +
	cast(#adw.valuexml.query('text()') as nvarchar(50)) + '''"></xsl:when>'
	from tblProviderOtherData 
	cross apply POtherDataXML.nodes('//Distribution') as #adw(valuexml)
where POtherDataProviderImportFk = 56