declare @recs table(row int identity, pnpk int)
declare @cnt int, @pos int

insert @recs
select distinct pn2.pnpk /*, pn2.pnnameauthors, nameauthors,
	dbo.fngetcorrectedauthors(pna.pnabasionymauthors), 
	dbo.fngetcorrectedauthors(pna.pnacombinationauthors), isnull(nameauthorscombinationauthors,'-1'), isnull(nameauthorsbasionymauthors,'-1'), 0*/
from tblname n
inner join tblnameauthors na on na.nameauthorsnamefk = n.nameguid
left join tblprovidername pn on pn.pnnamefk = n.nameguid and pn.pnproviderimportfk = 3
inner join tblprovidername pn2 on pn2.pnnamefk = n.nameguid and pn2.pnproviderimportfk <> 3
inner join tblprovidernameauthors pna on pna.pnaprovidernamefk = pn2.pnpk
inner join tblprovidername pn3 on pn3.pnnamefk = n.nameguid and pn3.pnproviderimportfk <> 3 and pn3.pnpk <> pn2.pnpk
inner join tblprovidernameauthors pna3 on pna3.pnaprovidernamefk = pn3.pnpk
where pn.pnpk is null and 
	((pna.pnabasionymauthors is not null and na.nameauthorsbasionymauthors is not null and dbo.fngetcorrectedauthors(pna.pnabasionymauthors) <> na.nameauthorsbasionymauthors)
	or (pna.pnacombinationauthors is not null and na.nameauthorscombinationauthors is not null and dbo.fngetcorrectedauthors(pna.pnacombinationauthors) <> na.nameauthorscombinationauthors)
	or (pna.pnabasionymauthors is not null and pna3.pnabasionymauthors is not null and dbo.fngetcorrectedauthors(pna.pnabasionymauthors) <> dbo.fngetcorrectedauthors(pna3.pnabasionymauthors))
	or (pna.pnacombinationauthors is not null and pna3.pnacombinationauthors is not null and dbo.fngetcorrectedauthors(pna.pnacombinationauthors) <> dbo.fngetcorrectedauthors(pna3.pnacombinationauthors)))


declare @pnId int, @totalCount int, @nameId uniqueidentifier

set @totalCount = 0
select @cnt = COUNT(*), @pos = 1 from @recs 

print(cast(@cnt as nvarchar(20)) + ' records to process.')


while (@pos <= @cnt)
begin
	select @pnId = pnpk
	from @recs where row = @pos

	set @totalCount = @totalCount + 1

	select @nameId = pnnamefk from tblprovidername where pnpk = @pnid

	if ((select count(*) from tblprovidername where pnnamefk = @nameid and pnproviderimportfk <> 5) > 1)
	begin
		print ('updating pn pnpk=' + cast(@pnid as varchar(20)))

		update tblProviderName
		set PNNameFk = null,
			PNLinkStatus = 'Unmatched',
			PNNameMatchScore = null,
			PNUpdatedDate = getdate()
		where PNPk = @pnid
		
		--unlink concepts?
		exec sprUpdate_ProviderConceptLinks @pnid, 'admin'

	end		

	/*--delete name?
	if (not exists(select * from tblprovidername where pnnamefk = @nameid))
	begin
		delete tblName
		where NameGuid = @nameid

		delete tblFieldStatus where FieldStatusRecordFk = cast(@nameid as varchar(38))
		
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
	begin*/


		update tblprovidername  
		set pnupdateddate = getdate()
		where pnnamefk = @nameid
	--end

	set @pos = @pos + 1 
end

print('updated ' + cast(@totalcount as nvarchar(20)) + ' provider names.')

