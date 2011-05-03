--find autonyms that are not accepted names but have "siblings" that are accepted => nomen. inconsistency

select n.NameFull, n.NamePreferred, pn.NameFull, pn.NamePreferred,
       (select top 1 NameFull from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
from tblName n
inner join tblRank tr on tr.RankPk = n.NameRankFk
inner join tblName pn on pn.NameGUID = n.NameParentFk
where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
       and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
        and pn.NamePreferredFk = pn.NameGUID and n.NamePreferredFk <> n.NameGUID
        and tr.RankSort > 4200
        
--find names that have infraspecific child names but no autonym child

select distinct n.NameGUID, n.NameFull 
from tblName n
inner join tblRank tr on tr.RankPk = n.NameRankFk
inner join tblName cn on cn.NameParentFk = n.NameGUID
left join (select n.nameguid, n.namefull, n.NameParentFk
	from tblName n
	inner join tblRank tr on tr.RankPk = n.NameRankFk
	where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
		and tr.RankSort > 4200) can on can.NameParentFk = n.NameGUID
where can.NameGUID is null and tr.RankSort = 4200

