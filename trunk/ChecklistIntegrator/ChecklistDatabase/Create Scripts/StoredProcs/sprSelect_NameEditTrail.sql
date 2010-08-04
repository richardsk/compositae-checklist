IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NameEditTrail')
	BEGIN
		DROP  Procedure  sprSelect_NameEditTrail
	END

GO

CREATE Procedure sprSelect_NameEditTrail
	@nameGuid uniqueidentifier
AS

	declare @details table(dt datetime, type nvarchar(100), details xml)

	insert @details
	select distinct pn.changeddate, 'Editor Update', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and provideriseditor = 1
	
	insert @details
	select distinct pn.changeddate, 'Provider Name Updated', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and (provideriseditor = 0 or provideriseditor is null) 
	
	insert @details
	select top 1 pn.changeddate, 'Provider Name Imported', 
		(select * from tblprovidername_change where pnpk = pn.pnpk for xml auto)
	from tblProviderName_Change pn
	left join vwProviderName vpn on vpn.PNPk = pn.PNPk
	where pn.PNNameFk = @nameguid and (provideriseditor = 0 or provideriseditor is null) 
	order by pn.PNUpdatedDate desc
	
	select * from @details

GO


GRANT EXEC ON sprSelect_NameEditTrail TO PUBLIC

GO


