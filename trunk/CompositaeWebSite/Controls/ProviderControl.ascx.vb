Imports ChecklistObjects
Imports ChecklistDataAccess

Imports System.Data

Partial Class Controls_ProviderControl
    Inherits System.Web.UI.UserControl

    Private Prov As ChecklistObjects.Provider

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Dim pk As Integer = Integer.Parse(Request.QueryString("ProviderId"))

            Prov = ProviderData.GetProvider(pk)

            Dim dt As New DataTable
            dt.Columns.Add("Field")
            dt.Columns.Add("Value")

            Dim col As New BoundField
            col.ItemStyle.Width = 120
            col.ItemStyle.Font.Bold = True
            col.DataField = "Field"
            DetailsGrid.Columns.Add(col)

            col = New BoundField
            col.DataField = "Value"
            DetailsGrid.Columns.Add(col)

            Dim urlPos As Integer = -1
            Dim projUrlPos As Integer = -1

            'dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Id, Prov.Id})
            dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Name, Prov.Name})
            If Prov.FullName <> "" Then
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Full_Name, Prov.FullName})
            End If
            If Prov.ContactName <> "" Then
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Contact_Name, Prov.ContactName})
            End If
            If Prov.ContactEmail <> "" Then
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Contact_Email, Prov.ContactEmail.Trim})
            End If
            If Prov.Url <> "" Then
                urlPos = dt.Rows.Count
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Website, Prov.Url})
            End If
            If Prov.ProjectUrl <> Prov.Url And Prov.ProjectUrl <> "" Then
                projUrlPos = dt.Rows.Count
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Project_Web, Prov.ProjectUrl.Trim})
            End If
            If Prov.Statement <> "" Then
                dt.Rows.Add(New Object() {"", ""})
                dt.Rows.Add(New Object() {Global.Resources.Resource.Prov_Statement, Prov.Statement})
            End If

            DetailsGrid.DataSource = dt
            DetailsGrid.DataBind()

            If urlPos > 0 Then
                DetailsGrid.Rows(urlPos).Cells(1).Text = "<a style='color:black' href='" + DetailsGrid.Rows(urlPos).Cells(1).Text + "' target=_blank>" + DetailsGrid.Rows(urlPos).Cells(1).Text + "</a>"
            End If

            If Prov.Url.Trim.Length > 0 Then
                DetailsGrid.Rows(projUrlPos).Cells(1).Text = "<a style='color:black' href='" + DetailsGrid.Rows(projUrlPos).Cells(1).Text + "' target=_blank>" + DetailsGrid.Rows(projUrlPos).Cells(1).Text + "</a>"
            End If
        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
        End Try
    End Sub
End Class
