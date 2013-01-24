
set nocount on
set ansi_warnings off

declare @recs table(row int identity, pnpk int)
declare @pos int, @cnt int

insert @recs
select pnpk
from vwprovidername
where providerpk = 10

select @pos = 1, @cnt = count(*) from @recs

print(@cnt)

declare @id int, @nameid uniqueidentifier

while (@pos <= @cnt)
begin
	select @id = pnpk
	from @recs where row = @pos

	select @nameid = pnnamefk from tblprovidername where pnpk = @id

	delete tblproviderName
	where pnpk = @id

	delete tblFieldStatus where FieldStatusRecordFk = cast(@id as varchar(38))
	
	--delete concepts
	delete cr
	from tblproviderConceptRelationship cr
	inner join tblproviderConcept c on c.pcconceptid = cr.pcrconcept1id
	inner join tblprovidername pn on pn.pnnameid = c.pcname1id
	where pn.pnpk = @id
	
	delete cr
	from tblproviderConceptRelationship cr
	inner join tblproviderConcept c on c.pcconceptid = cr.pcrconcept2id
	inner join tblprovidername pn on pn.pnnameid = c.pcname1id
	where pn.pnpk = @id
	
	delete c
	from tblproviderConcept c
	inner join tblprovidername pn on pn.pnnameid = c.pcname1id
	where pn.pnpk = @id
	


	--delete name?
	if (not exists(select * from tblprovidername where pnnamefk = @nameid))
	begin
		delete tblName
		where NameGuid = @nameid
		
		--delete concepts
		delete cr
		from tblConceptRelationship cr
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept1Fk
		where c.ConceptName1Fk = @nameid
		
		delete cr
		from tblConceptRelationship cr
		inner join tblConcept c on c.ConceptPk = cr.ConceptRelationshipConcept2Fk
		where c.ConceptName1Fk = @nameid
		
		delete tblConcept where ConceptName1Fk = @nameid
		
	end
	else
	begin

		update tblprovidername  
		set pnupdateddate = getdate()
		where pnnamefk = @nameid
	end


	print(@pos)

	set @pos = @pos + 1
end

