Imports WebDataAccess

Namespace LandcarePortal

    Partial Class TreeControl
        Inherits System.Web.UI.UserControl

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

        Private Function GetStartingNode() As String
            Return System.Configuration.ConfigurationManager.AppSettings.Get("StartingNode")
        End Function

#Region " Processes "

        Private Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
            'inisitalise the database connection

        End Sub

        'displays the left hand side tree of taxon
        Public Sub GetTree()

            Dim strAction As String = Request.QueryString.Get("Action")
            Dim strStateId As String = Request.QueryString.Get("StateId")
            Dim strNodeId As String = Request.QueryString.Get("NodeId")
            If strNodeId Is Nothing Then strNodeId = Request.QueryString.Get("NameId")

            Dim brWebTaxTree As WebTaxTree = New WebTaxTree

            brWebTaxTree.ValidNamesOnly = True

            Dim StateId As Long = 0
            Dim NodeId As String = ""

            NodeId = strNodeId

            If IsNumeric(strStateId) Then
                Session("StateId") = strStateId
                StateId = strStateId
            End If

            Dim xml As String
            Dim url As String
            If strAction = "" Then
                NodeId = GetStartingNode() 'Starting point for tree opens Plants
                brWebTaxTree.SelectNode(NodeId, 0)
                Response.Expires = 0
                xml = brWebTaxTree.TreeXml
                If xml IsNot Nothing Then
                    url = Utility.GetDefaultPageUrl(Request, "0") + "&"
                    xml = xml.Replace("TreeForm.aspx?", url)
                    Response.Write(xml)
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
                    brWebTaxTree.GetTreeState(StateId)
                    If NodeId IsNot Nothing Then brWebTaxTree.SelectNode(NodeId, StateId)
                Case "SelectNode"
                    If NodeId = "" Then
                        NodeId = GetStartingNode() 'Starting point for tree opens Plants
                    End If
                    brWebTaxTree.SelectNode(NodeId, StateId)
            End Select

            Response.Expires = 0
            xml = brWebTaxTree.TreeXml
            If xml IsNot Nothing Then
                url = Utility.GetDefaultPageUrl(Request, "0") + "&"
                xml = xml.Replace("TreeForm.aspx?", url)
                'set bg colour for current node
                Dim idStr As String = "Node_" + NodeId + """"
                xml = xml.Replace(idStr, idStr + " style=""background:" + ConfigurationManager.AppSettings("AltBGcolor") + """")
                Response.Write(xml)
            End If

        End Sub

#End Region

    End Class

End Namespace


