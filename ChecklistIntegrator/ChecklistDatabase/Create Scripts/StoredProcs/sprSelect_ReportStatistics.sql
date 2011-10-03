IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportStatistics')
	BEGIN
		DROP  Procedure  sprSelect_ReportStatistics
	END

GO

CREATE Procedure sprSelect_ReportStatistics
	
AS
	
	declare @res table(recordId nvarchar(300), recordDetails nvarchar(3000), recordType nvarchar(50), TableName nvarchar(100))
	
	declare @total int, @guidValid int, @confCount int, @unlinked int, @provCount int, @compl real
	declare @sysCount int

	declare @ranks table(row int identity, id int, rankname nvarchar(255))
	insert @ranks
	select rankpk, rankname 
	from tblrank
	order by ranksort
	
	select @provCount = count(*)
	from tblProviderName 
	where PNLinkStatus <> 'Discarded'
	
	/*select @provCount = @provCount + count(*)
	from tblProviderConcept
	where PCLinkStatus <> 'Discarded'
	
	select @provCount = @provCount + count(*)
	from tblProviderReference
	where PRLinkStatus <> 'Discarded'*/
	
	insert @res select null, 'Total Provider Records : ' + cast(@provCount as nvarchar(100)), null, null

	select @sysCount = count(*)
	from vwProviderName
	where ProviderName = 'SYSTEM'
	insert @res select null, 'Total SYSTEM Records : ' + cast(@sysCount as nvarchar(100)), null, null

	--editor records
	select @sysCount = count(*)
	from vwProviderName
	where ProviderIsEditor = 1
	insert @res select null, 'Total Editor Records : ' + cast(@sysCount as nvarchar(100)), null, null

	
	--total cons. names
	select @total = count(*) from tblname where NameFull <> 'root'
	
	insert @res select null, 'Total consensus Names : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	declare @pos int, @rankname nvarchar(200), @rankid int
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid
		
		if (@total > 0)
			insert @res select null, 'Total consensus Names (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--total accepted names
	select @total = count(*) from tblname where NameFull <> 'root'
		and namepreferredfk = nameguid
	
	insert @res select null, 'Total accepted Names : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid 
			and namepreferredfk = nameguid
		
		if (@total > 0)
			insert @res select null, 'Total accepted Names (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--total synonyms
	select @total = count(*) from tblname where NameFull <> 'root'
		and namepreferredfk <> nameguid
	
	insert @res select null, 'Total synonyms : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(*) from tblname 
		where NameFull <> 'root' and namerankfk = @rankid 
			and namepreferredfk <> nameguid
		
		if (@total > 0)
			insert @res select null, 'Total synonyms (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	--average prov names
	declare @avg int
	select @avg = avg(res.c) from (select count(pnpk) as c
		from tblname 
		inner join tblprovidername on pnnamefk = nameguid
		group by nameguid) res
		
	
	insert @res select null, 'Total average prov. names : ' + cast(@avg as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @avg = avg(res.c) from (select count(pnpk) as c
			from tblname 
			inner join tblprovidername on pnnamefk = nameguid
			where namerankfk = @rankid
			group by nameguid) res
		
		if (@total > 0)
			insert @res select null, 'Total average prov. names (at Rank ' + @rankname + ') : ' + cast(@avg as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	--average synonyms
	select @avg = avg(res.c) from (select count(s.nameguid) as c
		from tblname n
		inner join tblname s on s.namepreferredfk = n.nameguid
		where n.namepreferredfk = n.nameguid
		group by n.nameguid) res
	
	insert @res select null, 'Total average prov. names : ' + cast(@avg as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @avg = avg(res.c) from (select count(s.nameguid) as c
			from tblname n
			inner join tblname s on s.namepreferredfk = n.nameguid
			where n.namepreferredfk = n.nameguid and n.namerankfk = @rankid			
			group by n.nameguid) res
		
		if (@total > 0)
			insert @res select null, 'Total average prov. names (at Rank ' + @rankname + ') : ' + cast(@avg as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--AUTHORS - TODO - check they are correct
	select @total = count(nameguid)
	from tblname
	inner join tblnameauthors on nameauthorsnamefk = nameguid
	inner join tblprovidername on pnnamefk = nameguid
	inner join tblprovidernameauthors on pnaprovidernamefk = pnpk
	where isnull(nameauthorsbasionymauthors,'') <> isnull(pnabasionymauthors,'')
		or isnull(nameauthorscombinationauthors,'') <> isnull(pnacombinationauthors,'')
	
	insert @res select null, 'Total names with corrected authors : ' + cast(@total as nvarchar(100)), null, null
	
	
	select @total = count(n.nameguid)	
	/*select n.nameguid, n.namefull, n.namecanonical, par.namefull as Parent, 
		pn.pnnamefull, pn.pnnamecanonical, pn2.pnnamefull as provParent*/
	from tblname n
	inner join tblName par on par.nameguid = n.nameparentfk
	inner join vwprovidername pn on pn.pnnamecanonical = n.namecanonical and pn.pnnamerankfk = n.namerankfk
	inner join vwproviderconceptrelationship pcr on pcr.pcname1id = pn.pnnameid 
		and pcr.providerpk = pn.providerpk
	inner join vwprovidername pn2 on pn2.pnnameid = pcr.pcname2id 
		and pn2.providerpk = pcr.providerpk
	where pn2.pnnamecanonical = par.namecanonical and pn2.pnnamerankfk = par.namerankfk
		and pn.pnnamefk <> n.nameguid and n.nameauthors <> pn.pnnameauthors
	
	insert @res select null, 'Total names with un-corrected authors : ' + cast(@total as nvarchar(100)), null, null
	
	
	--number of homonyms
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(n.nameguid) / 2
			from tblname n
			inner join tblname p on p.nameguid = n.nameparentfk
			inner join tblname n2 on n2.namecanonical = n.namecanonical and n2.nameguid <> n.nameguid
			inner join tblname p2 on p2.nameguid = n2.nameparentfk and p2.namecanonical = p.namecanonical
			where n.namerankfk = @rankid and n2.namerankfk = @rankid
		
		insert @res select null, 'Total homonyms (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--names with dist. data
	
	select @total = count(distinct nameguid)
	from tblname 
	inner join tblotherdata on recordfk = nameguid
	where otherdatatypefk = 2	
	
	insert @res select null, 'Number of names with distribution data : ' + cast(@total as nvarchar(100)), null, null
	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(otherdatapk)
			from tblname n
			inner join tblotherdata on recordfk = nameguid
			where n.namerankfk = @rankid and otherdatatypefk = 2
		
		insert @res select null, 'Total count of distribution data (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	--concept conflicts	
	--loop through ranks
	
	select top 1 @rankId = id, @rankname = rankname, @pos = 1
	from @ranks
	where row = 1
	
	while (@rankId is not null)
	begin		
		select @total = count(n.nameguid)
		from tblname n
		inner join tblconcept c1 on c1.conceptname1fk = n.nameguid
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk
		left join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where conceptrelationshiprelationship = 'is child of' 
			and c2.conceptname1fk <> nameparentfk
			and n.namerankfk = @rankid 
			
		select @total = @total + count(n.nameguid)
		from tblname n
		inner join tblconcept c1 on c1.conceptname1fk = n.nameguid
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk
		left join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where conceptrelationshiprelationship = 'has preferred name' 
			and c2.conceptname1fk <> namepreferredfk
			and n.namerankfk = @rankid 
		
		insert @res select null, 'Total names with concept conflict (at Rank ' + @rankname + ') : ' + cast(@total as nvarchar(100)), null, null
		
		set @pos = @pos + 1
		
		set @rankid = null
		select top 1 @rankId = id, @rankname = rankname
		from @ranks
		where row = @pos
	end
	
	
	
	
	select r.*
	from @res r
	left join tblReportError re on re.ReportErrorRecordFk = r.RecordId and re.ReportErrorStatusFk = 3 and re.ReportErrorTable = r.TableName
	where re.ReportErrorPk is null
	order by recordType, recordId

GO


GRANT EXEC ON sprSelect_ReportStatistics TO PUBLIC

GO


  