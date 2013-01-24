

delete pcr
from tblname n
inner join tblname par on par.nameguid = n.nameparentfk
inner join tblprovidername pn on pn.pnnamefk = n.nameguid and (pnproviderimportfk = 5 or pnproviderimportfk = 52)
inner join tblproviderconcept pc on pc.pcname1id = pn.pnnameid
inner join tblproviderconceptrelationship pcr on pcr.pcrconcept1id = pc.pcconceptid
where par.namecanonical is null

delete pc
from tblname n
inner join tblname par on par.nameguid = n.nameparentfk
inner join tblprovidername pn on pn.pnnamefk = n.nameguid and (pnproviderimportfk = 5 or pnproviderimportfk = 52)
inner join tblproviderconcept pc on pc.pcname1id = pn.pnnameid
where par.namecanonical is null

delete pn
from tblname n
inner join tblname par on par.nameguid = n.nameparentfk
inner join tblprovidername pn on pn.pnnamefk = n.nameguid and (pnproviderimportfk = 5 or pnproviderimportfk = 52)
where par.namecanonical is null

update pn
set pnupdateddate = getdate()
from tblname n
inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
left join tblprovidername pn on pn.pnnamefk = n.nameguid 
inner join tblprovidernameauthors pna on pna.pnaprovidernamefk = pn.pnpk
where (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is null) 
		or (pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is null) 

update pn
set pnupdateddate = getdate()
from tblname n
inner join tblname par on par.nameguid = n.nameparentfk
inner join tblprovidername pn on pn.pnnamefk = n.nameguid 
where par.namecanonical is null
