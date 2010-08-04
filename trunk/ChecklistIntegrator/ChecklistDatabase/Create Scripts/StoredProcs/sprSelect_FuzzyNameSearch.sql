IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_FuzzyNameSearch')
	BEGIN
		DROP  Procedure  sprSelect_FuzzyNameSearch
	END

GO

CREATE Procedure sprSelect_FuzzyNameSearch
(
	@searchText nvarchar(300)
)
AS

	set @searchText = ltrim(@searchText)
	set @searchText = rtrim(@searchText)
	
	declare @pos int, @lastPos int, @partialText nvarchar(300)
	set @pos = charindex(' ', @searchText)
	while (@pos <> 0)
	begin
		set @lastPos = @pos
		set @pos = charindex(' ', @searchText, @pos + 1)		
	end
	if (@lastPos <> 0)
	begin
		set @partialText = substring(@searchText, 0, @lastPos)
	end
	print(@partialText)
	
	declare @ids table(id uniqueidentifier, match nvarchar(500))
	
	insert @ids
	select distinct n.nameguid, cn.namefull
	from tblName n 
	inner join tblname cn on cn.nameparentfk = n.nameguid 
	where cn.namefull like '%' + @searchText + '%' 
	union
	select distinct n.nameguid, pn.pnnamefull
	from tblName n 
	inner join tblprovidername pn on pn.pnnamefk = n.nameguid
	where pn.pnnamefull like '%' + @searchText + '%' 
	union
	select distinct n.nameguid, pn.pnnameauthors
	from tblName n 
	inner join tblprovidername pn on pn.pnnamefk = n.nameguid
	where pn.pnnameauthors like '%' + @searchText + '%' 
	union
	select distinct n.nameguid, n.nameorthography
	from tblName n 
	where n.nameorthography like '%' + @searchText + '%' 
	union
	select distinct n.nameguid, n.nameorthography
	from tblName n 
	where n.namefull like '%' + @searchText + '%' or n.namefull like '%' + @partialText + '%'
	
	
	select distinct n.nameguid, 
		n.namerankfk, 
		n.namefull, 
		n.namecanonical, 
		n.nameparent, 
		n.nameauthors, 
		tblrank.*, 
        match as MatchingText 
    from @ids i
    inner join tblName n on n.nameguid = i.id
    inner join tblRank on rankpk = n.namerankfk
    order by RankSort, n.NameFull

GO


GRANT EXEC ON sprSelect_FuzzyNameSearch TO PUBLIC

GO


