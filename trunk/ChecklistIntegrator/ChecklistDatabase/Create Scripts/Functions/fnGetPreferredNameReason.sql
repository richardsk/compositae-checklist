IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetPreferredNameReason')
	BEGIN
		DROP  Function  fnGetPreferredNameReason
	END

GO

CREATE Function fnGetPreferredNameReason
(
	@nameGuid uniqueidentifier
)
returns nvarchar(200)
AS
begin
	--get the reason the preferred name has been set
	
	declare @reason nvarchar(200)
		
	declare @allPrefNames nvarchar(4000)
	declare @prefFk uniqueidentifier, @hasSys bit, @prefProv int, @prefPrefFk uniqueidentifier, @done bit
	declare @recs table(pnpk int, providerpk int, rank int, AccTo int, isPref bit, prefNameFk uniqueidentifier, isEditor bit)
	declare @isEd bit, @basId uniqueidentifier

	set @allPrefNames = ' ' + cast(@nameguid as varchar(38))
	
	
	-- also check all names related to the same basionym
	select @basId = NameBasionymFk from tblName where NameGuid = @nameGuid

	set @done = 0
	set @reason = 'Unknown'

	while (@done = 0)
	begin
		delete @recs
		
		--get all prov records
		insert @recs
		select pn.pnpk, p.providerpk, p.ProviderPreferredConceptRanking, pr.prpk, pcr.PCRIsPreferredConcept, pn2.PNNameFk, p.provideriseditor
		from tblName
		inner join tblProviderName pn on PNNameFk = NameGUID
		inner join tblProviderImport pnpi on pnpi.ProviderImportPk = pn.PNProviderImportFk
		inner join tblProviderConcept pc on pc.PCName1Id = pn.PNNameId
		inner join tblProviderConceptRelationship pcr on pcr.PCRConcept1Id = pc.PCConceptId
				and pcr.PCRRelationshipFk = 15 
		inner join tblProviderImport pcrpi on pcrpi.ProviderImportPk = pcr.PCRProviderImportFk		
		inner join tblProvider p on p.ProviderPk = pcrpi.ProviderImportProviderFk
				and (pcrpi.ProviderImportProviderFk = pnpi.ProviderImportProviderFk or p.provideriseditor = 1)
		inner join tblProviderConcept pc2 on pc2.PCConceptId = pcr.PCRConcept2Id
		left join tblProviderName pn2 on pn2.PNNameId = pc2.PCName1Id
		left join tblProviderImport pnpi2 on pnpi2.ProviderImportPk = pn2.PNProviderImportFk
		left join tblProvider p2 on p2.ProviderPk = pnpi2.ProviderImportProviderFk
				and (p2.ProviderPk = pcrpi.ProviderImportProviderFk or p2.provideriseditor = 1)
		left join tblProviderReference pr on pr.PRReferenceId = pc.PCAccordingToId 
		left join tblProviderImport pri on pri.ProviderImportPk = pr.PRProviderImportFK
		left join tblProvider prp on prp.ProviderPk = pri.ProviderImportProviderFk and prp.ProviderPk = pcrpi.ProviderImportProviderFk
		where NameGUID = @nameGuid or NameBasionymFk = @basId
			
		--check most preferred provider details
		select top 1 @prefProv = ProviderPk from @recs order by rank 
		
		if ((select COUNT(pnpk) from @recs where providerpk = @prefProv and isEditor = 1) = 1)
		begin
			set @reason = 'Editor Record'
			return @reason		
		end
		
		if ((select count(distinct prefnameFk) from @recs where providerpk = @prefProv) = 1)
		begin
			select top 1 @isEd = isEditor, @prefFk = prefnamefk from @recs where providerpk = @prefProv
			set @reason = 'Most Preferred Provider'
			if (@isEd = 1) 
			begin
				set @reason = 'Editor Record'
				return @reason
			end
		end
		else
		begin
			-- there is > 1 pref name, so use IsPreferredConcept, or most recent by ref date
			if ((select count(*) from @recs where providerpk = @prefprov and ispref = 1) = 1)
			begin
				select top 1 @prefFk = prefnamefk, @isEd = isEditor from @recs where providerpk = @prefProv and ispref = 1
				if (@prefFk is not null) set @reason = 'Most Preferred Provider Concept'
				if (@isEd = 1) 
				begin
					set @reason = 'Editor Record'
					return @reason
				end
			end
			else
			begin
				select top 1 @prefFk = prefnamefk
				from @recs r
				inner join vwproviderreference pr on pr.prpk = r.accto
				left join tblproviderris ris on ris.prisproviderreferencefk = pr.prpk
				order by ris.prisdate desc				

				if (@prefFk is not null) set @reason = 'Most Recent Provider Concept'
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
				set @reason = 'Preferred Name of Preferred Name'
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

		if (@prefFk is not null) set @reason = 'Names point to this name as preferred name'
	end
	
	--if pref name is still null, check child names to see if any child names are 
	-- 'current' names, then this name should also be a 'current' name
	if (@prefFk is null)
	begin
		if (exists(select * from tblname 
				where nameparentfk = @nameGuid and namepreferredfk = nameguid))
		begin
			set @prefFk = @nameGuid
			set @reason = 'A child name is an accepted name'
		end
	end
	
	
	return @reason
end

GO


GRANT EXEC ON fnGetPreferredNameReason TO PUBLIC

GO


 