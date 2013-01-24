select distinct namefull, nameguid from tblname where nameparentfk = nameguid
union
select distinct namefull, nameguid from tblname n
where not exists(select * from tblname where nameguid = n.nameparentfk)
