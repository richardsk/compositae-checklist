Imports System.Data
Imports System.Collections.Generic
Imports WebDataAccess

Partial Class _Default
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
            'language
        'set culture to lang of requesting browser
        If Request.UserLanguages.Length > 0 Then
            Threading.Thread.CurrentThread.CurrentUICulture = New System.Globalization.CultureInfo(Request.UserLanguages(0))
            '= New System.Globalization.CultureInfo("fr-FR")
        End If

        SearchText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, SearchButton);")

        'tree height
        ClientScript.RegisterStartupScript(Me.GetType(), "getHeight", _
           "document.getElementById('TreeControl1_panel1').setAttribute('style', 'width:230px;overflow:auto;height:' + (getHeight() - 320) + 'px');", True)

        searchPanel.Visible = True

        Dim selPage As String = Request.QueryString("Page")
        DetailsPanel.Controls.Clear()
        If selPage Is Nothing OrElse selPage = "" Then
            Dim ctrl As Control = LoadControl("Controls\HomeControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
            searchPanel.Visible = False
            'ctrl = LoadControl("Controls\SimpleNameSearchControl.ascx")
            'DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "NameSearch" Then
            Dim ctrl As Control = LoadControl("Controls\NameSearchControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
            If Request.QueryString("searchText") IsNot Nothing AndAlso Not Page.IsPostBack Then
                SearchText.Text = Request.QueryString("searchText")
            End If
        ElseIf selPage = "AdvNameSearch" Then
            Dim ctrl As Control = LoadControl("Controls\AdvNameSearchControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
            searchPanel.Visible = False
        ElseIf selPage = "NameDetails" Then
            Dim nameId As String = Utility.NameID(Request)
            TreeControl1.SelectedNameId = nameId
            FeedbackLink.NavigateUrl += "&NameID=" + nameId
            Dim ctrl As Control = LoadControl("Controls\NameDetailsControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "LitSearch" Then
            Dim ctrl As Control = LoadControl("Controls\LiteratureSearchControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "AdvLitSearch" Then
            Dim ctrl As Control = LoadControl("Controls\AdvLitSearchControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "LitDetails" Then
            Dim ctrl As Control = LoadControl("Controls\LiteratureDetailsControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "SearchHelp" Then
            Dim ctrl As Control = LoadControl("Controls\SearchHelpControl.ascx")
            DetailsPanel.Controls.Add(ctrl)

            'HelpPanel.Controls.Add(New LiteralControl("<br/>&nbsp;&nbsp;<font size='2'><a href='default.aspx?Page=SearchHelp'>Search Help</a></font>"))
            'HelpPanel.Controls.Add(New LiteralControl("<br/>&nbsp;&nbsp;<font size='2'><a href='default.aspx?Page=DetailsHelp'>Name Details Help</a></font>"))
            'todo more help?
        ElseIf selPage = "DetailsHelp" Then
            Dim ctrl As Control = LoadControl("Controls\DetailsHelpControl.ascx")
            DetailsPanel.Controls.Add(ctrl)

            'HelpPanel.Controls.Add(New LiteralControl("<br/>&nbsp;&nbsp;<font size='2'><a href='default.aspx?Page=SearchHelp'>Search Help</a></font>"))
            'HelpPanel.Controls.Add(New LiteralControl("<br/>&nbsp;&nbsp;<font size='2'><a href='default.aspx?Page=DetailsHelp'>Name Details Help</a></font>"))
        ElseIf selPage = "Feedback" Then
            Dim ctrl As Control = LoadControl("Controls\FeedbackControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "About" Then
            leftMenuCell.Visible = False
            Dim ctrl As Control = LoadControl("Controls\AboutControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "Bibliography" Then
            Dim ctrl As Control = LoadControl("Controls\BibliographyControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "Provider" Then
            Dim ctrl As Control = LoadControl("Controls\ProviderControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "ProviderList" Then
            Dim ctrl As Control = LoadControl("Controls\ProviderListControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        ElseIf selPage = "Report" Then
            Dim ctrl As Control = LoadControl("Controls\ReportControl.ascx")
            DetailsPanel.Controls.Add(ctrl)
        End If

        If searchPanel.Visible Then
            Dim fields As List(Of SearchableField) = Search.ListSearchableFields("tblName")
            
            searchField.Items.Clear()
            For Each sf As SearchableField In fields
                Dim li As New ListItem(sf.FriendlyName, sf.FieldName)
                searchField.Items.Add(li)
            Next
            If Request.Form("searchField") IsNot Nothing Then
                searchField.SelectedValue = Request.Form("searchField")
            ElseIf Request.Params("searchField") IsNot Nothing Then
                searchField.SelectedValue = Request.Params("searchField")
            End If
            UpdateSearchFields()
        End If

    End Sub

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        If SearchText.Text.Length > 0 Or provCombo1.Visible = True Or countryCombo.Visible = True Or continentsCombo.Visible = True _
            Or regionsCombo.Visible = True Or unitsCombo.Visible = True Then
            If provCombo1.Visible = True Then
                Response.Redirect("~/Default.aspx?Page=NameSearch&searchText=" + provCombo1.Text + "&searchField=" + searchField.Text)
            ElseIf continentsCombo.Visible = True Then
                Response.Redirect("~/Default.aspx?Page=NameSearch&continent=" + continentsCombo.Text + "&searchField=" + searchField.Text)
            ElseIf countryCombo.Visible = True Then
                Response.Redirect("~/Default.aspx?Page=NameSearch&country=" + countryCombo.Text + "&searchField=" + searchField.Text)
            ElseIf regionsCombo.Visible = True Then
                Response.Redirect("~/Default.aspx?Page=NameSearch&region=" + regionsCombo.Text + "&searchField=" + searchField.Text)
            ElseIf unitsCombo.Visible = True Then
                Response.Redirect("~/Default.aspx?Page=NameSearch&unit=" + unitsCombo.Text + "&searchField=" + searchField.Text)
            Else
                Response.Redirect("~/Default.aspx?Page=NameSearch&searchText=" + SearchText.Text + "&searchField=" + searchField.Text)
            End If
        End If
    End Sub

    Protected Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRender

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "page_scroll", "javascript:document.getElementById('ImageLink').scrollIntoView();", True)

    End Sub

    Protected Sub searchField_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles searchField.SelectedIndexChanged
        'UpdateSearchFields()
    End Sub

    Private Sub UpdateSearchFields()
        SearchText.Visible = True
        provCombo1.Visible = False
        countryCombo.Visible = False
        continentsCombo.Visible = False
        regionsCombo.Visible = False
        unitsCombo.Visible = False

        If searchField.Text = "ProviderName" Then
            provCombo1.Visible = True
            SearchText.Visible = False
            countryCombo.Visible = False
            continentsCombo.Visible = False
            regionsCombo.Visible = False
            unitsCombo.Visible = False

            provCombo1.Items.Clear()

            Dim providers As ChecklistObjects.Provider() = ChecklistDataAccess.ProviderData.GetProviders()
            For Each p As ChecklistObjects.Provider In providers
                If Not p.IsEditor And p.Name <> "SYSTEM" Then
                    provCombo1.Items.Add(p.Name)
                End If
            Next
        ElseIf searchField.Text = "TDWGLevel3" Then
            provCombo1.Visible = False
            SearchText.Visible = False
            countryCombo.Visible = True
            continentsCombo.Visible = False
            regionsCombo.Visible = False
            unitsCombo.Visible = False

            countryCombo.Items.Clear()

            Dim countries As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG3)
            For Each c As TDWGGeo In countries
                countryCombo.Items.Add(c.Name)
            Next

            Dim selItem As String = Request.Form("countryCombo")
            If selItem IsNot Nothing Then
                countryCombo.SelectedValue = selItem
            Else
                selItem = Request.Params("country")
                If selItem IsNot Nothing Then countryCombo.SelectedValue = selItem
            End If
        ElseIf searchField.Text = "TDWGLevel1" Then
            provCombo1.Visible = False
            SearchText.Visible = False
            countryCombo.Visible = False
            continentsCombo.Visible = True
            regionsCombo.Visible = False
            unitsCombo.Visible = False

            continentsCombo.Items.Clear()

            Dim continents As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG1)

            For Each c As TDWGGeo In continents
                continentsCombo.Items.Add(c.Name)
            Next

            Dim selItem As String = Request.Form("continentsCombo")
            If selItem IsNot Nothing Then
                continentsCombo.SelectedValue = selItem
            Else
                selItem = Request.Params("continent")
                If selItem IsNot Nothing Then continentsCombo.SelectedValue = selItem
            End If
        ElseIf searchField.Text = "TDWGLevel2" Then
            provCombo1.Visible = False
            SearchText.Visible = False
            countryCombo.Visible = False
            continentsCombo.Visible = False
            regionsCombo.Visible = True
            unitsCombo.Visible = False

            regionsCombo.Items.Clear()

            Dim regs As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG2)

            For Each r As TDWGGeo In regs
                regionsCombo.Items.Add(r.Name)
            Next

            Dim selItem As String = Request.Form("regionsCombo")
            If selItem IsNot Nothing Then
                regionsCombo.SelectedValue = selItem
            Else
                selItem = Request.Params("region")
                If selItem IsNot Nothing Then regionsCombo.SelectedValue = selItem
            End If
        ElseIf searchField.Text = "TDWGLevel4" Then
            provCombo1.Visible = False
            SearchText.Visible = False
            countryCombo.Visible = False
            continentsCombo.Visible = False
            regionsCombo.Visible = False
            unitsCombo.Visible = True

            unitsCombo.Items.Clear()

            Dim units As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG4)

            For Each u As TDWGGeo In units
                unitsCombo.Items.Add(u.Name)
            Next

            Dim selItem As String = Request.Form("unitsCombo")
            If selItem IsNot Nothing Then
                unitsCombo.SelectedValue = selItem
            Else
                selItem = Request.Params("unit")
                If selItem IsNot Nothing Then unitsCombo.SelectedValue = selItem
            End If
        End If
    End Sub

    Protected Sub searchField_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles searchField.TextChanged
        UpdateSearchFields()
    End Sub
End Class
