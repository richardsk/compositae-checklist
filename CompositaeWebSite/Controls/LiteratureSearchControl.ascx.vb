Imports System.Collections.Generic
Imports System.Data
Imports WebDataAccess

Partial Class Controls_LiteratureSearchControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim f As NameValueCollection = Request.Form
        'If f("SearchControl1$cbxRangeCheck") = "on" Then

        SearchText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")

    End Sub

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        DoSearch(0)
    End Sub

    Protected Sub ClearButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearButton.Click
        SearchText.Text = ""
        UpperText.Text = ""
    End Sub

    Private Sub DoSearch(ByVal pageNumber As Integer)
        Try
            Dim ss As New List(Of SearchSetting)
            Dim s As New SearchSetting
            s.SearchField = "ReferenceCitation"
            s.SearchText = SearchText.Text
            If UpperText.Text.Length > 0 AndAlso Request.Form("SearchControl1$cbxRangeSearch") IsNot Nothing Then s.SearchUpperText = UpperText.Text
            ss.Add(s)
            Dim ds As DataSet = Search.LiteratureSearch(ss)
            DisplayResults(ds, pageNumber)
            ResultsGridView.Visible = True
        Catch ex As Exception
            ErrorLabel.Visible = True
            Utility.LogError(ex)
        End Try
    End Sub

    Private Sub DisplayResults(ByVal ds As DataSet, ByVal pageNumber As Integer)
        Dim dt As New DataTable
        dt.Columns.Add("ReferenceCitation")
        dt.Columns.Add("ReferenceGuid")

        dt.Merge(ds.Tables(0), False, MissingSchemaAction.Ignore)

        If dt.Rows.Count = 0 Then
            ErrorLabel.Visible = True
            ErrorLabel.Text = "No records found"
            ErrorLabel.ForeColor = Drawing.Color.Black
        Else
            Dim col As New BoundField
            col.DataField = "ReferenceCitation"
            col.HeaderText = "Citation"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "ReferenceGuid"
            ResultsGridView.Columns.Add(col)

            ResultsGridView.PageIndex = pageNumber
            ResultsGridView.DataSource = dt
            ResultsGridView.DataBind()

            ResultsGridView.Columns(1).Visible = False

            'update links
            For Each r As GridViewRow In ResultsGridView.Rows
                Dim link As String = "<a style='COLOR: black' href='default.aspx?Page=LitDetails&ReferenceId=" + r.Cells(1).Text + "'>" + r.Cells(0).Text + "</a>"
                r.Cells(0).Text = link
            Next
        End If
    End Sub

End Class
