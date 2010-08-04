IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NamesWithExactCanonical')
	BEGIN
		DROP  Procedure  sprSelect_NamesWithExactCanonical
	END

GO

CREATE Procedure sprSelect_NamesWithExactCanonical
	@providerNamePk int,
	@threshold int
AS

	declare @nameCanonical nvarchar(300)
	select @nameCanonical = ltrim(rtrim(lower(PNNameCanonical))) from tblProviderName where PNPk = @providerNamePk
	
	if (@namecanonical is null or len(@nameCanonical) = 0)
	begin
		--fail
		delete tmpMatchResults
		return
	end

	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select NameGuid, dbo.fnLevenshteinPercentage(lower(NameCanonical), @nameCanonical)
		from tblName 
		where ltrim(rtrim(NameCanonical)) = @nameCanonical
	end
	else
	begin
	
		delete m
		from tmpmatchresults m
		inner join tblName on NameGuid = MatchResultRecordId
		where namecanonical is null or ltrim(rtrim(NameCanonical)) <> @nameCanonical
		
	end

GO


GRANT EXEC ON sprSelect_NamesWithExactCanonical TO PUBLIC

GO


