IF EXISTS (SELECT * FROM sysobjects WHERE type = 'v' AND name = 'vwDwcTaxon')
	BEGIN
		DROP  view  dbo.vwDwCTaxon
	END

GO

CREATE VIEW [dbo].[vwDwCTaxon]
	AS 	
select c.ConceptLSID as taxonID,
	NameLSID as scientificNameID,
	'urn:lsid:compositae.org:concepts:' + cast(prcr.ConceptRelationshipConcept2Fk as varchar(20)) as acceptedNameUsageID,
	NamePreferred as acceptedNameUsage,
	'urn:lsid:compositae.org:concepts:' + cast(pcr.ConceptRelationshipConcept2Fk as varchar(20)) as parentNameUsageID,
	NameParent as parentNameUsage,
	case when n.namebasionymfk is not null then
		(select top 1 ConceptLSID from tblconcept where ConceptName1Fk = n.NameBasionymFk) 
	when n.namereplacementforfk is not null then 
		(select top 1 ConceptLSID from tblconcept where ConceptName1Fk = n.namereplacementforfk) 
	else null end as originalNameUsageID,
	case when n.namebasionymfk is not null then n.NameBasionym 
		when n.namereplacementforfk is not null then n.namereplacementfor
	else null end as originalNameUsage,
	NameFull as scientificName,
	NamePublishedIn as namePublishedIn,
	NameReferenceFk,
	--c.ConceptAccordingToFk as nameAccordingToID,
	--c.ConceptAccordingTo as nameAccordingTo,
	(select top 1 p.ProviderName
		from tblProviderConceptRelationship pcr
		inner join tblProviderImport pim on pim.ProviderImportPk = pcr.PCRProviderImportFk
		inner join tblprovider p on p.providerpk = pim.ProviderImportProviderFk
		where pcr.pcrconceptrelationshipfk = prcr.conceptrelationshipguid
		order by providerpreferredconceptranking) as nameAccordingTo,
	c.ConceptLSID as taxonConceptID,
	c.ConceptPk,
	'Plantae' as kingdom,
	'Compositae' as family,
	gn.flatnamecanonical as genus,
	sgn.flatnamecanonical as subgenus,
	sn.flatnamecanonical as specificEpithet,
	--isn.flatnamecanonical as infraspecificEpithet,
	case when r.ranksort > 4200 then n.namecanonical else '' end as infraspecificEpithet,
	r.RankName as TaxonRank,
	n.NameRank as VerbatimTaxonRank,
	n.NameAuthors as ScientificNameAuthorship,
	'ICBN' as NomenclaturalCode,
	case when n.namepreferredfk = n.nameguid then 'accepted' else 'synonym' end as TaxonomicStatus,
	case when n.nameinvalid = 1 then 'nom. inval.; ' else '' end +
	case when n.nameillegitimate = 1 then 'nom. illeg.; ' else '' end +
	case when n.namenomnotes is null then '' else n.namenomnotes end
	as NomenclaturalStatus,
	cast(n.NameNotes as nvarchar(4000)) as TaxonRemarks,
	n.NameUpdatedDate as Modified,
	'en' as Language,
	'All proprietary rights to the intellectual property in the Data remain with the Provider as its sole property. All proprietary rights to the intellectual property in the Combined Data remain with the Global Compositae Checklist project, The International Compositae Alliance and all Providers as their sole property.' as Rights,
	'Global Compositae Checklist, The International Compositae Alliance' as RightsHolder,
	'These data can be used with due attribution to Global Compositae Checklist and the data providers from which the data was sourced.' as AccessRights,
	'Flann, C (ed) 2009+ Global Compositae Checklist Accessed: [date]' as BibliographicCitation,
	'GCC' as DatasetID,
	'Global Compositae Checklist' as DatasetName,
	'http://lcrwebservices.landcareresearch.co.nz/compositaewebservice/ticachecklistservice.asmx/GetTICANameRecordTCS?ticaLSID=urn:lsid:compositae.org:names:' + CAST(n.nameguid as varchar(38)) as Source
from tblName n
inner join tblRank r on r.RankPk = n.NameRankFk
inner join tblConcept c on c.ConceptName1Fk = n.NameGUID
left join tblConceptRelationship prcr on prcr.ConceptRelationshipConcept1Fk = c.ConceptPk and prcr.ConceptRelationshipRelationshipFk = 15
left join tblConceptRelationship pcr on pcr.ConceptRelationshipConcept1Fk = c.ConceptPk and pcr.ConceptRelationshipRelationshipFk = 6
left join tblflatname gn on gn.flatnameseedname = n.NameGUID and gn.flatnamerankname = 'genus'
left join tblflatname sgn on sgn.flatnameseedname = n.NameGUID and sgn.flatnamerankname = 'subgenus'
left join tblflatname sn on sn.flatnameseedname = n.NameGUID and sn.flatnamerankname = 'species'
--left join tblflatname isn on isn.flatnameseedname = n.NameGUID and isn.flatnamerankname in 
--	('biovar','cultivar','forma','forma specialis','graft hybrid','hybrid formula','intergen hybrid','intragen hybrid','phagovar','pathovar','serovar','ß','subforma','subspecies','subvariety','variety','α','γ','δ','tax. infrasp.','nothosubspecies','nothovariety','lus','e','proles','[infrasp.unranked]','convar','race','pars.','nm.','mut.')
