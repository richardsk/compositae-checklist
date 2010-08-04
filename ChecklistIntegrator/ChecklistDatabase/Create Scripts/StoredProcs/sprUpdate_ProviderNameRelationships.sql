IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameRelationships')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameRelationships
	END

GO

CREATE Procedure sprUpdate_ProviderNameRelationships
	@providerNamePk int,
	@user nvarchar(50)
AS

	exec sprInsert_ProviderNameChange @providerNamepk, @user
	
	--update relationships to point to namePks for associated nameIds
	--must be done after integration so all nameFks have been be set
	--we dont do this for system provider names - they are set using the Fks, not the Ids

	if (exists(select * from vwProviderName where PNPk = @providerNamePk and ProviderIsEditor = 1))
		return;
		
		
	declare @refFk uniqueidentifier
	declare @typeFk uniqueidentifier
	declare @basFk uniqueidentifier
	declare @basedFk uniqueidentifier
	declare @consFk uniqueidentifier
	declare @homoFk uniqueidentifier
	declare @replFk uniqueidentifier	
	declare @blockFk uniqueidentifier
	
	--TypeName, PNTypeNameId
	select @typeFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNTypeNameId
	where pn.PNPk = @providerNamePk
	
	--Basionym, PNBasionymId
	select @basFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNBasionymId
	where pn.PNPk = @providerNamePk
	
	--BasedOn, PNBasedOnId
	select @basedFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNBasedOnId
	where pn.PNPk = @providerNamePk
	
	--ConservedAgainst, PNConservedAgainstId
	select @consFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNConservedAgainstId
	where pn.PNPk = @providerNamePk
	
	--HomonymOf, PNHomonymOfId
	select @homoFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNHomonymOfId
	where pn.PNPk = @providerNamePk
	
	--ReplacementFor, PNReplacementForId
	select @replFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.ProviderPk = pn.ProviderPk and n.PNNameId = pn.PNReplacementForId
	where pn.PNPk = @providerNamePk
	
	--Blocking, BlockingId
	select @blockFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBlockingId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--PNReferenceFk
	select @refFk = pr.PRReferenceFk
	from vwProviderName pn
	inner join vwProviderReference pr on pr.PRReferenceId = pn.PNReferenceId and pr.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	update tblProviderName
	set PNTypeNameFk = @typeFk,
		PNBasionymFk = @basFk,
		PNBasedOnFk = @basedFk,
		PNConservedAgainstFk = @consFk,
		PNHomonymOfFk = @homoFk,
		PNReplacementForFk = @replFk,
		PNBlockingFk = @blockFk,
		PNReferenceFk = @refFk,
		PNUpdatedDate = getdate(),
		PNUpdatedBy = @user
	where PNPk = @providerNamePk
	
	
	
	select *
	from vwProviderName
	where PNPk = @providerNamePk
	
	
GO


GRANT EXEC ON sprUpdate_ProviderNameRelationships TO PUBLIC

GO


