IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportAllSubordAndSyn')
	BEGIN
		DROP  Procedure  sprSelect_ReportAllSubordAndSyn
	END

GO

CREATE Procedure sprSelect_ReportAllSubordAndSyn
(
	@nameId uniqueidentifier
)
AS

	declare @ids table(id uniqueidentifier)
	declare @tmp table(id uniqueidentifier)
	
	insert @ids select @nameId
	
	insert @tmp
	select NameGuid from tblName where NameParentFk = @nameId
	
	while (exists(select * from @tmp))
	begin
		insert @ids
		select * from @tmp
		
		delete @tmp
		
		insert @tmp
		select n.NameGuid 
		from tblName n
		inner join @ids i on id = n.NameParentFk
		left join @ids e on e.id = n.NameGuid
		where e.id is null 
	end
	
	select cast(NameGuid as varchar(38)) as NameGuid, 
		NameFull, 
		NameRank, 
		cast(NameParentFk as varchar(38)) as NameParentFk,
		NameParent,
		cast(NamePreferredFk as varchar(38)) as NamePreferredFk,
		NamePreferred,
		case when NameGuid = @nameId then 1 else 0 end as IsReportedName
	from tblName n
	inner join tblRank r on r.rankpk = n.namerankfk
	inner join @ids i on i.id = n.NameGuid
	order by ranksort, namefull

	select cast(n.NameGuid as varchar(38)) as NameGuid, 
		n.NameFull, 
		n.NameRank, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
		case when n.NameGuid = @nameId then 1 else 0 end as IsReportedName
	from tblName n
	inner join tblRank r on r.rankpk = n.namerankfk
	inner join tblName cn on cn.NameGuid = n.NamePreferredFk and cn.NameGuid <> n.NameGuid
	inner join @ids i on i.id = n.NameGuid
	order by ranksort, n.namefull
	
GO


GRANT EXEC ON sprSelect_ReportAllSubordAndSyn TO PUBLIC

GO


