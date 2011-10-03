IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptLinks')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptLinks
	END

GO

CREATE Procedure sprUpdate_ConceptLinks
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update concept name links to point to the correct names
	--this will be done after a provider name has been relinked, or unliniked, 
	--	so the concepts need to follow the relink

	declare @updates table(counter int identity, PCRPk int)
		
	insert @updates
	select distinct PCRPk
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	left join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
	where c.ConceptName1Fk = @nameGuid 
	union
	select distinct PCRPk
	from  tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = pc.PCConceptId and pcr.ProviderPk = pc.ProviderPk
	left join vwProviderConcept pc2 on pc2.PCPk = pcr.PCPK 
	where c.ConceptName1Fk = @nameGuid 
	
	declare @conceptPk int, @conceptToPk int, @pos int, @count int, @crid uniqueidentifier
	declare @provPk int, @concept1Id nvarchar(300), @concept2Id nvarchar(300)
	declare @PCRPk int
	declare @oldCRID uniqueidentifier, @newCRID uniqueidentifier, @oldLSID nvarchar(300), @newLSID nvarchar(300)
	declare @name1Fk uniqueidentifier, @name2Fk uniqueidentifier
	
	select @pos = 1, @count = count(*) from @updates
	
	while (@pos <= @count)
	begin
		select @provPk = ProviderPk, @PCRPk = pcr.PCRPk, @oldCRID = PCRConceptRelationshipFk
		from vwProviderConceptRelationship pcr
		inner join @updates u on u.PCRPk = pcr.PCRPk
		where u.counter = @pos
		
		select @name1Fk = PNNamefk
		from vwProviderName pn
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId and pn.ProviderPk = pcr.ProviderPk
		where PCRPk = @PCRPk
		
		select @name2Fk = PNNamefk
		from vwProviderName pn
		inner join vwProviderConceptRelationship pcr on pcr.PCName2Id = pn.PNNameId and pn.ProviderPk = pcr.ProviderPk
		where PCRPk = @PCRPk

		if (@name1Fk is not null and @name2Fk is not null)
		begin
			--insert/update concept for these provider details
			exec sprInsert_ConceptRelationship @PCRPk, @user, @newCRID output
			
			--delete old concept rel?
			if (@oldCRID is not null and (not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRID)))
			begin
				select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRID
				select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @newCRID

				exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
			end
		end
		
		set @pos = @pos + 1
	end
		
	
GO


GRANT EXEC ON sprUpdate_ConceptLinks TO PUBLIC

GO


