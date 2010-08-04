IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnIsChildOf')
	BEGIN
		DROP  function fnIsChildOf
	END

GO

CREATE function fnIsChildOf
	(
	@nameGuid uniqueidentifier,
	@parent uniqueidentifier
	)
returns bit
AS
begin

	declare @found bit, @curName uniqueidentifier
	set @found = 0
	set @curName = @nameGuid
	
	if (@nameGuid = @parent) set @found = 1
	else 
	begin
		select @curName = nameparentfk from tblname where nameguid = @curName
		
		while (@curName is not null)
		begin
			if (@curName = @parent)
			begin
				set @found = 1
				set @curName = null
			end
			
			if (@curName is not null) select @curName = nameparentfk from tblname where nameguid = @curName
		end
	end
	
	return @found
end

GO


GRANT EXEC ON fnIsChildOf TO PUBLIC

GO

