Imports WebDataAccess

Partial Class TreeControl
    Inherits System.Web.UI.UserControl

    Public SelectedNameId As String = ""


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region


    Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'inisitalise the database connection

        Dim showAllChanged As Boolean = False

        If Not Page.IsPostBack Then
            If Session("allNames") IsNot Nothing Then
                allNamesCheck.Checked = Session("allNames")
            End If

        Else
            If Session("allNames") <> allNamesCheck.Checked Then showAllChanged = True
            Session("allNames") = allNamesCheck.Checked
        End If

        GetTree(showAllChanged)
    End Sub

    'displays the tree of taxon
    Public Sub GetTree(ByVal showAllChanged As Boolean)

        Dim strAction As String = Request.QueryString.Get("Action")
        Dim strStateId As String = Request.QueryString.Get("StateId")
        Dim strNodeId As String = Utility.NameID(Request)

        Dim brWebTaxTree As WebTaxTree = New WebTaxTree

        Dim allNames As Boolean = False
        If Session("allNames") IsNot Nothing Then
            allNames = Session("allNames")
        End If
        brWebTaxTree.ValidNamesOnly = Not allNames
        brWebTaxTree.SelectedNodeId = strNodeId

        Dim StateId As Long = 0
        Dim NodeId As String = ""

        NodeId = strNodeId

        If IsNumeric(strStateId) And Not showAllChanged Then
            Session("StateId") = strStateId
            StateId = strStateId
        End If

        If strAction = "" And SelectedNameId <> "" Then
            strNodeId = SelectedNameId
            strAction = "SelectNode"
        End If

        Dim xml As String
        Dim url As String
        If strAction = "" Then
            NodeId = brWebTaxTree.GetStartingNode() 'Starting point for tree 


            brWebTaxTree.SelectNode(NodeId, 0)
            Response.Expires = 0
            xml = brWebTaxTree.TreeXml
            If xml IsNot Nothing Then
                url = Utility.GetDefaultPageUrl(Request, Nothing) + "&"
                xml = xml.Replace("TreeForm.aspx?", url)
                Dim ctrl As New HtmlControls.HtmlGenericControl()
                ctrl.InnerHtml = xml
                panel1.Controls.Add(ctrl)
                'Response.Write(xml)
            End If
            Exit Sub
        End If

        'select whether the action is expand, collapse, display or select node
        Select Case strAction
            Case "Expand"
                brWebTaxTree.AddChildren(NodeId, StateId)
            Case "Collapse"
                brWebTaxTree.RemoveNodeChildren(NodeId, StateId)
            Case "Display"
                If StateId <> 0 Then brWebTaxTree.GetTreeState(StateId)
                If NodeId IsNot Nothing Then brWebTaxTree.SelectNode(NodeId, StateId)
            Case "SelectNode"
                If NodeId = "" Then
                    NodeId = brWebTaxTree.GetStartingNode()
                End If
                brWebTaxTree.SelectNode(NodeId, StateId)
        End Select

        If showAllChanged Then

        End If
        Response.Expires = 0
        xml = brWebTaxTree.TreeXml
        If xml IsNot Nothing Then
            url = Utility.GetDefaultPageUrl(Request, Nothing) + "&"
            xml = xml.Replace("TreeForm.aspx?", url)
            Dim ctrl As New HtmlControls.HtmlGenericControl()
            ctrl.InnerHtml = xml
            panel1.Controls.Add(ctrl)

            Page.ClientScript.RegisterStartupScript(Me.GetType, "tree_scroll", "document.getElementById('Node_" + NodeId.ToUpper + "').scrollIntoView();", True)


            'Response.Write(xml)
        End If

    End Sub


    Protected Sub allNamesCheck_CheckedChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles allNamesCheck.CheckedChanged

    End Sub
End Class



