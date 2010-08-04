IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ReferenceData')
	BEGIN
		DROP  Procedure  sprUpdate_ReferenceData
	END

GO

CREATE Procedure sprUpdate_ReferenceData
	@refGuid uniqueidentifier,
	@user nvarchar(50)	
AS

	--update RIS data from provider RIS	
	--get source records 
	--if a compositae/system record exists then use any non-null fields to populate RIS data
	--otherwise populate from majority value for each field
	--if equal number of majority values, eg 2 of each value, then update to null

	declare @cols table(row int identity, source nvarchar(100), dest nvarchar(100))
	
	insert @cols
	select RISMappingSourceCol, RISMappingDestCol
	from tblRISMapping
	
	declare @row int, @count int, @sql nvarchar(1000), @source nvarchar(100), @dest nvarchar(100), @type sysname
	select @row = 1, @count = count(*) from @cols
	
	declare @first int, @second int
	create table #vals(val nvarchar(4000), pk int, isSystem bit)
					
	while (@row < @count + 1)
	begin		
		select @source = source, @dest = dest from @cols where row = @row
		
		select @type = t.name 
		from systypes t 
		inner join syscolumns c on c.xtype = t.xtype and t.status = c.typestat
		inner join sysobjects o on o.id = c.id
		where c.name = @source and o.name = 'tblProviderRIS'
		
		delete #vals
		set @sql = 'insert #vals select cast(' + @source + ' as nvarchar(4000)), PRISPk, isnull(ProviderIsEditor,0) '
		set @sql = @sql + ' from vwProviderRIS ris '
		set @sql = @sql + ' inner join tblProviderReference pr on pr.PRPk = ris.PRISProviderReferenceFk '
		set @sql = @sql + ' where pr.PRReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''' and ' + @source + ' is not null'			
		set @sql = @sql + ' and pr.PRLinkStatus <> ''Discarded'''
		exec(@sql)
				
		if (exists(select * from #vals where isSystem = 1))
		begin
			--checklist system entered value
			if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update ris set RISUpdatedDate = getdate(), RISUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pr.' + @source
				set @sql = @sql + ' from tblReferenceRIS ris '
				set @sql = @sql + ' inner join vwProviderRIS pr on pr.PRReferenceFk = ris.RISReferenceFk '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null and v.isSystem = 1 '
				set @sql = @sql + '   group by v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pr.PRISPk '
				set @sql = @sql + ' where RISReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''''
			end 
			else
			begin
				set @sql = 'update tblReferenceRIS set ' + @dest + ' = (select top 1 pr.' + @source 
				set @sql = @sql + ' from vwProviderRIS pr inner join #vals v on v.pk = pr.PRISPk where v.isSystem = 1) '
				set @sql = @sql + ', RISUpdatedBy = ''' + @user + ''', RISUpdatedDate = getdate() '
				set @sql = @sql + ' where RISReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''''
			end
		end
		else
		begin
			create table #top2(counter int identity(1,1), val nvarchar(4000), number int)
			
			--find most common value
			if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'insert into #top2(val, number) '
				set @sql = @sql + 'select top 2 val, count(*) from #vals where val is not null '
				set @sql = @sql + ' group by val order by count(*) desc '
				
				exec(@sql)
				
				set @first = null
				set @second = null				
				select @first = number from #top2 where counter = 1
				select @second = number from #top2 where counter = 2
				
				if (@second is null or @first > @second) set @sql ='update ris set ' + @dest + ' = pr.' + @source + ', RISUpdatedDate = getdate(), RISUpdatedBy = ''' + @user + ''' '
				else set @sql = 'update ris set ' + @dest + ' = null, RISUpdatedDate = getdate(), RISUpdatedBy = ''' + @user + ''' '
				
				set @sql = @sql + ' from tblReferenceRIS ris '
				set @sql = @sql + ' inner join vwProviderRIS pr on pr.PRReferenceFk = ris.RISReferenceFk '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '   from #vals v where v.val is not null '
				set @sql = @sql + '   group by v.val, v.pk ' 
				set @sql = @sql + '   order by count(*) desc) f on f.Pk = pr.PRISPk '
				set @sql = @sql + ' where RISReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''''
				
			end 
			else
			begin		
				set @sql = 'insert #top2(val, number) '
				set @sql = @sql + 'select top 2 val, count(*) from #vals where val is not null '
				set @sql = @sql + ' group by val order by count(*) desc '
				
				exec(@sql)
				
				set @first = null
				set @second = null
				select @first = number from #top2 where counter = 1
				select @second = number from #top2 where counter = 2
				
				if (@second is null or @first > @second) set @sql ='update ris set ' + @dest + ' = f.' + @source + ', RISUpdatedDate = getdate(), RISUpdatedBy = ''' + @user + ''' '
				else set @sql = 'update ris set ' + @dest + ' = null, RISUpdatedDate = getdate(), RISUpdatedBy = ''' + @user + ''' '
				
				set @sql = @sql + ' from tblReferenceRIS ris '
				set @sql = @sql + ' inner join (select top 1 ' + @source + ', count(*) as c, PRReferenceFk '
				set @sql = @sql + '      from vwProviderRIS '
				set @sql = @sql + '      where PRReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''' '
				set @sql = @sql + '      group by ' + @source + ', PRReferenceFk '
				set @sql = @sql + '      order by c desc) f on f.PRReferenceFk = ris.RISReferenceFk '
				set @sql = @sql + ' where ris.RISReferenceFk = ''' + cast(@refGuid as varchar(38)) + ''''
			end
			    		
			drop table #top2		
		end
		
		print(@type)
		print(@sql)
		exec(@sql)
		
		set @row = @row + 1
	end
	
	
	--short citation
	declare @shortCit nvarchar(4000)
	--editor value
	select @shortCit = PRCitation 
	from vwProviderReference pr 
	where pr.PRReferenceFk = @refGuid and PRCitation is not null
		and pr.PRLinkStatus <> 'Discarded' and ProviderIsEditor = 1
	
	if (@shortCit is null)
	begin
		select @shortCit = PRCitation
		from vwProviderReference pr 
		inner join (select top 1 PRPk
				from vwProviderReference where PRCitation is not null
				group by PRCitation, PRPk
				order by count(*) desc) f on f.PRPk = pr.PRPk
		where PRReferenceFk = @refGuid
	end
	
	if (@shortCit is not null)
	begin
		update tblReference set ReferenceCitation = @shortCit where ReferenceGuid = @refGuid
	end
	
	
	--update reference citation from RIS
	declare @cit nvarchar(4000), @oldCIT nvarchar(4000), @oldFullCIT nvarchar(4000)
	select @oldCIT = ReferenceCitation, @oldFullCIT = ReferenceFullCitation from tblReference where ReferenceGuid = @refGuid
	
	if (exists(select * from tblReferenceRIS where RISReferenceFk = @refGuid))
	begin	
		select @cit = dbo.fnGetReferenceCitation(@refGuid)
		
	end
	else
	begin
		select @cit = PRCitation
		from vwProviderReference
		where PRReferenceFk = @refGuid and ProviderIsEditor = 1
		
	end
	
	if (@cit is not null) 
	begin
		update tblReference 
		set ReferenceFullCitation = @cit,
			ReferenceCitation = case when @oldCIT = @oldFullCIT then @cit else @oldCIT end
		where ReferenceGuid = @refGuid
	end
	
		
	--update name published in citations linking to this reference
	update n
	set NamePublishedIn = r.ReferenceFullCitation
	from tblReference r
	inner join tblName n on n.NameGuid = r.ReferenceGuid
	where r.ReferenceGuid = @refGuid
GO


GRANT EXEC ON sprUpdate_ReferenceData TO PUBLIC

GO


