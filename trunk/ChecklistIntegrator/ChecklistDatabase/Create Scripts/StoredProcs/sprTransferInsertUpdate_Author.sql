IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprTransferInsertUpdate_Author')
	BEGIN
		DROP  Procedure  sprTransferInsertUpdate_Author
	END

GO

CREATE Procedure sprTransferInsertUpdate_Author
	@AuthorPk int,
	@IPNIAuthor_Id nvarchar(255),
	@IPNIVersion nvarchar(255),
	@Abbreviation nvarchar(255),
	@Forename nvarchar(255),
	@Surname nvarchar(255),
	@TaxonGroups nvarchar(255),
	@Dates nvarchar(255),
	@IPNIAlternativeNames nvarchar(255),
	@CorrectAuthorFk int,
	@AddedDate smalldatetime,
	@AddedBy nvarchar(255),
	@UpdatedDate smalldatetime,
	@UpdatedBy nvarchar(255)
AS

	set identity_insert tblAuthors on
	
	insert tblAuthors(AuthorPK, IPNIAuthor_id, IPNIversion, Abbreviation, Forename, Surname, TaxonGroups, Dates, IPNIAlternativeNames, CorrectAuthorFK, AddedDate, AddedBy, UpdatedDate, UpdatedBy)
	select @AuthorPk, @IPNIAuthor_Id, @IPNIVersion, @Abbreviation, @Forename, @Surname, @TaxonGroups,
		@Dates, @IPNIAlternativeNames, @CorrectAuthorFk, @AddedDate, @AddedDate, @UpdatedDate, @UpdatedBy
	
	set identity_insert tblAuthors off
	
GO


GRANT EXEC ON sprTransferInsertUpdate_Author TO PUBLIC

GO


