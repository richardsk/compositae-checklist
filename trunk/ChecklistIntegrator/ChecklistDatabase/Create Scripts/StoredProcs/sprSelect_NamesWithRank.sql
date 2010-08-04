IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithRank')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithRank
	END

GO

CREATE Procedure sprSelect_NamesWithRank
	@providerNamePk int,
	@threshold int --ignored - must match rank fk exaclty
AS

	declare @nameRankFk int
	select @nameRankFk = PNNameRankFk from tblProviderName
	where PNPk = @providerNamePk
	
	if (@nameRankFk is null)
	begin
		--fail
		delete tmpMatchResults
		return
	end
	

	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, 100
		from tblName 
		where NameRankFk = @nameRankFk
	end
	else
	begin
		delete mr
		from tmpMatchResults mr
		inner join tblName n on n.NameGuid = mr.MatchResultRecordId
		where n.NameRankFk <> @nameRankFk
	end
	
GO


GRANT EXEC ON sprSelect_NamesWithRank TO PUBLIC

GO


