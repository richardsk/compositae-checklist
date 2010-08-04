 SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sprGetNode]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sprGetNode]
GO

CREATE procedure dbo.sprGetNode

@NameGuid					uniqueidentifier,
@intClassificationKey		int = 0,
@intRoleKey					int,
@bitDoSuppress				bit = 0

AS
	SET NOCOUNT ON
	
	DECLARE @bitSuppressMatch	bit
	IF @bitDoSuppress = 0 OR @bitDoSuppress IS NULL 
		SET @bitSuppressMatch = 1
	ELSE
		SET @bitSuppressMatch = 0
	
	--IF @intClassificationKey IS NULL OR @intClassificationKey = 0
	--	BEGIN
	
	SELECT n1.NameCreatedBy as NameAddedBy,
		n1.NameCreatedDate as NameAddedDate,
		null as NameAggregate,
		null as NameAnamorphGenusFK,
		n1.NameAuthors, 
		0 as NameAutonym,
		cast(n1.NameBasedOnFK as varchar(38)) as NameBasedOnFk,
		cast(n1.NameBasionymFK as varchar(38)) as NameBasionymFk,
		null as NameBlockingFK,
		isnull(n1.NameCanonical, '[unnamed]') as NameCanonical,
		null as NameCheckStatus,
		null as NameClassificationFK,
		cast(n1.NamePreferredFk as varchar(38)) as NameCurrentFK,
		0 as NameDubium,
		isnull(n1.NameFull, '') as NameFull,
		null as NameHybridLink,
		isnull(n1.NameIllegitimate, 0) as NameIllegitimate,
		isnull(n1.NameInCitation, 0) as NameInCitation,
		isnull(n1.NameInvalid, 0) as NameInvalid,
		0 as NameIsAnamorph,
		isnull(n1.NameMisapplied, 0) as NameMisapplied,
		'ICBN' as NameNomCode,
		0 as NameNovum,
		n1.NameOrthography as NameOrthographyVariant,
		null as NameOwner,
		null as NamePage,
		cast(n1.NameParentFk as varchar(38)) as NameParentFK,
		null as NamePrimaryOwnerFk,
		isnull(n1.NameProParte, 0) as NameProParte,
		cast(n1.NameReferenceFK as varchar(38)) as NameReferenceFk,
		null as NameSanctioningAuthor,
		null as NameSanctioningPage,
		null as NameSanctioningReferenceFK,
		0 as NameSuppress,
		null as NameTaxonomyReferenceFK,
		isnull(n1.NameRankFk, -1) as NameTaxonRankFk,
		null as NameTempRepKey,
		null as NameTypeLocality,
		cast(n1.NameTypeNameFk  as varchar(38))as NameTypeTaxonFK,
		n1.NameUpdatedBy,
		null as NameUpdatedByFK,
		n1.NameUpdatedDate,
		cast(n1.NameGuid as varchar(38)) as NameGuid,
		n1.NameYear as NameYearOfPublication, 
		null as NameYearOnPublication,  
		n1.NameParent as ParentName, 
		n1.NameBasionym as BasionymName, 
		null as BasionymDate,
		isnull(n1.NameLSID,'') as NameLSID,
		tr.RankName as TaxonRankName, 
		tr.RankAbbreviation as TaxonRankAbbreviation,
		tr.RankSort as TaxonRankSort,
		
		(
			SELECT count(*) FROM tblName b 
			WHERE b.NameParentFK = n1.NameGuid 
		) as ChildCount,
		
		(
			SELECT count(*) FROM tblName b 
			WHERE b.NameParentFK = n1.NameGuid and b.NamePreferredFk = b.NameGuid
		) as AcceptedChildCount,
		
		--rn.NodeRolePk, 		
		--p1.*, 
		
		1 as PermissionRead,
		1 as PermissionWrite,
		1 as PermissionsAddChildren,
		1 as PermissionsChangeLinks,
		1 as PermissionsModifyPermission
		
		--p2.PermissionsPk as InheritedPermissionsPk,
		--p2.PermissionsRead as InheritedPermissionsRead,
		--p2.PermissionsWrite as InheritedPermissionsWrite,
		--p2.PermissionsAddChildren as InheritedPermissionsAddChildren,
		--p2.PermissionsChangeLinks as InheritedPermissionsChangeLinks,
		--p2.PermissionsModifyPermission as InheritedPermissionsModifyPermission,
		
		FROM tblName n1
	        left join tblName pn on pn.NameGuid = n1.NameParentFk	
			--LEFT JOIN tblNodeRole rn ON (rn.NodeRoleNodeFk = n1.NameGuid AND rn.NodeRoleRoleFk = @intRoleKey)
			--LEFT JOIN tblPermissions p1 ON p1.PermissionsPk = rn.NodeRolePermissionsFk
			--LEFT JOIN tblPermissions p2 ON p2.PermissionsPk = rn.NodeRoleInheritedPermissionsFk
			LEFT JOIN tblRank tr ON n1.NameRankFk = tr.RankPk			
		WHERE n1.NameParentFK = @NameGuid
		--AND (n1.NameSuppress = 0 OR n1.NameSuppress = @bitSuppressMatch)
		
		ORDER BY tr.RankSort, n1.NameCanonical
		RETURN @@error
		--END
	--ELSE
	--	BEGIN
		
		--todo??
	--	END 

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameSynonyms')
	BEGIN
		DROP  Procedure  sprSelect_NameSynonyms
	END

GO

CREATE Procedure sprSelect_NameSynonyms
	@nameGuid uniqueidentifier
AS

	declare @pref uniqueidentifier, @id uniqueidentifier
	select @pref = NamePreferredFk from tblName where NameGuid = @nameGuid
	
	if (@pref = @nameGuid or @pref is null) set @id = @nameGuid
	else set @id = @pref
	
	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		n.NameLSID, 
		n.NameFull, 
		n.NameRank, 
		n.NameRankFk, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
		n.NameCanonical, 
		n.NameAuthors, 
		n.NameBasionymAuthors, 
		n.NameCombinationAuthors, 
		n.NamePublishedIn, 
		cast(n.NameReferenceFk as varchar(38)) as NameReferenceFk, 
		n.NameYear, 
		n.NameMicroReference, 
		n.NameTypeVoucher, 
		n.NameTypeName, 
		cast(n.NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		n.NameOrthography, 
		n.NameBasionym, 
		cast(n.NameBasionymFk as varchar(38)) as NameBasionymFk, 
		n.NameBasedOn, 
		cast(n.NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		n.NameConservedAgainst, 
		cast(n.NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		n.NameHomonymOf, 
		cast(n.NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		n.NameReplacementFor, 
		cast(n.NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
		n.NameInCitation,
		n.NameInvalid, 
		n.NameIllegitimate, 
		n.NameMisapplied, 
		n.NameProParte, 
		n.NameNomNotes, 
		n.NameStatusNotes,
		n.NameNotes,
		n.NameCreatedDate, 
		n.NameCreatedBy, 
		n.NameUpdatedDate, 
		n.NameUpdatedBy,
		dbo.fnGetFullName(NameGuid, 1,0,1,0,0) as NameFullFormatted,
		NameCounter
	from tblName n
	where n.NamePreferredFk = @id 

GO


GRANT EXEC ON sprSelect_NameSynonyms TO PUBLIC

GO





SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sprSelect_NodeToRoot]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sprSelect_NodeToRoot]
GO

-- returns a selection of nodes from the start node up through its ancestors to the root
-- uses a cursor
-- restricted by permissions of role accessing

CREATE PROCEDURE dbo.sprSelect_NodeToRoot

@StartNodeKey			uniqueidentifier, 
@intClassificationKey	int = 0,
@intRoleKey				int
	
AS

/* SET NOCOUNT ON */

DECLARE @tableResults	TABLE(NodeKey uniqueidentifier, NodeLevel int, NodeRolePk int )
DECLARE @ParentKey		uniqueidentifier
DECLARE @NodeKey		uniqueidentifier
DECLARE @intCount		int
DECLARE @GrandParent	uniqueidentifier
DECLARE @intLevel		int
declare @nodeRolePk     int
	
--IF @intClassificationKey IS NULL OR @intClassificationKey = 0 
--	BEGIN
	
	
	SELECT @ParentKey = NameParentFk, @NodeKey = NameGuid
	FROM         tblName 
	WHERE NameGuid = @StartNodeKey
	
	SET @intLevel = 0
	
 	SELECT @intCount = COUNT(*) FROM @tableResults WHERE NodeKey = @ParentKey
	
	WHILE @intCount < 1 
	AND (NOT @NodeKey IS NULL)
	BEGIN
		set @nodeRolePk = 1
	    --select top 1 @nodeRolePk = NodeRolePk 
	    --from tblNodeRole
	    --where NodeRoleNodeFk = @NodeKey and NodeRoleRoleFk = @intRoleKey
	    
		SET @intLevel = @intLevel + 1
		INSERT INTO @tableResults VALUES(@NodeKey, @intLevel, @nodeRolePk)
		
		SELECT @GrandParent = NameParentFk
		FROM         tblName 
		WHERE NameGuid = @ParentKey
		
		SET @NodeKey = @ParentKey
		SET @ParentKey = @GrandParent
		
		SELECT @intCount = COUNT(*) FROM @tableResults WHERE NodeKey = @NodeKey
	END
	
	
	SELECT n1.NameCreatedBy as NameAddedBy,
		n1.NameCreatedDate as NameAddedDate,
		null as NameAggregate,
		null as NameAnamorphGenusFK,
		n1.NameAuthors, 
		0 as NameAutonym,
		cast(n1.NameBasedOnFK as varchar(38)) as NameBasedOnFk,
		cast(n1.NameBasionymFK as varchar(38)) as NameBasionymFk,
		null as NameBlockingFK,
		isnull(n1.NameCanonical, '[unnamed]') as NameCanonical,
		null as NameCheckStatus,
		null as NameClassificationFK,
		cast(n1.NamePreferredFk as varchar(38)) as NameCurrentFK,
		0 as NameDubium,
		isnull(n1.NameFull, '') as NameFull,
		null as NameHybridLink,
		isnull(n1.NameIllegitimate, 0) as NameIllegitimate,
		isnull(n1.NameInCitation, 0) as NameInCitation,
		isnull(n1.NameInvalid, 0) as NameInvalid,
		0 as NameIsAnamorph,
		isnull(n1.NameMisapplied, 0) as NameMisapplied,
		'ICBN' as NameNomCode,
		0 as NameNovum,
		n1.NameOrthography as NameOrthographyVariant,
		null as NameOwner,
		null as NamePage,
		cast(n1.NameParentFk as varchar(38)) as NameParentFK,
		null as NamePrimaryOwnerFk,
		isnull(n1.NameProParte, 0) as NameProParte,
		cast(n1.NameReferenceFK as varchar(38)) as NameReferenceFk,
		null as NameSanctioningAuthor,
		null as NameSanctioningPage,
		null as NameSanctioningReferenceFK,
		0 as NameSuppress,
		null as NameTaxonomyReferenceFK,
		isnull(n1.NameRankFk,1) as NameTaxonRankFk,
		null as NameTempRepKey,
		null as NameTypeLocality,
		cast(n1.NameTypeNameFk  as varchar(38))as NameTypeTaxonFK,
		n1.NameUpdatedBy,
		null as NameUpdatedByFK,
		n1.NameUpdatedDate,
		cast(n1.NameGuid as varchar(38)) as NameGuid,
		n1.NameYear as NameYearOfPublication, 
		null as NameYearOnPublication,  
		n1.NameParent as ParentName, 
		n1.NameBasionym as BasionymName, 
		null as BasionymDate,
		isnull(n1.NameLSID,'') as NameLSID,
		tr.RankName as TaxonRankName, tr.RankAbbreviation as TaxonRankAbbreviation,
		
    	b.NodeLevel,  
    	@StartNodeKey as SeedNode,
    	
    	tr.RankSort as TaxonRankSort,
    	tr.RankName as TaxonRankFullName,
    	
		--rn.NodeRolePk, 		
		--p1.*, 
		
		1 as PermissionRead,
		1 as PermissionWrite,
		1 as PermissionsAddChildren,
		1 as PermissionsChangeLinks,
		1 as PermissionsModifyPermission
		
		--p2.PermissionsPk as InheritedPermissionsPk,
		--p2.PermissionsRead as InheritedPermissionsRead,
		--p2.PermissionsWrite as InheritedPermissionsWrite,
		--p2.PermissionsAddChildren as InheritedPermissionsAddChildren,
		--p2.PermissionsChangeLinks as InheritedPermissionsChangeLinks,
		--p2.PermissionsModifyPermission as InheritedPermissionsModifyPermission,
		
	FROM @tableResults b 
	    LEFT JOIN tblName n1 ON n1.NameGuid = b.NodeKey
	    left join tblName pn on pn.NameGuid = n1.NameParentFk
		--LEFT JOIN tblNodeRole rn on rn.NodeRolePk = b.NodeRolePk
		--LEFT JOIN tblPermissions p1 ON p1.PermissionsPk = rn.NodeRolePermissionsFk
		--LEFT JOIN tblPermissions p2 ON p2.PermissionsPk = rn.NodeRoleInheritedPermissionsFk 
		LEFT JOIN tblRank tr ON n1.NameRankFk = tr.RankPk
	ORDER BY b.NodeLevel DESC
	
	RETURN @@error
	--END
--ELSE --Alternate Hierarchy
	--todo??


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

