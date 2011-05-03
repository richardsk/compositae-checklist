Imports ChecklistDataAccess
Imports ChecklistObjects

Imports System.Data

Partial Class ProviderFieldDetails
    Inherits System.Web.UI.Page

    Dim provNames As DataSet

    Protected ReadOnly Property AltBGColor() As String
        Get
            Return ConfigurationManager.AppSettings("AltBGcolor")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Dim id As String = Request.QueryString("nameGuid")
            Dim field As String = Request.QueryString("pnField")

            Label1.Text += field.Substring(2)

            provNames = NameData.GetProviderNameRecords(id)

            Dim dt As New DataTable
            dt.Columns.Add("Provider")
            dt.Columns.Add("Value")

            Dim col As New BoundField
            col.ItemStyle.Width = 450
            col.DataField = "Provider"
            col.HeaderText = "Provider"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            DetailsGrid.Columns.Add(col)

            col = New BoundField
            col.DataField = "Value"
            col.HeaderText = "Value"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            DetailsGrid.Columns.Add(col)

            For Each r As DataRow In provNames.Tables(0).Rows
                dt.Rows.Add(New Object() {r("ProviderPk").ToString + " - " + r("ProviderName").ToString, r(field).ToString})
            Next

            DetailsGrid.DataSource = dt
            DetailsGrid.DataBind()

            DetailsGrid.HeaderStyle.BackColor = System.Drawing.Color.FromName(AltBGColor)
        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
        End Try
    End Sub
End Class
