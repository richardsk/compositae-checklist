IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRank')
	BEGIN
		DROP  Procedure  sprUpdate_NameRank
	END

GO

CREATE Procedure sprUpdate_NameRank
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update NameRankFk to point to rank in tblRank table (ONLY if currently null)
	-- match on any of the known ranks for each rank
	
	declare  @nRank nvarchar(100), @curRankFk int
	
	select @nRank = lower(NameRank), @curRankFk = NameRankFk
	from tblName 
	where NameGuid = @nameGuid
	
	if (@curRankFk is not null) 
	begin
		select @curRankFk
		return
	end
	
	declare @ranks table(Counter int identity, RankPk int, KnownRanks nvarchar(500))
		
	
	insert into @ranks
	select RankPk, '@' + RankKnownAbbreviations + '@'
	from tblRank
		
	declare @pos int, @count int, @abbrevs nvarchar(500), @pk int, @setRank int
	select @pos = 1, @count = count(*) from @ranks
	
	while (@pos < @count + 1)
	begin
		select @abbrevs = KnownRanks, @pk = RankPk from @ranks where Counter = @pos
		
		if (charindex('@' + @nRank + '@', @abbrevs) <> 0)
		begin			
			update tblName 
			set NameRankFk = @Pk, NameUpdatedDate = getdate(), NameUpdatedBy = @user
			where NameGuid = @nameGuid
			
			set @setRank = @Pk
			set @count = -1 --end loop			
		end
		
		set @pos = @pos + 1
	end
	
	select @setRank

GO


GRANT EXEC ON sprUpdate_NameRank TO PUBLIC

GO


