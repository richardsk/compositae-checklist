IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_NameLinkData')
	BEGIN
		DROP  Procedure  sprUpdate_NameLinkData
	END

GO

CREATE Procedure sprUpdate_NameLinkData
	@nameGuid uniqueidentifier,
	@user nvarchar(50)
AS

	update n
	set n.NamePreferred = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NamePreferredFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameParent = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameParentFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameBasionym = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameBasionymFk
	where n.NameGuid = @nameGuid

	update n
	set n.NameBasedOn = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameBasedOnFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameHomonymOf = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameHomonymOfFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameReplacementFor = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameReplacementForFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameBlocking = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameBlockingFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameTypeName = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameTypeNameFk
	where n.NameGuid = @nameGuid
	
	update n
	set n.NameConservedAgainst = ln.NameFull
	from tblName n
	inner join tblName ln on ln.NameGuid = n.NameConservedAgainstFk
	where n.NameGuid = @nameGuid
	
GO


GRANT EXEC ON sprUpdate_NameLinkData TO PUBLIC

GO


