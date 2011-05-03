IF EXISTS (SELECT * FROM sysobjects WHERE type = 'v' AND name = 'vwDwcLiterature')
	BEGIN
		DROP  view  dbo.vwDwCLiterature
	END

GO

CREATE VIEW [dbo].[vwDwCLiterature]
	AS 

SELECT c.ConceptPk as TaxonID,
	ReferenceLSID as Identifier,
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
