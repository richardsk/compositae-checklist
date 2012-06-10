IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_ProviderName')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_ProviderName
	END

GO

CREATE Procedure sprTransferInsertUpdate_ProviderName
	@PNPk int, 
	@PNNameFk uniqueidentifier, 
	@PNLinkStatus nvarchar(20), 
	@PNNameMatchScore int,  
	@PNProviderImportFk int, 
	@PNProviderUpdatedDate datetime, 
	@PNProviderAddedDate datetime, 
	@PNNameId nvarchar(4000), 
	@PNNameFull nvarchar(300), 
	@PNNameRank nvarchar(50), 
	@PNNameRankFk int, 
	@PNNameCanonical nvarchar(300), 
	@PNNameAuthors nvarchar(300), 
	@PNBasionymAuthors nvarchar(300), 
	@PNCombinationAuthors nvarchar(300), 
	@PNPublishedIn nvarchar(1000), 
	@PNReferenceId nvarchar(4000), 
	@PNReferenceFk uniqueidentifier, 
	@PNYear nvarchar(20), 
	@PNMicroReference nvarchar(150), 
	@PNTypeVoucher ntext, 
	@PNTypeName nvarchar(300), 
	@PNTypeNameId nvarchar(4000), 
	@PNTypeNameFk uniqueidentifier, 
	@PNOrthography nvarchar(300), 
	@PNBasionym nvarchar(300), 
	@PNBasionymId nvarchar(4000), 
	@PNBasionymFk uniqueidentifier, 
	@PNBasedOn nvarchar(300), 
	@PNBasedOnId nvarchar(4000), 
	@PNBasedOnFk uniqueidentifier, 
	@PNConservedAgainst nvarchar(300), 
	@PNConservedAgainstId nvarchar(4000), 	
	@PNConservedAgainstFk uniqueidentifier, 
	@PNHomonymOf nvarchar(300), 
	@PNHomonymOfId nvarchar(4000), 
	@PNHomonymOfFk uniqueidentifier, 
	@PNReplacementFor nvarchar(300), 
	@PNReplacementForId nvarchar(4000), 
	@PNReplacementForFk uniqueidentifier, 
	@PNBlocking nvarchar(300), 
	@PNBlockingId nvarchar(4000), 
	@PNBlockingFk uniqueidentifier, 
	@PNInCitation bit,
	@PNInvalid bit, 
	@PNIllegitimate bit, 
	@PNMisapplied bit, 
	@PNProParte bit, 
	@PNGeographyText ntext, 
	@PNGeographyCodes nvarchar(4000), 
	@PNClimate ntext, 
	@PNLifeform ntext, 
	@PNIUCN ntext, 
	@PNNotes ntext, 
	@PNStatusNotes nvarchar(2000), 
	@PNNonNotes ntext,
	@PNQualityStatement nvarchar(4000),
	@PNNameVersion nvarchar(200),
	@PNCreatedDate datetime,
	@PNCreatedBy nvarchar(50),
	@PNUpdatedDate datetime,
	@PNUpdatedBy nvarchar(50)
AS
	
	if (@PNPk = -1 or not exists(select * from tblProviderName where PNPk = @PNPk) )
	begin
		set identity_insert tblProviderName on
		insert into tblProviderName(
			PNPk, 
			PNNameFk, 
			PNLinkStatus, 
			PNNameMatchScore, 
			PNProviderImportFk, 
			PNProviderUpdatedDate, 
			PNProviderAddedDate, 
			PNNameId, 
			PNNameFull, 
			PNNameRank, 
			PNNameRankFk, 
			PNNameCanonical, 
			PNNameAuthors, 
			PNBasionymAuthors, 
			PNCombinationAuthors, 
			PNPublishedIn, 
			PNReferenceId, 
			PNReferenceFk, 
			PNYear, 
			PNMicroReference, 
			PNTypeVoucher, 
			PNTypeName, 
			PNTypeNameId, 
			PNTypeNameFk, 
			PNOrthography, 
			PNBasionym, 
			PNBasionymId, 
			PNBasionymFk, 
			PNBasedOn, 
			PNBasedOnId, 
			PNBasedOnFk, 
			PNConservedAgainst, 
			PNConservedAgainstId, 
			PNConservedAgainstFk, 
			PNHomonymOf, 
			PNHomonymOfId, 
			PNHomonymOfFk, 
			PNReplacementFor, 
			PNReplacementForId, 
			PNReplacementForFk, 
			PNBlocking, 
			PNBlockingId, 
			PNBlockingFk, 
			PNInCitation, 
			PNInvalid, 
			PNIllegitimate, 
			PNMisapplied, 
			PNProParte, 
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
			PNCreatedDate, 
			PNCreatedBy, 
			PNUpdatedDate, 
			PNUpdatedBy)
		select @PNPk, 
			@PNNameFk, 
			@PNLinkStatus, 
			@PNNameMatchScore, 
			@PNProviderImportFk, 
			@PNProviderUpdatedDate, 
			@PNProviderAddedDate, 
			@PNNameId, 
			@PNNameFull, 
			@PNNameRank, 
			@PNNameRankFk, 
			@PNNameCanonical, 
			@PNNameAuthors, 
			@PNBasionymAuthors, 
			@PNCombinationAuthors, 
			@PNPublishedIn, 
			@PNReferenceId, 
			@PNReferenceFk, 
			@PNYear, 
			@PNMicroReference, 
			@PNTypeVoucher, 
			@PNTypeName, 
			@PNTypeNameId, 
			@PNTypeNameFk, 
			@PNOrthography, 
			@PNBasionym, 
			@PNBasionymId, 
			@PNBasionymFk, 
			@PNBasedOn, 
			@PNBasedOnId, 
			@PNBasedOnFk, 
			@PNConservedAgainst, 
			@PNConservedAgainstId, 
			@PNConservedAgainstFk, 
			@PNHomonymOf, 
			@PNHomonymOfId, 
			@PNHomonymOfFk, 
			@PNReplacementFor, 
			@PNReplacementForId, 
			@PNReplacementForFk, 
			@PNBlocking,
			@PNBlockingId,
			@PNBlockingFk,
			@PNInCitation,
			@PNInvalid, 
			@PNIllegitimate, 
			@PNMisapplied, 
			@PNProParte, 
			@PNGeographyText, 
			@PNGeographyCodes, 
			@PNClimate, 
			@PNLifeform, 
			@PNIUCN, 
			@PNNotes, 
			@PNStatusNotes, 
			@PNNonNotes,
			@PNQualityStatement,
			@PNNameVersion,
			@PNCreatedDate,
			@PNCreatedBy,
			@PNUpdatedDate,
			@PNUpdatedBy
			
			set identity_insert tblProviderName off
		end
		else
		begin
			
			update tblProviderName
			set PNNameFk = @PNNameFk, 
			PNLinkStatus = @PNLinkStatus, 
			PNNameMatchScore = @PNNameMatchScore, 
			PNProviderImportFk = @PNProviderImportFk, 
			PNProviderUpdatedDate = @PNProviderUpdatedDate, 
			PNProviderAddedDate = @PNProviderAddedDate, 
			PNNameId = @PNNameId, 
			PNNameFull = @PNNameFull, 
			PNNameRank = @PNNameRank, 
			PNNameRankFk = @PNNameRankFk, 
			PNNameCanonical = @PNNameCanonical, 
			PNNameAuthors = @PNNameAuthors, 
			PNBasionymAuthors = @PNBasionymAuthors, 
			PNCombinationAuthors = @PNCombinationAuthors, 
			PNPublishedIn = @PNPublishedIn, 
			PNReferenceId = @PNReferenceId, 
			PNReferenceFk = @PNReferenceFk, 
			PNYear = @PNYear, 
			PNMicroReference = @PNMicroReference, 
			PNTypeVoucher = @PNTypeVoucher, 
			PNTypeName = @PNTypeName, 
			PNTypeNameId = @PNTypeNameId, 
			PNTypeNameFk = @PNTypeNameFk, 
			PNOrthography = @PNOrthography, 
			PNBasionym = @PNBasionym, 
			PNBasionymId = @PNBasionymId, 
			PNBasionymFk = @PNBasionymFk, 
			PNBasedOn = @PNBasedOn, 
			PNBasedOnId = @PNBasedOnId, 
			PNBasedOnFk = @PNBasedOnFk, 
			PNConservedAgainst = @PNConservedAgainst, 
			PNConservedAgainstId = @PNConservedAgainstId, 
			PNConservedAgainstFk = @PNConservedAgainstFk, 
			PNHomonymOf = @PNHomonymOf, 
			PNHomonymOfId = @PNHomonymOfId, 
			PNHomonymOfFk = @PNHomonymOfFk, 
			PNReplacementFor = @PNReplacementFor, 
			PNReplacementForId = @PNReplacementForId, 
			PNReplacementForFk = @PNReplacementForFk, 
			PNBlocking = @PNBlocking, 
			PNBlockingId = @PNBlockingId, 
			PNBlockingFk = @PNBlockingFk, 
			PNInCitation = @PNInCitation,
			PNInvalid = @PNInvalid, 
			PNIllegitimate = @PNIllegitimate, 
			PNMisapplied = @PNMisapplied, 
			PNProParte = @PNProParte, 
			PNGeographyText = @PNGeographyText, 
			PNGeographyCodes = @PNGeographyCodes, 
			PNClimate = @PNClimate, 
			PNLifeform = @PNLifeform, 
			PNIUCN = @PNIUCN, 
			PNNotes = @PNNotes, 
			PNStatusNotes = @PNStatusNotes, 
			PNNonNotes = @PNNonNotes,
			PNQualityStatement = @PNQualityStatement,
			PNNameVersion = @PNNameVersion,
			PNCreatedDate = @PNCreatedDate,
			PNCreatedBy = @PNCreatedBy,
			PNUpdatedDate = @PNUpdatedDate,
			PNUpdatedBy = @PNUpdatedBy
		where PNPk = @PNPk
	end


GO


GRANT EXEC ON sprTransferInsertUpdate_ProviderName TO PUBLIC

GO

