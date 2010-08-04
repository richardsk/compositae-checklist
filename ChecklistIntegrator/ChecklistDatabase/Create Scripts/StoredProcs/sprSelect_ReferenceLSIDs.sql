IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReferenceLSIDs')
	BEGIN
		DROP  Procedure  sprSelect_ReferenceLSIDs
	END

GO

CREATE Procedure sprSelect_ReferenceLSIDs
	@pageNumber int,
	@pageSize int
AS

	create table #ids(row int identity, ReferenceLSID nvarchar(300))
	declare @sql nvarchar(2000)
	
	set @sql = '
		insert #ids
		select top ' + cast(@pageNumber * @pageSize as nvarchar(10)) + ' ReferenceLSID
		from tblReference'
		
	exec(@sql)
	
	select ReferenceLSID from #ids where row > (@pageNumber-1)*@pageSize

GO


GRANT EXEC ON sprSelect_ReferenceLSIDs TO PUBLIC

GO


