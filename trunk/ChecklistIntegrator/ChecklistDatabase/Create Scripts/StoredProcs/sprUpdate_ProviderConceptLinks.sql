IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderConceptLinks')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderConceptLinks
	END

GO

CREATE Procedure sprUpdate_ProviderConceptLinks
	@PNPk int,
	@user nvarchar(50)	
AS
	--update the PCConceptFk and PCRConceptRelationshipFk's for the specified provider name
	--if providername is unlinked then concepts will be too

	declare @tmpId uniqueidentifier, @nameFk uniqueidentifier
	set @tmpId = newid()
		
	select @nameFk = PNNameFk from tblProviderName where PNPk = @PNPk
	
	if (@nameFk is null)
	begin
		--unlink concepts
		update pc
		set PCConceptFk = null,
			PCLinkStatus = 'Unmatched',
			PCMatchScore = null,
			PCUpdatedDate = getdate(),
			PCUpdatedBy = @user
		from vwProviderConcept pc
		inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
		where pn.PNPk = @PNPk
		
		
		update pcr
		set pcr.PCRConceptRelationshipFk = null,
			pcr.PCRLinkStatus = 'Unmatched',
			pcr.PCRMatchScore = null,
			pcr.PCRUpdatedDate = getdate(),
			pcr.PCRUpdatedBy = @user
		from tblProviderConceptRelationship pcr
		inner join vwProviderConceptRelationship vpcr on vpcr.PCRPk = pcr.PCRPk
		inner join vwProviderConcept pc on pc.PCConceptId = vpcr.PCRConcept1Id and pc.ProviderPk = vpcr.ProviderPk
		inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
		where pn.PNPk = @PNPk
		
		update pcr
		set pcr.PCRConceptRelationshipFk = null,
			pcr.PCRLinkStatus = 'Unmatched',
			pcr.PCRMatchScore = null,
			pcr.PCRUpdatedDate = getdate(),
			pcr.PCRUpdatedBy = @user
		from tblProviderConceptRelationship pcr
		inner join vwProviderConceptRelationship vpcr on vpcr.pcrpk = pcr.pcrpk
		inner join vwProviderConcept pc on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = vpcr.ProviderPk
		inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pc.ProviderPk = pn.ProviderPk
		where pn.PNPk = @PNPk
	end
	else
	begin
		--update links
		declare @updates table(counter int identity, PCRPk int, PCPk1 int, PCPk2 int)
			
		insert @updates
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
		inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		where pn.PNPk = @PNPk
		
		insert @updates
		select distinct PCRPk, pc.PCPk, pc2.PCPk
		from  vwProviderName pn
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept2Id = pc.PCConceptId and pcr.ProviderPk = pc.ProviderPk
		inner join vwProviderConcept pc2 on pc2.PCPk = pcr.PCPK 
		where pn.PNPk = @PNPk
		
		declare @conceptPk int, @conceptToPk int, @pos int, @count int, @crid uniqueidentifier
		declare @provPk int, @concept1Id nvarchar(300), @concept2Id nvarchar(300)
		declare @PCRPk int, @name1Fk uniqueidentifier, @name2Fk uniqueidentifier
		declare @oldCRID uniqueidentifier, @newCRID uniqueidentifier, @oldLSID nvarchar(300), @newLSID nvarchar(300)
		
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
	end	
	
	

GO


GRANT EXEC ON sprUpdate_ProviderConceptLinks TO PUBLIC

GO


