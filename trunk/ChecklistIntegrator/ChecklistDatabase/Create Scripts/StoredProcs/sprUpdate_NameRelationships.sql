IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRelationships')
	BEGIN
		DROP  Procedure  sprUpdate_NameRelationships
	END

GO

CREATE Procedure sprUpdate_NameRelationships
	@nameGuid uniqueidentifier,
	@providerNamePk int,
	@user nvarchar(50)
AS
	--sets the name relationships for a name based on the provided providername.  
	--update concepts to point to correct name guid

	declare @nameId nvarchar(300)
	declare @refFk uniqueidentifier
	declare @typeFk uniqueidentifier
	declare @basFk uniqueidentifier
	declare @basedFk uniqueidentifier
	declare @consFk uniqueidentifier
	declare @homoFk uniqueidentifier
	declare @replFk uniqueidentifier
	declare @blockFk uniqueidentifier
	declare @parentFk uniqueidentifier
	declare @pnRefFk uniqueidentifier
		
	--TypeName, PNTypeNameId
	select @typeFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNTypeNameId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Basionym, PNBasionymId
	select @basFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBasionymId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--BasedOn, PNBasedOnId
	select @basedFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBasedOnId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--ConservedAgainst, PNConservedAgainstId
	select @consFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNConservedAgainstId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--HomonymOf, PNHomonymOfId
	select @homoFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNHomonymOfId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--ReplacementFor, PNReplacementForId
	select @replFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNReplacementForId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Blocking, BlockingId
	select @blockFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBlockingId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Referencefk
	select @refFk = pr.PRReferenceFk
	from vwProviderName pn
	inner join vwProviderReference pr on pr.PRReferenceId = pn.PNReferenceId and pr.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
		
	--parent
	select @parentFk = p.PNNameFk
	from vwProviderName pn
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1)
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	inner join vwProviderName p on p.PNNameId = pcr.PCName2Id
	where pn.PNPk = @providerNamePk and pcr.PCRRelationshipFk = 6 
	
	if (@parentFk is null)
	begin
		select @parentFk = dbo.fnGetNameParentMatch(@nameGuid)
		
		if (@parentFk = '00000000-0000-0000-0000-000000000000')
		begin
			set @parentFk = null
			--select @parentFk = NameGuid	from tblName where NameFull = 'Unknown'
		end
	end
	
	--update name
	
	update tblName
	set NameReferenceFk = @refFk,
		NameTypeNameFk = @typeFk,
		NameBasionymFk = @basFk,
		NameBasedOnFk = @basedFk, 
		NameConservedAgainstFk = @consFk,
		NameHomonymOfFk = @homoFk,
		NameReplacementForFk = @replFk,
		NameBlockingFk = @blockFk,
		NameParentFk = isnull(@parentFk, NameParentFk)
	where NameGuid = @nameGuid


	--update concepts
		
	exec sprUpdate_ConceptLinks @nameGuid, @user
	
	/*update c
	set ConceptName1Fk = @nameGuid,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @providerNamePk
	
	update c
	set ConceptName1Fk = @nameGuid,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	inner join vwProviderName pn on pn.PNNameId = pcr.PCName2Id and pn.ProviderPk = pcr.ProviderPk
	where pn.PNPk = @providerNamePk*/
	
GO


GRANT EXEC ON sprUpdate_NameRelationships TO PUBLIC

GO


