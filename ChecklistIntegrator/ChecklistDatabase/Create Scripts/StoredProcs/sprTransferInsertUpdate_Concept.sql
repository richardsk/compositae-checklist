IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Concept')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Concept
	END

GO

CREATE Procedure sprTransferInsertUpdate_Concept
	@conceptPk int,
	@conceptLSID nvarchar(300),
	@name1 nvarchar(4000),
	@name1Fk uniqueidentifier,
	@accordingTo nvarchar(4000),
	@accToFk uniqueidentifier,
	@createdDate datetime,
	@createdBy nvarchar(50),
	@updatedDate datetime,
	@updatedBy nvarchar(50)
	
AS
	

	if (@conceptPk is not null and exists(select * from tblConcept where ConceptPk = @conceptPk))
	begin	
		update tblConcept 
		set ConceptName1 = @name1,
			ConceptName1Fk = @name1Fk,
			ConceptAccordingTo = @accordingTo,
			ConceptAccordingToFk = @accToFk,
			ConceptCreatedDate = @createdDate,
			ConceptCreatedBy = @createdBy,
			ConceptUpdatedDate = @updatedDate,
			ConceptUpdatedBy = @updatedBy
		where ConceptPk = @conceptPk
	end
	else
	begin
		set identity_insert tblConcept on
		
		insert tblConcept(ConceptPk, ConceptLSID, ConceptName1, ConceptName1Fk, ConceptAccordingTo, ConceptAccordingToFk, ConceptCreatedDate, ConceptCreatedBy, ConceptUpdatedDate, ConceptUpdatedBy)
		select @conceptPk,
			@conceptLSID,
			@name1,
			@name1Fk,
			@accordingTo,
			@accToFk,
			@createdDate,
			@createdBy, 
			@updatedDate,
			@updatedBy
			
		set identity_insert tblConcept off
	end
	
	select @@identity

GO


GRANT EXEC ON sprTransferInsertUpdate_Concept TO PUBLIC

GO


 