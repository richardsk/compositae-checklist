IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AutonymIssues')
	BEGIN
		DROP  Procedure  sprSelect_AutonymIssues
	END

GO

CREATE Procedure sprSelect_AutonymIssues
as

	--find autonyms that are not accepted names but have "siblings" that are accepted => nomen. inconsistency
	select distinct n.NameGUID, n.NameFull, tr.RankName
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and pn.NamePreferredFk = pn.NameGUID and (n.NamePreferredFk is null or n.NamePreferredFk <> n.NameGUID)
			and tr.RankSort > 4200
    
	--find autonyms that have no accepted concept and have no "siblings" that are accepted, then need to point to parent as the pref name
	select distinct n.NameGUID, n.NameFull, n.NameParentFk
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			and not exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID and NameRankFk = n.NameRankFk)
			and n.NamePreferredFk is null
			and tr.RankSort > 4200
			and pn.NamePreferredFk is not null

	--find names that have infraspecific child names but no autonym child
	select distinct n.NameGUID, n.NameFull, n.NameCanonical, n.namebasionymauthors, n.namecombinationauthors,
		cast((select distinct isnull(cast(infn.NameRankFk as varchar(10)) + ',','') as [text()] 
			from tblName infn
			where infn.NameParentFk = n.nameguid 
				and not exists(select n2.nameguid
					from tblName n2
					where n2.NameParentFk = n.NameGUID and
						infn.NameRankFk = n2.NameRankFk and
						CHARINDEX(n2.NameCanonical, n2.namefull, charindex(n2.NameCanonical, n2.namefull) + 1) <> 0)
			for xml path(''), type) as nvarchar(1000)) as Ranks
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName cn on cn.NameParentFk = n.NameGUID and cn.NameRankFk <> 24
	inner join tblRank ctr on ctr.RankPk = cn.NameRankFk
	left join (select n.nameguid, n.NameParentFk, tr.RankSort
		from tblName n
		inner join tblRank tr on tr.RankPk = n.NameRankFk
		where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			) can on can.NameParentFk = n.NameGUID and can.RankSort = ctr.ranksort
	where can.NameGUID is null and tr.RankSort = 4200
	
GO


GRANT EXEC ON sprSelect_AutonymIssues TO PUBLIC

GO
	