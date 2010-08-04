Imports System.Collections.Generic
Imports DataAccess

Partial Class HomeControl
    Inherits System.Web.UI.UserControl

    Protected Sub SearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        If SearchText.Text.Length > 0 Then
            Response.Redirect("~/Default.aspx?Page=NameSearch&searchText=" + SearchText.Text)
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        SearchText.Focus()
        SearchText.Attributes.Add("onkeypress", "javascript:return KeyDownHandler(event, ctl03_SearchButton);")

        Dim continents As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG1)
        continentsCombo.DataSource = continents
        continentsCombo.DataBind()

        Dim regions As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG2)
        regionCombo.DataSource = regions
        regionCombo.DataBind()

        Dim countries As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG3)
        countryCombo.DataSource = countries
        countryCombo.DataBind()

        Dim units As List(Of TDWGGeo) = Distribution.GetTDWGGeoList(TDWGGeoLevel.TDWG4)
        basicUnitCombo.DataSource = units
        basicUnitCombo.DataBind()

    End Sub

    Protected Sub contSearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles contSearchButton.Click
        If continentsCombo.SelectedIndex <> -1 Then
            Response.Redirect("~/Default.aspx?Page=NameSearch&continent=" + continentsCombo.Text)
        End If
    End Sub

    Protected Sub countryButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles countryButton.Click
        If countryCombo.SelectedIndex <> -1 Then
            Response.Redirect("~/Default.aspx?Page=NameSearch&country=" + countryCombo.Text)
        End If
    End Sub

    Protected Sub RegionSearchButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RegionSearchButton.Click
        If regionCombo.SelectedIndex <> -1 Then
            Response.Redirect("~/Default.aspx?Page=NameSearch&region=" + regionCombo.Text)
        End If
    End Sub

    Protected Sub basicUnitButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles basicUnitButton.Click
        If basicUnitCombo.SelectedIndex <> -1 Then
            Response.Redirect("~/Default.aspx?Page=NameSearch&unit=" + basicUnitCombo.Text)
        End If
    End Sub
End Class
