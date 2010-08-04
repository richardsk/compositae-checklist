IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_Authors')
	BEGIN
		DROP  Procedure  sprSelect_Authors
	END

GO

CREATE Procedure sprSelect_Authors
	@searchTxt nvarchar(100),
	@anywhereInText bit
AS

	declare @likeText nvarchar(150)
	set @likeText = @searchTxt + '%'
	
	if (@anywhereInText = 1) set @likeText = '%' + @likeText
	
	select a.AuthorPk,
		a.IPNIAuthor_Id,
		a.IPNIVersion,
		a.Abbreviation,		
		a.Forename,
		a.Surname,
		a.TaxonGroups,
		a.Dates,
		a.IPNIAlternativeNames,
		case when a.CorrectAuthorFk = a.AuthorPk then '<self>' else ca.Abbreviation end as CorrectAuthor,
		a.CorrectAuthorFk,
		a.AddedDate,
		a.AddedBy,
		a.UpdatedDate,
		a.UpdatedBy
	from tblAuthors a
	left join tblAuthors ca on ca.AuthorPk = a.CorrectAuthorFk
	where a.Abbreviation like @likeText

GO


GRANT EXEC ON sprSelect_Authors TO PUBLIC

GO

