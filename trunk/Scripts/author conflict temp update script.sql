select distinct nameguid, namefull, pn2.pnpk --, isnull(nameauthorscombinationauthors,'-1'), isnull(nameauthorsbasionymauthors,'-1'), 0
from tblname n
inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
left join tblprovidername pn on pn.pnnamefk = n.nameguid and pn.pnproviderimportfk = 3
inner join tblprovidername pn2 on pn2.pnnamefk = n.nameguid and pn2.pnproviderimportfk <> 3
inner join tblprovidernameauthors pna on pna.pnaprovidernamefk = pn2.pnpk
where pn.pnpk is null and 	
	((pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is not null and dbo.fngetcorrectedauthors(pna.pnabasionymauthors) <> na.nameauthorsbasionymauthors)
	or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is not null and dbo.fngetcorrectedauthors(pna.pnacombinationauthors) <> na.nameauthorscombinationauthors))
