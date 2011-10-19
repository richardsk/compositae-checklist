--accepted species table
--remember to REMOVE top 100 limitation if used for testing
select top 100 n.namelsid as AcceptedTaxonID,
	'Plantae' as Kingdom,
	'' as Phylum, --phylum
	'' as Class, --class
	'' as 'Order', --order
	'' as SuperFamilyName, --SuperFamilyName
	'Compositae' as Family,
	substring(n.namefull, 1, charindex(' ', n.namefull)) as Genus, --genus
	isnull(fn.FlatNameCanonical,'') as SubGenusName, --SubGenusName
	n.namecanonical as Species, --species
	isnull('"' + n.nameauthors + '"','') as AuthorString,
	'Provisionally Accepted' as GSDNameStatus, --gsd status
	'Provisionally Accepted' as Sp2000NameStatus, --sp2000 status
	0 as IsFossil, --isFossil
	'terrestrial' as LifeZone, --life zone
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"' as AdditionalData, --additional data
	isnull(n.nameupdatedby,n.NameCreatedBy) as LTSSpecialist, --specialist
	isnull(n.nameupdateddate, n.NameCreatedDate) as LTSDate,
	'' as SpeciesURL, --species url
	'' as GSDTaxonGUI, --GSDTaxonGUI
	'' as GSDNameGUI --GSDNameGUI
from tblname n
left join tblFlatName fn on fn.FlatNameSeedName = n.NameGUID and 
		fn.FlatNameTaxonRankFk in (101,121,122,29,21,104,33,22,34,100,110)
where NameRankFk = 24 and NamePreferredFk = NameGUID

--accepted infra specifics table
select n.namelsid as AcceptedTaxonID,
	pn.NameLSID as ParentSpeciesID, --parent ID
	n.namecanonical as InfraSpeciesEpithet, --infraspecific
	isnull('"' + n.nameauthors + '"','') as InfraSpeciesAuthorString,
	case when tr.RankIncludeInFullName = 1 then tr.RankAbbreviation else '' end as InfraSpeciesMarker,
	'Provisionally Accepted' as GSDNameStatus, --gsd status
	'Provisionally Accepted' as Sp2000NameStatus, --sp2000 status
	0 as IsFossil, --isFossil
	'terrestrial' as LifeZone, --life zone
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"' as AdditionalData, --additional data
	isnull(n.nameupdatedby,n.NameCreatedBy) as LTSSpecialist, --specialist
	isnull(n.nameupdateddate, n.NameCreatedDate) as LTSDate,
	'' as InfraSpeciesURL, --infraspecies url
	'' as GSDTaxonGUI, --GSDTaxonGUI
	'' as GSDNameGUI --GSDNameGUI
from tblname n
inner join tblRank tr on tr.RankPk = n.NameRankFk
inner join tblName pn on pn.NameGUID = n.NameParentFk
where RankSort > 4200 and n.NamePreferredFk = n.NameGUID
	
--synonyms table
select n.namelsid as ID,
	pn.namelsid as AcceptedTaxonID, --accepted name id
	substring(n.namefull, 1, charindex(' ', n.namefull))as Genus, --genus
	isnull(fn.FlatNameCanonical,''), --sub genus
	case when tr.RankSort = 4200 then 		
		n.namecanonical 
	else		
		parn.namecanonical 	
	end as Species, --species
	isnull('"' + n.nameauthors + '"','') as AuthorString,
	case when RankPk <> 24 then n.NameCanonical else '' end as InfraSpecies,
	case when rankpk <> 24 then rankname else '' end as InfraSpecificMarker, --infraspmarker
	case when rankpk <> 24 then isnull('"' + n.nameauthors + '"','') else '' end as InfraSpecificAuthorString, --infraspauthor
	'Synonym' as GSDNameStatus, --gsd status
	'Synonym' as Sp2000NameStatus, --sp2000 status
	'' as GSDNameGUI --GSDNameGUI
from tblName n
inner join tblName pn on pn.NameGUID = n.NamePreferredFk
inner join tblName parn on parn.NameGUID = n.nameparentfk
inner join tblRank tr on tr.RankPk = n.NameRankFk
left join tblFlatName fn on fn.FlatNameSeedName = n.NameGUID and 
		fn.FlatNameTaxonRankFk in (101,121,122,29,21,104,33,22,34,100,110)
where tr.RankSort >= 4200 and n.NamePreferredFk <> n.NameGUID

--distribution table
--remember to REMOVE top 100 limitation if used for testing
select n.NameLSID as AcceptedTaxonID,
	'"' + (select distinct
               case when OD.data.value('./@L1', 'nvarchar(100)') = '' then '' else OD.data.value('./@L1', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L2', 'nvarchar(100)') = '' then '' else OD.data.value('./@L2', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L3', 'nvarchar(100)') = '' then '' else OD.data.value('./@L3', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L4', 'nvarchar(100)') = '' then '' else OD.data.value('./@L4', 'nvarchar(100)') end + '; '
                 -- OD.data.value('./@Occurrence', 'nvarchar(100)') + ', ' +
                 -- OD.data.value('./@Origin', 'nvarchar(100)') + '; '
                   from tblOtherData
					left join tblname sn on sn.namepreferredfk = n.nameguid
                  cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data)
                  where (RecordFk = n.NameGUID or RecordFk = sn.nameguid) and (
                                       OD.data.value('./@L1', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L2', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L3', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L4', 'nvarchar(100)') <> '')
                  for xml path('')) + '"' as DistributionElement, --dist
	'TDWG' as StandardInUse, --standard
	'' as DistributionStatus --distribution status
from tblName n
inner join tblOtherData o on o.RecordFk = n.NameGUID
inner join tblrank tr on tr.rankpk = n.namerankfk
where tr.RankSort >= 4200

--source database table
select 'Global Compositae Checklist' as DatabaseFullName, --db name
	'GCC' as DatabaseShortName, --db full nmae
	'3 (Beta)' as DatabaseVersion, -- db version ??
	GETDATE() as ReleaseDate, --release date
	'C. Flann (ed); The International Compositae Alliance' as AuthorsEditors, --author/editor
	'Compositae' as TaxonomicCoverage, --taxonomic coverage
	'Sunflowers' as GroupNameInEnglish, --english name
	'"' + 'The Global Compositae Checklist is an integrated database of nomenclatural and taxonomic information for the second largest vascular plant family in the world. It is compiled from many contributed datasets. The database will be continually updated. Distribution data is included in TDWG Geographic standard format, the distribution data is derived from contributed data and is not presumed to be comprehensive. Additional information such as references will be added in the future. All species are marked as “provisionally accepted names” in Beta version. Dataset may contain some errors.'+ '"' as Abstract, -- abstract
	'"' + 'Wageningen University, The Netherlands'+ '"' as Organisation, --organisation
	'http://www.compositae.org/checklist', --home url
	'Global' as Coverage, --coverage
	'99%' as Completeness, --completeness
	'4' as Confidence, --confidence
	'http://202.27.243.13/compositaechecklist/images/logo%20small.jpg', --logo url
	'Christina Flann' as ContactPerson --contact
	
