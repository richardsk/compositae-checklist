Imports ChecklistDataAccess
Imports ChecklistObjects

Imports System.Data
Imports System.Collections.Generic


Partial Class Controls_ProviderListControl
    Inherits System.Web.UI.UserControl

    Protected ReadOnly Property AltBGColor() As String
        Get
            Return ConfigurationManager.AppSettings("AltBGcolor")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            If Request.QueryString.Get("coverage") IsNot Nothing Then
                DisplayMap()
            Else
                DisplayProviders()
            End If
            
        Catch ex As Exception
            DataAccess.Utility.LogError(ex)
        End Try
    End Sub

    Private Sub DisplayMap()
        Dim map As Control = LoadControl("StaticMapControl.ascx")
        mapPlaceholder.Controls.Add(map)
    End Sub

    Private Sub DisplayProviders()
        Dim dt As New DataTable
        dt.Columns.Add("ProviderId")
        dt.Columns.Add("ProviderName")

        Dim ps As New List(Of String)

        Dim providers As ChecklistObjects.Provider() = ProviderData.GetProviders()
        For Each p As ChecklistObjects.Provider In providers
            If Not p.IsEditor And p.Name <> "SYSTEM" Then
                dt.Rows.Add(New Object() {p.Id, p.Name})
            End If
        Next

        DetailsGridView.RepeatColumns = 2
        DetailsGridView.Width = New Unit("100%")

        DetailsGridView.DataSource = New DataView(dt)
        DetailsGridView.DataBind()

    End Sub
End Class
