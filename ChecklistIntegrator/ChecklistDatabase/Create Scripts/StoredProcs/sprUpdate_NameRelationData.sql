 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRelationData')
	BEGIN
		DROP  Procedure  sprUpdate_NameRelationData
	END

GO

CREATE Procedure sprUpdate_NameRelationData
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update parent and preferred fks
	declare @parentFk uniqueidentifier
	--try system PN rec
	select top 1 @parentfk = p.PNNameFk
	from vwProviderName pn
	inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId 
	inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId 
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id 
	inner join vwProviderName p on p.PNNameId = pc2.PCName1Id 
	where ppn.PNNameFk = @nameGuid and p.ProviderIsEditor = 1 and pcr.PCRRelationshipFk = 6 --parent
	
	if (@parentFk is null)
	begin
		--try parentage PN rec
		select top 1 @parentfk = p.PNNameFk
		from vwProviderName pn
		inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and PCR.ProviderPk = pc.ProviderPk
		inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc.ProviderPk
		inner join tblProvider pr on pr.ProviderPk = p.ProviderPk
		where ppn.PNNameFk = @nameGuid and pr.ProviderUseForParentage = 1 and pcr.PCRRelationshipFk = 6 --parent	
			and ppn.pnnameid <> p.pnnameid
	end
	
	if (@parentFk is null)
	begin
		--use majority
		select top 1 @parentfk = v.val
		from tblName n
		inner join (select p.PNNameFk as val, count(*) as c
			from vwProviderName pn
			inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
			inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1)
			inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and (PCR.ProviderPk = pc.ProviderPk or pcr.provideriseditor = 1)
			inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and (pc2.ProviderPk = pcr.ProviderPk or pc2.provideriseditor = 1)
			inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and (p.ProviderPk = pc.ProviderPk or p.provideriseditor = 1)
			where ppn.PNNameFk = @nameGuid and pcr.PCRRelationshipFk = 6 --parent rel
				and ppn.pnnameid <> p.pnnameid
			group by p.pnnamefk
			) v on v.val = n.NameGuid
		order by c desc	
	end

	if (@parentFk is null)
	begin
		select @parentFk = dbo.fnGetNameParentMatch(@nameGuid)
		
		if (@parentFk = '00000000-0000-0000-0000-000000000000')
		begin
			set @parentFk = null
			--select @parentFk = NameGuid	from tblName where NameFull = 'Unknown'
		end
	end
		
	--parent
	update n
	set n.NameParentFk = @parentFk, n.NameParent = pn.NameFull
	from tblName n
	inner join tblName pn on pn.NameGuid = @parentFk
	where n.NameGuid = @nameGuid				
	

	--preferred	
	declare @prefFk uniqueidentifier
	
	select @prefFk = dbo.fnGetPreferredName(@nameGuid)
	
	update n
	set n.NamePreferredFk = @prefFk, n.NamePreferred = pn.NameFull
	from tblName n
	left join tblName pn on pn.NameGuid = @prefFk
	where n.NameGuid = @nameGuid		
	
	
GO
	
GRANT EXEC ON sprUpdate_NameRelationData TO PUBLIC

GO