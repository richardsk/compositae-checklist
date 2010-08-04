IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameData')
	BEGIN
		DROP  Procedure  sprUpdate_NameData
	END

GO

CREATE Procedure sprUpdate_NameData
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	--OBSOLETE - now done in the code.
	
	--get source records 
	--if a compositae/system record exists then use any non-null fields to populate name data
	--otherwise populate from majority value for each field
	--if equal number of majority values, eg 2 of each value, then update to null

	declare @cols table(row int identity, source nvarchar(100), dest nvarchar(100))
	
	insert @cols
	select NameMappingSourceCol, NameMappingDestCol
	from tblNameMapping
	where NameMappingSourceCol <> 'PNParentNameFk' --dont update parent as this upsets the tree
	
	declare @row int, @count int, @sql nvarchar(1000), @source nvarchar(100), @dest nvarchar(100), @type sysname
	select @row = 1, @count = count(*) from @cols
	
	declare @first int, @second int
	create table #vals(val nvarchar(4000), pk int, isSystem bit)
					
	while (@row < @count + 1)
	begin	
		create table #top2(counter int identity(1,1), val nvarchar(4000), number int, uidVal uniqueidentifier, bitVal bit, intVal int)
				
		select @source = source, @dest = dest from @cols where row = @row
		
		select @type = t.name 
		from systypes t 
		inner join syscolumns c on c.xtype = t.xusertype 
		inner join sysobjects o on o.id = c.id
		where c.name = @source and o.name = 'tblProviderName'
		
		delete #vals
		set @sql = 'insert #vals select cast(' + @source + ' as nvarchar(4000)), PNPk, isnull(ProviderIsEditor,0) '
		set @sql = @sql + ' from tblProviderName pn '
		set @sql = @sql + ' inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk '
		set @sql = @sql + ' inner join tblProvider p on p.ProviderPk = pim.ProviderImportProviderFk '
		set @sql = @sql + ' where PNNameFk = ''' + cast(@nameGuid as varchar(38)) + ''' and ' + @source + ' is not null and len(cast(' + @source + ' as varchar(100))) > 0 '
		set @sql = @sql + ' and PNLinkStatus <> ''Discarded'''
		print(@sql)
		exec(@sql)
				
		if (exists(select * from #vals where isSystem = 1))
		begin
			--checklist system entered value
			if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'update n set NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''', '
				set @sql = @sql + @dest + ' = pn.' + @source
				set @sql = @sql + ' from tblName n '
				set @sql = @sql + ' inner join tblProviderName pn on pn.PNNameFk = n.NameGuid '
				set @sql = @sql + ' inner join (select top 1 v.pk '
				set @sql = @sql + '	  from tblProviderName pn '
				set @sql = @sql + '   inner join #vals v on v.pk = pn.pnpk '
				set @sql = @sql + '   where v.val is not null and v.isSystem = 1 '
				set @sql = @sql + '   order by pnupdateddate desc) f on f.Pk = pn.PNPk '
				set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + ''''
			end 
			else
			begin
				set @sql = 'update tblName set ' + @dest + ' = (select top 1 pn.' + @source 
				set @sql = @sql + ' from tblProviderName pn inner join #vals v on v.pk = pn.PNPk where v.isSystem = 1 order by pnupdateddate desc) '
				set @sql = @sql + ', NameUpdatedBy = ''' + @user + ''', NameUpdatedDate = getdate() '
				set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + ''''
			end
		end
		else
		begin			
			--find most common value
			if (@type = 'ntext')
			begin			
				--special case for text type fields
				set @sql = 'insert into #top2(val, number, uidVal, bitVal, intVal) '
				set @sql = @sql + 'select top 2 val, count(*), null, null, null from #vals where val is not null '
				set @sql = @sql + ' group by val order by count(*) desc '
				
				exec(@sql)
				
				set @first = null
				set @second = null				
				select @first = number from #top2 where counter = 1
				select @second = number from #top2 where counter = 2
				
				if (@second is null or @first > @second or @source = 'PNNameCanonical') 
				begin
					set @sql ='update tblName set ' + @dest + ' = (select top 1 val from #top2), NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
					set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 
				end
				else 
				begin
					set @sql = 'update tblName set ' + @dest + ' = null, NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
					set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 
				end
				
			end 
			else
			begin		
				if (@type = 'uniqueidentifier')
				begin
					set @sql = 'insert #top2(val, number, uidVal, bitVal, intVal) '
					set @sql = @sql + 'select top 2 val, count(*), cast(val as uniqueidentifier), null, null from #vals where val is not null '
					set @sql = @sql + ' group by val order by count(*) desc '
				end
				else if (@type = 'bit')
				begin
					set @sql = 'insert #top2(val, number, uidVal, bitVal, intVal) '
					set @sql = @sql + 'select top 2 val, count(*), null, val, null from #vals where val is not null '
					set @sql = @sql + ' group by val order by count(*) desc '
				end
				else if (@type = 'int')
				begin
					set @sql = 'insert #top2(val, number, uidVal, bitVal, intVal) '
					set @sql = @sql + 'select top 2 val, count(*), null, null, val from #vals where val is not null '
					set @sql = @sql + ' group by val order by count(*) desc '					
				end
				else
				begin
					set @sql = 'insert #top2(val, number, uidVal, bitVal, intVal) '
					set @sql = @sql + 'select top 2 val, count(*), null, null, null from #vals where val is not null '
					set @sql = @sql + ' group by val order by count(*) desc '
				end
				
				exec(@sql)
				
				set @first = null
				set @second = null
				select @first = number from #top2 where counter = 1
				select @second = number from #top2 where counter = 2
				
				if (@second is null or @first > @second or @source = 'PNNameCanonical') 
				begin
				
					if (@type = 'uniqueidentifier')
					begin
						set @sql ='update tblName set ' + @dest + ' = (select top 1 uidVal from #top2), NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
						set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 
					end
					else if (@type = 'bit')
					begin
						set @sql ='update tblName set ' + @dest + ' = (select top 1 bitVal from #top2), NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
						set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 						
					end
					else if (@type = 'int')
					begin
						set @sql ='update tblName set ' + @dest + ' = (select top 1 intVal from #top2), NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
						set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 						
					end
					else
					begin
						set @sql ='update tblName set ' + @dest + ' = (select top 1 val from #top2), NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
						set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 
					end
					
				end
				else 
				begin
					set @sql = 'update tblName set ' + @dest + ' = null, NameUpdatedDate = getdate(), NameUpdatedBy = ''' + @user + ''' '
					set @sql = @sql + ' where NameGuid = ''' + cast(@nameGuid as varchar(38)) + '''' 
				end
			end
			    		
		end
		
		print(@type)
		print(@sql)
		exec(@sql)
		
		drop table #top2		
		
		set @row = @row + 1
	end
	
	/*--standardise the rank
	update n
	set NameRank = isnull(RankName, NameRank)
	from tblName n
	inner join tblRank r on r.RankPk = n.NameRankFk
	where n.NameGuid = @nameGuid*/
	
	
	--name full
	update tblName
	set NameFull = dbo.fnGetFullName(NameGuid, 0, 0, 1, 0, 0)
	where NameGuid = @nameGuid
	
	
	
	--match scores
	declare @pns table(counter int identity, pnpk int)
	declare @pnpk int
	insert @pns select pnpk from tblprovidername where pnnamefk = @nameGuid
	
	select @row = 1, @count = count(*) from @pns
	
	while (@row <= @count)
	begin
		select @pnpk = pnpk from @pns where counter = @row
		
		exec sprCalculateMatchScore @pnpk
		update tblProviderName set PNNameMatchScore = (select top 1 PercentMatch from tmpMatchScore)
		where PNPk = @pnpk
		
		set @row = @row + 1	
	end
	
	--authors
	
	--exec sprUpdate_NameAuthors @nameGuid, @user
	exec sprUpdate_ConsensusAuthors @nameGuid, @user
	
GO
	
GRANT EXEC ON sprUpdate_NameData TO PUBLIC

GO


