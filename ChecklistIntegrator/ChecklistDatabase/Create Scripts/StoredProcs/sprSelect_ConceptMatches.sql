IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConceptMatches')
	BEGIN
		DROP  Procedure  sprSelect_ConceptMatches
	END

GO

CREATE Procedure sprSelect_ConceptMatches
	@PCPk int
AS

	declare @name1Id nvarchar(300), @name2Id nvarchar(300), @relFk int, @accToId nvarchar(4000), @accToFk uniqueidentifier
	declare @name2Fk uniqueidentifier, @name1Fk uniqueidentifier, @provPk int
		
	select @name1Id = PCName1Id, @name2Id = PCName2Id, @relFk = PCRelationshipFk, @accToId = PCAccordingToId,
		@provPk = ProviderPk
	from vwProviderConcept
	where PCPk = @PCPk
	
	select @name1Fk = PNNameFk from vwProviderName where PNNameId = @name1Id and ProviderPk = @provPk
	select @name2Fk = PNNameFk from vwProviderName where PNNameId = @name2Id and ProviderPk = @provPk
	select @accToFk = PRReferenceFk from tblProviderReference where PRReferenceId = @accToId
		
	if (@name2Fk is not null and @relFk is not null)
	begin
		select * 
		from tblConcept
		where ConceptName1Fk = @name1Fk and ConceptName2Fk = @name2Fk 
				and ConceptRelationshipFk = @relFk and 
				(@accToFk is null or ConceptAccordingToFk = @accToFk)
	end
	
GO


GRANT EXEC ON sprSelect_ConceptMatches TO PUBLIC

GO


