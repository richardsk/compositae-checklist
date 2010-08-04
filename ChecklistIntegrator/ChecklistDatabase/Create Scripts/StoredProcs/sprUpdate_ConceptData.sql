IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ConceptData')
	BEGIN
		DROP  Procedure  sprUpdate_ConceptData
	END

GO

CREATE Procedure sprUpdate_ConceptData
	@conceptPk int,
	@user nvarchar(50)
AS

	--get source records 
	--if a compositae/system record exists then use any non-null fields to populate name data
	--otherwise populate from majority value for each field
	--todo what if equal number of majority values, eg 2 of each value?

	declare @cols table(row int identity, source nvarchar(100), dest nvarchar(100))
	declare @nameFk uniqueidentifier, @refFk uniqueidentifier
	
	insert @cols
	select ConceptMappingSourceCol, ConceptMappingDestCol
	from tblConceptMapping
	
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
		where c.name = @source and o.name = 'tblProviderConcept'
		
		delete #vals
		set @sql = 'insert #vals select cast(' + @source + ' as nvarchar(4000)), PCPk, isnull(ProviderIsEditor,0) '
		set @sql = @sql + ' from tblProviderConcept pc '
		set @sql = @sql + ' inner join tblProviderImport pim on pim.ProviderImportPk = pc.PCProviderImportFk '
		set @sql = @sql + ' inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk '
		set @sql = @sql + ' where PCConceptFk = ' + cast(@conceptPk as varchar(15)) + ' and (' + @source + ' is not null or ProviderIsEditor = 1)'			
		set @sql = @sql + ' and PCLinkStatus <> ''Discarded'''
		exec(@sql)
				
		if (exists(select * from #vals where isSystem = 1))
		begin
			--checklist system entered value
			if (@source = 'PCAccordingToId')
			begin
				--special case for ref id
				select top 1 @refFk = PRReferenceFk 
				from tblProviderReference pr
				inner join tblProviderConcept pc on pc.PCAccordingToId = pr.PRReferenceId
				inner join #vals v on v.pk = pc.pcpk
				where pc.PCConceptFk = @conceptPk and v.isSystem = 1
				
				update tblConcept 
				set ConceptAccordingToFk = @refFk, ConceptUpdatedBy = @user, ConceptUpdatedDate = getdate() 
				where ConceptPk = @conceptPk
			end
			else if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update c set ConceptUpdatedDate = getdate(), ConceptUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pc.' + @source
				set @sql = @sql + ' from tblConcept c '
				set @sql = @sql + ' inner join tblProviderConcept pc on pc.PCConceptFk = c.ConceptPk '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null and v.isSystem = 1 '
				set @sql = @sql + '   group by v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pc.PCPk '
				set @sql = @sql + ' where ConceptPk = ' + cast(@conceptPk as varchar(15)) 
			end 
			else
			begin
				set @sql = 'update tblConcept set ' + @dest + ' = (select top 1 pc.' + @source 
				set @sql = @sql + ' from tblProviderConcept pc inner join #vals v on v.pk = pc.PCPk where v.isSystem = 1) '
				set @sql = @sql + ', ConceptUpdatedBy = ''' + @user + ''', ConceptUpdatedDate = getdate() '
				set @sql = @sql + ' where ConceptPk = ' + cast(@ConceptPk as varchar(15)) 
			end
		end
		else
		begin
			--find most common value
			if (@source = 'PCAccordingToId')
			begin
				--special case for ref id
				select @refFk = f.PRReferenceFk
				from (select top 1 PRReferenceFk, count(*) as c
					from vwProviderReference pr
					inner join vwProviderConcept pc on pc.PCAccordingToId = pr.PRReferenceId and pr.ProviderPk = pc.ProviderPk
					inner join #vals v on v.pk = pc.pcpk
					where pc.PCConceptFk = @conceptPk 
					group by pc.PCAccordingToId, pr.PRReferenceFk
					order by c desc) f 
				
				update tblConcept 
				set ConceptAccordingToFk = @refFk, ConceptUpdatedBy = @user, ConceptUpdatedDate = getdate() 
				where ConceptPk = @conceptPk
			end
			else if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update c set ConceptUpdatedDate = getdate(), ConceptUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pc.' + @source
				set @sql = @sql + ' from tblConcept c '
				set @sql = @sql + ' inner join tblProviderConcept pc on pc.PCConceptFk = c.ConceptPk '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null '
				set @sql = @sql + '   group by v.val, v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pc.PCPk '
				set @sql = @sql + ' where ConceptPk = ' + cast(@conceptPk as varchar(15)) 
				
			end 
			else
			begin		
				set @sql = 'update ct set ' + @dest + ' = f.' + @source + ', ConceptUpdatedDate = getdate(), ConceptUpdatedBy = ''' + @user + ''' '
				set @sql = @sql + ' from tblConcept ct '
				set @sql = @sql + ' inner join (select top 1 ' + @source + ', count(*) as c, PCConceptFk '
				set @sql = @sql + '      from tblProviderConcept '
				set @sql = @sql + '      where PCConceptFk = ' + cast(@conceptPk as varchar(15)) 
				set @sql = @sql + '      group by ' + @source + ', PCConceptFk '
				set @sql = @sql + '      order by c desc) f on f.PCConceptFk = ct.ConceptPk '
				set @sql = @sql + ' where ct.ConceptPk = ' + cast(@conceptPk as varchar(15)) 
			end
			    				
		end
		
		print(@type)
		print(@sql)
		exec(@sql)
		
		set @row = @row + 1
	end


GO


GRANT EXEC ON sprUpdate_ConceptData TO PUBLIC

GO


