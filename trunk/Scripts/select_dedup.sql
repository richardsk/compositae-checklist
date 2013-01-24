declare @ids table(id uniqueidentifier)

insert @ids
select nameguid
from tblname
inner join tblRank on RankPk = NameRankFk
where RankSort >= 3000 

select cast(nameguid as varchar(38)) + '@' +
	NameFull + '@' + 
	SUBSTRING(namefull, 0, charindex(' ', namefull)) + '@' +
	isnull((case when RankSort <= 4200 then NameCanonical 
	 when (CHARINDEX(' ', namefull, charindex(' ', namefull) + 1)) = 0 then ''
	else SUBSTRING(namefull, charindex(' ', namefull) + 1, 
		CHARINDEX(' ', namefull, charindex(' ', namefull) + 1) - CHARINDEX(' ', namefull)-1) end), '')
	+ '@' +
	case when RankSort > 4200 then namecanonical else '' end + '@' +
	isnull(NameAuthors,'') + '@' +
	isnull(NameBasionymAuthors,'') + '@' +
	isnull(NameCombinationAuthors,'') + '@' +
	isnull(RankName,'') + '@' +
	isnull(NameYear,'') + '@' +
	isnull(NamePublishedIn,'') + '@' +
	isnull(NameMicroReference,'') collate latin1_general_ci_ai
from @ids id
inner join tblName on NameGUID = id.id
inner join tblRank on RankPk = NameRankFk
where (dbo.fnischildof(nameguid, 'B238E95E-12B6-44E5-9ABA-B891A56A9356') = 1
	or dbo.fnischildof(nameguid, 'F84FA45B-C1DB-4F8F-9A21-7054E4C71895') = 1
	or dbo.fnischildof(nameguid, '5676959D-31C0-485C-8336-FB009A057811') = 1)
	

--select dbo.fnischildof(newid(), newid()) 'F84FA45B-C1DB-4F8F-9A21-7054E4C71895', 'B238E95E-12B6-44E5-9ABA-B891A56A9356') 
--select * from tblRank
--select * from tblname where namefull like 'pilosella%' and NameRankFk = 8