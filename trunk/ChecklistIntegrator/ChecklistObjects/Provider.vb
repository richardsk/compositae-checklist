Public Class Provider
    Inherits BaseObject

    Public FullName As String
    Public Url As String
    Public ProjectUrl As String
    Public ContactName As String
    Public ContactPhone As String
    Public ContactEmail As String
    Public ContactAddress As String
    Public Statement As String
    Public IsEditor As Boolean = False
    Public UseForParentage As Boolean = False
    Public PreferredConceptRanking As Integer = -1


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow)
        IdAsInt = row("ProviderPk")
        Name = row("ProviderName").ToString
        Url = row("ProviderHomeUrl").ToString
        ProjectUrl = row("ProviderProjectUrl").ToString
        ContactName = row("ProviderContactName").ToString
        ContactEmail = row("ProviderContactEmail").ToString
        ContactPhone = row("ProviderContactPhone").ToString
        ContactAddress = row("ProviderContactAddress").ToString
        FullName = row("ProviderNameFull").ToString
        Statement = row("ProviderStatement").ToString
        If Not row.IsNull("ProviderIsEditor") Then IsEditor = row("ProviderIsEditor")
        If Not row.IsNull("ProviderUseForParentage") Then UseForParentage = row("ProviderUseForParentage")
        If Not row.IsNull("ProviderPreferredConceptRanking") Then PreferredConceptRanking = row("ProviderPreferredConceptRanking")
        CreatedBy = row("ProviderCreatedBy").ToString
        UpdatedBy = row("ProviderUpdatedBy").ToString
        If Not row.IsNull("ProviderCreatedDate") Then CreatedDate = row("ProviderCreatedDate")
        If Not row.IsNull("ProviderUpdatedDate") Then UpdatedDate = row("ProviderUpdatedDate")
    End Sub
End Class
