Imports System.Collections.Generic
Imports WebDataAccess

Partial Class Controls_AdvSearchControl
    Inherits System.Web.UI.UserControl

    Public Event AddOrField(ByVal add As Boolean, ByVal id As String)
    Public Event AddAndField(ByVal add As Boolean, ByVal id As String)

    Private m_ssID As String = ""
    Private m_selectedField As String = ""
    Private m_andOrMode As AndOrMode = AndOrMode.ModeBoth
    Private m_loading As Boolean = False

    Public Enum AndOrMode
        None
        ModeAnd
        ModeOr
        ModeBoth
    End Enum

    Public Fields As List(Of SearchableField)
    Public Providers As ChecklistObjects.Provider()

    Public Overrides Sub Focus()
        SearchText1.Focus()
    End Sub

    Public Property ShowAndOr() As AndOrMode
        Get
            Return m_andOrMode
        End Get
        Set(ByVal value As AndOrMode)
            m_andOrMode = value
            AndCheck1.Visible = (value = AndOrMode.ModeAnd Or value = AndOrMode.ModeBoth)
            OrCheck1.Visible = (value = AndOrMode.ModeOr Or value = AndOrMode.ModeBoth)
            downArrowImg.Visible = AndCheck1.Visible
            rightArrowImg.Visible = OrCheck1.Visible
        End Set
    End Property

    Public Sub SetSearchField(ByVal ss As SearchSetting)
        m_ssID = ss.ID
        m_selectedField = ss.SearchField
        SearchText1.Text = ss.SearchText
        AnywhereCheck1.Checked = ss.AnywhereInText
        WholeWordCheck1.Checked = ss.WholeWord
        'UpperText1.Text = ss.SearchUpperText
    End Sub

    Public Function GetSearchField() As SearchSetting
        Dim s As New SearchSetting
        s.ID = m_ssID
        s.SearchField = Field1.Text
        If s.SearchField = "ProviderName" Then
            s.SearchText = provCombo1.Text.Trim
        ElseIf s.SearchField.StartsWith("TDWGLevel") Then
            s.SearchText = geoCombo.Text.Trim
        Else
            s.SearchText = SearchText1.Text.Trim
        End If
        If provCombo1.Visible Then s.SearchText = provCombo1.Text.Trim
        'If UpperText1.Text.Length > 0 Then s.SearchUpperText = UpperText1.Text
        s.AnywhereInText = AnywhereCheck1.Checked
        s.WholeWord = WholeWordCheck1.Checked
        Return s
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SearchText1.Attributes.Add("onkeypress", "javascript:if (event.keyCode == 13) { event.cancel=true; event.returnValue=false; $('#ctl03_SearchButton').click();}")
        'UpperText1.Attributes.Add("onkeypress", "javascript:if (event.keyCode == 13) { event.cancel=true; event.returnValue=false; $('#ctl03_SearchButton').click();}")

        m_loading = True

        For Each sf As SearchableField In Fields
            Dim li As New ListItem(sf.FriendlyName, sf.FieldName)
            Field1.Items.Add(li)
            If li.Value = m_selectedField Then
                li.Selected = True
            End If
        Next

        m_loading = False

    End Sub

    Protected Sub AndCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles AndCheck1.CheckedChanged
        RaiseEvent AddAndField(AndCheck1.Checked, m_ssID)
    End Sub

    Protected Sub OrCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles OrCheck1.CheckedChanged
        RaiseEvent AddOrField(OrCheck1.Checked, m_ssID)
    End Sub

    'Protected Sub RangeCheck1_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RangeCheck1.CheckedChanged
    'UpperTD1.Visible = (RangeCheck1.Checked = True)
    'UpperTD2.Visible = (RangeCheck1.Checked = True)
    'End Sub

    Public Sub Clear()
        SearchText1.Text = ""
        'UpperText1.Text = ""
        provCombo1.SelectedIndex = -1
        AndCheck1.Checked = False
        OrCheck1.Checked = False
    End Sub

    Protected Sub Field1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles Field1.SelectedIndexChanged
        If m_loading Then Return

        If Field1.Text = "ProviderName" Then
            provCombo1.Visible = True
            SearchText1.Visible = False
            geoCombo.Visible = False

            provCombo1.Items.Clear()

            Dim providers As ChecklistObjects.Provider() = ChecklistDataAccess.ProviderData.GetProviders()
            For Each p As ChecklistObjects.Provider In providers
                If Not p.IsEditor And p.Name <> "SYSTEM" Then
                    provCombo1.Items.Add(p.Name)
                End If
            Next
            If Request.Form("ctl03$AdvSearchControl1$provCombo1") IsNot Nothing Then
                provCombo1.SelectedValue = Request.Form("ctl03$AdvSearchControl1$provCombo1")
            End If
        ElseIf Field1.Text.StartsWith("NameIllegitimate") Then
            SearchText1.Text = "1"
            SearchText1.Visible = False
            AnywhereCheck1.Checked = False
            AnywhereCheck1.Visible = False
            WholeWordCheck1.Checked = False
            WholeWordCheck1.Visible = False
            Label8.Visible = False
        ElseIf Field1.Text.StartsWith("NameInvalid") Then
            SearchText1.Text = "1"
            SearchText1.Visible = False
            AnywhereCheck1.Checked = False
            AnywhereCheck1.Visible = False
            WholeWordCheck1.Checked = False
            WholeWordCheck1.Visible = False
            Label8.Visible = False
        ElseIf Field1.Text.StartsWith("TDWGLevel") Then
            provCombo1.Visible = False
            SearchText1.Visible = False
            geoCombo.Visible = True

            Dim regions As New List(Of TDWGGeo)
            If Field1.Text = "TDWGLevel1" Then
                regions = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG1)
            End If
            If Field1.Text = "TDWGLevel2" Then
                regions = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG2)
            End If
            If Field1.Text = "TDWGLevel3" Then
                regions = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG3)
            End If
            If Field1.Text = "TDWGLevel4" Then
                regions = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG4)
            End If

            geoCombo.Items.Clear()
            For Each c As TDWGGeo In regions
                geoCombo.Items.Add(c.Name)
            Next

            Dim selItem As String = Request.Form("ctl03$" + ID + "$geoCombo")
            If selItem IsNot Nothing Then geoCombo.SelectedValue = selItem
        End If
    End Sub
End Class
