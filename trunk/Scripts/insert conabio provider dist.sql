insert tblproviderotherdata
select 7, 'distribution',
	namefull,
	pnpk,
	'',null,
	'<Distributions><Distribution schema="TDWG Level 2" occurrence="Present" origin="" region="79"/></Distributions>',
	getdate(),
	'admin', 
	null, null
from tblprovidername
left join tblname on nameguid = pnnamefk
where pnproviderimportfk = 7
	