 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ChildrenAtRank')
	BEGIN
		DROP  Procedure  sprSelect_ChildrenAtRank
	END

GO

CREATE Procedure sprSelect_ChildrenAtRank
	@nameGuid uniqueidentifier,
	@rank nvarchar(50)
AS
	
	declare @names table(rowid int identity, nameguid uniqueidentifier, namecanonical nvarchar(300),
			namefull nvarchar(300), namerank nvarchar(100), nameauthors nvarchar(300),
			nameyear nvarchar(50))
			
	insert @names
	select nameguid, namecanonical, namefull, rankname, nameauthors, nameyear
	from tblrank
	inner join tblname on namerankfk = rankpk
	where nameguid = @nameGuid
	
	
	declare @pos int, @last int, @n uniqueidentifier, @r nvarchar(50)
	select @pos = min(rowId) from @names
	select @last = max(rowId) from @names
	
	while (@pos <= @last)
	begin
	print(@pos)
		if (exists(select * from @names where rowid = @pos and namerank <> @rank))
		begin
			select @n = nameGuid, @r = namerank from @names where rowId = @pos
			print(@r)
			if (@r <> @rank)
			begin
				insert @names
				select nameguid, namecanonical, namefull, rankname, nameauthors, nameyear
				from tblrank
				inner join tblname on namerankfk = rankpk
				where nameparentfk = @n
				
				delete @names where nameguid = @n
			end
		end
		
		set @pos = @pos + 1
		select @last = max(rowId) from @names
		
	end
				
	select * from @names
	

GO


GRANT EXEC ON sprSelect_ChildrenAtRank TO PUBLIC

GO


