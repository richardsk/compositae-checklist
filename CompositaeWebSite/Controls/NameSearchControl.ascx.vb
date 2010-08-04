Imports System.Collections.Generic
Imports System.Data

Partial Class Controls_NameSearchControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'SearchText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")
        'SearchUpperText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")

        'SearchText.Focus()

        reportImage.Visible = False
        downloadLink.Visible = False
        downloadCsvImage.Visible = False
        downloadCsvLink.Visible = False

        If Not Page.IsPostBack Then
            'If Request.QueryString("download") IsNot Nothing Then
            '    doDownload()
            'Else
            DoSearches()
            'End If
        End If

    End Sub

    Private Function DoSearches() As DataSet
        Dim ds As DataSet = Nothing

        If Request.QueryString("searchText") IsNot Nothing Then
            Dim txt As String = Request.QueryString("searchText")
            Dim field As String = Request.QueryString("searchField")
            'SearchText.Text = txt
            ds = DoSearch(0, field, txt, Nothing)
        ElseIf Request.QueryString("country") IsNot Nothing Then
            ds = DoDistSearch(0)
        ElseIf Request.QueryString("continent") IsNot Nothing Then
            ds = DoDistSearch(0)
        ElseIf Request.QueryString("region") IsNot Nothing Then
            ds = DoDistSearch(0)
        ElseIf Request.QueryString("unit") IsNot Nothing Then
            ds = DoDistSearch(0)
        End If

        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            reportImage.Visible = True
            downloadLink.Visible = True
            downloadCsvImage.Visible = True
            downloadCsvLink.Visible = True
            'reportLink.NavigateUrl = Request.RawUrl
            'If Request.QueryString("download") Is Nothing Then
            '    reportLink.NavigateUrl += "&download=true"
            'End If
        End If

        Return ds
    End Function

    Private Function DoSearch(ByVal pageNumber As Integer, ByVal searchField As String, ByVal searchText As String, ByVal upperText As String) As DataSet
        Dim resds As DataSet = Nothing
        Try
            Dim ss As New List(Of DataAccess.SearchSetting)
            Dim s As New DataAccess.SearchSetting
            s.SearchField = "NameFull"
            If searchField IsNot Nothing Then s.SearchField = searchField
            s.SearchText = searchText.Trim
            s.SearchUpperText = upperText
            ss.Add(s)
            Dim sst As New DataAccess.SearchStatusSelection
            Dim ds As DataSet = DataAccess.Search.NameSearch(ss, sst)
            DisplayResults(ds, pageNumber)
            If ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
                Dim varDs As DataSet = DataAccess.Search.NameSearchVariants(searchText)
                DisplayDidYouMeanResults(varDs, pageNumber)
                If varDs.Tables.Count > 0 AndAlso varDs.Tables(0).Rows.Count > 0 Then
                    resds = varDs
                End If
            Else
                resds = ds
                numSearchResults.Text = ds.Tables(0).Rows.Count.ToString + " " + Global.Resources.Resource.Search_Results
            End If
            ResultsGridView.Visible = True
        Catch ex As Exception
            ErrorLabel.Visible = True
            DataAccess.Utility.LogError(ex)
        End Try

        Return resds
    End Function

    Private Function DoDistSearch(ByVal pageNumber As Integer) As DataSet
        Dim resds As DataSet = Nothing
        Try
            Dim txt As String = Request.QueryString("continent")
            Dim level As DataAccess.TDWGGeoLevel = DataAccess.TDWGGeoLevel.TDWG4
            'Dim tg As New DataAccess.TDWGGeo
            If txt IsNot Nothing Then
                'tg = DataAccess.Distribution.GetTDWGeoByName(DataAccess.TDWGGeoLevel.TDWG1, txt)
                level = DataAccess.TDWGGeoLevel.TDWG1
            Else
                txt = Request.QueryString("region")
                If txt IsNot Nothing Then
                    'tg = DataAccess.Distribution.GetTDWGeoByName(DataAccess.TDWGGeoLevel.TDWG2, txt)
                    level = DataAccess.TDWGGeoLevel.TDWG2
                Else
                    txt = Request.QueryString("country")
                    If txt IsNot Nothing Then
                        'tg = DataAccess.Distribution.GetTDWGeoByName(DataAccess.TDWGGeoLevel.TDWG3, txt)
                        level = DataAccess.TDWGGeoLevel.TDWG3
                    Else

                        txt = Request.QueryString("unit")
                        If txt IsNot Nothing Then
                            'tg = DataAccess.Distribution.GetTDWGeoByName(DataAccess.TDWGGeoLevel.TDWG4, txt)
                            level = DataAccess.TDWGGeoLevel.TDWG4
                        End If
                    End If
                End If
            End If

            If txt IsNot Nothing Then
                Dim tgs As List(Of DataAccess.TDWGGeo) = DataAccess.Distribution.Gazetteer.GetGeoRegions(level, txt)
                Dim ds As DataSet = DataAccess.Search.DistributionSearch(tgs)

                DisplayResults(ds, pageNumber)
                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    resds = ds
                    numSearchResults.Text = ds.Tables(0).Rows.Count.ToString + " " + Global.Resources.Resource.Search_Results
                End If
                ResultsGridView.Visible = True
            End If
        Catch ex As Exception
            ErrorLabel.Visible = True
            DataAccess.Utility.LogError(ex)
        End Try

        Return resds
    End Function

    Private Sub DisplayResults(ByVal ds As DataSet, ByVal pageNumber As Integer)
        Dim dt As New DataTable
        dt.Columns.Add("NameRankFk")
        dt.Columns.Add("NameFull")
        dt.Columns.Add("NameStatus")
        dt.Columns.Add("NameGuid")
        dt.Columns.Add("NamePreferredFk")

        dt.Merge(ds.Tables(0), False, MissingSchemaAction.Ignore)

        If dt.Rows.Count = 0 Then
            ErrorLabel.Visible = True
            ErrorLabel.Text = "No records found"
            ErrorLabel.ForeColor = Drawing.Color.Black
        Else
            reportImage.Visible = True
            downloadLink.Visible = True
            downloadCsvImage.Visible = True
            downloadCsvLink.Visible = True

            Dim col As New BoundField
            col.DataField = "NameRankFk"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameFull"
            col.HeaderText = Global.Resources.Resource.Result_Full_Name
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameStatus"
            col.HeaderText = Global.Resources.Resource.Result_Status
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NameGuid"
            ResultsGridView.Columns.Add(col)

            col = New BoundField
            col.DataField = "NamePreferredFk"
            ResultsGridView.Columns.Add(col)

            ResultsGridView.AutoGenerateColumns = False
            ResultsGridView.PageIndex = pageNumber
            ResultsGridView.DataSource = dt
            ResultsGridView.DataBind()

            ResultsGridView.Columns(3).Visible = False
            ResultsGridView.Columns(4).Visible = False


            'update rank image and name links
            For Each r As GridViewRow In ResultsGridView.Rows
                r.Cells(0).Text = "<img src='images\" + DataAccess.Utility.GetImageIndex(r.Cells(0).Text) + "'/>"

                Dim link As String = "<a style='COLOR: black' href='default.aspx?Page=NameDetails&TabNum=0&NameId=" + r.Cells(3).Text + "'>" + r.Cells(1).Text + "</a>"
                r.Cells(1).Text = link

                If r.Cells(2).Text.StartsWith("Accepted") Then
                    r.Cells(2).Text = "<span style='color:green'>" + r.Cells(2).Text + "</span>"
                ElseIf Not r.Cells(2).Text.StartsWith("[No Concept]") Then
                    link = "<span style='color:red'>Synonym</span> of <a style='COLOR: black' href='default.aspx?Page=NameDetails&TabNum=0&NameId=" + r.Cells(4).Text + "'>"
                    r.Cells(2).Text = link + r.Cells(2).Text + "</a>"
                End If
            Next
            ResultsGridView.HeaderRow.Cells(0).Text = ""
        End If
    End Sub

    Private Sub DisplayDidYouMeanResults(ByVal ds As DataSet, ByVal pageNumber As Integer)
        
        If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            Dim html As String = "<table width='100%'><tr><td colspan='2'><b>" + Global.Resources.Resource.Did_You_Mean + "</b></td></tr>"

            For Each row As DataRow In ds.Tables(0).Rows
                html += "<tr><td style='color:green'>" + row("MatchingText").ToString + "</td>"
                html += "<td>" + DataAccess.Utility.GetNameLinkHtml(Request, row("NameGuid").ToString, row("NameFull").ToString, "0") + "</td></tr>"
            Next

            html += "</table>"

            Dim ctrl As New HtmlGenericControl()
            ctrl.InnerHtml = html

            didYouMeanPlaceholder.Controls.Add(ctrl)
        End If

    End Sub

    'Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
    '    Dim txt As String = SearchText.Text
    '    Dim upTxt As String = ""
    '    'If SearchUpperText.Text.Length > 0 AndAlso Request.Form("SearchControl1$cbxRangeSearch") = "on" Then upTxt = SearchUpperText.Text
    '    DoSearch(0, txt, upTxt)
    'End Sub

    Protected Sub ResultsGridView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResultsGridView.PageIndexChanging
        Dim txt As String = Request.QueryString("searchText")
        Dim field As String = Request.QueryString("searchField")
        Dim upTxt As String = ""
        'If SearchUpperText.Text.Length > 0 AndAlso Request.Form("SearchControl1$cbxRangeSearch") = "on" Then upTxt = SearchUpperText.Text
        DoSearch(e.NewPageIndex, field, txt, upTxt)
    End Sub

    'Protected Sub ClearButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles ClearButton.Click
    '    SearchText.Text = ""
    '    'SearchUpperText.Text = ""

    'End Sub

    Protected Sub doDownload()
        Try

            Dim results As DataSet = DoSearches()

            If results IsNot Nothing AndAlso results.Tables.Count > 0 AndAlso results.Tables(0).Rows.Count > 0 Then
                Dim doc As String = DataAccess.Report.GetNamesReport(results, False, False)

                Dim fname As String = Guid.NewGuid.ToString + ".rtf"
                IO.File.WriteAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "temp\" + fname), doc)

                Response.Redirect(Request.ApplicationPath + "\temp\" + fname)

                'Response.Clear()
                'Response.ContentType = "application/rtf"
                'Response.Write(doc)
                'Response.End()

            End If
        Catch ex As Exception
            DataAccess.Utility.LogError(ex)
        End Try
    End Sub

    Protected Sub doDownloadCSV()
        Dim results As DataSet = DoSearches()

        If results IsNot Nothing AndAlso results.Tables.Count > 0 AndAlso results.Tables(0).Rows.Count > 0 Then
            Dim doc As String = DataAccess.Report.GetNamesReportCSV(results, False, True)

            Dim fname As String = Guid.NewGuid.ToString + ".csv"
            IO.File.WriteAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "temp\" + fname), doc)

            Response.Redirect(Request.ApplicationPath + "\temp\" + fname)

        End If
    End Sub

    Protected Sub downloadLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles downloadLink.Click
        doDownload()
    End Sub

    Protected Sub downloadCsvLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles downloadCsvLink.Click
        doDownloadCSV()
    End Sub
End Class
