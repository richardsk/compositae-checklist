--need to repeat the following bit for as many users as you want to add - replace all the funkv with User Login and replace other details
if (not exists(select * from tblname where userlogin = 'funkv'))
begin
	insert tbluser select 'funkv', null, 'Vicki Funk', 'funkv@si.edu'
	insert tbluserprovider select (select userpk from tbluser where userlogin = 'funkv'), 31
end


go

if (not exists(select * from tblproviderimport where providerimportproviderpk = 31))
begin
	insert tblproviderimport
	select 31, null, null, 'System', null, null, null, null, null, null, null, null, null, null
end

 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithSameBasionym')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithSameBasionym
	END

GO

CREATE Procedure sprSelect_NamesWithSameBasionym
	@nameguid uniqueidentifier
AS

	declare @basGuid uniqueidentifier
	
	select @basGuid = NameBasionymFk from tblName where NameGuid = @nameGuid
	
	select cast(NameGUID as varchar(38)) as NameGuid, 
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
		dbo.fnGetFullName(NameGuid, 1,0,1,0,0) as NameFullFormatted
	from tblName 
	where (@basGuid is not null and (NameBasionymFk = @basGuid or NameGuid = @basGuid))

GO


GRANT EXEC ON sprSelect_NamesWithSameBasionym TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_StandardXmlForConsensus')
	BEGIN
		DROP  Procedure  sprSelect_StandardXmlForConsensus
	END

GO

CREATE Procedure sprSelect_StandardXmlForConsensus
	@nameGuid uniqueidentifier,
	@otherDataTypeFk int
AS


	select Provider.ProviderPK id, Provider.ProviderName as [name],
		(select so2.StandardXML from tblStandardOutput so2 where so2.StandardOutputPK = so.StandardOutputPK)
	from tblProvider Provider 
		inner join tblProviderImport pri on Provider.ProviderPK = pri.ProviderImportProviderFK
		inner join tblProviderName pn on pn.PNProviderImportFK = pri.ProviderImportPK
		inner join vwProviderOtherData po on pn.PNNameId = po.POtherDataRecordId and provider.ProviderPK = po.ProviderPk and po.OutputTypeFk = @otherDataTypeFk
		inner join tblStandardOutput so on po.POtherDataTextPk = so.POtherDataFK		
	where pn.pnnamefk=@nameGuid and so.othertypefk = @otherDataTypeFk
	for xml auto, root('DataSet'), type

GO


GRANT EXEC ON sprSelect_StandardXmlForConsensus TO PUBLIC

GO
	
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherData')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherData
	END

GO

CREATE Procedure sprInsertUpdate_OtherData
	@otherDataPk uniqueidentifier,
	@otherDataTypeFk int,
	@recordFk nvarchar(300),
	@xml nvarchar(max),
	@data nvarchar(max),
	@user nvarchar(50)
AS

	if (@otherDataPk is null or not exists(select * from tblOtherData where OtherDataPk = @otherDataPk))
	begin
		--check if a record for this name and data type already exists
		select @otherDataPk = OtherDataPk from tblOtherData where RecordFk = @recordFk and OtherDataTypeFk = @otherDataTypeFk
		
		if (@otherDataPk is null)
		begin
			set @otherDataPk = newid()
			
			insert tblOtherData
			select @otherDataPk,
				@otherDataTypeFk,
				@recordFk,
				@xml, 
				@data,
				@user,
				getdate(),
				null, null					
		end
		else
		begin
			update tblOtherData
			set OtherDataTypeFk = @otherDataTypeFk,
				RecordFk = @recordFk,
				OtherDataXml = @Xml,
				OtherDataData = @data,
				UpdatedBy = @user,
				UpdatedDate = getdate()
			where OtherDataPk = @otherDataPk
		end
	end
	else
	begin
		update tblOtherData
		set OtherDataTypeFk = @otherDataTypeFk,
			RecordFk = @recordFk,
			OtherDataXml = @Xml,
			OtherDataData = @data,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where OtherDataPk = @otherDataPk
			
	end
	
	
	--all standard output for this name and tpye will point to this record
	--update so
	--set OtherDataFk = @otherDataPk
	--from tblStandardOutput so	
	--left join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	--left join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
	--where pn.PNNameFk = @recordFk and so.OtherTypeFk = @otherDataTypeFk
	
	
	select * from tblOtherData where OtherDataPk = @otherDataPk

GO


GRANT EXEC ON sprInsertUpdate_OtherData TO PUBLIC

GO


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
		inner join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
		where conceptrelationshiprelationship = 'is child of' 
			and c2.conceptname1fk <> nameparentfk
			and n.namerankfk = @rankid 
			
		select @total = @total + count(n.nameguid)
		from tblname n
		inner join tblconcept c1 on c1.conceptname1fk = n.nameguid
		inner join tblconceptrelationship on conceptrelationshipconcept1fk = c1.conceptpk
		inner join tblconcept c2 on c2.conceptpk = conceptrelationshipconcept2fk 
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


  IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportNamesList')
	BEGIN
		DROP  Procedure  sprSelect_ReportNamesList
	END

GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportNamesList')
	BEGIN
		DROP  Procedure  sprSelect_ReportNamesList
	END

GO

CREATE Procedure sprSelect_ReportNamesList
	@nameIds nvarchar(max),
	@showConflicts bit
AS


	declare @pos int, @lastPos int, @id nvarchar(100)
	declare @ids table(id uniqueidentifier)
	set @pos = CHARINDEX(',', @nameids)
	set @lastPos = 0
	while (@pos <> 0)
	begin
		set @id = SUBSTRING(@nameids, @lastpos, @pos - @lastpos)
		print(@id)
		insert @ids
		select @id
		
		set @lastPos = @pos + 1
		set @pos = CHARINDEX(',', @nameids, @lastpos)
	end

	if (LEN(@nameids) > 0)
	begin
		if (@lastPos > 0) 
		begin
			set @id = SUBSTRING(@nameids, @lastpos, len(@nameids))
			insert @ids select @id
		end
		else
		begin
			insert @ids select @nameids
		end
	end


	if (@showConflicts = 1)
	begin
		select distinct n.nameguid, n.namefull, n.namepreferredfk, 
			n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied,
			n.namepublishedin, n.nameorthography, 
			n.namebasionymauthors, n.namecombinationauthors,
			n.NamePreferred,  
			dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted,
			RankSort,
			case when pcr.PCName2 <> n.NamePreferred then '1' else '0' end as hasConf,
			case when cn.NamePreferredFk <> cn.NameGUID then '1' else '0' end as hasPrefNameIncons,
			case when exists(select top 1 ssn.NameGUID
				from tblname sn 
				inner join tblName ssn on ssn.NamePreferredFk = sn.NameGUID and ssn.NameGUID <> sn.NameGUID
				where sn.namepreferredfk = n.NameGUID and sn.NameGUID <> n.NameGUID
				) then '1' else '0' end as hasSynonymIncons,
			'Data Providers : ' + dbo.fnGetProviderTitles(n.nameguid) as DataProviders
		from @ids id 
		inner join tblName n on id.id = n.nameguid
		inner join tblrank r on r.rankpk = n.namerankfk
		left join tblName cn on cn.NameGUID = n.NamePreferredFk and cn.NameGUID <> n.NameGUID
		inner join tblProviderName pn on pn.pnnamefk = n.nameguid  
		inner join tblProviderImport pim on pim.ProviderImportPk = pn.pnproviderimportfk  
		inner join tblProvider p on p.providerpk = pim.providerimportproviderfk  
		left join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId and pcr.ProviderPk = p.ProviderPk
	end
	else
	begin
		select distinct n.nameguid, n.namefull, n.namepreferredfk, 
			n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied,
			n.namepublishedin, n.nameorthography, 
			n.namebasionymauthors, n.namecombinationauthors,
			n.NamePreferred,  
			dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted,
			RankSort,
			'Data Providers : ' + dbo.fnGetProviderTitles(n.nameguid) as DataProviders
		from @ids id 
		inner join tblName n on id.id = n.nameguid
		inner join tblrank r on r.rankpk = n.namerankfk
	end

go

GRANT EXEC ON sprSelect_ReportNamesList TO PUBLIC


GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameContributors')
	BEGIN
		DROP  Procedure  sprSelect_NameContributors
	END

GO

CREATE Procedure sprSelect_NameContributors
	@nameGuid uniqueidentifier 
AS

select distinct userfullname
from tblprovidername_change
inner join tbluser on userlogin = changedby 
where pnnamefk = @nameGuid

GO


GRANT EXEC ON sprSelect_NameContributors TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsert_ConceptRelationship')
	BEGIN
		DROP  Procedure  dbo.sprInsert_ConceptRelationship
	END

GO

CREATE Procedure dbo.sprInsert_ConceptRelationship
	@PCRPk int,
	@user nvarchar(50),
	@conceptRelGuid uniqueidentifier output
AS
	--inserts a ConceptRelationship if an equivalent doesnt already exist
	-- inserts Concepts for the relationship if they dont exist
	-- if the PCR was already pointing at a consensus CR then it may need to be unlinked

	declare @concept1Id nvarchar(300), @concept2Id nvarchar(300), @providerPk int
	declare @relationship nvarchar(300), @relationshipFk int, @oldCRGuid uniqueidentifier
	declare @hybridOrder int
	declare @name1 nvarchar(4000), @name2 nvarchar(4000) 
	declare @accordingTo nvarchar(4000) 
	declare @name1Fk uniqueidentifier, @name2Fk uniqueidentifier, @accToFk uniqueidentifier
	declare @PCPk1 int, @PCPk2 int
	declare @conceptPk int, @conceptToPk int
	declare @pcLinkStatus nvarchar(20), @pcToLinkStatus nvarchar(20), @pcrLinkStatus nvarchar(20)
	declare @oldLSID nvarchar(300), @newLSID nvarchar(300)
	set @pcLinkStatus = 'Matched'
	set @pcToLinkStatus = 'Matched'
	set @pcrLinkStatus = 'Matched'
		
	select @concept1Id = PCRConcept1Id, @concept2Id = PCRConcept2Id, @relationship = PCRRelationship,
		@relationshipFk = PCRRelationshipFk, @hybridOrder = PCRHybridOrder, @providerPk = ProviderPk,
		@oldCRGuid = PCRConceptRelationshipFk
	from vwProviderConceptRelationship
	where PCRPk = @PCRPk
	
	--get fks for names and ref (the ProviderName and Providerref Ids are passed into this SP)
	select @name1Fk = PNNameFk, @name1 = NameFull, @PCPk1 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
	
	select @name2Fk = PNNameFk, @name2 = NameFull, @PCPk2 = pc.PCPk
	from vwProviderName pn
	inner join tblName n on n.NameGuid = pn.PNNameFk
	inner join vwProviderConcept pc on (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1) and pc.PCName1Id = pn.PNNameId
	where PCConceptId = @concept2Id and pc.ProviderPk = @providerPk
	
	select @accToFk = PRReferenceFk, @accordingto = PCAccordingTo
	from vwProviderReference pr
	inner join vwProviderConcept pc on (pc.ProviderPk = pr.ProviderPk or pc.provideriseditor = 1) and pc.PCAccordingToId = pr.PRReferenceId
	where pc.PCConceptId = @concept1Id and pc.ProviderPk = @providerPk
		
	--only insert if names have been inserted
	if (@name1Fk is not null and @name2Fk is not null)
	begin
		
		declare @tmpId uniqueidentifier
		set @tmpId = newid()
		
		select top 1 @conceptPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name1Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
		
		select top 1 @conceptToPk = ConceptPk
		from tblConcept 
		where ConceptName1Fk = @name2Fk and isnull(ConceptAccordingToFk, @tmpId) = isnull(@accToFk, @tmpId)
			
		if (@conceptPk is null)
		begin
			insert tblConcept
			select null,
				@name1,
				@name1Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptPk = @@identity
			set @pcLinkStatus = 'Inserted'
		end
		
		if (@conceptToPk is null)
		begin
			insert tblConcept
			select null,
				@name2,
				@name2Fk,
				@accordingTo,
				@accToFk,
				getdate(),
				@user, 
				null, null
				
			select @conceptToPk = @@identity
			set @pcToLinkStatus = 'Inserted'
		end
		
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptPk as nvarchar(20))
		where ConceptPk = @conceptPk
		
		update tblConcept 
		set ConceptLSID = 'urn:lsid:compositae.org:concepts:' + cast(@conceptToPk as nvarchar(20))
		where ConceptPk = @conceptToPk
		
		
		--insert concept relationship?
			
		select top 1 @conceptRelGuid = ConceptRelationshipGuid 
		from tblConceptRelationship 
		where ConceptRelationshipConcept1Fk = @conceptPk and ConceptRelationshipConcept2Fk = @conceptToPk
			and ConceptRelationshipRelationshipFk = @relationshipFk
		
		if (@conceptRelGuid is null)
		begin
			set @conceptRelGuid = newid()	
		
			insert tblConceptRelationship
			select @conceptRelGuid, 'urn:lsid:compositae.org:concept-relationship:' + cast(@conceptRelGuid as varchar(38)), 
				@conceptPk, @conceptToPk, @relationship, @relationshipFk, @hybridorder, 
				getdate(), @user, null, null
				
			set @pcrLinkStatus = 'Inserted'
		end	
				
		--set provider Fks to point to consensus records
		update tblProviderConceptRelationship
		set PCRConceptRelationshipFk = @conceptRelGuid, PCRLinkStatus = @pcrLinkStatus, PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
		where PCRPk = @PCRPk
		
		update tblProviderConcept
		set PCConceptFk = @conceptPk, PCLinkStatus = @pcLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk1
		
		update tblProviderConcept
		set PCConceptFk = @conceptToPk, PCLinkStatus = @pcToLinkStatus, PCUpdatedDate = getdate(), PCUpdatedBy = @user
		where PCPk = @PCPk2
			
		--delete old concept rel?
		if (@oldCRGuid is not null and not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
		begin			
			select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid
			select @newLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @conceptRelGuid

			exec sprDelete_ConceptRelationship @oldLSID, @newLSID, @user
		end
			
		--if this is a parent or preferred concept then update the assoc. tblname fields
		if (@relationshipFk = 6 or @relationshipFk = 15)
		begin
			exec sprUpdate_NameRelationData @name1Fk, @user
		end
		
	end
	else
	begin
		--unlink?
		if (@oldCRGuid is not null)
		begin
			update tblProviderConceptRelationship
			set PCRConceptRelationshipFk = null, PCRLinkStatus = 'Unmatched', PCRUpdatedDate = getdate(), PCRUpdatedBy = @user
			where PCRPk = @PCRPk
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk1
		
			update tblProviderConcept
			set PCConceptFk = null, PCLinkStatus = 'Unmatched', PCUpdatedDate = getdate(), PCUpdatedBy = @user
			where PCPk = @PCPk2
			
			--delete old concept rel?
			if (not exists(select * from tblProviderConceptRelationship where PCRConceptRelationshipFk = @oldCRGuid))
			begin				
				select @oldLSID = ConceptRelationshipLSID from tblConceptRelationship where ConceptRelationshipGuid = @oldCRGuid

				exec sprDelete_ConceptRelationship @oldLSID, 'Unlinked', @user
			end
		end
	end
	
	
	select cast(ConceptRelationshipgUID as varchar(38)) as ConceptRelationshipGuid,
		ConceptRelationshipLSID,
		ConceptRelationshipConcept1Fk,
		ConceptRelationshipConcept2Fk,
		ConceptRelationshipRelationship,
		ConceptRelationshipRelationshipFk,
		ConceptRelationshipHybridOrder,
		ConceptRelationshipCreatedDate,
		ConceptRelationshipCreatedBy,
		ConceptRelationshipUpdatedDate,
		ConceptRelationshipUpdatedBy
	from tblConceptRelationship 
	where ConceptRelationshipGuid = @conceptRelGuid 

GO


GRANT EXEC ON dbo.sprInsert_ConceptRelationship TO PUBLIC

GO


 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRelationData')
	BEGIN
		DROP  Procedure  sprUpdate_NameRelationData
	END

GO

CREATE Procedure sprUpdate_NameRelationData
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--update parent and preferred fks
	declare @parentFk uniqueidentifier
	--try system PN rec
	select top 1 @parentfk = p.PNNameFk
	from vwProviderName pn
	inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId 
	inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId 
	inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id 
	inner join vwProviderName p on p.PNNameId = pc2.PCName1Id 
	where ppn.PNNameFk = @nameGuid and p.ProviderIsEditor = 1 and pcr.PCRRelationshipFk = 6 --parent
	
	if (@parentFk is null)
	begin
		--try parentage PN rec
		select top 1 @parentfk = p.PNNameFk
		from vwProviderName pn
		inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
		inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and pc.ProviderPk = pn.ProviderPk
		inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and PCR.ProviderPk = pc.ProviderPk
		inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and pc2.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and p.ProviderPk = pc.ProviderPk
		inner join tblProvider pr on pr.ProviderPk = p.ProviderPk
		where ppn.PNNameFk = @nameGuid and pr.ProviderUseForParentage = 1 and pcr.PCRRelationshipFk = 6 --parent	
			and ppn.pnnameid <> p.pnnameid
	end
	
	if (@parentFk is null)
	begin
		--use majority
		select top 1 @parentfk = v.val
		from tblName n
		inner join (select p.PNNameFk as val, count(*) as c
			from vwProviderName pn
			inner join tblProviderName ppn on ppn.PNPk = pn.PNPk
			inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1)
			inner join vwProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId and (PCR.ProviderPk = pc.ProviderPk or pcr.provideriseditor = 1)
			inner join vwProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id and (pc2.ProviderPk = pcr.ProviderPk or pc2.provideriseditor = 1)
			inner join vwProviderName p on p.PNNameId = pc2.PCName1Id and (p.ProviderPk = pc.ProviderPk or p.provideriseditor = 1)
			where ppn.PNNameFk = @nameGuid and pcr.PCRRelationshipFk = 6 --parent rel
				and ppn.pnnameid <> p.pnnameid
			group by p.pnnamefk
			) v on v.val = n.NameGuid
		order by c desc	
	end

	if (@parentFk is null)
	begin
		select @parentFk = dbo.fnGetNameParentMatch(@nameGuid)
		
		if (@parentFk = '00000000-0000-0000-0000-000000000000')
		begin
			set @parentFk = null
			--select @parentFk = NameGuid	from tblName where NameFull = 'Unknown'
		end
	end
		
	--parent
	update n
	set n.NameParentFk = @parentFk, n.NameParent = pn.NameFull
	from tblName n
	inner join tblName pn on pn.NameGuid = @parentFk
	where n.NameGuid = @nameGuid				
	

	--preferred	
	declare @prefFk uniqueidentifier
	
	select @prefFk = dbo.fnGetPreferredName(@nameGuid)
	
	update n
	set n.NamePreferredFk = @prefFk, n.NamePreferred = pn.NameFull
	from tblName n
	left join tblName pn on pn.NameGuid = @prefFk
	where n.NameGuid = @nameGuid		
	
	
GO
	
GRANT EXEC ON sprUpdate_NameRelationData TO PUBLIC

GO
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameRelationships')
	BEGIN
		DROP  Procedure  sprUpdate_NameRelationships
	END

GO

CREATE Procedure sprUpdate_NameRelationships
	@nameGuid uniqueidentifier,
	@providerNamePk int,
	@user nvarchar(50)
AS
	--sets the name relationships for a name based on the provided providername.  
	--update concepts to point to correct name guid

	declare @nameId nvarchar(300)
	declare @refFk uniqueidentifier
	declare @typeFk uniqueidentifier
	declare @basFk uniqueidentifier
	declare @basedFk uniqueidentifier
	declare @consFk uniqueidentifier
	declare @homoFk uniqueidentifier
	declare @replFk uniqueidentifier
	declare @blockFk uniqueidentifier
	declare @parentFk uniqueidentifier
	declare @pnRefFk uniqueidentifier
		
	--TypeName, PNTypeNameId
	select @typeFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNTypeNameId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Basionym, PNBasionymId
	select @basFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBasionymId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--BasedOn, PNBasedOnId
	select @basedFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBasedOnId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--ConservedAgainst, PNConservedAgainstId
	select @consFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNConservedAgainstId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--HomonymOf, PNHomonymOfId
	select @homoFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNHomonymOfId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--ReplacementFor, PNReplacementForId
	select @replFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNReplacementForId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Blocking, BlockingId
	select @blockFk = n.PNNameFk 
	from vwProviderName pn
	inner join vwProviderName n on n.PNNameId = pn.PNBlockingId and n.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
	
	--Referencefk
	select @refFk = pr.PRReferenceFk
	from vwProviderName pn
	inner join vwProviderReference pr on pr.PRReferenceId = pn.PNReferenceId and pr.ProviderPk = pn.ProviderPk
	where pn.PNPk = @providerNamePk
		
	--parent
	select @parentFk = p.PNNameFk
	from vwProviderName pn
	inner join vwProviderConcept pc on pc.PCName1Id = pn.PNNameId and (pc.ProviderPk = pn.ProviderPk or pc.provideriseditor = 1)
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	inner join vwProviderName p on p.PNNameId = pcr.PCName2Id
	where pn.PNPk = @providerNamePk and pcr.PCRRelationshipFk = 6 
	
	if (@parentFk is null)
	begin
		select @parentFk = dbo.fnGetNameParentMatch(@nameGuid)
		
		if (@parentFk = '00000000-0000-0000-0000-000000000000')
		begin
			set @parentFk = null
			--select @parentFk = NameGuid	from tblName where NameFull = 'Unknown'
		end
	end
	
	--update name
	
	update tblName
	set NameReferenceFk = @refFk,
		NameTypeNameFk = @typeFk,
		NameBasionymFk = @basFk,
		NameBasedOnFk = @basedFk, 
		NameConservedAgainstFk = @consFk,
		NameHomonymOfFk = @homoFk,
		NameReplacementForFk = @replFk,
		NameBlockingFk = @blockFk,
		NameParentFk = isnull(@parentFk, NameParentFk)
	where NameGuid = @nameGuid


	--update concepts
		
	exec sprUpdate_ConceptLinks @nameGuid, @user
	
	/*update c
	set ConceptName1Fk = @nameGuid,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderName pn on pn.PNNameId = pc.PCName1Id and pn.ProviderPk = pc.ProviderPk
	where pn.PNPk = @providerNamePk
	
	update c
	set ConceptName1Fk = @nameGuid,
		ConceptUpdatedBy = @user,
		ConceptUpdatedDate = getdate()
	from tblConcept c
	inner join vwProviderConcept pc on pc.PCConceptFk = c.ConceptPk
	inner join vwProviderConceptRelationship pcr on pcr.PCPk = pc.PCPk
	inner join vwProviderName pn on pn.PNNameId = pcr.PCName2Id and pn.ProviderPk = pcr.ProviderPk
	where pn.PNPk = @providerNamePk*/
	
GO


GRANT EXEC ON sprUpdate_NameRelationships TO PUBLIC

GO


IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredName')
	BEGIN
		DROP  Function  fnGetPreferredName
	END

GO

CREATE Function fnGetPreferredName
(
	@nameGuid uniqueidentifier
)
returns uniqueidentifier
AS
begin
	--get preferred name
	-- if that name has a diff preferred name then use that one
	-- to avoid inconsistencies
	
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier)
	
	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	set @done = 0
	
	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk
		from tblName
		inner join vwProviderName pn on PNNameFk = NameGUID
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId 
				and (pcr.ProviderPk = pn.ProviderPk or pcr.provideriseditor = 1)
				and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p2 on p2.PNNameId = pcr.PCName2Id 
				and (p2.ProviderPk = pcr.ProviderPk or p2.provideriseditor = 1)
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(*) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv and ispref = 1
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				
			end
		end
				
		if (@prefFk is null or @prefFk = @nameGuid) set @done = 1
		else
		begin
			set @allPrefNames = @allPrefNames + ' ' + cast(@prefFk as varchar(38)) + ' '
						
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk or
				charindex(' ' + cast(@prefpreffk as varchar(38)) + ' ', @allPrefNames) <> 0) 
					set @done = 1
			else 
			begin
				set @nameGuid = @prefPrefFk
				set @allPrefNames = @allPrefNames + ' ' + cast(@prefprefFk as varchar(38)) + ' '
			end
		end
	end
	
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid and nameguid <> namepreferredfk
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
		end
	end
	
	--check all names related to the same basionym
	-- get the highest ranking preferred name (ranking from provider table)
	-- of the set
	
	return @prefFk
end

GO


GRANT EXEC ON fnGetPreferredName TO PUBLIC

GO


 