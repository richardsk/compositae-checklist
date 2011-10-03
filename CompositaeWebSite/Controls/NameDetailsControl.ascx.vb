Imports System.Data
Imports System.Collections.Generic

Imports ChecklistObjects
Imports ChecklistDataAccess
Imports WebDataAccess


Partial Class Controls_NameDetailsControl
    Inherits System.Web.UI.UserControl

    Private _selectedTab As Integer = 0

    Private Sub SelectMenuItem(ByVal index As Integer)
        _selectedTab = index

        Dim nameId As String = Request.QueryString("nameId")

        'menuTable.Rows(0).Cells(0).ForeColor = Drawing.Color.Gray
        menuTable.Rows(0).Cells(0).Font.Underline = False
        'menuTable.Rows(0).Cells(1).ForeColor = Drawing.Color.Gray
        menuTable.Rows(0).Cells(1).Font.Underline = False
        'menuTable.Rows(0).Cells(2).ForeColor = Drawing.Color.Gray
        menuTable.Rows(0).Cells(2).Font.Underline = False
        'menuTable.Rows(0).Cells(3).ForeColor = Drawing.Color.Gray
        menuTable.Rows(0).Cells(3).Font.Underline = False
        'menuTable.Rows(0).Cells(4).ForeColor = Drawing.Color.Gray
        menuTable.Rows(0).Cells(4).Font.Underline = False

        menuTable.Rows(0).Cells(_selectedTab).BorderWidth = New Unit(2)
        'menuTable.Rows(0).Cells(_selectedTab).ForeColor = Drawing.Color.Black
        menuTable.Rows(0).Cells(_selectedTab).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, _selectedTab.ToString) + "&nameId=" + nameId + "'>" + TabText(_selectedTab) + "</a>"
        menuTable.Rows(0).Cells(_selectedTab).Font.Bold = True

    End Sub

    Private Function TabText(ByVal tabNum As Integer) As String
        If tabNum = 0 Then Return Global.Resources.Resource.Consensus_Data
        If tabNum = 1 Then Return Global.Resources.Resource.Original_Data
        If tabNum = 2 Then Return Global.Resources.Resource.Taxonomic_Concepts
        If tabNum = 3 Then Return Global.Resources.Resource.Other_Data
        If tabNum = 4 Then Return Global.Resources.Resource.Reports
        Return ""
    End Function

    Public Function GetParentText() As String

        Dim TabNum As String = Request.QueryString("TabNum")

        Dim Parents As DataSet
        Dim ParentString As String = ""

        Dim selName As ChecklistObjects.Name = ChecklistDataAccess.NameData.GetName(Nothing, WebDataAccess.Utility.NameID(Request))

        If selName IsNot Nothing Then
            Parents = ChecklistDataAccess.TreeData.GetNodeToRoot(1, selName.Id, 0)

            For Each Node2RootRow As DataRow In Parents.Tables(0).Rows
                If Node2RootRow.IsNull("TaxonRankSort") = False Then
                    If Node2RootRow("TaxonRankSort") > 400 AndAlso Node2RootRow("TaxonRankSort") <> 1000 Then
                        If Node2RootRow("NameGuid") <> selName.Id.ToUpper Then
                            Dim rnk As String = Node2RootRow("TaxonRankFullName").ToString.Trim
                            rnk = rnk.Substring(0, 1).ToUpper + rnk.Substring(1)
                            ParentString &= " <b>" & rnk & "</b>:&nbsp<I>"
                            Dim nameText As String = Node2RootRow("NameCanonical").ToString.Trim
                            If Node2RootRow("TaxonRankSort") >= 4200 Then nameText = Node2RootRow("NameFull").ToString.Trim
                            ParentString &= WebDataAccess.Utility.GetNameLinkHtml(Request, Node2RootRow("NameGuid"), nameText, TabNum)
                            ParentString &= "</i>"
                        End If
                    End If
                End If
            Next
        End If

        Return ParentString + " <b>Rank</b>: " + selName.NameRank
    End Function

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        NameHierarchyLabel.Text = ""
        NameHierarchyLabel.Text = GetParentText()

        Dim nameId As String = WebDataAccess.Utility.NameID(Request)

        menuTable.Rows(0).Cells(0).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "0") + "&nameId=" + nameId + "'>" + TabText(0) + "</a>"
        menuTable.Rows(0).Cells(1).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "1") + "&nameId=" + nameId + "'>" + TabText(1) + "</a>"
        menuTable.Rows(0).Cells(2).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "2") + "&nameId=" + nameId + "'>" + TabText(2) + "</a>"
        menuTable.Rows(0).Cells(3).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "3") + "&nameId=" + nameId + "'>" + TabText(3) + "</a>"
        menuTable.Rows(0).Cells(4).Text = "<a style='color:black;text-decoration:none' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "4") + "&nameId=" + nameId + "'>" + TabText(4) + "</a>"

        'If Not Page.IsPostBack Then
        DisplayCurrentTab()
        'End If
    End Sub

    Private Sub DisplayCurrentTab()
        If Request.QueryString("TabNum") IsNot Nothing Then
            SelectMenuItem(Integer.Parse(Request.QueryString("TabNum")))
        Else
            SelectMenuItem(0)
        End If

        If _selectedTab = 0 Then
            ConsensusControl1.Visible = True
            ConsensusControl1.Display()
        ElseIf _selectedTab = 1 Then
            OriginalDataControl1.Visible = True
            OriginalDataControl1.Display()
        ElseIf _selectedTab = 2 Then
            TaxonConceptsControl1.Visible = True
            TaxonConceptsControl1.Display()
        ElseIf _selectedTab = 3 Then
            OtherDataControl1.Visible = True
            OtherDataControl1.Display()
        ElseIf _selectedTab = 4 Then
            ReportControl1.Visible = True
            ReportControl1.Display()
        End If
    End Sub


End Class
