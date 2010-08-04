IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprCalculateMatchScore')
	BEGIN
		DROP  Procedure  sprCalculateMatchScore
	END

GO

CREATE Procedure sprCalculateMatchScore
(
	@PNPk int
)
AS

	--calculate percent of fields that are the same as the consensus record
	-- multiply by the weighting in the mapping table
	
	declare @result int
	declare @fields table(counter int identity, pnField nvarchar(100), nameField nvarchar(100), weight int)
	
	insert @fields
	select NameMappingSourceCol, NameMappingDestCol, NAmeMappingMatchWeighting
	from tblNameMapping
	
	declare @pos int, @count int, @sql nvarchar(1000), @pnf nvarchar(100), @nf nvarchar(100), @wt int
	select @pos = 1, @count = count(*) from @fields

	delete tmpMatchScore
	insert tmpMatchScore select 0
	
	while (@pos <= @count)
	begin
		select @pnf = pnField, @nf = nameField, @wt = weight from @fields where counter = @pos
		
		set @sql = 'update tmpMatchScore set PercentMatch = '
		set @sql = @sql + '(case when ' + @pnf + ' like ' + @nf + ' then 0 '
		set @sql = @sql + ' when ' + @pnf + ' is null and ' + @nf + ' is null then 0 '
		set @sql = @sql + ' else 1 end) * ' + cast(isnull(@wt, 1) as varchar(50)) + ' + PercentMatch'
		set @sql = @sql + ' from tblProviderName inner join tblName on NameGuid = PNNameFk where PNPk = ' + cast(@pnpk as varchar(50))
		
		exec (@sql)
		
		set @pos = @pos + 1
	end
	
	update tmpMatchScore
	set PercentMatch = 100 - (PercentMatch * 100 / @count) 
	

GO


GRANT EXEC ON sprCalculateMatchScore TO PUBLIC

GO


