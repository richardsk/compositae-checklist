IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReferencesWithCitation')
	BEGIN
		DROP  Procedure  sprSelect_ReferencesWithCitation
	END

GO

CREATE Procedure sprSelect_ReferencesWithCitation
	@providerRefPk int,
	@threshold int
AS

	declare @refCitation nvarchar(4000)
	select @refCitation = lower(PRCitation) from tblProviderReference where PRPk = @providerRefPk
	
	
	if ((select count(*) from tmpMatchResults) = 0) --assume this is the first match
	begin
		insert tmpMatchResults
		select ReferenceGuid, dbo.fnLevenshteinPercentage(lower(ReferenceCitation), @refCitation)
		from tblReference 
		where ReferenceCitation = @refCitation
	end
	else
	begin
		delete mr
		from tmpMatchResults mr
		inner join tblReference r on r.ReferenceGuid = mr.MatchResultRecordId
		where ReferenceCitation <> @refCitation
	end

GO


GRANT EXEC ON sprSelect_ReferencesWithCitation TO PUBLIC

GO


