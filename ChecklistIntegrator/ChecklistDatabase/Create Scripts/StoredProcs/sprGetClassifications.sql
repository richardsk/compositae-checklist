IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprGetClassifications')
	BEGIN
		DROP  Procedure  sprGetClassifications
	END

GO

CREATE Procedure sprGetClassifications
	
AS

	--todo is this needed?
	select 1 as ClassificationCounterPk, 
		'Compositae' as ClassificationDescription

GO


GRANT EXEC ON sprGetClassifications TO PUBLIC

GO


