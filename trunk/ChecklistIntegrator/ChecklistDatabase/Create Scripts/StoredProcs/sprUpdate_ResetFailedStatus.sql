IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprUpdate_ResetFailedStatus')
	BEGIN
		DROP  Procedure  sprUpdate_ResetFailedStatus
	END

GO

CREATE Procedure sprUpdate_ResetFailedStatus

AS

	update tblProviderName set PNLinkStatus = 'IntegrationFail' where PNLinkStatus = 'FailedCurrent'
	update tblProviderReference set PRLinkStatus = 'IntegrationFail' where PRLinkStatus = 'FailedCurrent'
	update tblProviderConcept set PCLinkStatus = 'IntegrationFail' where PCLinkStatus = 'FailedCurrent'

GO


GRANT EXEC ON sprUpdate_ResetFailedStatus TO PUBLIC

GO


