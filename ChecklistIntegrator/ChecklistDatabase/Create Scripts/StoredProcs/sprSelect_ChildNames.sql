IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ChildNames')
	BEGIN
		DROP  Procedure  sprSelect_ChildNames
	END

GO

CREATE Procedure sprSelect_ChildNames
	@parentNameGuid uniqueidentifier,
	@recurseChildren bit	
AS

	declare @ranks table(rankPk int)
	declare @res table(NameGuid uniqueidentifier, GotChildren bit)


	--we only want to select recursive children where they have the same rank as any of the immediate children	
	insert @ranks
	select distinct RankPk
	from tblRank
	inner join tblName on NameRankFk = RankPk 
	where NameParentFk = @parentNameGuid

	--get all immediate children
	insert @res
	select NameGuid, null
	from tblName
	where NameParentFk = @parentNameGuid
	
	declare @count int, @lastCount int
	select @count = count(*), @lastCount = 0 from @res
	
	while (@recurseChildren = 1 and @count > @lastCount)
	begin
		set @lastCount = @count
		
		update @res set GotChildren = 1 where GotChildren = 0
		update @res set GotChildren = 0 where GotChildren is null
		
		insert @res
		select n.NameGuid, null
		from tblName n
		inner join @res r on n.NameParentfk = r.NameGuid and r.GotChildren = 0
		inner join @ranks rnk on rnk.RankPk = n.NameRankFk
		
		select @count = count(*) from @res
	end

	select cast(n.NameGUID as varchar(38)) as NameGuid, 
		NameLSID, 
		NameFull, 
		NameRank, 
		NameRankFk, 
		cast(NameParentFk as varchar(38)) as NameParentFk,
		NameParent,
		cast(NamePreferredFk as varchar(38)) as NamePreferredFk,
		NamePreferred,
		NameCanonical, 
		NameAuthors, 
		NameBasionymAuthors, 
		NameCombinationAuthors, 
		NamePublishedIn, 
		cast(NameReferenceFk as varchar(38)) as NameReferenceFk, 
		NameYear, 
		NameMicroReference, 
		NameTypeVoucher, 
		NameTypeName, 
		cast(NameTypeNameFk as varchar(38)) as NameTypeNameFk, 
		NameOrthography, 
		NameBasionym, 
		cast(NameBasionymFk as varchar(38)) as NameBasionymFk, 
		NameBasedOn, 
		cast(NameBasedOnFk as varchar(38)) as NameBasedOnFk, 
		NameConservedAgainst, 
		cast(NameConservedAgainstFk as varchar(38)) as NameConservedAgainstFk, 
		NameHomonymOf, 
		cast(NameHomonymOfFk as varchar(38)) as NameHomonymOfFk, 
		NameReplacementFor, 
		cast(NameReplacementForFk as varchar(38)) as NameReplacementForFk,  
		NameBlocking, 
		cast(NameBlockingFk as varchar(38)) as NameBlockingFk,
		NameInCitation,
		NameInvalid, 
		NameIllegitimate, 
		NameMisapplied, 
		NameProParte, 
		NameNomNotes, 
		NameStatusNotes,
		NameNotes,
		NameCreatedDate, 
		NameCreatedBy, 
		NameUpdatedDate, 
		NameUpdatedBy,
		dbo.fnGetFullName(n.NameGuid, 1,0,1,0,0) as NameFullFormatted,
		NameCounter,
		RankSort
	from tblName n
	inner join @res r on r.NameGuid = n.NameGuid
	inner join tblrank on rankpk = namerankfk
	
GO


GRANT EXEC ON sprSelect_ChildNames TO PUBLIC

GO


