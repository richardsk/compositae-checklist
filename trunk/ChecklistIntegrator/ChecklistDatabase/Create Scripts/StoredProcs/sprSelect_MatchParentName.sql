IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_MatchParentName')
	BEGIN
		DROP  Procedure  sprSelect_MatchParentName
	END

GO

CREATE Procedure sprSelect_MatchParentName
	@pnpk int
AS
	--get parent name by matching parent details of the provider name
		
	declare @parentFk uniqueidentifier
	
	select @parentFk = dbo.fnGetProviderNameParentMatch( @pnpk )
	
	if (@parentFk = '00000000-0000-0000-0000-000000000000')
	begin
		select @parentfk as NameGuid
	end
	else
	begin	
		exec sprSelect_Name @parentFk
	end

GO


GRANT EXEC ON sprSelect_MatchParentName TO PUBLIC

GO


