IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReferencesForName')
	BEGIN
		DROP  Procedure  dbo.sprSelect_ReferencesForName
	END

GO

CREATE Procedure dbo.sprSelect_ReferencesForName
	@nameGuid uniqueidentifier
AS

	declare @refs table(RefId uniqueidentifier, IsProtologue bit)
	
	insert into @refs
	select distinct r.referenceguid, 1 
	from tblReference r
	inner join tblName on NameReferencefk = r.ReferenceGuid
	where Nameguid = @nameGuid
	union
	select distinct r.referenceguid, 0
	from tblReference r
	inner join tblConcept c on c.ConceptAccordingToFk = r.ReferenceGuid
	where c.ConceptName1Fk = @nameGuid

	select r.*, IsProtologue
	from tblReference r
	inner join @refs on refid = r.referenceguid
	
	select pr.*
	from vwProviderReference pr
	inner join @refs on refid = pr.prreferencefk
	
GO


GRANT EXEC ON sprSelect_ReferencesForName TO PUBLIC

GO


