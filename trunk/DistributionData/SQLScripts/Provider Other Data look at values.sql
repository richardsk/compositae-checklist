



-- get other data from a provider regardless of the import
select pn.PNNameFull, pn.PNNameId,
	pod.POtherDataType,
	pod.POtherDataData, pod.POtherDataXML
	from tblProviderName pn
		inner join tblProviderImport pim on pn.PNProviderImportFk = pim.ProviderImportPk
		inner join tblProvider pro on pim.ProviderImportProviderFk = pro.ProviderPk
		inner join tblProviderImport pim2 on pro.ProviderPk = pim2.ProviderImportProviderFk
		inner join tblProviderOtherData pod on pn.PNNameId = pod.POtherDataRecordId
			and pim2.ProviderImportPk = pod.POtherDataProviderImportFk
	where pro.ProviderPk = 28
	-- next query line looks for records with a given value in the node <Status>.  It counts 
	-- <Occurrence> nodes that have the specifed text in <Status>.
	and cast(pod.POtherDataXML.query('count(//Occurrence[Status=''introduced: I(A)''])') as varchar(5)) > 0
--	and cast(pod.POtherDataXML.query('count(//Occurrence[Status])') as varchar(5)) > 0
	

-- Russia

select pn.PNNameFull, pn.PNNameId,
	pod.POtherDataType,
	pod.POtherDataData, pod.POtherDataXML
	from tblProviderName pn
		inner join tblProviderImport pim on pn.PNProviderImportFk = pim.ProviderImportPk
		inner join tblProvider pro on pim.ProviderImportProviderFk = pro.ProviderPk
		inner join tblProviderImport pim2 on pro.ProviderPk = pim2.ProviderImportProviderFk
		inner join tblProviderOtherData pod on pn.PNNameId = pod.POtherDataRecordId
			and pim2.ProviderImportPk = pod.POtherDataProviderImportFk
	where pro.ProviderPk = 49
	-- next query line looks for records with a given value in the node <Status>.  It counts 
	-- <Occurrence> nodes that have the specifed text in <Status>.
	and cast(pod.POtherDataXML.query('count(//Distribution[Region=''eastern and western Mediterranean''])') as varchar(5)) > 0
