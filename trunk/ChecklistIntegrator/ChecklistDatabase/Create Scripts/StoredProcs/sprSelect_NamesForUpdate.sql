IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesForUpdate')
	BEGIN
		DROP  Procedure  sprSelect_NamesForUpdate
	END

GO

CREATE Procedure sprSelect_NamesForUpdate
	
AS

	declare @names table(nameGuid uniqueidentifier)
	declare @moreNames table(nameGuid uniqueidentifier)
	
	insert @names
	select distinct nameguid 
	from tblName n
	inner join tblProviderName pn on pn.pnnamefk = n.nameguid
	where pn.pnupdateddate > n.nameupdateddate
	
	insert @moreNames
	select distinct c.conceptname1fk
	from tblconcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept2fk = c.conceptpk
	inner join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept1fk
	inner join @names n on n.nameguid = c.conceptname1fk
	where c.conceptname1fk <> c2.conceptname1fk 
	
	insert @moreNames
	select distinct c.conceptname1fk
	from tblconcept c
	inner join tblconceptrelationship cr on cr.conceptrelationshipconcept1fk = c.conceptpk
	inner join tblconcept c2 on c2.conceptpk = cr.conceptrelationshipconcept2fk
	inner join @names n on n.nameguid = c.conceptname1fk
	where c.conceptname1fk <> c2.conceptname1fk 
		
	
	insert @names
	select * from @moreNames
	
	--names that point to themselves as parent - should happen, but if it does a refresh should fix it
	insert @names 
	select nameguid
	from tblName 
	where nameparentfk = nameguid
	
	insert @names
	select distinct n.nameguid
	from tblName n
	left join @names nam on nam.nameguid = n.nameguid 
	left join tblName p on p.nameguid = n.nameparentfk
	left join tblName pr on pr.nameguid = n.namepreferredfk
	left join tblName b on b.nameguid = n.namebasionymfk
	left join tblName ba on ba.nameguid = n.namebasedonfk
	left join tblName t on t.nameguid = n.nametypenamefk
	left join tblName h on h.nameguid = n.namehomonymoffk
	left join tblName r on r.nameguid = n.namereplacementforfk
	left join tblName bl on bl.NameGuid = n.NameBlockingFk
	left join tblName c on c.nameguid = n.nameconservedagainstfk
	where nam.nameguid is null and 
		((p.namefull collate SQL_Latin1_General_CP1_CI_AI  <> n.nameparent) or
		(pr.nameguid is not null and pr.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namepreferred) or
		(b.nameguid is not null and b.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namebasionym) or
		(ba.nameguid is not null and ba.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namebasedon) or
		(t.nameguid is not null and t.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nametypename) or
		(h.nameguid is not null and h.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namehomonymof) or
		(r.nameguid is not null and r.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.namereplacementfor) or
		(bl.nameguid is not null and bl.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nameblocking) or
		(c.nameguid is not null and c.namefull collate SQL_Latin1_General_CP1_CI_AI <> n.nameconservedagainst))
		

	select distinct cast(n.NameGUID as varchar(38)) as NameGuid
	from tblName n
	inner join @names u on u.nameGuid = n.NameGuid

GO


GRANT EXEC ON sprSelect_NamesForUpdate TO PUBLIC

GO


