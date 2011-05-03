Imports System.Collections.Generic
Imports System.Data
Imports WebDataAccess

Partial Class SimpleNameSearchControl
    Inherits System.Web.UI.UserControl

    Private Sub DoSearch(ByVal pageNumber As Integer)
        Try
            Dim ss As New List(Of SearchSetting)
            Dim s As New SearchSetting
            s.SearchField = "NameFull"
            s.SearchText = SearchText.Text.Trim
            ss.Add(s)
            Dim sst As New SearchStatusSelection
            sst.IncludeUnknown = False
            Dim ds As DataSet = Search.NameSearch(ss, sst)
            ResultsGridView.Visible = True
            DisplayResults(ds, pageNumber)
        Catch ex As Exception
            ErrorLabel.Visible = True
            Utility.LogError(ex)
        End Try
    End Sub

    Private Sub DisplayResults(ByVal ds As DataSet, ByVal pageNumber As Integer)
        Dim dt As New DataTable
        dt.Columns.Add("NameRankFk")
        dt.Columns.Add("NameFull")
        dt.Columns.Add("NameParent")
        dt.Columns.Add("NameGuid")

        dt.Merge(ds.Tables(0), False, MissingSchemaAction.Ignore)

        If dt.Rows.Count = 0 Then
            ErrorLabel.Visible = True
            ErrorLabel.Text = "No records found"
            ErrorLabel.ForeColor = Drawing.Color.Black
            ResultsGridView.Visible = False
        Else
            Dim col As New BoundField
            col.DataField = "NameRankFk"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameFull"
            col.HeaderText = "Full Name"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameParent"
            col.HeaderText = "Parent"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameGuid"
            ResultsGridView.Columns.Add(col)

            ResultsGridView.PageIndex = pageNumber
            ResultsGridView.DataSource = dt
            ResultsGridView.DataBind()

            ResultsGridView.Columns(3).Visible = False

            'update rank image and name links
            For Each r As GridViewRow In ResultsGridView.Rows
                r.Cells(0).Text = "<img src='images\" + Utility.GetImageIndex(r.Cells(0).Text) + "'/>"

                Dim link As String = "<a style='COLOR: black' href='default.aspx?Page=NameDetails&TabNum=0&NameId=" + r.Cells(3).Text + "'>" + r.Cells(1).Text + "</a>"
                r.Cells(1).Text = link
            Next
            ResultsGridView.HeaderRow.Cells(0).Text = ""
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ErrorLabel.Visible = False
        ResultsGridView.Columns.Clear()

        SearchText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
        SearchText.Focus()

    End Sub

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        DoSearch(0)
    End Sub

    Protected Sub ResultsGridView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResultsGridView.PageIndexChanging
        DoSearch(e.NewPageIndex)
    End Sub


End Class
