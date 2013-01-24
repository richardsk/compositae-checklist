
select n.NameFull, n.NamePreferred, pn.NameFull, pn.NamePreferred,
	(select top 1 NameFull from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
	, tr.RankSort, tr.RankName
from tblName n
inner join tblRank tr on tr.RankPk = n.NameRankFk 
inner join tblName pn on pn.NameGUID = n.NameParentFk
where CHARINDEX(n.NameCanonical, n.namefull, charindex(n.NameCanonical, n.namefull) + 1) <> 0
	and exists(select NameGUID from tblName where NamePreferredFk = NameGUID and NameParentFk = pn.NameGUID)
	 and pn.NamePreferredFk = pn.NameGUID and n.NamePreferredFk <> n.NameGUID
	 and tr.RankSort > 4200
	
