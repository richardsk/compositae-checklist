IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_Concept')
	BEGIN
		DROP  Procedure  dbo.sprDelete_Concept
	END

GO

CREATE Procedure dbo.sprDelete_Concept
	@conceptLSID nvarchar(300),
	@newConceptLSID nvarchar(300),
	@user nvarchar(50)
AS

	
	delete tblConceptRelationship 
	from tblConceptRelationship 
	inner join tblConcept on ConceptPk = ConceptRelationshipConcept1Fk 
	where ConceptLsid = @conceptLsid 
		
	delete tblConceptRelationship 
	from tblConceptRelationship 
	inner join tblConcept on ConceptPk = ConceptRelationshipConcept2Fk 
	where ConceptLsid = @conceptLsid
	
	insert into tblDeprecated
	select @conceptLsid, @newConceptLsid, 'tblConcept', getdate(), @user
	
	delete tblConcept
	where ConceptLsid = @conceptLsid
	
GO

GO


GRANT EXEC ON dbo.sprDelete_Concept TO PUBLIC

GO


