IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_OtherData')
	BEGIN
		DROP  Procedure  sprInsertUpdate_OtherData
	END

GO

CREATE Procedure sprInsertUpdate_OtherData
	@otherDataPk uniqueidentifier,
	@otherDataTypeFk int,
	@recordFk nvarchar(300),
	@xml nvarchar(max),
	@data nvarchar(max),
	@user nvarchar(50)
AS

	if (@otherDataPk is null or not exists(select * from tblOtherData where OtherDataPk = @otherDataPk))
	begin
		--check if a record for this name and data type already exists
		select @otherDataPk = OtherDataPk from tblOtherData where RecordFk = @recordFk and OtherDataTypeFk = @otherDataTypeFk
		
		if (@otherDataPk is null)
		begin
			set @otherDataPk = newid()
			
			insert tblOtherData
			select @otherDataPk,
				@otherDataTypeFk,
				@recordFk,
				@xml, 
				@data,
				@user,
				getdate(),
				null, null					
		end
		else
		begin
			update tblOtherData
			set OtherDataTypeFk = @otherDataTypeFk,
				RecordFk = @recordFk,
				OtherDataXml = @Xml,
				OtherDataData = @data,
				UpdatedBy = @user,
				UpdatedDate = getdate()
			where OtherDataPk = @otherDataPk
		end
	end
	else
	begin
		update tblOtherData
		set OtherDataTypeFk = @otherDataTypeFk,
			RecordFk = @recordFk,
			OtherDataXml = @Xml,
			OtherDataData = @data,
			UpdatedBy = @user,
			UpdatedDate = getdate()
		where OtherDataPk = @otherDataPk
			
	end
	
	
	--all standard output for this name and type will point to this record
	update so
	set OtherDataFk = @otherDataPk
	from tblStandardOutput so	
	inner join vwProviderOtherData pod on pod.POtherDataTextPk = so.POtherDataFk
	inner join vwProviderName pn on pn.PNNameId = pod.POtherDataRecordId and pod.ProviderPk = pn.ProviderPk
	where pn.PNNameFk = @recordFk and so.OtherTypeFk = @otherDataTypeFk
	
	--update distribution table
	set arithabort on
	delete 	tblDistribution where nameguid = @recordFk

	insert tblDistribution
	select distinct recordFk, 
		OD.data.value('./@L1', 'nvarchar(100)') as L1,
		OD.data.value('./@L2', 'nvarchar(100)') as L2,
		OD.data.value('./@L3', 'nvarchar(100)') as L3,
		OD.data.value('./@L4', 'nvarchar(100)') as L4,
		OD.data.value('./@region', 'nvarchar(100)') as Region, 
		OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence
	from tblOtherData 
	cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) 
	where RecordFk = @recordFk
	

	select * from tblOtherData where OtherDataPk = @otherDataPk

GO


GRANT EXEC ON sprInsertUpdate_OtherData TO PUBLIC

GO


