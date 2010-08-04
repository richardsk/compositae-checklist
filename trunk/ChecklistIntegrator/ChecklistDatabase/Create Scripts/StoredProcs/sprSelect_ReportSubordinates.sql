IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportSubordinates')
	BEGIN
		DROP  Procedure  sprSelect_ReportSubordinates
	END

GO

CREATE Procedure sprSelect_ReportSubordinates
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
			
	
GO


GRANT EXEC ON sprSelect_ReportSubordinates TO PUBLIC

GO


