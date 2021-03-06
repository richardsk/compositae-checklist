
delete 
from tblConceptRelationship where ConceptRelationshipConcept1Fk is null or ConceptRelationshipConcept2Fk is null

update pcr
set pcr.PCRConceptRelationshipFk = null, PCRLinkStatus = 'Unmatched', PCRMatchScore = null
from tblProviderConceptRelationship pcr
where not exists(select * from tblConceptRelationship where ConceptRelationshipGuid = pcr.PCRConceptRelationshipFk)

go
 
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

 go
 
 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'v' AND name = 'vwDwcLiterature')
	BEGIN
		DROP  view  dbo.vwDwCLiterature
	END

GO

CREATE VIEW [dbo].[vwDwCLiterature]
	AS 

SELECT c.ConceptPk as TaxonID,
	ReferenceCitation as BibliographicCitation,
	RISTitle as Title,
	RISAuthors as Creator,
	RISDate as [Date],
	RISJournalName as Source,
	RISKeywords as Subject,
	RISNotes as TaxonRemarks
from dbo.tblConcept c
inner join dbo.tblReference r on r.ReferenceGUID = c.ConceptAccordingToFk
left join dbo.tblreferenceris ris on ris.risreferencefk = r.referenceguid

go

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
	isn.flatnamecanonical as infraspecificEpithet,
	r.RankName as TaxonRank,
	n.NameRank as VerbatimTaxonRank,
	n.NameAuthors as ScientificNameAuthorship,
	'ICBN' as NomenclaturalCode,
	case when n.namepreferredfk = n.nameguid then 'accepted' else 'synonym' end as TaxonomicStatus,
	case when n.nameinvalid = 1 then 'nom. inval.; ' else '' end +
	case when n.nameillegitimate = 1 then 'nom. illeg.; ' else '' end +
	case when n.namenomnotes is null then '' else n.namenomnotes end
	as NomenclaturalStatus,
	n.NameNotes as TaxonRemarks,
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
left join tblflatname isn on isn.flatnameseedname = n.NameGUID and isn.flatnamerankname in 
	('biovar','cultivar','forma','forma specialis','graft hybrid','hybrid formula','intergen hybrid','intragen hybrid','phagovar','pathovar','serovar','ß','subforma','subspecies','subvariety','variety','α','γ','δ','tax. infrasp.','nothosubspecies','nothovariety','lus','e','proles','[infrasp.unranked]','convar','race','pars.','nm.','mut.')

go

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AutonymIssues')
	BEGIN
		DROP  Procedure  sprSelect_AutonymIssues
	END

GO

CREATE Procedure sprSelect_AutonymIssues
as

	--find autonyms that are not accepted names but have "siblings" that are accepted => nomen. inconsistency
	select distinct n.NameGUID, n.NameFull, tr.RankName
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		   and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and pn.NamePreferredFk = pn.NameGUID and n.NamePreferredFk <> n.NameGUID
			and tr.RankSort > 4200
    
    --find autonyms that have no accepted concept and have no "siblings" that are accepted, then need to point to parent as the pref name
    select distinct n.NameGUID, n.NameFull, n.NameParentFk
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		   and not exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and n.NamePreferredFk is null
			and tr.RankSort > 4200
    
	--find names that have infraspecific child names but no autonym child
	select distinct n.NameGUID, n.NameFull, n.NameCanonical,
		cast((select distinct isnull(cast(infn.NameRankFk as varchar(10)) + ',','') as [text()] 
			from tblName infn
			where infn.NameParentFk = n.nameguid 
				and not exists(select n2.nameguid
					from tblName n2
					where n2.NameParentFk = n.NameGUID and
						infn.NameRankFk = n2.NameRankFk and
						CHARINDEX(n2.NameCanonical, n2.namefull, charindex(n2.NameCanonical, n2.namefull) + 1) <> 0)
			for xml path(''), type) as nvarchar(1000)) as Ranks
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName cn on cn.NameParentFk = n.NameGUID and cn.NameRankFk <> 24
	inner join tblRank ctr on ctr.RankPk = cn.NameRankFk
	left join (select n.nameguid, n.NameParentFk, tr.RankSort
		from tblName n
		inner join tblRank tr on tr.RankPk = n.NameRankFk
		where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			) can on can.NameParentFk = n.NameGUID and can.RankSort = ctr.ranksort
	where can.NameGUID is null and tr.RankSort = 4200
	
GO


GRANT EXEC ON sprSelect_AutonymIssues TO PUBLIC

GO
	