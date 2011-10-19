--accepted species table
--remember to REMOVE top 100 limitation if used for testing
select top 100 n.namelsid,
	'Plantae',
	'', --phylum
	'', --class
	'', --order
	'', --SuperFamilyName
	'Compositae',
	substring(n.namefull, 1, charindex(' ', n.namefull)), --genus
	n.namecanonical, --species
	isnull(n.nameauthors,''),
	'Provisionally Accepted', --gsd status
	'Provisionally Accepted', --sp2000 status
	0, --isFossil
	'', --life zone
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"', --additional data
	isnull(n.nameupdatedby,n.NameCreatedBy), --specialist
	isnull(n.nameupdateddate, n.NameCreatedDate),
	'', --species url
	'', --GSDTaxonGUI
	'' --GSDNameGUI
from tblname n
where NameRankFk = 24 and NamePreferredFk = NameGUID

--accepted infra specifics table
select n.namelsid,
	pn.NameLSID, --parent ID
	n.namecanonical, --infraspecific
	isnull(n.nameauthors,''),
	case when tr.RankIncludeInFullName = 1 then tr.RankAbbreviation else '' end,
	'Provisionally Accepted', --gsd status
	'Provisionally Accepted', --sp2000 status
	0, --isFossil
	'', --life zone
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"', --additional data
	isnull(n.nameupdatedby,n.NameCreatedBy), --specialist
	isnull(n.nameupdateddate, n.NameCreatedDate),
	'', --species url
	'', --GSDTaxonGUI
	'' --GSDNameGUI
from tblname n
inner join tblRank tr on tr.RankPk = n.NameRankFk
inner join tblName pn on pn.NameGUID = n.NameParentFk
where RankSort > 4200 and n.NamePreferredFk = n.NameGUID
	
--synonyms table
select n.namelsid,
	pn.namelsid, --accepted name id
	substring(n.namefull, 1, charindex(' ', n.namefull)), --genus
	isnull(fn.FlatNameCanonical,''), --sub genus
	case when tr.RankSort = 4200 then 		
		n.namecanonical 
	else		
		parn.namecanonical 	
	end, --species
	isnull(n.nameauthors,''),
	case when tr.RankSort > 4200 then n.NameCanonical else '' end, --infraspecies
	'', --infraspmarker
	'', --infraspauthor
	'Synonym', --gsd status
	'Synonym' --sp2000 status
from tblName n
inner join tblName pn on pn.NameGUID = n.NamePreferredFk
inner join tblName parn on parn.NameGUID = n.nameparentfk
inner join tblRank tr on tr.RankPk = n.NameRankFk
left join tblFlatName fn on fn.FlatNameSeedName = n.NameGUID and 
		fn.FlatNameTaxonRankFk in (101,121,122,29,21,104,33,22,34,100,110)
where tr.RankSort >= 4200 and n.NamePreferredFk <> n.NameGUID

--distribution table
--remember to REMOVE top 100 limitation if used for testing
select top 100 '"' + (select distinct
               case when OD.data.value('./@L1', 'nvarchar(100)') = '' then '' else OD.data.value('./@L1', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L2', 'nvarchar(100)') = '' then '' else OD.data.value('./@L2', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L3', 'nvarchar(100)') = '' then '' else OD.data.value('./@L3', 'nvarchar(100)') + ', ' end +
               case when OD.data.value('./@L4', 'nvarchar(100)') = '' then '' else OD.data.value('./@L4', 'nvarchar(100)') end + '; '
                 -- OD.data.value('./@Occurrence', 'nvarchar(100)') + ', ' +
                 -- OD.data.value('./@Origin', 'nvarchar(100)') + '; '
                   from tblOtherData
					left join tblname sn on sn.namepreferredfk = n.nameguid
                  cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data)
                  where (RecordFk = n.nameGuid or RecordFk = sn.nameguid) and (
                                       OD.data.value('./@L1', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L2', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L3', 'nvarchar(100)') <> '' or
                                       OD.data.value('./@L4', 'nvarchar(100)') <> '')
                  for xml path('')) + '"' as Distribution --dist
from tblName n
inner join tblOtherData o on o.RecordFk = n.NameGUID

--source database table
select 'Compositae', --taxonomic coverage
	'Global Compositae Checklist', --db name
	'Global Compositae Checklist', --db full nmae
	'1', -- db version ??
	GETDATE(), --release date
	'http://www.compositae.org/checklist', --home url
	'http://www.compositae.org/checklist', --search url
	'http://202.27.243.13/compositaechecklist/images/logo%20small.jpg', --logo url
	'', --std abstract
	'Wageningen University', --custodian
	'Christina Flann' --author/editor
	
