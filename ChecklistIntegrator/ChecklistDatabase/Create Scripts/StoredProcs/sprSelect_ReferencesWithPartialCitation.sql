IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReferencesWithPartialCitation')
	BEGIN
		DROP  Procedure  sprSelect_ReferencesWithPartialCitation
	END

GO

CREATE Procedure sprSelect_ReferencesWithPartialCitation
	@providerRefPk int,
	@threshold int
AS

	declare @refCitation nvarchar(4000)
	select @refCitation = lower(PRCitation) from tblProviderReference where PRPk = @providerRefPk
	
	declare @lenDiff int
	set @lenDiff = ceiling((len(@refCitation)*(100-@threshold)/100)) --10% of citation length
	
	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		declare @lvs table(refId uniqueidentifier)
		insert @lvs
		select ReferenceGuid
		from tblReference 
		where abs(len(ReferenceCitation) - len(@refCitation)) <= @lenDiff
		
		insert tmpMatchResults
		select ReferenceGuid, dbo.fnLevenshteinPercentage(lower(ReferenceCitation), @refCitation)
		from @lvs l
		inner join tblReference r on r.ReferenceGuid = l.refId
		where dbo.fnLevenshteinPercentage(lower(ReferenceCitation), @refCitation) >= @threshold 
	end
	else
	begin
		delete mr
		from tmpMatchResults mr
		inner join tblReference r on r.ReferenceGuid = mr.MatchResultRecordId
		where dbo.fnLevenshteinPercentage(lower(ReferenceCitation), @refCitation) < @threshold 
	end

GO


GRANT EXEC ON sprSelect_ReferencesWithPartialCitation TO PUBLIC

GO


