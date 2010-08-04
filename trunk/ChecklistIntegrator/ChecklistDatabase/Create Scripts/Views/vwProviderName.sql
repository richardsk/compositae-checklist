IF EXISTS (SELECT * FROM sysobjects WHERE type = 'V' AND name = 'vwProviderName')
	BEGIN
		DROP  View vwProviderName
	END
GO

CREATE View vwProviderName AS

	select p.ProviderName,
		PNNameFull, 
		PNNameCanonical, 
		PNNameRank, 
		PNNameAuthors, 
		PNYear, 
		PNBasionymAuthors, 
		PNNameId, 
		PNCombinationAuthors,
		PNPublishedIn,  
		PNReferenceId, 
		PNMicroReference, 
		PNTypeName, 
		PNTypeNameId, 
		PNBasionym, 
		PNBasionymId, 
		PNBasedOn, 
		PNBasedOnId, 
		PNConservedAgainst, 
		PNConservedAgainstId,  
		PNHomonymOf, 
		PNHomonymOfId, 
		PNReplacementFor, 
		PNReplacementForId, 
		PNBlocking,
		PNBlockingId,
		PNTypeVoucher, 
		PNOrthography, 
		PNInCitation,
		PNInvalid, 
		PNIllegitimate, 
		PNMisapplied, 
		PNProParte, 
		PNLinkStatus, 
		PNNameMatchScore, 
		PNGeographyText, 
		PNGeographyCodes, 
		PNClimate, 
		PNLifeform, 
		PNIUCN, 
		PNNotes, 
		PNStatusNotes, 
		PNNonNotes, 
		PNQualityStatement,
		PNNameVersion,
		p.ProviderIsEditor,
		p.ProviderPk,
		PNPk,
		cast(PNNameFk as varchar(38)) as PNNameFk, 
		PNProviderImportFk, 
		PNProviderUpdatedDate, 
		PNProviderAddedDate, 
		PNNameRankFk, 
		cast(PNReferenceFk as varchar(38)) as PNReferenceFk, 
		cast(PNTypeNameFk as varchar(38)) as PNTypeNameFk,
		cast(PNBasionymFk as varchar(38)) as PNBasionymFk, 
		cast(PNBasedOnFk as varchar(38)) as PNBasedOnFk, 
		cast(PNConservedAgainstFk as varchar(38)) as PNConservedAgainstFk, 
		cast(PNHomonymOfFk as varchar(38)) as PNHomonymOfFk, 
		cast(PNReplacementForFk as varchar(38)) as PNReplacementForFk, 
		cast(PNBlockingFk as varchar(38)) as PNBlockingFk,
		PNCreatedDate, 
		PNCreatedBy, 
		PNUpdatedDate, 
		PNUpdatedBy
	from tblProviderName pn
	left join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk
	left join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk


GO


GRANT SELECT ON vwProviderName TO PUBLIC

GO

