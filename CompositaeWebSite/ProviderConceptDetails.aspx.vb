Imports ChecklistDataAccess
Imports ChecklistObjects

Imports System.Data

Partial Class ProviderConceptDetails
    Inherits System.Web.UI.Page

    Dim provConcs As DataSet

    Protected ReadOnly Property AltBGColor() As String
        Get
            Return ConfigurationManager.AppSettings("AltBGcolor")
        End Get
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Dim id As String = Request.QueryString("nameGuid")
            Dim crGuid As String = Request.QueryString("crGuid")

            provConcs = ConceptData.GetProviderConceptRelationshipRecords(id, False)

            Dim dt As New DataTable
            dt.Columns.Add("Provider")
            dt.Columns.Add("Relationship")
            dt.Columns.Add("Value")

            Dim col As New BoundField
            col.ItemStyle.Width = 250
            col.DataField = "Provider"
            col.HeaderText = "Provider"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            DetailsGrid.Columns.Add(col)

            col = New BoundField
            col.ItemStyle.Width = 100
            col.DataField = "Relationship"
            col.HeaderText = "Relationship"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            DetailsGrid.Columns.Add(col)

            col = New BoundField
            col.ItemStyle.Width = 100
            col.DataField = "Value"
            col.HeaderText = "Value"
            col.HeaderStyle.HorizontalAlign = HorizontalAlign.Left
            DetailsGrid.Columns.Add(col)

            For Each r As DataRow In provConcs.Tables(0).Rows
                If r("PCRConceptRelationshipFk").ToString = crGuid Then
                    dt.Rows.Add(New Object() {r("ProviderPk").ToString + " - " + r("ProviderName").ToString, r("PCRRelationship"), r("PCName2").ToString})
                End If
            Next

            DetailsGrid.DataSource = dt
            DetailsGrid.DataBind()

            DetailsGrid.HeaderStyle.BackColor = System.Drawing.Color.FromName(AltBGColor)
        Catch ex As Exception
            DataAccess.Utility.LogError(ex)
        End Try
    End Sub
End Class
