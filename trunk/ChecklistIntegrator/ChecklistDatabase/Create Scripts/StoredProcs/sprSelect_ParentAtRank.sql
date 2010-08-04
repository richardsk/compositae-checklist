 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ParentAtRank')
	BEGIN
		DROP  Procedure  sprSelect_ParentAtRank
	END

GO

CREATE Procedure sprSelect_ParentAtRank
	@nameGuid uniqueidentifier,
	@rank nvarchar(50)
AS
	
	declare @thisrank nvarchar(50), @parid uniqueidentifier
	
	select @thisrank = rankname, @parid = nameparentfk
	from tblname
	inner join tblrank on rankpk = namerankfk
	where nameguid = @nameguid
		
	while (@thisrank <> @rank and @nameguid is not null)
	begin		
		set @nameguid = null
		select @thisrank = rankname, @nameguid = nameguid, @parid = nameparentfk
		from tblname
		inner join tblrank on rankpk = namerankfk
		where nameguid = @parid
	end
	
	select @nameguid

GO


GRANT EXEC ON sprSelect_ParentAtRank TO PUBLIC

GO


 