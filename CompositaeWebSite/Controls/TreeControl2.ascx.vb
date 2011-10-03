Imports System.Xml
Imports System.Data

Imports WebDataAccess

Partial Class Controls_TreeControl2
    Inherits System.Web.UI.UserControl

    Private Sub AddNode(ByVal nodeList As TreeNodeCollection, ByVal nameId As String, ByVal rankId As Integer, ByVal nameFull As String, ByVal hasChildren As Boolean)
        Dim tn As New TreeNode
        tn.Text = nameFull
        tn.ImageUrl = "~/images/" + Utility.GetImageIndex(rankId)
        tn.NavigateUrl = "~/" + Utility.GetNamePageUrl(Request, "0", nameId)
        tn.PopulateOnDemand = True
        tn.Expanded = False
        tn.Value = nameId

        nodeList.Add(tn)

        If hasChildren Then
            Dim dummy As New TreeNode
            dummy.Text = "dummy"
            tn.ChildNodes.Add(dummy)
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If TreeView1.Nodes.Count = 0 Then
                Dim n As ChecklistObjects.Name = ChecklistDataAccess.NameData.GetName(Nothing, ConfigurationManager.AppSettings.Get("StartingNode"))

                Dim hasChildren As Integer = 0
                hasChildren = ChecklistDataAccess.NameData.GetChildNameCount(n.Id)

                AddNode(TreeView1.Nodes, n.Id, n.NameRankFk, n.NameFull, (hasChildren > 0))
                
            End If
        End If
    End Sub

    Protected Sub TreeView1_SelectedNodeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeView1.SelectedNodeChanged

    End Sub

    Protected Sub TreeView1_TreeNodeExpanded(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles TreeView1.TreeNodeExpanded
        If e.Node.ChildNodes.Count > 0 Then
            If e.Node.ChildNodes(0).Text = "dummy" Then
                e.Node.ChildNodes.Clear()

                Dim cn As DataSet = ChecklistDataAccess.NameData.GetChildNames(e.Node.Value, False)
                For Each row As DataRow In cn.Tables(0).Rows
                    Dim hasChildren As Integer = 0
                    hasChildren = ChecklistDataAccess.NameData.GetChildNameCount(row("NameGuid").ToString)
                    AddNode(e.Node.ChildNodes, row("NameGuid").ToString, row("NameRankFk"), row("NameFull").ToString, (hasChildren > 0))
                Next
            End If
        End If
    End Sub

    Protected Sub TreeView1_TreeNodePopulate(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.TreeNodeEventArgs) Handles TreeView1.TreeNodePopulate

    End Sub

    '    'Start from the root
    '    Dim CurrentNode As XmlElement

    '    'get list of nodes, root to selected node
    '    Dim da As New DaTrees
    '    Dim ds As DsNodeToRoot = da.GetNodeToRoot(TreeView1.SelectedValue, 0)
    '    Dim table As DsNodeToRoot.sprSelect_NodeToRootDataTable = ds.sprSelect_NodeToRoot
    '    Dim row As DsNodeToRoot.sprSelect_NodeToRootRow
    '    Dim index As Long

    '    'start from root and work downwards, populating as necessary  
    '    For index = 1 To table.Rows.Count - 1

    '        row = table.Rows(index)
    '        Dim NameKey As String = row.NameGuid

    '        'populate node if necessary
    '        If GetChildCount(CurrentNode) = 0 Then
    '            AddChildrenFromNamesTable(NameKey)
    '        End If

    '    Next

    'End Sub

    'Private Sub AddChildrenFromNamesTable(ByVal NodeUniqueId As String)
    '    Dim Node As XmlElement

    '    'find node in XML Document
    '    FindNode(Node, NodeUniqueId)
    '    If Node Is Nothing Then
    '        Exit Sub
    '    End If


    '    SetState(Node, EMPTY_TAG)

    '    'get children of name indicated by name key, do not get suppressed children
    '    Dim ds As DsTaxTreeNode = mDaTrees.GetTaxTreeNodes(NodeUniqueId, 0, True)
    '    If ds Is Nothing Then
    '        Exit Sub
    '    End If

    '    'iterate through the child names
    '    Dim table As DsTaxTreeNode.sprGetNodeDataTable = ds.sprGetNode

    '    If table.Count > 0 Then
    '        SetState(Node, MINUS_TAG) 'Show the node has been expanded '-'
    '    Else
    '        SetState(Node, EMPTY_TAG)
    '    End If

    '    Dim row As DsTaxTreeNode.sprGetNodeRow
    '    For Each row In table
    '        If row.IsNameParentFKNull = False Then

    '            'only show node if role has read permission
    '            Dim HasReadPermission As Boolean = True
    '            If row.IsPermissionsReadNull = False Then
    '                HasReadPermission = row.PermissionsRead
    '            End If

    '            'only show node if name is not suppressed
    '            Dim Suppress As Boolean = row.NameSuppress

    '            'only show name if valid and not supressed?
    '            If ValidNamesOnly And row("AcceptedChildCount") = 0 Then
    '                If row.IsNameCurrentFKNull OrElse row.NameCurrentFK <> row.NameGuid Then
    '                    Suppress = True
    '                End If
    '            End If

    '            If row.NameGuid <> "" And HasReadPermission = True And Suppress = False Then
    '                Dim RankKey As Long = 0

    '                RankKey = row.NameTaxonRankFk

    '                'decide whether node has children by the child count
    '                Dim ChildrenState As String
    '                If row.ChildCount < 1 Then
    '                    ChildrenState = EMPTY_TAG ' '
    '                Else
    '                    ChildrenState = PLUS_TAG  '+'
    '                End If

    '                'Get the node key
    '                Dim CurrentNameKey As String = ""
    '                If row.IsNameCurrentFKNull = False Then
    '                    CurrentNameKey = row.NameCurrentFK
    '                End If

    '                Dim illeg As Boolean = False
    '                If row.NameIllegitimate Or row.NameInvalid Or row.NameMisapplied Then
    '                    illeg = True
    '                End If

    '                'add node to XML Document
    '                AddChild(Node, row.NameGuid, row.NameCanonical, ChildrenState, RankKey, CurrentNameKey, illeg, row.NameFull)

    '            End If
    '        End If
    '    Next

    'End Sub

End Class
