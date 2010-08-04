IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportSubordAndSyn')
	BEGIN
		DROP  Procedure  sprSelect_ReportSubordAndSyn
	END

GO

CREATE Procedure sprSelect_ReportSubordAndSyn
(
	@nameId uniqueidentifier
)
AS

	
	select cast(NameGuid as varchar(38)) as NameGuid, 
		NameFull, 
		NameRank, 
		cast(NameParentFk as varchar(38)) as NameParentFk,
		NameParent,
		cast(NamePreferredFk as varchar(38)) as NamePreferredFk,
		NamePreferred,
		case when NameGuid = @nameId then 1 else 0 end as IsReportedName
	from tblName
	where NameParentFk = @nameId or NameGuid = @nameId
	order by namefull
			
	
	select cast(n.NameGuid as varchar(38)) as NameGuid, 
		n.NameFull, 
		n.NameRank, 
		cast(n.NameParentFk as varchar(38)) as NameParentFk,
		n.NameParent,
		cast(n.NamePreferredFk as varchar(38)) as NamePreferredFk,
		n.NamePreferred,
		case when n.NameGuid = @nameId then 1 else 0 end as IsReportedName
	from tblName n
	inner join tblName cn on cn.NameGuid = n.NamePreferredFk and cn.NameGuid <> n.NameGuid
	where cn.NameParentFk = @nameId or cn.NameGuid = @nameId
	order by n.namefull
	
GO


GRANT EXEC ON sprSelect_ReportSubordAndSyn TO PUBLIC

GO


