declare @ids table(nameguid uniqueidentifier)

insert @ids
select nameguid
from tblname 
where NameRankFk = 24 and NamePreferredFk = NameGUID
 

update pn
set pn.PNUpdatedDate = GETDATE()
from tblproviderName pn
inner join tblname n on n.nameguid = pn.PNNameFk
left join @ids i on i.nameguid = n.NamePreferredFk
where n.NameRankFk = 24 and n.NamePreferredFk is not null and
	i.nameguid is null
