Imports System.Collections.Generic
Imports System.Data

Partial Class Controls_AdvNameSearchControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            reportLink.Visible = False
            reportImage.Visible = False
            downloadCsvImage.Visible = False
            downloadCsvLink.Visible = False

            Dim fields As List(Of DataAccess.SearchableField) = DataAccess.Search.ListSearchableFields("tblName")
            Dim providers As ChecklistObjects.Provider() = ChecklistDataAccess.ProviderData.GetProviders()

            AdvSearchControl1.Fields = fields
            AdvSearchControl1.Providers = providers
            AdvSearchControl1.ShowAndOr = Controls_AdvSearchControl.AndOrMode.ModeBoth
            AdvSearchControl2.Fields = fields
            AdvSearchControl2.Providers = providers
            AdvSearchControl2.ShowAndOr = Controls_AdvSearchControl.AndOrMode.None
            AdvSearchControl3.Fields = fields
            AdvSearchControl3.Providers = providers
            AdvSearchControl3.ShowAndOr = Controls_AdvSearchControl.AndOrMode.ModeBoth
            AdvSearchControl4.Fields = fields
            AdvSearchControl4.Providers = providers
            AdvSearchControl4.ShowAndOr = Controls_AdvSearchControl.AndOrMode.None
            AdvSearchControl5.Fields = fields
            AdvSearchControl5.Providers = providers
            AdvSearchControl5.ShowAndOr = Controls_AdvSearchControl.AndOrMode.ModeOr
            AdvSearchControl6.Fields = fields
            AdvSearchControl6.Providers = providers
            AdvSearchControl6.ShowAndOr = Controls_AdvSearchControl.AndOrMode.None

            'If Not Page.IsPostBack Then
            '    If Request.QueryString("download") IsNot Nothing Then
            '        doDownload()
            '    End If
            'End If

            AdvSearchControl1.Focus()
        Catch ex As Exception
            DataAccess.Utility.LogError(ex)
        End Try

    End Sub

    Public Function GetSearchFields() As List(Of DataAccess.SearchSetting)
        Dim ss As New List(Of DataAccess.SearchSetting)

        ss.Add(AdvSearchControl1.GetSearchField())
        If AdvSearchControl2.Visible Then
            Dim sf As DataAccess.SearchSetting = AdvSearchControl2.GetSearchField()
            sf.IsOr = True
            ss.Add(sf)
        End If
        If AdvSearchControl3.Visible Then
            Dim sf As DataAccess.SearchSetting = AdvSearchControl3.GetSearchField()
            sf.IsAnd = True
            ss.Add(sf)
        End If
        If AdvSearchControl4.Visible Then
            Dim sf As DataAccess.SearchSetting = AdvSearchControl4.GetSearchField()
            sf.IsOr = True
            ss.Add(sf)
        End If
        If AdvSearchControl5.Visible Then
            Dim sf As DataAccess.SearchSetting = AdvSearchControl5.GetSearchField()
            sf.IsAnd = True
            ss.Add(sf)
        End If
        If AdvSearchControl6.Visible Then
            Dim sf As DataAccess.SearchSetting = AdvSearchControl6.GetSearchField()
            sf.IsOr = True
            ss.Add(sf)
        End If

        Return ss
    End Function

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        DoSearch(0)
    End Sub

    Private Function DoSearch(ByVal pageNumber As Integer) As DataSet
        Try
            Dim ss As List(Of DataAccess.SearchSetting) = GetSearchFields()
            Dim sst As New DataAccess.SearchStatusSelection
            sst.IncludeAccepted = chkIncludeAccepted.Checked
            sst.IncludeSynonyms = chkIncludeSynonyms.Checked
            sst.IncludeUnknown = chkIncludeUnknown.Checked
            Dim ds As DataSet = DataAccess.Search.NameSearch(ss, sst)
            DisplayResults(ds, pageNumber)
            ResultsGridView.Visible = True

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                reportImage.Visible = True
                reportLink.Visible = True
                downloadCsvImage.Visible = True
                downloadCsvLink.Visible = True
                'reportLink.NavigateUrl = Request.RawUrl
                'If Request.QueryString("download") Is Nothing Then
                'reportLink.NavigateUrl += "&download=true"
                'End If
            End If

            Return ds
        Catch ex As Exception
            ErrorLabel.Visible = True
            DataAccess.Utility.LogError(ex)
        End Try
        Return Nothing
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
            reportLink.Visible = True
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

            numSearchResults.Text = ds.Tables(0).Rows.Count.ToString + " " + Global.Resources.Resource.Search_Results
        End If
    End Sub

    Protected Sub ResultsGridView_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles ResultsGridView.PageIndexChanging
        DoSearch(e.NewPageIndex)
    End Sub

    Protected Sub AdvSearchControl1_AddAndField(ByVal add As Boolean, ByVal id As String) Handles AdvSearchControl1.AddAndField
        AdvSearchControl3.Visible = add
    End Sub

    Protected Sub AdvSearchControl1_AddOrField(ByVal add As Boolean, ByVal id As String) Handles AdvSearchControl1.AddOrField
        AdvSearchControl2.Visible = True
    End Sub

    Protected Sub AdvSearchControl3_AddAndField(ByVal add As Boolean, ByVal id As String) Handles AdvSearchControl3.AddAndField
        AdvSearchControl5.Visible = add
    End Sub

    Protected Sub AdvSearchControl3_AddOrField(ByVal add As Boolean, ByVal id As String) Handles AdvSearchControl3.AddOrField
        AdvSearchControl4.Visible = add
    End Sub

    Protected Sub AdvSearchControl5_AddOrField(ByVal add As Boolean, ByVal id As String) Handles AdvSearchControl5.AddOrField
        AdvSearchControl6.Visible = add
    End Sub

    Protected Sub clearButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles clearButton.Click
        AdvSearchControl1.Clear()
        AdvSearchControl2.Clear()
        AdvSearchControl3.Clear()
        AdvSearchControl4.Clear()
        AdvSearchControl5.Clear()
        AdvSearchControl6.Clear()
        AdvSearchControl2.Visible = False
        AdvSearchControl3.Visible = False
        AdvSearchControl4.Visible = False
        AdvSearchControl5.Visible = False
        AdvSearchControl6.Visible = False
    End Sub

    Protected Sub doDownloadRTF()
        Dim results As DataSet = DoSearch(0)

        If results IsNot Nothing AndAlso results.Tables.Count > 0 AndAlso results.Tables(0).Rows.Count > 0 Then
            Dim doc As String = DataAccess.Report.GetNamesReport(results, False, False)

            Dim fname As String = Guid.NewGuid.ToString + ".rtf"

            IO.File.WriteAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "temp\" + fname), doc)

            Response.Redirect(Request.ApplicationPath + "\temp\" + fname)

        End If
    End Sub

    Protected Sub doDownloadCSV()
        Dim results As DataSet = DoSearch(0)

        If results IsNot Nothing AndAlso results.Tables.Count > 0 AndAlso results.Tables(0).Rows.Count > 0 Then
            Dim doc As String = DataAccess.Report.GetNamesReportCSV(results, False, True)

            Dim fname As String = Guid.NewGuid.ToString + ".csv"
            IO.File.WriteAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "temp\" + fname), doc)

            Response.Redirect(Request.ApplicationPath + "\temp\" + fname)

        End If
    End Sub

    Protected Sub reportLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles reportLink.Click
        doDownloadRTF()
    End Sub

    Protected Sub downloadCsvLink_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles downloadCsvLink.Click
        doDownloadCSV()
    End Sub

End Class
