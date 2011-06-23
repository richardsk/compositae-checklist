IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_AutonymIssues')
	BEGIN
		DROP  Procedure  sprSelect_AutonymIssues
	END

GO

CREATE Procedure sprSelect_AutonymIssues
as

	--find autonyms that are not accepted names but have "siblings" that are accepted => nomen. inconsistency
	select n.NameGUID, n.NameFull, n.NamePreferred, pn.NameFull, pn.NamePreferred,
		   (select top 1 NameFull from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName pn on pn.NameGUID = n.NameParentFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		   and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
			and pn.NamePreferredFk = pn.NameGUID and n.NamePreferredFk <> n.NameGUID
			and tr.RankSort > 4200
			and not exists(select * from tblName n2
					where CHARINDEX(n2.NameCanonical, n2.namefull, charindex(n2.NameCanonical, n2.namefull) + 1) <> 0
					 and n2.NameParentFk = pn.NameGUID
					 and n2.NameGUID <> n.NameGUID)
        
	--find names that have infraspecific child names but no autonym child
	select distinct n.NameGUID, n.NameFull, n.NameCanonical
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	inner join tblName cn on cn.NameParentFk = n.NameGUID
	left join (select n.nameguid
		from tblName n
		inner join tblRank tr on tr.RankPk = n.NameRankFk
		where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
			and tr.RankSort > 4200) can on can.NameParentFk = n.NameGUID
	where can.NameGUID is null and tr.RankSort = 4200
	
GO


GRANT EXEC ON sprSelect_AutonymIssues TO PUBLIC

GO
	