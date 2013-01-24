update tblOtherData set tmpxml = OtherDataXml

while exists(select * from tblOtherData where CHARINDEX('<Provider>', cast(tmpxml as nvarchar(max))) <> 0)
begin
	update o
	set tmpxml = 
		REPLACE(cast(tmpxml  as nvarchar(max)), 
		'<Provider>' + cast(OD.data.value('.', 'nvarchar(100)') as nvarchar(max)) + '</Provider>', 
		'<Provider id=''' + cast(OD.data.value('.', 'nvarchar(100)') as nvarchar(max)) + '''>' + 
			(select providername from tblprovider where providerpk = cast(OD.data.value('.', 'nvarchar(100)') as nvarchar(max))) + '</Provider>')
	--  OtherDataXml.value('(//Provider)[1]', 'nvarchar(4000)') 
	select o.*
	from tblOtherData o
	cross apply tmpxml.nodes('//Provider[@id=''null'']') as OD(data) 
	where cast(tmpxml.query('//Provider[@id]') as nvarchar(4000)) = ''
end

select top 1000 * from tblOtherData

