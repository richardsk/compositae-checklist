Imports System.Collections.Generic
Imports System.Data
Imports WebDataAccess

Partial Class AdvLitSearchControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim fields As List(Of SearchableField) = Search.ListSearchableFields("tblReferenceRIS")
            For Each sf As SearchableField In fields
                Field1.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
                FieldOr1.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
                Field2.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
                FieldOr2.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
                Field3.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
                FieldOr3.Items.Add(New ListItem(sf.FriendlyName, sf.FieldName))
            Next

            SearchText1.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            SearchText2.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            SearchText3.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            SearchTextOr1.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            SearchTextOr2.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            SearchTextOr3.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")

            UpperText1.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            UpperText2.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
            UpperText3.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")

        Catch ex As Exception
            Utility.LogError(ex)
        End Try
    End Sub

    Public Function GetSearchFields() As List(Of SearchSetting)
        Dim ss As New List(Of SearchSetting)

        Dim s As New SearchSetting
        s.SearchField = Field1.Text
        s.SearchText = SearchText1.Text
        If UpperText1.Text.Length > 0 Then s.SearchUpperText = UpperText1.Text
        s.AnywhereInText = AnywhereCheck1.Checked
        s.WholeWord = WholeWordCheck1.Checked

        ss.Add(s)

        If SearchTextOr1.Text.Length > 0 Then
            s = New SearchSetting
            s.IsOr = True
            s.SearchField = FieldOr1.Text
            s.SearchText = SearchTextOr1.Text
            If UpperTextOr1.Text.Length > 0 Then s.SearchUpperText = UpperTextOr1.Text
            s.AnywhereInText = AnywhereCheckOr1.Checked
            s.WholeWord = WholeWordCheckOr1.Checked

            ss.Add(s)
        End If

        If SearchText2.Text.Length > 0 Then
            s = New SearchSetting
            s.IsAnd = True
            s.SearchField = Field2.Text
            s.SearchText = SearchText2.Text
            If UpperText2.Text.Length > 0 Then s.SearchUpperText = UpperText2.Text
            s.AnywhereInText = AnywhereCheck2.Checked
            s.WholeWord = WholeWordCheck2.Checked

            ss.Add(s)
        End If

        If SearchTextOr2.Text.Length > 0 Then
            s = New SearchSetting
            s.IsOr = True
            s.SearchField = FieldOr2.Text
            s.SearchText = SearchTextOr2.Text
            If UpperTextOr2.Text.Length > 0 Then s.SearchUpperText = UpperTextOr2.Text
            s.AnywhereInText = AnywhereCheckOr2.Checked
            s.WholeWord = WholeWordCheckOr2.Checked

            ss.Add(s)
        End If

        If SearchText3.Text.Length > 0 Then
            s = New SearchSetting
            s.IsAnd = True
            s.SearchField = Field3.Text
            s.SearchText = SearchText3.Text
            If UpperText3.Text.Length > 0 Then s.SearchUpperText = UpperText3.Text
            s.AnywhereInText = AnywhereCheck3.Checked
            s.WholeWord = WholeWordCheck3.Checked

            ss.Add(s)
        End If

        If SearchTextOr3.Text.Length > 0 Then
            s = New SearchSetting
            s.IsOr = True
            s.SearchField = FieldOr3.Text
            s.SearchText = SearchTextOr3.Text
            If UpperTextOr3.Text.Length > 0 Then s.SearchUpperText = UpperTextOr3.Text
            s.AnywhereInText = AnywhereCheckOr3.Checked
            s.WholeWord = WholeWordCheckOr3.Checked

            ss.Add(s)
        End If

        Return ss
    End Function

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        DoSearch(0)
    End Sub

    Private Sub DoSearch(ByVal pageNumber As Integer)
        Try
            Dim ss As List(Of SearchSetting) = GetSearchFields()
            Dim ds As DataSet = Search.AdvancedLiteratureSearch(ss)
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
        dt.Columns.Add("ReferenceFullCitation")

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

            col = New BoundField
            col.DataField = "ReferenceFullCitation"
            ResultsGridView.Columns.Add(col)

            ResultsGridView.PageIndex = pageNumber
            ResultsGridView.DataSource = dt
            ResultsGridView.DataBind()

            ResultsGridView.Columns(1).Visible = False
            ResultsGridView.Columns(2).Visible = False

            'update links
            For Each r As GridViewRow In ResultsGridView.Rows
                Dim cit As String = ds.Tables(0).Rows(r.RowIndex)("ReferenceCitation").ToString
                If cit.Length = 0 Then cit = r.Cells(2).Text
                Dim link As String = "<a style='COLOR: black' href='default.aspx?Page=LitDetails&ReferenceId=" + r.Cells(1).Text + "'>" + cit + "</a>"
                r.Cells(0).Text = link
            Next
        End If
    End Sub

    Protected Sub ResultsGridView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResultsGridView.PageIndexChanging
        DoSearch(e.NewPageIndex)
    End Sub

    Protected Sub RangeCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheck1.CheckedChanged
        UpperTD1.Visible = RangeCheck1.Checked
        UpperTD2.Visible = RangeCheck1.Checked
    End Sub

    Protected Sub RangeCheckOr1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheckOr1.CheckedChanged
        UpperTD3.Visible = RangeCheckOr1.Checked
        UpperTD4.Visible = RangeCheckOr1.Checked
    End Sub

    Protected Sub RangeCheck2_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheck2.CheckedChanged
        UpperTD5.Visible = RangeCheck2.Checked
        UpperTD6.Visible = RangeCheck2.Checked
    End Sub

    Protected Sub RangeCheckOr2_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheckOr2.CheckedChanged
        UpperTD7.Visible = RangeCheckOr2.Checked
        UpperTD8.Visible = RangeCheckOr2.Checked
    End Sub

    Protected Sub RangeCheck3_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheck3.CheckedChanged
        UpperTD9.Visible = RangeCheck3.Checked
        UpperTD10.Visible = RangeCheck3.Checked
    End Sub

    Protected Sub RangeCheckOr3_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheckOr3.CheckedChanged
        UpperTD11.Visible = RangeCheckOr3.Checked
        UpperTD12.Visible = RangeCheckOr3.Checked
    End Sub

    Private Sub UpdateAndBoxes()
        and_1.Visible = AndCheck1.Checked
        If Not AndCheck1.Checked Then
            AndCheck2.Checked = False
            OrCheck2.Checked = False
            OrCheck3.Checked = False
            and_2.Visible = False
            advanced_or2.Visible = False
            advanced_or3.Visible = False
        End If

        and_2.Visible = AndCheck2.Checked
        If Not AndCheck2.Checked Then
            OrCheck3.Checked = False
            advanced_or3.Visible = False
        End If
    End Sub

    Protected Sub AndCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles AndCheck1.CheckedChanged
        UpdateAndBoxes()
    End Sub

    Protected Sub AndCheck2_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles AndCheck2.CheckedChanged
        UpdateAndBoxes()
    End Sub

    Protected Sub OrCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OrCheck1.CheckedChanged
        advanced_or1.Visible = OrCheck1.Checked
    End Sub

    Protected Sub OrCheck2_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OrCheck2.CheckedChanged
        advanced_or2.Visible = OrCheck2.Checked
    End Sub

    Protected Sub OrCheck3_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OrCheck3.CheckedChanged
        advanced_or3.Visible = OrCheck3.Checked
    End Sub
End Class
