IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithYear')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithYear
	END

GO

CREATE Procedure sprSelect_NamesWithYear
	@providerNamePk int,
	@threshold int
AS

	declare @nameYear nvarchar(20)
	select @nameYear = lower(PNYear) from tblProviderName where PNPk = @providerNamePk
	
	
	if (@nameYear is null or len(@nameYear) = 0)
	begin
		--pass
		return
	end
	

	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, 100
		from tblName 
		where NameYear = @nameYear
	end
	else
	begin
	--special case - if there are no matching names with the specified year then 
		-- also check the provider name year for matches
		if ((select count(*) from tmpmatchresults m
			inner join tblName n on n.NameGuid = m.MatchResultRecordId
			where len(NameYear)=0 or isnull(NameYear, @nameYear) = @nameYear) = 0)
		begin
			delete m
			from tmpMatchResults m
			where not exists( select * 
				from tblprovidername pn
				where pn.pnnamefk = m.matchresultrecordid
					and len(PNYear) = 0 or isnull(PNYear, @nameYear) = @nameYear ) 
				
			print('Provider Name Author Match')
		end
		else
		begin
			delete mr
			from tmpMatchResults mr
			inner join tblName n on n.NameGuid = mr.MatchResultRecordId
			where len(NameYear) > 0 and isnull(NameYear, @nameYear) <> @nameYear
		end
	end

	
GO


GRANT EXEC ON sprSelect_NamesWithYear TO PUBLIC

GO


