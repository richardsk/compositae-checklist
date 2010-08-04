IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetProviderTitles')
	BEGIN
		DROP  Function  fnGetProviderTitles
	END

GO

CREATE Function fnGetProviderTitles
	(
		@nameGuid uniqueidentifier
	)
returns nvarchar(2000)
AS
begin
	declare @provs nvarchar(2000)
	
	set @provs = ''
	
	select @provs = case when charindex(', ' + p.providername, @provs) <> 0 then @provs 
		else @provs + ', ' + p.providername end
	from tblprovidername pn
	inner join tblproviderimport pim on pim.providerimportpk = pnproviderimportfk
	inner join tblprovider p on p.providerpk = pim.providerimportproviderfk
	where pn.pnnamefk = @nameguid
	
	if (len(@provs) > 0) set @provs = substring(@provs, 2, len(@provs))
	
	return @provs
end

GO


GRANT EXEC ON fnGetProviderTitles TO PUBLIC

GO


