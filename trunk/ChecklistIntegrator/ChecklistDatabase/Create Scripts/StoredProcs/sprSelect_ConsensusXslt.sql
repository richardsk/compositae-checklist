IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ConsensusXslt')
	BEGIN
		DROP  Procedure  sprSelect_ConsensusXslt
	END

GO

CREATE Procedure sprSelect_ConsensusXslt
	@otherDataTypePk int
AS

	select xslt
	from tblTransformation
	inner join tblotherdatatype on consensustransformationfk = transformationpk
	where otherdatatypepk = @otherDataTypePk

GO


GRANT EXEC ON sprSelect_ConsensusXslt TO PUBLIC

GO


