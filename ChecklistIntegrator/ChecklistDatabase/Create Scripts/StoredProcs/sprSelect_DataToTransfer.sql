IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_DataToTransfer')
	BEGIN
		DROP  Procedure  sprSelect_DataToTransfer
	END

GO

CREATE Procedure sprSelect_DataToTransfer
	@fromDate datetime
AS

	declare @dt datetime
	if (@fromDate is null) set @dt = '1/1/2000'
	else set @dt = @fromDate

	select * from tblAuthors where UpdatedDate >= @dt or AddedDate >= @dt
	select * from tblNameAuthors where NameAuthorsCreatedDate >= @dt
	select * from tblProviderNameAuthors where PNACreatedDate >= @dt
	select * from tblConcept where ConceptUpdatedDate >= @dt or ConceptCreatedDate >= @dt
	select * from tblConceptRelationship where ConceptRelationshipUpdatedDate >= @dt or ConceptRelationshipCreatedDate >= @dt
	select * from tblDeprecated where DeprecatedDate >= @dt
	select * from tblFieldStatus where FieldStatusCreatedDate >= @dt or FieldStatusUpdatedDate >= @dt
	select * from tblName where NameCreatedDate >= @dt or NameUpdatedDate >= @dt
	select * from tblProvider where ProviderCreatedDate >= @dt or ProviderUpdatedDate >= @dt
	select * from tblProviderConcept where PCCreatedDate >= @dt or PCUpdatedDate >= @dt
	select * from tblProviderConcept_Change where ChangedDate >= @dt 
	select * from tblProviderConceptRelationship where PCRCreatedDate >= @dt or PCRUpdatedDate >= @dt
	select * from tblProviderConceptRelationship_Change where ChangedDate >= @dt 
	select * from tblProviderImport where ProviderImportCreatedDate >= @dt
	select * from tblProviderName where PNCreatedDate >= @dt or PNUpdatedDate >= @dt
	select * from tblProviderName_Change where ChangedDate >= @dt 
	select * from tblProviderOtherData where POtherDataCreatedDate >= @dt or POtherDataUpdatedDate >= @dt
	select * from tblProviderReference where PRCreatedDate >= @dt or PRUpdatedDate >= @dt
	select * from tblProviderReference_Change where ChangedDate >= @dt 
	select * from tblProviderRIS where PRISCreatedDate >= @dt or PRISUpdatedDate >= @dt
	select * from tblProviderRIS_Change where ChangedDate >= @dt 
	select * from tblReference where ReferenceCreatedDate >= @dt or ReferenceUpdatedDate >= @dt
	select * from tblReferenceRIS where RISCreatedDate >= @dt or RISUpdatedDate >= @dt
	select * from tblOtherData where CreatedDate >= @dt or UpdatedDate >= @dt
	select * from tblStandardOutput where UpdatedDate >= @dt
	select * from tblTransformation where UpdatedDate >= @dt
	select * from tblOtherDataTransformation where UpdatedDate >= @dt
	select * from tblOtherDataType where UpdatedDate >= @dt
	
GO


GRANT EXEC ON sprSelect_DataToTransfer TO PUBLIC

GO


