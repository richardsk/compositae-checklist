IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_DuplicateNameReferences')
	BEGIN
		DROP  Procedure  sprSelect_DuplicateNameReferences
	END

GO

CREATE Procedure sprSelect_DuplicateNameReferences
	@parentNameGuid uniqueidentifier,
	@recurseChildren bit
AS

	declare @res table(NameGuid uniqueidentifier primary key, GotChildren bit, NameReferenceFk uniqueidentifier)

	--get all immediate children
	insert @res
	select NameGuid, null, NameReferenceFk
	from tblName
	where NameParentFk = @parentNameGuid
	
	declare @count int, @lastCount int
	select @count = count(*), @lastCount = 0 from @res
	
	
	while (@recurseChildren = 1 and @count > @lastCount)
	begin
		set @lastCount = @count
		
		update @res set GotChildren = 1 where GotChildren = 0
		update @res set GotChildren = 0 where GotChildren is null
		
		insert @res
		select n.NameGuid, null, n.NameReferenceFk
		from tblName n
		inner join @res r on n.NameParentfk = r.NameGuid and r.GotChildren = 0
		
		select @count = count(*) from @res
	end
	
			
	SELECT  distinct cast(pr1.PRReferenceFk as nvarchar(38)) as ReferenceGuid1,
		cast(pr2.PRReferenceFk as nvarchar(38)) as ReferenceGuid2
		from @res n 
		inner join tblProvidername pn1 on pn1.pnnamefk = n.nameguid 
		INNER JOIN tblProviderReference pr1 on pr1.PRReferenceId = pn1.PNReferenceId 
		INNER JOIN tblProviderName pn2 ON pn1.PNNameFk = pn2.PNNameFk 
		inner join tblProviderReference pr2 on pr2.PRReferenceId = pn2.PNReferenceId 
		WHERE     pr1.PRReferenceFk <> pr2.PRReferenceFk and pr1.prreferencefk is not null and pr2.prreferencefk is not null
		

GO


GRANT EXEC ON sprSelect_DuplicateNameReferences TO PUBLIC

GO


