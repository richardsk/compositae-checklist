IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameLSIDs')
	BEGIN
		DROP  Procedure  sprSelect_NameLSIDs
	END

GO

CREATE Procedure sprSelect_NameLSIDs
	@pageNumber int,
	@pageSize int
AS

	create table #ids(row int identity, NameLSID nvarchar(300))
	declare @sql nvarchar(2000)
	
	set @sql = '
		insert #ids
		select top ' + cast(@pageNumber * @pageSize as nvarchar(10)) + ' NameLSID
		from tblName'
		
	exec(@sql)
	
	select NameLSID from #ids where row > (@pageNumber-1)*@pageSize

GO


GRANT EXEC ON sprSelect_NameLSIDs TO PUBLIC

GO


