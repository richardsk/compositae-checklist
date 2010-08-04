IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_CleanDatabase')
	BEGIN
		DROP  Procedure  sprUpdate_CleanDatabase
	END

GO

CREATE Procedure sprUpdate_CleanDatabase

AS

	--clean up remaining provider records that have been created by the editor but then unliked
	delete tblprovidername
	from tblprovidername 
	inner join tblproviderimport on providerimportpk = pnproviderimportfk
	inner join tblprovider on providerpk = providerimportproviderfk
	where pnnamefk is null and provideriseditor = 1


	delete tblproviderris	
	from tblproviderris
	inner join tblproviderreference on prpk = prisproviderreferencefk
	inner join tblproviderimport on providerimportpk = prproviderimportfk
	inner join tblprovider on providerpk = providerimportproviderfk
	where prreferencefk is null and provideriseditor = 1
	
	delete tblproviderreference
	from tblproviderreference
	inner join tblproviderimport on providerimportpk = prproviderimportfk
	inner join tblprovider on providerpk = providerimportproviderfk
	where prreferencefk is null and provideriseditor = 1


	delete tblproviderconcept
	from tblproviderconcept
	inner join tblproviderimport on providerimportpk = pcproviderimportfk
	inner join tblprovider on providerpk = providerimportproviderfk
	where pcconceptfk is null and provideriseditor = 1
	
GO


GRANT EXEC ON sprUpdate_CleanDatabase TO PUBLIC

GO


