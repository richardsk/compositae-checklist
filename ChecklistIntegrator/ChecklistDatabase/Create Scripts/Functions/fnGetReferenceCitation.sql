IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'fnGetReferenceCitation')
	BEGIN
		DROP  Function  fnGetReferenceCitation
	END

GO

CREATE Function fnGetReferenceCitation
(
	@refGuid uniqueidentifier 
)
returns nvarchar(4000)
AS

begin

		declare @risType nvarchar(50), @risTypePk int, @cit nvarchar(4000)
		
		select @risType = RIStype from tblReferenceRIS where RISReferenceFk = @refGuid
		select top 1 @risTypePk = RISTypePk
		from tblRisType 
		where charindex('@' + upper(@risType) + '@', RISTypeKnownValues) <> 0
		
		if (@risTypePk = 1)
		begin
			select @cit = isnull(RISAuthors,'') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' (' + rtrim(RISDate) + ')','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + cast(RISTitle as nvarchar(2000)) + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' Vol. ' + RISVolume + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Vol. Vol', 'Vol')
			set @cit = replace(@cit, 'Vol. .', '') --no vol
			select @cit = @cit + isnull(' Edition ' + RISIssue + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Edition Edition', 'Edition')
			set @cit = replace(@cit, 'Edition .', '') --no edition
			select @cit = @cit + isnull(' ' + RISPublisher + ', ','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISCityOfPublication + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
						
			set @cit = replace(@cit, '..', '.')
		end
		
		if (@risTypePk = 2)
		begin			
			select @cit = isnull(RISAuthors,'') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' (' + rtrim(RISDate) + ')','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + cast(RISTitle as nvarchar(2000)) + '. In: ','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISAuthors2,'') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + cast(RISTitle2 as nvarchar(2000)) + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' Vol. ' + RISVolume + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Vol. Vol', 'Vol')
			set @cit = replace(@cit, 'Vol. .', '') --no vol
			select @cit = @cit + isnull(' Edition ' + RISIssue + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Edition Edition', 'Edition')
			set @cit = replace(@cit, 'Edition .', '') --no edition
			select @cit = @cit + isnull(' ' + RISPublisher + ', ','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISCityOfPublication + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISStartPage + ' -','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISEndPage + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			
			set @cit = replace(@cit, '..', '.')
		end
		
		if (@risTypePk = 3)
		begin
			select @cit = isnull(RISAuthors,'') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' (' + rtrim(RISDate) + ')','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + cast(RISTitle as nvarchar(2000)) + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + cast(RISJournalName as nvarchar(2000)),'') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISVolume,'') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Vol. .', '') --no vol
			select @cit = @cit + isnull(' (' + RISIssue + ')','') from tblReferenceRIS where RISReferenceFk = @refGuid
			set @cit = replace(@cit, 'Edition .', '') --no edition
			select @cit = @cit + isnull(' : ' + RISStartPage + ' -','') from tblReferenceRIS where RISReferenceFk = @refGuid
			select @cit = @cit + isnull(' ' + RISEndPage + '.','') from tblReferenceRIS where RISReferenceFk = @refGuid
						
			set @cit = replace(@cit, '..', '.')			
		end
		
		return @cit
	
end

GO


GRANT EXEC ON fnGetReferenceCitation TO PUBLIC

GO


