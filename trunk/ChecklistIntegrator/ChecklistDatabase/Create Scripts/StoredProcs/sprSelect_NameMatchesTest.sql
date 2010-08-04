IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameMatchesTest')
	BEGIN
		DROP  Procedure  sprSelect_NameMatchesTest
	END

GO

CREATE Procedure sprSelect_NameMatchesTest
	@providerNamePk int
AS
set nocount ON
	delete tmpMatchResults
	
	--get match rule set for rank of this name
	declare @matchId nvarchar(50)
	select @matchId = RankMatchRuleSetFk
	from tblProviderName pn 
	inner join tblRank r on r.RankPk = pn.PNNameRankFk
	where pn.PNPk = @providerNamePk 
		
	--execute each match function until either no records in tmpMatchResults or end of match set
		
	declare @matchFuncs table(MatchPk int, MatchFunction nvarchar(1000), Threshold int, PassFk int, FailFk int)
	
	insert into @matchFuncs
	select MatchPk, MatchFunction, MatchThreshold, MatchPassFk, MatchFailFk
	from tblMatch
	where MatchRuleSet = @matchId
	order by MatchFirst desc
	
	declare @finished bit, @func nvarchar(1000), @pk int, @passFk int, @failFk int, @thHold int, @count int
	set @finished = 0
	select top 1 @pk = MatchPk from @matchFuncs
	
	
	create table #tmpRes(recId nvarchar(300), matchScore int)
	
	declare @dispName nvarchar(500)
	select @dispName = pnnamefull from tblprovidername where pnpk = @providernamepk
	print (@dispName)
			
	while (@finished = 0)
	begin	
		select @pk = MatchPk, @func = MatchFunction, @thHold = Threshold, @passFk = PassFk, @failFk = FailFk
		from @matchFuncs 
		where MatchPk = @pk
	
		update tmpIntegration
		set SPTrace = isnull(SPTrace + ', ', '') + @func 
		where RecordId = @providerNamePk
	
		--tmp store current results
		delete #tmpRes
		insert #tmpRes select * from tmpMatchResults
			
		--build up stored proc call
		declare @spCall nvarchar(4000)
		set @spCall = 'exec ' + @func + ' ' + cast(@providerNamePk as nvarchar(50)) + ', ' + cast(@thHold as varchar(10)) 
		--todo other params, are they required?
		print(@spCall)
		exec(@spCall)						
			
		select @count = count(*) from tmpMatchResults
		declare @resNum nvarchar(100)
		set @resNum = 'results = ' + cast(@count as nvarchar(20))
		print(@resNum)
		if (@count < 10)
		begin
			select @spCall, n1.NameGuid, n1.NameFull from tmpMatchResults as tm inner join tblName as n1
				on tm.MatchResultRecordId = n1.NameGuid
		end
		if (@count = 0) 
		begin

			
			-- if failed then restore previous results, then continue to the failFk match row
			set @pk = @failFk
			if (@pk is not null)
			begin
				insert tmpMatchResults
				select * from #tmpRes
			end
		end
		else set @pk = @passFk
		
		if (@pk is null) set @finished = 1
	end
	
	--return remaining matching names
	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		n.NameLSID, 
		n.NameFull, 
		n.NameRank, 
		n.NameRankFk, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
		n.NameCanonical, 
		n.NameAuthors, 
		n.NameBasionymAuthors, 
		n.NameCombinationAuthors, 
		n.NamePublishedIn, 
		cast(n.NameReferenceFk as varchar(38)) as NameReferenceFk, 
		n.NameYear, 
		n.NameMicroReference, 
		n.NameTypeVoucher, 
		n.NameTypeName, 
		cast(n.NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		n.NameOrthography, 
		n.NameBasionym, 
		cast(n.NameBasionymFk as varchar(38)) as NameBasionymFk, 
		n.NameBasedOn, 
		cast(n.NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		n.NameConservedAgainst, 
		cast(n.NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		n.NameHomonymOf, 
		cast(n.NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		n.NameReplacementFor, 
		cast(n.NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
		n.NameInCitation,
		n.NameInvalid, 
		n.NameIllegitimate, 
		n.NameMisapplied, 
		n.NameProParte, 		
		n.NameNomNotes, 
		n.NameStatusNotes,
		n.NameNotes,
		n.NameCreatedDate, 
		n.NameCreatedBy, 
		n.NameUpdatedDate, 
		n.NameUpdatedBy,
		dbo.fnGetFullName(NameGuid, 1,0,1,0,0) as NameFullFormatted,
		NameCounter
	from tblName n
	inner join tmpMatchResults r on r.MatchResultRecordId = N.NameGuid

	select avg(MatchResultScore) as MatchScore from tmpMatchResults

GO


GRANT EXEC ON sprSelect_NameMatchesTest TO PUBLIC

GO


