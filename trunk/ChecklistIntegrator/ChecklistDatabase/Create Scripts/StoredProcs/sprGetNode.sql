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

