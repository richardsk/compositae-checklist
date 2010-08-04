IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSearch_References')
	BEGIN
		DROP  Procedure  sprSearch_References
	END

GO

CREATE Procedure sprSearch_References
	@searchTxt nvarchar(1000)
AS

	select *
	from tblReference
	where ReferenceCitation like '%' + @searchTxt + '%' or ReferenceFullCitation like '%' + @searchTxt + '%' 
		or (len(@searchTxt)>10 and ReferenceLSID like '%' + @searchTxt + '%')
	order by ReferenceCitation

GO


GRANT EXEC ON sprSearch_References TO PUBLIC

GO


