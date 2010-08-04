IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'fnGetIPNIIds')
	BEGIN
		DROP  Function fnGetIPNIIds
	END

GO

CREATE Function fnGetIPNIIds
(
	@nameGuid uniqueidentifier
)
returns nvarchar(200)
AS
begin

	declare @ids nvarchar(200)
	
	set @ids = ''
	select @ids = @ids + isnull(pnnameid + ',','')
	from tblprovidername pn 
	inner join tblProviderImport pim on pim.ProviderImportPk = pn.PNProviderImportFk 
	where pn.PNNameFk = @NameGUID and pim.ProviderImportProviderFk = 19
	
	if (len(@ids) > 0) set @ids = left(@ids, len(@ids)-1)
	
	return @ids

end

GO


GRANT EXEC ON fnGetIPNIIds TO PUBLIC

GO

