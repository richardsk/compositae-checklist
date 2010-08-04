select 'GCC-' + CAST(NameGUID as nvarchar(38)) as t1ID,
	NameLSID as GCCLSID,
	isnull((select top 1 c1.conceptlsid from tblconcept c1
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk and conceptrelationshiprelationshipfk = 15
		inner join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where c1.conceptname1fk = nameguid and c2.conceptname1fk = namepreferredfk),'[none]') as ConceptLSID,
	'Asteraceae' as acceptedFamily,
	'Asteraceae' as family,
	'"' + NameFull + '"' as fullName,
	RankName as rank,
	case when NameRankFk = 8 and CHARINDEX('×', NameCanonical) <> 0 then '×' else '' end as genusHybridMarker,
	case when CHARINDEX(' ', NameFull) = 0 then NameCanonical
		else SUBSTRING(namefull, 0, charindex(' ', NameFull)) end collate SQL_Latin1_General_CP1_CI_AI as genus,
	'"' + isnull(case when NameRankFk = 8 then NameBasionymAuthors
		when NameRankFk = 24 then (select NameBasionymAuthors from tblName where NameGUID = n.nameparentfk)
		else (select npp.NameBasionymAuthors from tblName npp inner join tblName np on npp.NameGUID = np.NameParentFk where np.NameGUID = n.NameParentFk)
		end, '') + '"' as genusBasionymAuthors,
	'"' + isnull(case when NameRankFk = 8 then NameAuthors
		when NameRankFk = 24 then (select NameAuthors from tblName where NameGUID = n.nameparentfk)
		else (select npp.NameAuthors from tblName npp inner join tblName np on npp.NameGUID = np.NameParentFk where np.NameGUID = n.NameParentFk)
		end, '') + '"' as genusAuthors,
	case when NameRankFk =24 and charindex('×', NameCanonical) <> 0 then '×' else '' end as speciesHybridMarker,
	case when NameRankFk = 24 then NameCanonical
		when charindex(' ', namefull, charindex(' ', namefull) + 1) = 0 then ''
		when RankSort > 4200 then SUBSTRING(NameFull, charindex(' ', namefull) + 1,
			charindex(' ', namefull, charindex(' ', namefull) + 1) - CHARINDEX(' ', namefull) - 1)
		else ''
		end collate SQL_Latin1_General_CP1_CI_AI as species,
	'"' + isnull((case when NameRankFk = 24 then namebasionymauthors
		when ranksort > 4200 then (select NameBasionymAuthors from tblName where NameGUID = n.nameparentfk)
		end), '') + '"' as speciesBasAuthors,
	'"' + isnull(case when NameRankFk = 24 then nameauthors
		when ranksort > 4200 then (select NameAuthors from tblName where NameGUID = n.nameparentfk)
		end, '') + '"' as speciesAuthors,
	case when RankSort > 4200 then RankName else '' end as infraspecificRank,
	case when RankSort > 4200 then NameCanonical else '' end as infraspecificEpithet,
	'"' + case when RankSort > 4200 then NameBasionymAuthors else '' end + '"' as infraspecificBasAuthors,
	'"' + case when RankSort > 4200 then NameAuthors else '' end + '"' as infraspecificAuthors,
	'"' + NameBasionymAuthors + '"' as basionymAuthors,
	'"' + NameCombinationAuthors + '"' as primaryAuthors,
	'"' + replace(NamePublishedIn, '"', '''') + '"' as publication,
	'' as collation,
	'"' + replace(isnull(cast(NameMicroReference as nvarchar(4000)),''), '"', '''') + '"' as page,
	isnull(NameYear,'') as date,
	'' as reference,
	isnull('GCC-' + CAST(NameBasionymFk as nvarchar(38)), '') as basionymID,
	isnull('GCC-' + CAST(NameReplacementForFk as nvarchar(38)), '') as replacedSynonymID,
	'"' + replace(isnull(cast(NameStatusNotes as nvarchar(4000)),''), '"', '''') + '"' as nomenclaturalRemarks,
	case when NameIllegitimate = 1 then 'Illegitimate'
		when NameInvalid = 1 then 'Invalid'
		when NamePreferredFk is null then 'Unplaced'
		when NamePreferredFk <> NameGUID then 'Synonym'
		else 'Accepted' end as taxonomicStatus,
	isnull('GCC-' + CAST(NamePreferredFk as nvarchar(38)), '') as acceptedNameID,
	'"' + isnull(NamePreferred, '') + '"' as acceptedName,
	isnull('GCC-' + CAST(NameParentFk as nvarchar(38)), '') as parentNameID,
	'GCC' as source,
	cast(nameguid as varchar(38)) as originalID,
	'true' as lastModifiedInSourceAvailable,
	convert(varchar(50), nameupdateddate, 126) as lastModifiedInSource,
	convert(varchar(50), getdate(), 126) as dateExported,	
	'' as ipniID,
	'"' + dbo.fnGetIPNIIds(n.nameguid) + '"' as IPNIContributions,
	'"Data Providers: ' + dbo.fngetprovidertitles(n.nameguid) + '"' as GCCDataProviders,
	'"' + replace(isnull(cast(namenotes as nvarchar(4000)),''), '"', '''') + '"' as notes
from tblName n
inner join tblRank on RankPk = NameRankFk
where NameRankFk = 8 or RankSort >= 4200
