
dbcc dbreindex('tblname', '', 70)

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE NONCLUSTERED INDEX IX_tblProviderName_Change_ChangedBy ON dbo.tblProviderName_Change
	(
	ChangedBy
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 70, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX IX_tblProviderName_Change_PNNameFk ON dbo.tblProviderName_Change
	(
	PNNameFk
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_tblProviderName_Change ON dbo.tblProviderName_Change
	(
	PNPk
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT

dbcc dbreindex('tblprovidername_change', '', 70)


CREATE NONCLUSTERED INDEX IX_tblFlatName_NameUFK ON dbo.tblFlatName
	(
	FlatNameNameUFk
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	
go

dbcc dbreindex('tblflatname', '', 70)


CREATE NONCLUSTERED INDEX IX_tblOtherData ON dbo.tblOtherData
	(
	RecordFk
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

dbcc dbreindex('tblotherdata', '', 70)

