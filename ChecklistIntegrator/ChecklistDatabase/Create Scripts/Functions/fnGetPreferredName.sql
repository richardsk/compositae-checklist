IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredName')
	BEGIN
		DROP  Function  fnGetPreferredName
	END

GO

CREATE Function fnGetPreferredName
(
	@nameGuid uniqueidentifier
)
returns uniqueidentifier
AS
begin
	--get preferred name
	-- if that name has a diff preferred name then use that one
	-- to avoid inconsistencies
	
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier)
	
	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	set @done = 0
	
	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, p2.PNNameFk
		from tblName
		inner join vwProviderName pn on PNNameFk = NameGUID
		inner join vwProviderConceptRelationship pcr on pcr.PCName1Id = pn.PNNameId 
				and (pcr.ProviderPk = pn.ProviderPk or pcr.provideriseditor = 1)
				and pcr.PCRRelationshipFk = 15 
		inner join tblProvider p on p.ProviderPk = pcr.ProviderPk
		inner join vwProviderName p2 on p2.PNNameId = pcr.PCName2Id 
				and (p2.ProviderPk = pcr.ProviderPk or p2.provideriseditor = 1)
		left join vwProviderReference pr on pr.PRReferenceId = pcr.PCAccordingToId and pr.ProviderPk = pcr.ProviderPk
		where NameGUID = @nameGuid
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(*) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @prefFk = prefnamefk from @recs where providerpk = @prefProv and ispref = 1
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				
			end
		end
				
		if (@prefFk is null or @prefFk = @nameGuid) set @done = 1
		else
		begin
			set @allPrefNames = @allPrefNames + ' ' + cast(@prefFk as varchar(38)) + ' '
						
			select @prefPrefFk = namepreferredfk from tblname where nameguid = @prefFk

			if (@prefPrefFk is null or @prefPrefFk = @prefFk or
				charindex(' ' + cast(@prefpreffk as varchar(38)) + ' ', @allPrefNames) <> 0) 
					set @done = 1
			else 
			begin
				set @nameGuid = @prefPrefFk
				set @allPrefNames = @allPrefNames + ' ' + cast(@prefprefFk as varchar(38)) + ' '
			end
		end
	end
	
	
	--if pref name is still null, check if any names point to this name as their 
	-- preferred name - if so, then this name should point to itself as pref name
	if (@prefFk is null)
	begin
		select @prefFk = namepreferredfk
		from tblname 
		where namepreferredfk = @nameGuid and nameguid <> namepreferredfk
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
		end
	end
	
	--check all names related to the same basionym
	-- get the highest ranking preferred name (ranking from provider table)
	-- of the set
	
	return @prefFk
end

GO


GRANT EXEC ON fnGetPreferredName TO PUBLIC

GO


 