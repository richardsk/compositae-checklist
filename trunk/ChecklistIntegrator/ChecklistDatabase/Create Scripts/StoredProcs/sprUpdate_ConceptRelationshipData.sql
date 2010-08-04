IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptRelationshipData')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptRelationshipData
	END

GO

CREATE Procedure sprUpdate_ConceptRelationshipData
	@conceptRelationshipGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--OBSOLETE - done in code
	--get source records 
	--if a compositae/system record exists then use any non-null fields to populate name data
	--otherwise populate from majority value for each field
	--todo what if equal number of majority values, eg 2 of each value?

	declare @cols table(row int identity, source nvarchar(100), dest nvarchar(100))
	declare @conceptFk int, @refFk uniqueidentifier
	
	insert @cols
	select ConceptRelMappingSourceCol, ConceptRelMappingDestCol
	from tblConceptRelationshipMapping
	
	declare @row int, @count int, @sql nvarchar(1000), @source nvarchar(100), @dest nvarchar(100), @type sysname
	select @row = 1, @count = count(*) from @cols
	
	create table #vals(val nvarchar(4000), pk int, isSystem bit)
			
	while (@row < @count + 1)
	begin		
		select @source = source, @dest = dest from @cols where row = @row
		
		select @type = t.name 
		from systypes t 
		inner join syscolumns c on c.xtype = t.xtype and t.status = c.typestat
		inner join sysobjects o on o.id = c.id
		where c.name = @source and o.name = 'tblProviderConceptRelationship'
		
		delete #vals
		set @sql = 'insert #vals select cast(' + @source + ' as nvarchar(4000)), PCRPk, isnull(ProviderIsEditor,0) '
		set @sql = @sql + ' from vwProviderConceptRelationship '
		set @sql = @sql + ' where PCRConceptRelationshipFk = ''' + cast(@conceptRelationshipGuid as varchar(38)) + ''' and (' + @source + ' is not null or ProviderIsEditor = 1)'			
		set @sql = @sql + ' and PCRLinkStatus <> ''Discarded'''
		exec(@sql)
				
		if (exists(select * from #vals where isSystem = 1))
		begin
			--checklist system entered value
			
			if (@source = 'PCRConcept1Id')
			begin
				--special case for ref id
				select top 1 @conceptFk = PCConceptFk
				from tblProviderConceptRelationship pcr
				inner join tblProviderConcept pc on pc.PCConceptId = pcr.PCRConcept1Id --system val (only one possible)
				inner join #vals v on v.pk = pcr.pcrpk
				where pcr.PCRConceptRelationshipFk = @conceptRelationshipGuid and v.isSystem = 1
				
				update tblConceptRelationship
				set ConceptRelationshipConcept1Fk = @conceptFk, ConceptRelationshipUpdatedBy = @user, ConceptRelationshipUpdatedDate = getdate() 
				where ConceptRelationshipGuid = @conceptRelationshipGuid
			end
			else if (@source = 'PCRConcept2Id')
			begin
				--special case for ref id
				select top 1 @conceptFk = PCConceptFk
				from tblProviderConceptRelationship pcr
				inner join tblProviderConcept pc on pc.PCConceptId = pcr.PCRConcept2Id --system val (only one possible)
				inner join #vals v on v.pk = pcr.pcrpk
				where pcr.PCRConceptRelationshipFk = @conceptRelationshipGuid and v.isSystem = 1
				
				update tblConceptRelationship
				set ConceptRelationshipConcept2Fk = @conceptFk, ConceptRelationshipUpdatedBy = @user, ConceptRelationshipUpdatedDate = getdate() 
				where ConceptRelationshipGuid = @conceptRelationshipGuid
			end
			else if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update cr set ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pcr.' + @source
				set @sql = @sql + ' from tblConceptRelationship cr '
				set @sql = @sql + ' inner join tblProviderConceptRelationship pcr on pcr.PCRConceptRelationshipFk = cr.ConceptRelationshipGuid '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null and v.isSystem = 1 '
				set @sql = @sql + '   group by v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pcr.PCRPk '
				set @sql = @sql + ' where ConceptRelationshipGuid = ''' + cast(@conceptRelationshipGuid as varchar(38)) + '''' 
			end 
			else
			begin
				set @sql = 'update tblConceptRelationship set ' + @dest + ' = (select top 1 pcr.' + @source 
				set @sql = @sql + ' from tblProviderConceptRelationship pcr inner join #vals v on v.pk = pcr.PCRPk where v.isSystem = 1) '
				set @sql = @sql + ', ConceptRelationshipUpdatedBy = ''' + @user + ''', ConceptRelationshipUpdatedDate = getdate() '
				set @sql = @sql + ' where ConceptRelationshipGuid = ''' + cast(@ConceptRelationshipGuid as varchar(38)) + '''' 
			end
		end
		else
		begin
			--find most common value
			if (@source = 'PCRConcept1Id')
			begin
				--special case for ref id
				select @conceptFk = f.PCConceptFk
				from (select top 1 PCConceptFk, count(*) as c
					from vwProviderConcept pc
					inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept1Id and pc.ProviderPk = pcr.ProviderPk
					inner join #vals v on v.pk = pcr.pcrpk
					where pcr.PCRConceptRelationshipFk = @conceptRelationshipGuid
					group by pcr.PCRConcept1Id, pc.PCConceptFk
					order by c desc) f 
				
				update tblConceptRelationship 
				set ConceptRelationshipConcept1Fk = @conceptFk, ConceptRelationshipUpdatedBy = @user, ConceptRelationshipUpdatedDate = getdate() 
				where ConceptRelationshipGuid = @conceptRelationshipGuid
			end
			else if (@source = 'PCRConcept2Id')
			begin
				--special case for ref id
				select @conceptFk = f.PCConceptFk
				from (select top 1 PCConceptFk, count(*) as c
					from vwProviderConcept pc
					inner join vwProviderConceptRelationship pcr on pc.PCConceptId = pcr.PCRConcept2Id and pc.ProviderPk = pcr.ProviderPk
					inner join #vals v on v.pk = pcr.pcrpk
					where pcr.PCRConceptRelationshipFk = @conceptRelationshipGuid
					group by pcr.PCRConcept2Id, pc.PCConceptFk
					order by c desc) f 
				
				update tblConceptRelationship 
				set ConceptRelationshipConcept2Fk = @conceptFk, ConceptRelationshipUpdatedBy = @user, ConceptRelationshipUpdatedDate = getdate() 
				where ConceptRelationshipGuid = @conceptRelationshipGuid
			end
			else if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update cr set ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pc.' + @source
				set @sql = @sql + ' from tblConceptRelationship cr '
				set @sql = @sql + ' inner join tblProviderConceptRelationship pcr on pcr.PCRConceptRelationshipFk = cr.ConceptRelationshipGuid '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null '
				set @sql = @sql + '   group by v.val, v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pcr.PCRPk '
				set @sql = @sql + ' where ConceptRelationshipGuid = ''' + cast(@conceptRelationshipGuid as varchar(38)) + ''''
				
			end 
			else
			begin		
				set @sql = 'update cr set ' + @dest + ' = f.' + @source + ', ConceptRelationshipUpdatedDate = getdate(), ConceptRelationshipUpdatedBy = ''' + @user + ''' '
				set @sql = @sql + ' from tblConceptRelationship cr '
				set @sql = @sql + ' inner join (select top 1 ' + @source + ', count(*) as c, PCRConceptRelationshipFk '
				set @sql = @sql + '      from tblProviderConceptRelationship '
				set @sql = @sql + '      where PCRConceptRelationshipFk = ''' + cast(@conceptRelationshipGuid as varchar(38)) + ''''
				set @sql = @sql + '      group by ' + @source + ', PCRConceptRelationshipFk '
				set @sql = @sql + '      order by c desc) f on f.PCRConceptRelationshipFk = cr.ConceptRelationshipGuid '
				set @sql = @sql + ' where cr.ConceptRelationshipGuid = ''' + cast(@conceptRelationshipGuid as varchar(38)) + ''''
			end
			    				
		end
		
		print(@type)
		print(@sql)
		exec(@sql)
		
		set @row = @row + 1
	end


GO


GRANT EXEC ON sprUpdate_ConceptRelationshipData TO PUBLIC

GO


