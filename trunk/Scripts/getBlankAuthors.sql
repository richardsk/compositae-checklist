--select * from tblProviderName where PNPk = 530586
--select * from tblProviderName where PNNameFk = '03377F3C-097E-4178-8DB1-FF8F1FAC2432'


select distinct nameguid, namefull, pn2.pnpk, pn2.PNNameAuthors, 
	PNABasionymAuthors, PNACombinationAuthors, Abbreviation, CorrectAuthorFK
from tblName
inner join tblProviderName pn1 on pn1.PNNameFk = NameGUID AND len(pn1.PNNameAuthors) > 0
inner join tblProviderName pn2 on pn2.PNNameFk = NameGUID
inner join tblProviderNameAuthors on PNAProviderNameFk = pn2.pnpk
inner join tblAuthors on cast(AuthorPK as varchar(20)) = PNACombinationAuthors
where (NameAuthors is null or NameAuthors = '')
order by NameGUID
