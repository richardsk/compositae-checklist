IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ReportDiffMatrix')
	BEGIN
		DROP  Procedure  sprSelect_ReportDiffMatrix
	END

GO

CREATE Procedure sprSelect_ReportDiffMatrix
(
	@nameId uniqueidentifier
)
AS

	
	select *
	from tblName
	where NameGuid = @nameId
		
	select *
	from vwProviderName 
	where PNNameFk = @nameId
	
			
	
GO


GRANT EXEC ON sprSelect_ReportDiffMatrix TO PUBLIC

GO


