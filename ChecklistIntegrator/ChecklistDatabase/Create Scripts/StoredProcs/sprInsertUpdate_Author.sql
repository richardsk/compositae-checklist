IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Author')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Author
	END

GO

CREATE Procedure sprInsertUpdate_Author
	@authorPk int,
	@IPNIAuthor_Id nvarchar(255),
	@IPNIVersion nvarchar(255),
	@abbreviation nvarchar(255),
	@forename nvarchar(255),
	@surname nvarchar(255),
	@TaxonGroups nvarchar(255),
	@Dates nvarchar(255),
	@IPNIAlternativeNames nvarchar(255),
	@correctAuthorFk int,
	@user nvarchar(50)
	
AS

	if (@authorPk is null or @authorPk = -1)
	begin
		insert tblAuthors
		select @IPNIAuthor_Id, @IPNIVersion, @abbreviation, @forename, @surname, @TaxonGroups, @Dates, @IPNIAlternativeNames, @correctAuthorFk, getdate(), @user, null, null
		
		select @authorPk = @@identity
				
	end
	else
	begin
		if (not exists(select * from tblAuthors where AuthorPk = @authorPk))
		begin
			set identity_insert tblAuthors on
			
			insert tblAuthors(AuthorPK, IPNIAuthor_id, IPNIversion, Abbreviation, Forename, Surname, TaxonGroups, Dates, IPNIAlternativeNames, CorrectAuthorFK, AddedDate, AddedBy, UpdatedDate, UpdatedBy) 
			select @authorPk, @IPNIAuthor_Id, @IPNIVersion, @abbreviation, @forename, @surname, @TaxonGroups, @Dates, @IPNIAlternativeNames, @correctAuthorFk, getdate(), @user, null, null
			
			set identity_insert tblAuthors off
		end
		else
		begin		
			update tblAuthors
			set IPNIAuthor_Id = @IPNIAuthor_Id,
				IPNIVersion = @IPNIVersion,				
				Abbreviation = @abbreviation,
				Forename = @forename,
				Surname = @surname,
				TaxonGroups = @TaxonGroups,
				Dates = @Dates,
				IPNIAlternativeNames = @IPNIAlternativeNames,
				CorrectAuthorFk = @correctAuthorFk
			where AuthorPk = @authorPk
						
		end
	end
		
	if (@correctAuthorFk is null)
	begin
		update tblAuthors 
		set CorrectAuthorFk = @authorPk,
			UpdatedDate = getdate(),
			UpdatedBy = @user
		where AuthorPk = @authorPk
	end

	select @authorPk

GO


GRANT EXEC ON sprInsertUpdate_Author TO PUBLIC

GO


