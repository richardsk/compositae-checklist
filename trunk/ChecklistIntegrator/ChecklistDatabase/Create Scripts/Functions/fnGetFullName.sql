IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetFullName')
	BEGIN
		DROP  Function  fnGetFullName
	END

GO

CREATE Function fnGetFullName
(
	@NameGuid			uniqueidentifier,
	@bitFormatted		bit = 0,
	@bitYear			bit = 0,
	@bitAuthors			bit = 0,
	@bitLiterature		bit = 0,
	@flags              bit = 0
)
	
RETURNS nvarchar(1000)
AS
BEGIN

	-- Declarations ------------------------------------------------------------------------------------

	DECLARE @nvcFullName			nvarchar(1000)
	DECLARE @nvcNameCanonical		nvarchar(100)
	DECLARE @nvcParentName			nvarchar(100)
	DECLARE @nvcNameAuthors			nvarchar(255)
	DECLARE @nvcNameRank			nvarchar(100)
	DECLARE @nvcYearOf				nvarchar(10)
	DECLARE @nvcYearOn				nvarchar(10)
	
	DECLARE @bitNameMisapplied		bit
	DECLARE @bitNameInCitation		bit
	DECLARE @intNameRankSort		int
	DECLARE @intParentRankSort		int
	DECLARE @vcParentGuid			uniqueidentifier
	declare @isAutonym				bit
	declare @inclRankName           bit
	declare @rankNameStr            varchar(1000)

	DECLARE @NameNomCode			varchar(5)
	
	DECLARE @nvcLiteratureKey		uniqueidentifier
	
	-- Select ------------------------------------------------------------------------------------------
	
	SELECT 
		@nvcNameCanonical = n.NameCanonical, 
		@nvcParentName = pn.NameCanonical,
		@intParentRankSort =(SELECT RankSort FROM tblRank WHERE RankPk =  pn.NameRankFk),
		@intNameRankSort = tr.RankSort,
		@nvcYearOf = n.NameYear ,
		@nvcYearOn = n.NameYear ,
		@nvcNameAuthors = n.NameAuthors ,
		@bitNameMisapplied = n.NameMisapplied,
		@vcParentGuid = n.NameParentFk,
		--@bitNameInCitation = n.NameInCitation,
		@nvcNameRank = tr.RankAbbreviation,
		--@nvcLiteratureKey = case when n.NameAutonym = 1 then pn.NameReferenceFK else n.NameReferenceFK end,
		@NameNomCode = 'ICBN',
		--@isAutonym = n.NameAutonym
		@inclRankName = tr.RankIncludeInFullName
	FROM tblName n 
		LEFT JOIN tblName pn ON n.NameParentFk = pn.NameGuid
		LEFT JOIN tblRank tr ON tr.RankPk = n.NameRankFk
	WHERE n.NameGuid  = @NameGuid
		
	--if (len(@nvcNameAuthors) > 30)
	--begin
	--    declare @pos int
	--    set @pos = charindex(',', @nvcNameAuthors, 30)
	--    set @nvcNameAuthors = left(@nvcNameAuthors, @pos) + ' et al'
	--end
	
	if (@inclRankName = 1) set @rankNameStr = ' ' + @nvcNameRank + ' '
	else set @rankNameStr = ''
	
	--nomencl. status
	declare @status nvarchar(100)
	if @flags = 1
	begin
	    declare @invalid bit, @illegit bit, @dubious bit, @misapp bit, @proparte bit, @aggr bit, @anam bit
	    select @invalid = isnull(NameInvalid,0), @illegit = isnull(NameIllegitimate,0), 
	        @dubious = 0, @misapp = isnull(NameMisapplied,0), --isnull(NameDubium,0)
	        @proparte = isnull(NameProParte,0), @aggr = 0, -- isnull(NameAggregate,0), 
	        @anam = 0 --isnull(NameIsAnamorph,0)
	    from tblName
	    where NameGuid = @nameGuid
	    
	    if (@invalid = 1 or @illegit = 1 or @dubious = 1 or @misapp = 1 or @proparte = 1 or @aggr = 1 or @anam = 1)
	    begin
	        set @status = '('
	        if @invalid = 1 set @status = @status + 'nom. inv., '
	        if @illegit = 1 set @status = @status + 'nom. illegit., '
	        if @dubious = 1 set @status = @status + 'nom. dub., '
	        if @proparte = 1 set @status = @status + 'pro. parte., '
	        if @aggr = 1 set @status = @status + 'agg., '
	        if @anam = 1 set @status = @status + 'stat. anam., '
	        
	        set @status = left(@status, len(@status) - 1) + ')'
	    end
	end
		
	-- formatting --------------------------------------------------------------------------------------
		
	DECLARE @nvcItalic		nvarchar(10)
	DECLARE @nvcItalicEnd	nvarchar(10)
	DECLARE @nvcBold		nvarchar(10)
	DECLARE @nvcBoldEnd		nvarchar(10)
		
	IF @bitFormatted = 1
		BEGIN
		SET @nvcItalic = '<I>'
		SET @nvcItalicEnd = '</I>'
		SET @nvcBold = '<B>'
		SET @nvcBoldEnd = '</B>'
		END
	ELSE
		BEGIN	
		SET @nvcItalic = ''
		SET @nvcItalicEnd = ''
		SET @nvcBold = ''
		SET @nvcBoldEnd = ''
		END
	
	-- name --------------------------------------------------------------------------------------------
	IF @intNameRankSort > 4200  AND LTRIM(RTRIM(UPPER(@NameNomCode))) != 'ICZN'
		BEGIN 
		IF @intNameRankSort = 5800
			BEGIN
			SET @nvcFullName = '''' + @nvcNameCanonical + ''''
			END
		ELSE
			BEGIN 
			SET @nvcFullName =  @nvcNameRank  + ' ' + @nvcItalic + @nvcNameCanonical + @nvcItalicEnd
			END
		END
	ELSE IF @intNameRankSort > 3000 AND @intNameRankSort < 4200 -- bracket these rows
		BEGIN
		IF (NOT (@nvcNameCanonical IS NULL OR RTrim(@nvcNameCanonical) = ''))
			BEGIN
			SET @nvcFullName = ltrim(@rankNameStr) + @nvcItalic + @nvcNameCanonical + @nvcItalicEnd 
			END
		END
	ELSE
		SET @nvcFullName = @nvcItalic + @nvcNameCanonical + @nvcItalicEnd
	
	-- Author Block ------------------------------------------------------------------------------------
	DECLARE @nvcAuthorBlock nvarchar(500)
	SET @nvcAuthorBlock = ''
	
	-- Authors 
	IF @bitAuthors = 1 
		BEGIN
		-- misapplied
		IF @bitNameMisapplied = 1
			SET @nvcAuthorBlock = ' sensu'
		
		-- Authors
		IF (NOT (@nvcNameAuthors IS NULL OR RTrim(@nvcNameAuthors) = '')) 
			SET @nvcAuthorBlock = @nvcAuthorBlock + ' ' + @nvcNameAuthors
			
		END
	
	-- Literature -----------------------------------------------------------------------------------------
		
	DECLARE @nvcLiterature	nvarchar(1000)
	SET @nvcLiterature = ''
	
						
	IF @bitLiterature = 1 AND @nvcLiteratureKey IS NOT NULL
		BEGIN
		SET @nvcLiterature = dbo.GetLiteratureCitation(@nvcLiteratureKey, 1, 0)
		END
	
	-- year --------------------------------------------------------------------------------------------
	
	IF @bitYear = 1 
		BEGIN
		IF NOT (@nvcYearOf IS NULL OR RTrim(@nvcYearOf) = '') 
			SET @nvcLiterature = @nvcLiterature + ' (' + @nvcYearOf + ')'

		IF (NOT (@nvcYearOn IS NULL OR RTrim(@nvcYearOn) = '')) AND NOT @nvcYearOn = @nvcYearOf
			SET @nvcLiterature = @nvcLiterature + ' [' + @nvcYearOn + ']'
		END
		
	-- Name Calculation --------------------------------------------------------------------------------
		
	-- names <= genus
	IF @intNameRankSort <= 3000 OR @intNameRankSort IS NULL -- genus or less
		BEGIN

		SET @nvcFullName = @nvcFullName + @nvcAuthorBlock
		SET @nvcFullName = @nvcFullName + @nvcLiterature
	    if @status is not null set @nvcFullName = @nvcFullName + ' ' + @status
		RETURN (@nvcFullName)
		END
	
	IF @intParentRankSort = 3000 AND @intNameRankSort = 4200 --most common, speed up by ignoring special cases
		BEGIN
		-- parent name
		IF @intNameRankSort >= 4200 AND NOT (@nvcParentName IS NULL OR RTrim(@nvcParentName) = '')
			SET @nvcFullName = @nvcItalic + @nvcParentName + @nvcItalicEnd + rtrim(@rankNameStr) + ' ' + @nvcFullName
		
		SET @nvcFullName = @nvcFullName + @nvcAuthorBlock
		SET @nvcFullName = @nvcFullName + @nvcLiterature
	    if @status is not null set @nvcFullName = @nvcFullName + ' ' + @status
		RETURN (@nvcFullName)
		END
	
	-- Handle difficult cases
	DECLARE @bitAuthorDone	bit
	SET @bitAuthorDone = 0
	DECLARE @nvcNameCanonicalOriginal		nvarchar(100)
	SET @nvcNameCanonicalOriginal = @nvcNameCanonical

	DECLARE @tblKeysDone	table(NameGuid	uniqueidentifier) -- List of names that have being covered, this is to stop circular references
	INSERT INTO @tblKeysDone(NameGuid) VALUES(@NameGuid) 

	DECLARE @vcNameGuid	uniqueidentifier, @isUnknwon bit
	set @isUnknwon = 0
	
	-- loop till rank <= 3000
	WHILE @isUnknwon = 0 and (NOT @vcParentGuid IS NULL) AND @intNameRankSort > 3000 AND NOT (@vcParentGuid IN (SELECT * FROM @tblKeysDone))
		BEGIN
		SET @vcNameGuid = @vcParentGuid
		INSERT INTO @tblKeysDone(NameGuid) VALUES(@vcNameGuid)
		
		DECLARE @intNameRankFk int
		SET @intNameRankFk = NULL
		
		SELECT 
			@nvcNameCanonical = NameCanonical, 
			@intNameRankSort = RankSort,
			@vcParentGuid = NameParentFk,
			@nvcNameRank = RankAbbreviation,
			@intNameRankFk = NameRankFk,
			@inclRankName = RankIncludeInFullName
		FROM tblName LEFT JOIN tblRank ON RankPk = NameRankFk
		WHERE NameGuid = @vcNameGuid
		
		if (lower(@nvcNameCanonical) = 'unknown')
			set @isUnknwon = 1
		
	    if (@inclRankName = 1) set @rankNameStr = ' ' + @nvcNameRank + ' '
	    else set @rankNameStr = ''
		
		
		IF @intNameRankSort = 4200 AND LTrim(RTrim(@nvcNameCanonicalOriginal)) = LTrim(RTrim(@nvcNameCanonical)) -- Insert Author
			BEGIN
			SET @nvcFullName =  ltrim(@nvcAuthorBlock + ' ' + @nvcFullName)
			SET @bitAuthorDone = 1
			END
		
		IF @intNameRankSort > 3000 AND @intNameRankSort < 4200 -- bracket these rows
			BEGIN
			IF (NOT (@nvcNameCanonical IS NULL OR RTrim(@nvcNameCanonical) = ''))
				BEGIN
				SET @nvcFullName = '(' + ltrim(@rankNameStr) + @nvcItalic + @nvcNameCanonical + @nvcItalicEnd + ')' + ' ' +@nvcFullName 
				END
			END
		ELSE
			BEGIN
			IF (NOT (@nvcNameCanonical IS NULL OR RTrim(@nvcNameCanonical) = ''))
				BEGIN
				
				IF @intNameRankSort > 4200 AND LTRIM(RTRIM(UPPER(@NameNomCode))) != 'ICZN'
					BEGIN 
					IF @inclRankName = 0
						BEGIN
						SET @nvcFullName = '''' + @nvcNameCanonical + ''' ' + @nvcFullName 
						END
					ELSE
						BEGIN 
						SET @nvcFullName = @nvcNameRank  + ' ' + @nvcItalic + @nvcNameCanonical + @nvcItalicEnd +' ' + @nvcFullName 	
						END 
					END
				ELSE
					BEGIN
					SET @nvcFullName = ltrim(@rankNameStr) + @nvcItalic + @nvcNameCanonical + @nvcItalicEnd + ' ' + @nvcFullName 
					END
				END
			END
	
		END -- WHILE
	
	if (@isUnknwon = 1)
	begin
		-- if a child of unknown then just use a provider name full name
		select top 1 @nvcFullName = PNNameFull from tblProviderName where PNNameFk = @nameGuid
	end
	else
	begin
		IF @bitAuthorDone = 0
			SET @nvcFullName = @nvcFullName + @nvcAuthorBlock		
	end

	SET @nvcFullName = @nvcFullName + @nvcLiterature
	
	if @status is not null set @nvcFullName = @nvcFullName + ' ' + @status
	    	    
	RETURN (@nvcFullName)
end

GO


GRANT EXEC ON fnGetFullName TO PUBLIC

GO


