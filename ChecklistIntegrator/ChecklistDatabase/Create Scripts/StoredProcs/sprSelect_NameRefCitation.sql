IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameRefCitation')
	BEGIN
		DROP  Procedure  sprSelect_NameRefCitation
	END

GO

CREATE Procedure sprSelect_NameRefCitation
	@nameGuid uniqueidentifier
AS

	declare @ref nvarchar(4000)
	
	--select top 1 @ref = ReferenceCitation --todo, what if there is more than 1 provider name with different references - probably shouldnt happen
	--from tblReference r
	--inner join vwProviderReference pr on pr.PRReferenceFk = r.referenceguid
	--inner join vwProviderName pn on pn.pnreferenceid = pr.prreferenceid and pn.providerpk = pr.providerpk
	--where pn.PNNameFk = @nameGuid

	select top 1 @ref = isnull(ReferenceCitation, ReferenceFullCitation) --todo, what if there is more than 1 provider name with different references - probably shouldnt happen
	from tblReference r
	inner join tblName n on n.NameReferenceFk = r.ReferenceGuid
	where n.NameGuid = @nameGuid
	
	select @ref
	
GO


GRANT EXEC ON sprSelect_NameRefCitation TO PUBLIC

GO


