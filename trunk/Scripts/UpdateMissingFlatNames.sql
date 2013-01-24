declare @names table(nameguid uniqueidentifier, row int identity(1,1))
insert @names
select nameguid
from tblName n
left join tblFlatName fn on fn.FlatNameSeedName = n.NameGUID	
where fn.FlatNamePk is null

declare @pos int, @cnt int, @id uniqueidentifier

select @pos = 1, @cnt = COUNT(*) from @names

while (@pos < @cnt)
begin
	select @id = nameguid from @names where row = @pos
	
	insert tblFlatName
	exec p_sprSelect_Name_ToRoot_003 @id
	
	set @pos = @pos + 1
end
