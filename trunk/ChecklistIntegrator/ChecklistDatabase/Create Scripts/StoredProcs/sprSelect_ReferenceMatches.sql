IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReferenceMatches')
	BEGIN
		DROP  Procedure  sprSelect_ReferenceMatches
	END

GO

CREATE Procedure sprSelect_ReferenceMatches
	@providerReferencePk int,
	@matchRuleSet int
AS

	delete tmpMatchResults
		
	
	--execute each match function until either no records in tmpMatchResults or end of match set
		
	declare @matchFuncs table(MatchPk int, MatchFunction nvarchar(1000), Threshold int, PassFk int)
	
	insert into @matchFuncs
	select MatchPk, MatchFunction, MatchThreshold, MatchPassFk
	from tblMatch
	where MatchRuleSet = @matchRuleSet
	order by MatchFirst desc
	
	declare @finished bit, @func nvarchar(1000), @pk int, @passFk int, @thHold int, @count int
	set @finished = 0
	select top 1 @pk = MatchPk from @matchFuncs
	
	while (@finished = 0)
	begin
		select @pk = MatchPk, @func = MatchFunction, @thHold = Threshold, @passFk = PassFk
		from @matchFuncs 
		where MatchPk = @pk
		
		--build up stored proc call
		declare @spCall nvarchar(4000)				
		set @spCall = 'exec ' + @func + ' ' + cast(@providerReferencePk as nvarchar(50)) + ', ' + cast(@thHold as varchar(10))
		--todo other params, are they required?
		print(@spCall)
		exec(@spCall)						
		
		select @count = count(*) from tmpMatchResults
		
		if (@count = 0) set @finished = 1				
		else set @pk = @passFk
		if (@pk is null) set @finished = 1
	end
	
	--return remaining matching refs
	select cast(ReferenceGUID as nvarchar(38)) as ReferenceGuid,
		ReferenceLSID,
		ReferenceCitation,
		ReferenceFullCitation,
		ReferenceCreatedDate,
		ReferenceCreatedBy,
		ReferenceUpdatedDate,
		ReferenceUpdatedBy
	from tblReference r
	inner join tmpMatchResults mr on mr.MatchResultRecordId = r.ReferenceGuid
	
	

GO


GRANT EXEC ON sprSelect_ReferenceMatches TO PUBLIC

GO


