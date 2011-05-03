Imports ChecklistDataAccess
Imports ChecklistObjects
Imports WebDataAccess

Imports System.Data

Partial Class EditTrailDetails
    Inherits System.Web.UI.Page

    Dim edits As DataSet

    Protected ReadOnly Property AltBGColor() As String
        Get
            Return ConfigurationManager.AppSettings("AltBGcolor")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Dim id As String = Utility.NameID(Request)

            Dim SelName As Name = NameData.GetName(Nothing, id)

            Label1.Text += SelName.NameFullFormatted

            edits = NameData.GetNameEditTrail(id)

            Dim dt As New DataTable
            dt.Columns.Add("dt")
            dt.Columns.Add("type")
            dt.Columns.Add("details")

            Dim col As New BoundField
            col.ItemStyle.Width = 450
            col.DataField = "dt"
            col.HeaderText = "Date"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            EditDetailsGrid.Columns.Add(col)

            col = New BoundField
            col.DataField = "type"
            col.HeaderText = "Type"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            EditDetailsGrid.Columns.Add(col)

            col = New BoundField
            col.DataField = "details"
            col.HeaderText = "Details "
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            EditDetailsGrid.Columns.Add(col)

            For Each r As DataRow In edits.Tables(0).Rows
                dt.Rows.Add(New Object() {r("dt").ToString, r("type").ToString, r("details").ToString})
            Next

            EditDetailsGrid.DataSource = dt
            EditDetailsGrid.DataBind()

        Catch ex As Exception
            Utility.LogError(ex)
        End Try
    End Sub
End Class
