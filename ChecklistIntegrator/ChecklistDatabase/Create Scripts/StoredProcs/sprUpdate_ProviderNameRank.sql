IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ProviderNameRank')
	BEGIN
		DROP  Procedure  sprUpdate_ProviderNameRank
	END

GO

CREATE Procedure sprUpdate_ProviderNameRank
	@providerNamePk int,
	@user nvarchar(50)
AS

	--update ProviderNameRankFk to point to rank in tblRank table
	-- match on any of the known ranks for each rank
	
	exec sprInsert_ProviderNameChange @providerNamePk, @user
	
	declare  @pnRank nvarchar(100), @curRankFk int
	
	select @pnRank = rtrim(ltrim(lower(PNNameRank))), @curRankFk = PNNameRankFk
	from tblProviderName 
	where PNPk = @providerNamePk

	if (@curRankFk is not null) 
	begin
		select @curRankFk
		return
	end
	
	if (substring(@pnRank, len(@pnrank) - 1, 1) = '.')
	begin
		set @pnRank = SUBSTRING(@pnRank, 1, len(@pnRank) - 1)
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
		
		if (charindex('@' + @pnRank + '@', @abbrevs) <> 0)
		begin
			update tblProviderName 
			set PNNameRankFk = @Pk, PNUpdatedDate = getdate(), PNUpdatedBy = @user
			where PNPk = @providerNamePk
			
			set @setRank = @Pk
			set @count = -1 --end loop			
		end
		
		set @pos = @pos + 1
	end
	
	select @setRank
	
GO


GRANT EXEC ON sprUpdate_ProviderNameRank TO PUBLIC

GO


