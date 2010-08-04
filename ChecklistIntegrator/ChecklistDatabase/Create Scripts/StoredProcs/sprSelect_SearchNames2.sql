IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_SearchNames2')
	BEGIN
		DROP  Procedure  sprSelect_SearchNames2
	END

GO

CREATE PROCEDURE dbo.sprSelect_SearchNames2
	@nvcSearchText1			nvarchar(100),			-- First Search Text
	@nvcField1				nvarchar(100),			-- First Field to be searched (field in tblName)
	@bitWholeWord1			bit = 0,				-- 1: search for Whole Word	0: any part of word	
	@bitAnywhere1			bit = 0,				-- 1: Anywhere in Field 0: Start of Field
	
	@bitUseOr				bit = 0,				-- 1: Search1 Or Search2   0: Search1 And Search2 
	
	@nvcSearchText2			nvarchar(100) = NULL,	-- Second Search Text, if null or empty string, only first search text is used
	@nvcField2				nvarchar(100) = NULL,	-- Second Field to be searched (field in tblName) 
	@bitWholeWord2			bit = 0,				-- 1: search for Whole Word	0: any part of word	
	@bitAnywhere2			bit = 0,				-- 1: Anywhere in Field 0: Start of Field
	
	@bitMisappliedOnly		bit = 0,				-- Filter search for only those that are misapplied
	@bitHybridOnly			bit = 0,				-- Filter search for only those that are hybrid
	@bitCurrentNamesOnly		bit = 0,			-- Filter search for only those that are CurrentNames
	
	@intRoleKey				int,					-- Role for read permissions: search results are filtered to show names that have read permission for the given role (Admin = 1 ie  everything)

	@nvcOrderBy1			nvarchar(100) = NULL,	-- First Order By Field  (Note: not all columns of name are return at present)
	@bitDescending1			bit = 0,				-- First Order 1: Descending 0: Ascending
	@nvcOrderBy2			nvarchar(100) = NULL,	-- Second Order By Field  (Note: not all columns of name are return at present)
	@bitDescending2			bit = 0,					-- Second Order 1: Descending 0: Ascending
	
	@intStartIndex			int = NULL,				-- for paging
	@intEndIndex			int = NULL,				-- for paging
	@intTotalRows			int = NULL OUTPUT,
	@bitDoNotShowSuppressed	bit = 1,
	
	@intYearStart			int = NULL,
	@intYearEnd				int = NULL,
	@uidCancelQuery			uniqueidentifier = NULL, 
	
	@FilterByTag			bit = 0
	
AS

	SET NOCOUNT ON

	DECLARE @nvcSqlQuery	varchar(8000)
	DECLARE @nvcSelect		varchar(3000)
	DECLARE @nvcFrom		varchar(2000)
	DECLARE @nvcWhereTrim	varchar(2000)
	
	DECLARE @nvcAndOr		varchar(10)
	
	DECLARE @nvcSqlQueryFinal	varchar(8000)
	DECLARE @nvcWhere		varchar(2000)
	DECLARE @nvcOrder		varchar(2000)
	
	IF @FilterByTag IS NULL
		SET @FilterByTag = 0
	
	
	IF @bitWholeWord1 IS NULL
		SET @bitWholeWord1 = 0
	
	IF @bitWholeWord2 IS NULL
		SET @bitWholeWord2 = 0
	
	IF @bitAnywhere1 IS NULL
		SET @bitAnywhere1 = 0
	
	IF @bitAnywhere2 IS NULL
		SET @bitAnywhere2 = 0
	
	IF @bitMisappliedOnly IS NULL
		SET @bitMisappliedOnly = 0
		
	IF @bitHybridOnly IS NULL
		SET @bitHybridOnly = 0
		
	IF @bitCurrentNamesOnly IS NULL
		SET @bitCurrentNamesOnly = 0
	
	IF @intEndIndex IS NULL
		SET @intEndIndex = 0
	
	IF @intStartIndex IS NULL
		SET @intStartIndex = 0
		
	IF @bitDescending1 IS NULL
		SET @bitDescending1 = 0
		
	IF @bitDescending2 IS NULL
		SET @bitDescending2 = 0
	
	
	-- the text for where
	IF @bitUseOr IS NULL OR @bitUseOr = 0
		SET @nvcAndOr = ' AND '
	ELSE
		SET @nvcAndOr = ' OR '
	
	-- **** Important: the search fields are all in tblName at present and not in the joined tables
	
	-- *************************** SELECT **********************************
	SET @nvcSelect = 'SELECT
		n1.NameCreatedBy as NameAddedBy,
		n1.NameCreatedDate as NameAddedDate,
		null as NameAggregate,
		null as NameAnamorphGenusFK,
		n1.NameAuthors, 
		0 as NameAutonym,
		cast(n1.NameBasedOnFK as varchar(38)) as NameBasedOnFk,
		cast(n1.NameBasionymFK as varchar(38)) as NameBasionymFk,
		null as NameBlockingFK,
		isnull(n1.NameCanonical, ''[unnamed]'') as NameCanonical,
		null as NameCheckStatus,
		null as NameClassificationFK,
		cast(n1.NamePreferredFk as varchar(38)) as NameCurrentFK,
		0 as NameDubium,
		isnull(n1.NameFull, '''') as NameFull,
		null as NameHybridLink,
		isnull(n1.NameIllegitimate, 0) as NameIllegitimate,
		isnull(n1.NameInCitation, 0) as NameInCitation,
		isnull(n1.NameInvalid, 0) as NameInvalid,
		0 as NameIsAnamorph,
		isnull(n1.NameMisapplied, 0) as NameMisapplied,
		''ICBN'' as NameNomCode,
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
		isnull(n1.NameRankFk, 1) as NameTaxonRankFk,
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
		isnull(n1.NameLSID,'''') as NameLSID,
		tr.RankName as TaxonRankName, 
		tr.RankAbbreviation as TaxonRankAbbreviation,
		tr.RankSort as TaxonRankSort  '
			
			-- *************************** FROM ************************************
			SET @nvcFrom =  ' FROM tblName n1 
		LEFT JOIN tblRank tr ON n1.NameRankFk = tr.RankPk '
	
	
	-- *************************** WHERE TRIM ********************************
	-- this is used to pre-cut the set which is then pruned by the wholeword function
	
	DECLARE @nvcPrefix1 nvarchar(10)
	DECLARE @nvcPrefix2 nvarchar(10)
	declare @addedFrom bit
	set @addedFrom = 0
	SET @nvcPrefix1 = 'n1.'
	SET @nvcPrefix2 = 'n1.'
	
	IF @nvcField1 IS NOT NULL AND LEN(@nvcField1) > 4
	BEGIN
		IF  SUBSTRING(@nvcField1, 1, 4) <> 'Name'
			SET @nvcPrefix1 = ''
			
		if substring(@nvcField1, 1, 4) = 'Prov'
		begin
			set @nvcField1 = replace(@nvcField1, 'Provider', 'PN')
			set @nvcPrefix1 = 'pn.'
			set @nvcFrom = @nvcFrom + ' inner join tblProviderName pn on pn.PNNameFk = n1.NameGuid '
			set @addedFrom = 1
		end
	END
	IF @nvcField2 IS NOT NULL AND LEN(@nvcField2) > 4
	BEGIN
		IF  SUBSTRING(@nvcField2, 1, 4) <> 'Name'
			SET @nvcPrefix2 = ''
				
		if substring(@nvcField2, 1, 4) = 'Prov'
		begin
			set @nvcField2 = replace(@nvcField2, 'Provider', 'PN')
			set @nvcPrefix2 = 'pn.'
			if @addedFrom = 0 set @nvcFrom = @nvcFrom + ' inner join tblProviderName pn on pn.PNNameFk = n1.NameGuid '			
		end
	END
	 
	
	IF @bitAnywhere1 = 0 OR @bitAnywhere1 IS NULL
		SET @nvcWhereTrim = ' WHERE ( ' + @nvcPrefix1 + @nvcField1 + ' LIKE ''' + @nvcSearchText1 + '%'' '
	ELSE
		SET @nvcWhereTrim = ' WHERE ( ' + @nvcPrefix1 + @nvcField1 + ' LIKE ''%' + @nvcSearchText1 + '%'' '
		
	IF NOT (@nvcSearchText2 IS NULL OR RTrim(@nvcSearchText2) = '')
		BEGIN
		IF @bitAnywhere2 = 0 OR @bitAnywhere2 IS NULL
			SET @nvcWhereTrim = @nvcWhereTrim + ' ' + @nvcAndOr + ' ' + @nvcPrefix2 +  @nvcField2 + ' LIKE ''' + @nvcSearchText2 + '%''' 
		ELSE
			SET @nvcWhereTrim = @nvcWhereTrim + ' ' + @nvcAndOr + ' ' + @nvcPrefix2 +  @nvcField2 + ' LIKE ''%' + @nvcSearchText2 + '%''' 
		END	
	
	SET @nvcWhereTrim = @nvcWhereTrim + ' ) '
		
	IF @bitMisappliedOnly = 1
		SET @nvcWhereTrim = @nvcWhereTrim + ' AND n1.NameMisapplied = 1 '

	--IF @bitHybridOnly = 1
      --  SET @nvcWhereTrim = @nvcWhereTrim + ' AND n1.NameHybridLink = ''F'' '
	
	--IF @bitCurrentNamesOnly = 1
      --SET @nvcWhereTrim = @nvcWhereTrim + ' AND n1.NameGuid = n1.NamePreferredNameFK '
	
	--IF @bitDoNotShowSuppressed = 1
      --SET @nvcWhereTrim = @nvcWhereTrim + ' AND n1.NameSuppress = 0 '
      
    --IF @FilterByTag = 1 
      --SET @nvcWhereTrim = @nvcWhereTrim + ' AND (NOT EXISTS (SELECT 1 FROM dbo.tblNomenclaturalStatus WHERE NomenclaturalStatusNameFK = n1.NameGuid AND NomenclaturalStatusStatusTypeFK = 6)) '
      
    --IF (@intYearStart IS NOT NULL AND @intYearStart > 0) OR (@intYearEnd IS NOT NULL AND @intYearEnd > 0)
	--	BEGIN
	--	IF @nvcWhereTrim <> '' 
	--		SET @nvcWhere = @nvcWhere + ' AND '
	--	
	--	SET @nvcWhereTrim = @nvcWhereTrim + ' dbo.IsYearInRange(NameYearOfPublication, NameYearOnPublication, cast(' +  cast(IsNull(@intYearStart, 0) as nvarchar(10)) + ' as int) , cast(' +  cast(IsNull(@intYearEnd,0) as nvarchar(10)) + ' as int) ) = 1 '
	--	END
      	
	-- *************************** ORDER BY *********************************
	SET @nvcOrder = ' ORDER BY '
	IF @nvcOrderBy1 IS NULL OR RTrim(@nvcOrderBy1) = '' -- Only add order if @nvcOrderBy1 contains a field
		BEGIN 
		SET @nvcOrder = @nvcOrder + ' n1.NameFull '
		END 
	ELSE
		BEGIN
		SET @nvcOrder = @nvcOrder + ' n1.' + @nvcOrderBy1
		
		IF @bitDescending1 = 1 -- Descending Flag
			SET @nvcOrder = @nvcOrder + ' DESC '
		
		IF NOT (@nvcOrderBy2 IS NULL OR RTrim(@nvcOrderBy2) = '') AND NOT @nvcOrderBy2 = @nvcOrderBy1 -- Only add second order if @nvcOrderBy2 contains a field
			BEGIN
			SET @nvcOrder = ' n1.' + @nvcOrder + ' , ' + ' n1.' + @nvcOrderBy2
			
			IF @bitDescending2 = 1 -- Descending Flag
				SET @nvcOrder = @nvcOrder + ' DESC '
			
			END
		END	
		
	
	--Quick execution if no paging and no wholeword selection
	IF @bitWholeWord1 = 0 AND @bitWholeWord1 = 0 AND @intStartIndex = 0 AND @intEndIndex = 0
		BEGIN
		SET @nvcSqlQuery = @nvcSelect + @nvcFrom + @nvcWhereTrim + @nvcOrder
		PRINT @nvcSqlQuery 
		EXEC(@nvcSqlQuery)
		RETURN @@ERROR
		END
	
	
	-- *************************** WHERE ************************************
	IF NOT (@nvcSearchText1 IS NULL OR RTrim(@nvcSearchText1) = '')
		BEGIN
		SET @nvcWhere = ' dbo.FindWord('''  + @nvcSearchText1 + ''', ' + @nvcPrefix1 + @nvcField1 + ', ' + cast(@bitAnywhere1 as nvarchar(100)) + ', ' + cast(@bitWholeWord1 as nvarchar(100)) + ') = 1' 
		IF NOT (@nvcSearchText2 IS NULL OR RTrim(@nvcSearchText2) = '')
			SET @nvcWhere = @nvcWhere + @nvcAndOr + ' dbo.FindWord('''  + @nvcSearchText2 + ''', ' + @nvcPrefix2 + @nvcField2 + ', ' + cast(@bitAnywhere2 as nvarchar(100)) + ', ' + cast(@bitWholeWord2 as nvarchar(100)) + ') = 1' 
		END
	ELSE
		BEGIN
		SET @nvcWhere = ''
		END
	
	--Quick execution if no paging 
	IF @intStartIndex = 0 AND @intEndIndex = 0
		BEGIN
		SET @nvcSqlQuery = @nvcSelect + @nvcFrom + @nvcWhereTrim + ' AND (' + @nvcWhere + ')' + @nvcOrder
		PRINT @nvcSqlQuery 
		PRINT @nvcWhereTrim
		PRINT @nvcWhere 
		EXEC(@nvcSqlQuery)
		RETURN @@ERROR
		END
		
	-- **************************** EXECUTE *********************************
	-- paging is done by sending the top <end index> results into temp table and selecting the top <end index - start index> in the opersite order
	
	DECLARE @sp_id uniqueidentifier
	SET @sp_id = NEWID() -- the id of this instance of this stored procedure
	
	

	
	-- insert into temp table, reverse order
	SET @nvcSqlQuery = ' INSERT INTO tmpNameSearch(NameSearchSP_Key, NameSearchOrderByTimestamp, NameSearchNameFk, NameSearchName)  
		SELECT TOP ' 
			+ CAST(@intEndIndex AS nvarchar(20)) 
			+ ' ''' + CAST(@sp_id AS nvarchar(100)) 
			+ ''', NULL, n1.NameGuid, n1.NameFull FROM tblName n1 LEFT JOIN tblRank tr ON n1.NameRankFk = tr.RankPk '  
			+ @nvcWhereTrim + ' AND (' + @nvcWhere + ')' + @nvcOrder
	--print @nvcSqlQuery
	EXEC(@nvcSqlQuery)
	
	-- bail if cancel has been requested
	--IF dbo.IsCancelRequested(@uidCancelQuery) = 1
	--	BEGIN
	--	exec z_sprInsert_DebugEntry 'sprSelect_SearchNames', 'Cancel', '2'
	--	EXEC sprUpdate_CancelRequestClear @uidCancelQuery
	--	DELETE FROM tmpNameSearch WHERE  NameSearchSP_Key = @sp_id
	--	RETURN @@ERROR
	--	END
	
	-- Get total 
	SET @nvcSqlQuery = ' INSERT INTO tmpSearchCount(SearchCountCount, SearchCountTimestamp, SearchCountSP_Key) 
		SELECT COUNT(*), NULL, ''' 
			+ CAST(@sp_id AS nvarchar(100)) 
			+ ''' FROM tblName n1 LEFT JOIN tblTaxonRank tr ON n1.NameTaxonRankFk = tr.TaxonRankPk ' 
			+ @nvcWhereTrim 
			+ ' AND (' + @nvcWhere + ')'
	EXEC(@nvcSqlQuery)	
	SELECT @intTotalRows = SearchCountCount FROM tmpSearchCount
	
	
	
	-- set start index
	DECLARE @intAdjustedStartIndex int
	SET @intAdjustedStartIndex = @intEndIndex + 1 - @intStartIndex
	IF @intTotalRows < @intEndIndex
		BEGIN
		SET @intAdjustedStartIndex = @intAdjustedStartIndex - (@intEndIndex - @intTotalRows)
		END
	
	DECLARE @sp_id_Reverse uniqueidentifier
	SET @sp_id_Reverse = NEWID() -- the id of this instance of this stored procedure for the reverse
	
	--SELECT @sp_id
	
	-- bail if cancel has been requested
	--IF dbo.IsCancelRequested(@uidCancelQuery) = 1
	--	BEGIN
	--	exec z_sprInsert_DebugEntry 'sprSelect_SearchNames', 'Cancel', '3'
	--	EXEC sprUpdate_CancelRequestClear @uidCancelQuery
	--	DELETE FROM tmpNameSearch WHERE  NameSearchSP_Key = @sp_id_Reverse OR NameSearchSP_Key = @sp_id
	--	RETURN @@ERROR
	--	END
	
	--reverse order
	SET @nvcSqlQuery = 
	'   INSERT INTO tmpNameSearch(NameSearchSP_Key, NameSearchOrderByTimestamp, NameSearchNameFk, NameSearchName)  
		SELECT TOP ' + CAST(@intAdjustedStartIndex AS nvarchar(20)) 
		+ ' ''' +  CAST(@sp_id_Reverse AS nvarchar(100)) +  ''', NULL, n2.NameSearchNameFk, n2.NameSearchName
		FROM tmpNameSearch n2
		WHERE n2.NameSearchSP_Key = ''' + CAST(@sp_id AS nvarchar(100)) + '''
		ORDER BY n2.NameSearchOrderByTimestamp DESC '
	print @nvcSqlQuery
	EXEC(@nvcSqlQuery)
	
	
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
		isnull(n1.NameRankFk, 1) as NameTaxonRankFk,
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
		tr.RankSort as TaxonRankSort
	FROM tmpNameSearch ns
		LEFT JOIN tblName n1 ON n1.NameGuid = ns.NameSearchNameFk
		LEFT JOIN tblRank tr ON n1.NameRankFk = tr.RankPk 
	WHERE NameSearchSP_Key = @sp_id_Reverse
	--AND (@FilterByTag = 0 OR NOT EXISTS (SELECT 1 FROM dbo.tblNomenclaturalStatus WHERE NomenclaturalStatusNameFK = n1.NameGuid AND NomenclaturalStatusStatusTypeFK = 6))
	ORDER BY NameSearchOrderByTimestamp DESC
	

		
	DELETE FROM tmpNameSearch WHERE  NameSearchSP_Key = @sp_id_Reverse OR NameSearchSP_Key = @sp_id
	
	DELETE FROM tmpSearchCount WHERE SearchCountSP_Key = @sp_id
	
	RETURN @@ERROR
	
	
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GRANT EXEC ON sprSelect_SearchNames2 TO PUBLIC

GO


