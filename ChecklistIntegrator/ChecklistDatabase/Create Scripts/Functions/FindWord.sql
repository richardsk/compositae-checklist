 SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FindWord]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[FindWord]
GO

CREATE FUNCTION dbo.FindWord
	(	
	@nvcWord nvarchar(100),
	@nvcText nvarchar(100),
	@bitAnywhere	bit,
	@bitWholeWord	bit
	)
RETURNS bit
AS
	BEGIN
		
	IF  (@nvcWord IS NULL) OR (@nvcText IS NULL) 
		BEGIN
		RETURN 0
		END
		
	IF  @nvcWord = ''
		BEGIN
		RETURN 1
		END
 
	DECLARE	@Temp	nvarchar(100)
	DECLARE @WordLength INT
	DECLARE @TextLength INT
	SET @WordLength = LEN(@nvcWord)
	SET @TextLength = LEN(@nvcText)
 
	IF  @WordLength = 0 OR @TextLength = 0
		BEGIN
		RETURN 0
		END
	DECLARE @WordIndex	INT
	SET @WordIndex = CHARINDEX(@nvcWord, @nvcText)
	
	IF  @WordIndex <= 0
		BEGIN
		RETURN 0
		END
		
	IF @bitAnywhere = 0 AND @WordIndex <> 1
		BEGIN
		RETURN 0
		END	
		
	IF @bitWholeWord = 0 
		BEGIN
		RETURN 1
		END	
		
	DECLARE @BeforeWordIndex	INT	
	DECLARE @AfterWordIndex	INT
	DECLARE @c char		
	DECLARE @Continue BIT
	SET @Continue = 1
			
	WHILE @WordIndex > 0 AND @Continue = 1
		BEGIN
		--check character before start
		SET @Continue = 0
		
		SET @BeforeWordIndex = @WordIndex - 1
	    
		IF @BeforeWordIndex > 0 
			BEGIN
			SET @Temp = SUBSTRING(@nvcText, @BeforeWordIndex, 1)
			SET @c = CAST(@Temp as CHAR)
			IF dbo.IsNotLetterOrDigit(@c) = 0
				BEGIN
				SET @Continue = 1
				END
			END 
		
		SET @AfterWordIndex = @WordIndex + @WordLength
	    
		IF @AfterWordIndex <= @TextLength
			BEGIN
			SET @Temp = SUBSTRING(@nvcText, @AfterWordIndex, 1)
			SET @c = CAST(@Temp as CHAR)
			IF dbo.IsNotLetterOrDigit(@c) = 0
				BEGIN
				SET @Continue = 1
				END
			END 
		
		IF  @Continue = 0
			BEGIN
			RETURN 1
			END
		
		IF @bitAnywhere = 0
			BEGIN
			RETURN 0
			END
		
		SET @Continue = 1
		
		SET @WordIndex = CHARINDEX(@nvcWord, @nvcText, @WordIndex + @WordLength)
		IF  @WordIndex <= 0
			BEGIN
			RETURN 0
			END
		END
	
	RETURN 0 
	END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

