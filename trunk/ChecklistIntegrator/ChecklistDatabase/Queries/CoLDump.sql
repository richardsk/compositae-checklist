select n.namelsid,
	'Plantae',
	'', --phylum
	'', --class
	'', --order
	'', --SuperFamilyName
	'Compositae',
	substring(n.namefull, 1, charindex(' ', n.namefull)), --genus
	n.namecanonical, --species
	n.nameauthors,
	'', --infraspecies
	'', --infraspmarker
	'', --infraspauthor
	'Provisionally Accepted', --gsd status
	'Provisionally Accepted', --sp2000 status
	'"' + (select
                OD.data.value('./@L1', 'nvarchar(100)') + ', ' +
                OD.data.value('./@L2', 'nvarchar(100)') + ', ' +
                OD.data.value('./@L3', 'nvarchar(100)') + ', ' +
                OD.data.value('./@L4', 'nvarchar(100)') + '; '
                  -- OD.data.value('./@Occurrence', 'nvarchar(100)') + ', ' +
                  -- OD.data.value('./@Origin', 'nvarchar(100)') + '; '
                    from tblOtherData
                   cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data)
                   where RecordFk = n.nameGuid for xml path('')) + '"', --dist
	'', --occ status
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"',
	n.nameupdatedby, 
	n.nameupdateddate,
	'' --species url
from tblname n
where NameRankFk = 24 and NamePreferredFk = NameGUID
	
select n.namelsid,
	pn.namelsid, --accepted name id
	substring(n.namefull, 1, charindex(' ', n.namefull)), --genus
	n.namecanonical, --species
	n.nameauthors,
	'', --infraspecies
	'', --infraspmarker
	'', --infraspauthor
	'Synonym', --gsd status
	'Synonym' --sp2000 status
from tblName n
inner join tblName pn on pn.NameGUID = n.NamePreferredFk
where n.NameRankFk = 24 and n.NamePreferredFk <> n.NameGUID


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
	