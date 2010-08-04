Imports System.Windows.Forms
Imports System.Drawing
Imports ChecklistObjects

Public Class TaxTree
    Inherits System.Windows.Forms.UserControl

    Public TaxTreeDs As DataSet
    Public NodeToRootDs As DataSet

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mUtility = New LcUtility()
    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub
    Friend WithEvents TreeView1 As System.Windows.Forms.TreeView
    Friend WithEvents imlTaxTreeImages As System.Windows.Forms.ImageList
    'Friend WithEvents cddAlternateHierarchy As ComboDisplay
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Private components As System.ComponentModel.IContainer

    'Required by the Windows Form Designer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(TaxTree))
        Me.TreeView1 = New System.Windows.Forms.TreeView
        Me.imlTaxTreeImages = New System.Windows.Forms.ImageList(Me.components)
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        'cddAlternateHierarchy = New ComboDisplay
        Me.SuspendLayout()
        '
        'TreeView1
        '
        Me.TreeView1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TreeView1.ForeColor = System.Drawing.Color.Gray
        Me.TreeView1.HideSelection = False
        Me.TreeView1.HotTracking = True
        Me.TreeView1.ImageIndex = 28
        Me.TreeView1.ImageList = Me.imlTaxTreeImages
        Me.TreeView1.ItemHeight = 18
        Me.TreeView1.Location = New System.Drawing.Point(0, 0)
        Me.TreeView1.Name = "TreeView1"
        Me.TreeView1.SelectedImageIndex = 28
        Me.TreeView1.Size = New System.Drawing.Size(150, 150)
        Me.TreeView1.TabIndex = 3
        '
        'imlTaxTreeImages
        '
        Me.imlTaxTreeImages.ImageSize = New System.Drawing.Size(16, 16)
        Me.imlTaxTreeImages.ImageStream = CType(resources.GetObject("imlTaxTreeImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlTaxTreeImages.TransparentColor = System.Drawing.Color.Transparent
        '
        'TaxTree
        '
        Me.Controls.Add(Me.TreeView1)
        Me.Name = "TaxTree"
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Member Variables"

    Private mUtility As LcUtility
    Private mOldNode As TreeNode
    Private mEnabled As Boolean

    Private mClassificationKey As Long
    Private mToolTipNode
    Private mMousePos As Point
    Private mDragEnabled As Boolean
    Private mSendEvent As Boolean

    Public MergeKey As String

    Public SelectedNodeName As String
    Public SelectedGuid As String
    Public SelectedUPk As String

#End Region

#Region "Constants"

    Private Const NO_KEY As String = "-777"
    Public s_RootKey As String

#End Region

#Region "Properties"

    Public ReadOnly Property SelectedNode() As TreeNode
        Get
            Return TreeView1.SelectedNode
        End Get
    End Property

    Public ReadOnly Property RootKey() As String
        Get
            If s_RootKey Is Nothing Then
                Try
                    s_RootKey = ChecklistDataAccess.TreeData.GetRootId()
                Catch ex As Exception
                End Try
            End If
            Return s_RootKey
        End Get
    End Property

    Public ReadOnly Property SelectedKey() As String
        Get
            Dim node As TreeNode = TreeView1.SelectedNode
            If node Is Nothing Then Return -1
            Dim info As TaxTreeNode = node.Tag
            If info Is Nothing Then Return -1
            Return info.NameGuid
        End Get
    End Property

    Property DragEnabled() As Boolean
        Get
            Return mDragEnabled
        End Get
        Set(ByVal Value As Boolean)
            mDragEnabled = Value
        End Set
    End Property

    'Property CustomEnabled() As Boolean
    '    Get
    '        Return mEnabled
    '    End Get
    '    Set(ByVal Value As Boolean)
    '        mEnabled = Value
    '        If mEnabled = True Then
    '            TreeView1.HotTracking = True
    '            cddAlternateHierarchy.DisplayState = ComboDisplay.disState.disInput
    '        Else
    '            TreeView1.HotTracking = False
    '            cddAlternateHierarchy.DisplayState = ComboDisplay.disState.disReadOnly
    '        End If
    '    End Set
    'End Property

    Public ReadOnly Property MousePos() As Point
        Get
            Return mMousePos
        End Get
    End Property




#End Region

#Region "Events"

    Event NodeSelected(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs)

    Private Sub TaxTree_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Me.DesignMode Then
            InitialiseTree()
        End If
    End Sub

    Friend Sub InitialiseTree()
        mSendEvent = True
        CollapseAndRefresh()
        mEnabled = True
        Try
            'LoadAlternateHierarchy()
        Catch ex As Exception
            'Debug.Assert(False, ex.Message)
        End Try
    End Sub

    Private Sub TreeView1_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles TreeView1.MouseMove

        mMousePos = New Point(e.X, e.Y)

        Dim node As TreeNode = TreeView1.GetNodeAt(e.X, e.Y)
        If node Is Nothing Then
            Exit Sub
        End If

        If mToolTipNode Is node Then
            Exit Sub
        End If

        mToolTipNode = node

        'Debug.WriteLine(node.Text)
        SetToolTip(node)
        'ToolTip1.SetToolTip(TreeView1, node.Text)

    End Sub


    Private Sub TreeView1_DragEnter(ByVal sender As Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles TreeView1.DragEnter
        Debug.WriteLine(e.Data.GetDataPresent(Me.GetType.FullName))
        Dim Tree As TreeItemListControl = New TreeItemListControl()
        If e.Data.GetDataPresent(Tree.GetType.FullName) = True Then
            e.Effect = DragDropEffects.Move
        Else
            e.Effect = DragDropEffects.None
        End If
    End Sub

    'Private Sub cddAlternateHierarchy_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cddAlternateHierarchy.SelectedIndexChanged
    '    Me.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
    '    Dim ClassificationKey As Long = cddAlternateHierarchy.SelectedKey

    '    If mClassificationKey < 0 Then
    '        mClassificationKey = 0
    '    End If
    '    If mClassificationKey <> ClassificationKey Then
    '        mClassificationKey = ClassificationKey
    '        ChangeTree()
    '    End If
    '    Me.Cursor.Current = System.Windows.Forms.Cursors.Default
    'End Sub

    Private Sub TreeView1_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles TreeView1.KeyUp
        If e.KeyCode = Keys.F5 Then
            CollapseAndRefresh()
        End If
    End Sub

    Public Event TreeviewExpandWhileDisabled(ByVal NameKey As String)
    Public Event TreeviewNodeSelectedWhileDisabled(ByVal NameKey As String)

    Private Sub TreeView1_BeforeExpand(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles TreeView1.BeforeExpand
        Me.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor

        Dim Parent As TreeNode = e.Node
        Dim tag As TaxTreeNode = Parent.Nodes(0).Tag

        If mEnabled = False Then
            'e.Cancel = True
            RaiseEvent TreeviewExpandWhileDisabled(tag.NameGuid)
            'Exit Sub
        End If


        If tag.NameGuid <> NO_KEY Then Exit Sub

        Try
            Parent.Nodes(0).Remove()
            Populate(Parent)

        Catch ex As Exception
            MsgBox("Failed to load tree.  Error : " + ex.Message + ":" + ex.StackTrace)
        End Try

        Me.Cursor.Current = System.Windows.Forms.Cursors.Default
    End Sub

    Private Sub TreeView1_BeforeCollapse(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles TreeView1.BeforeCollapse
        If mEnabled = False Then
            e.Cancel = True

            Exit Sub
        End If
    End Sub

    Sub Treeview1_BeforeSelected(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewCancelEventArgs) Handles TreeView1.BeforeSelect
        If mEnabled = False Then
            e.Cancel = True
            RaiseEvent TreeviewNodeSelectedWhileDisabled(e.Node.Tag.NameGuid)
            Exit Sub
        End If

        Dim f As Font

        If Not mOldNode Is Nothing Then
            f = New Font(mOldNode.NodeFont, FontStyle.Regular)
            mOldNode.NodeFont = f
            Dim str1 As String = mOldNode.Text
            mOldNode.Text = Trim(str1)
        End If

        Dim node As TreeNode = e.Node
        If Not node Is Nothing Then
            f = New Font(mOldNode.NodeFont, FontStyle.Bold)
            node.NodeFont = f
            Dim str2 As String = e.Node.Text

            e.Node.Text = str2 + Space(str2.Length / 2)

        End If

        mOldNode = e.Node


    End Sub

    Sub Treeview1_NodeSelected(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles TreeView1.AfterSelect

        Dim tag As TaxTreeNode = e.Node.Tag
        If Not tag Is Nothing Then
            SelectedNodeName = tag.FullName
            SelectedGuid = tag.NameGuid
        End If

        If mSendEvent Then
            RaiseEvent NodeSelected(sender, e)
        End If
    End Sub

    Public Event EnterPressed(ByVal e As System.Windows.Forms.KeyEventArgs)

    Private Sub TreeView1_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles TreeView1.KeyDown
        If e.KeyCode = Keys.Enter Then RaiseEvent EnterPressed(e)
    End Sub


#End Region

#Region "Public Functions and Sub"

    Public Sub RemoveNode(ByVal NameKey As String)

        Dim RootNode As TreeNode = TreeView1.TopNode
        Dim TheNode As TreeNode
        Dim TheKey As String = NameKey

        TheNode = FindNode(NameKey)
        If TheNode Is Nothing Then
            Return
        End If

        TheNode.Remove()

    End Sub


    Public Sub UpdateNode(ByVal NameKey As String, ByVal RankKey As Long, ByVal NameParentKey As String, ByVal Name As String)

        Dim TheNode As TreeNode
        Dim TheKey As String = NameKey

        TheNode = FindNode(NameKey)
        If TheNode Is Nothing Then
            'use parent node
            TheNode = FindNode(NameParentKey)
            If TheNode Is Nothing Then
                Return
            End If
            TheKey = NameParentKey
        Else
            'update node
            TheNode.Text = Name
            Dim ImageIndex As Long = LcUtility.GetImageIndex(RankKey)
            TheNode.SelectedImageIndex = ImageIndex
            TheNode.ImageIndex = ImageIndex
            Dim item As TaxTreeNode = TheNode.Tag
            If Not item Is Nothing Then
                item.RankKey = RankKey
            End If
        End If


        Try

            'get children and add any children that do not exist
            LoadTaxTreeNodeDs(TheKey)
            Dim count As Long = TaxTreeDs.Tables(0).Rows.Count
            For Each row As DataRow In TaxTreeDs.Tables(0).Rows

                If LcUtility.KeyNotSet(row("NameGuid")) = False Then
                    If IsChildNodePresent(TheNode, row("NameGuid")) = False Then
                        Dim node As TreeNode = TheNode.Nodes.Add(row("NameCanonical"))
                        Dim tag As New TaxTreeNode
                        tag.NameGuid = row("NameGuid").ToString
                        tag.NameLSID = row("NameLSID").ToString
                        If Not row.IsNull("NameCurrentFK") Then
                            If row("NameGuid") = row("NameCurrentFK") Then
                                SetIsCurrentName(node)
                            End If
                        End If
                        node.Tag = tag

                        node.ImageIndex = LcUtility.GetImageIndex(row("NameTaxonRankFk"))
                        node.SelectedImageIndex = LcUtility.GetImageIndex(row("NameTaxonRankFk"))
                        tag.RankKey = row("NameTaxonRankFk")
                        tag.RankSort = 0
                        If Not row.IsNull("TaxonRankSort") Then tag.RankSort = row("TaxonRankSort")

                        If row("ChildCount") > 0 Then
                            SetHasChildren(node)
                            tag.ChildCount = row("ChildCount")
                        End If

                    End If
                End If

            Next
        Catch ex As Exception
            MsgBox("Failed to load tree.  Error : " + ex.Message + ":" + ex.StackTrace)
        End Try


    End Sub

    Public Sub LoadControlSettings(ByVal UserKey)
        'TODO add user setting code
    End Sub

    Public Sub SaveControlSettings(ByVal UserKey)
        'TODO add user setting code
    End Sub


    'Public Sub SelectLSIDNode(ByVal lsid As String)
    '    SelectNode(Int.WebGetLSIDNameKey(lsid))
    'End Sub

    'selects a node in the tree, opening nodes on the way down
    Public Sub SelectNode(ByVal Namekey As String, Optional ByVal SendEvent As Boolean = True)

        'loads the member dataset "NodeToRoot1" from the database
        'root n1 n2 n3 n
        'childcount the number of children of each node
        LoadNodeToRootDs(Namekey)

        'the root node 
        Dim currentNode As TreeNode = TreeView1.Nodes.Item(0)
        Dim index As Long

        'no rows, query failed, name not in tree
        If NodeToRootDs.Tables(0).Rows.Count < 1 Then Exit Sub

        'check that root in tree is the same as root in list
        Dim row As DataRow = NodeToRootDs.Tables(0).Rows(0)
        If row("NameGuid") <> RootKey Then Exit Sub

        'step through each level
        Dim start As Long = 0


        For index = start To NodeToRootDs.Tables(0).Rows.Count - 2 'zero based, (-2 so actual seed node is not included)
            row = NodeToRootDs.Tables(0).Rows(index)
            Dim tag As TaxTreeNode = currentNode.Tag

            'the node has being reached
            If tag.NameGuid = Namekey Then
                Exit For
            End If

            'expand in view so visible
            currentNode.Expand()

            'add all children
            Try
                If currentNode.Nodes.Count > 0 Then
                    tag = currentNode.Nodes(0).Tag
                    If tag.NameGuid = NO_KEY Then 'the placeholder node
                        Populate(currentNode)
                    End If
                Else
                    Populate(currentNode)
                End If

            Catch ex As Exception
                MsgBox("Failed to load tree.  Error : " + ex.Message + ":" + ex.StackTrace)
            End Try

            'get next name in list
            Dim nextRow As DataRow = NodeToRootDs.Tables(0).Rows(index + 1)

            'select the name child from the children
            Dim childNode As TreeNode = GetChildNodeByKey(currentNode, nextRow("NameGuid"))
            If childNode Is Nothing Then Exit Sub
            currentNode = childNode
        Next

        Me.Select()
        TreeView1.Select()
        mSendEvent = SendEvent
        TreeView1.SelectedNode = currentNode
        mSendEvent = True
        currentNode.EnsureVisible()
        'If SendEvent = True Then
        '    RaiseEvent NodeSelected(Me, New System.Windows.Forms.TreeViewEventArgs(currentNode))
        'End If
    End Sub

    Public Sub Unpopulate(ByVal NodeUniqueKey As String)
        Dim Node As TreeNode = FindNode(NodeUniqueKey)
        If Node Is Nothing Then Return
        Unpopulate(Node)
    End Sub


    Public Sub Unpopulate(ByVal Node As TreeNode)
        Dim ChildCount As Long = Node.GetNodeCount(False)
        If ChildCount = 0 Then

            Exit Sub
        End If
        Node.Nodes.Clear()
        SetHasChildren(Node)
    End Sub

    Public Sub CollapseAndRefresh()
        TreeView1.Nodes.Clear()
        Dim Root As TreeNode = TreeView1.Nodes.Add("Root" + "    ")
        Root.Collapse()

        If Root.Tag Is Nothing Then
            Root.Tag = New TaxTreeNode
        End If

        Dim tag As TaxTreeNode = Root.Tag

        tag.NameGuid = RootKey
        SetHasChildren(Root)
        Dim f As Font = New Font("Tahoma", 8, FontStyle.Bold)
        Root.NodeFont = f
        mOldNode = Root
    End Sub

#End Region

#Region "Private Functions and Subs"


    Private Sub SetToolTip(ByVal node As TreeNode)
        If node Is Nothing Then
            Return
        End If

        Dim tag As TaxTreeNode = node.Tag
        If tag Is Nothing Then
            Return
        End If

        Dim TipText As String = ""

        If tag.Misapplied = True Or tag.InEd = True Then
            TipText &= "sensu "
        End If


        TipText &= tag.Authors
        If Trim(tag.YearOf) <> "" Then
            TipText &= " (" & tag.YearOf & ")"
        End If

        ToolTip1.SetToolTip(TreeView1, TipText)

    End Sub

    Private Function IsChildNodePresent(ByVal Node As TreeNode, ByVal ChildKey As String) As Boolean
        Dim ChildNode As TreeNode
        For Each ChildNode In Node.Nodes
            Dim tag As TaxTreeNode = ChildNode.Tag
            If tag.NameGuid = ChildKey Then
                Return True
            End If
        Next
        Return False
    End Function


    Private Function FindNode(ByVal NameGuid As String) As TreeNode

        Dim node As TreeNode
        For Each node In TreeView1.Nodes
            Dim tag As TaxTreeNode = node.Tag
            If tag.NameGuid = NameGuid Then
                Return node 'matching case
            End If

            'depth first search, see if key matches any descendants
            Dim DescendantNode As TreeNode = FindNodeInChildren(NameGuid, node)
            If Not DescendantNode Is Nothing Then
                Return DescendantNode 'matching case
            End If
        Next

        Return Nothing
    End Function

    'recursive function, finds a desendant node by its key, returns nothing if not found
    Private Function FindNodeInChildren(ByVal NameGuid As String, ByVal Node As TreeNode) As TreeNode

        If Node Is Nothing Then Return Nothing

        Dim NodeName As String = Node.Text
        Dim ChildCount As Long = Node.Nodes.Count

        Dim ChildNode As TreeNode
        For Each ChildNode In Node.Nodes
            Dim tag As TaxTreeNode = ChildNode.Tag
            If tag.NameGuid = NameGuid Then
                Return ChildNode 'matching case
            End If

            'depth first search, see if key matches any descendants
            Dim DescendantNode As TreeNode = FindNodeInChildren(NameGuid, ChildNode)
            If Not DescendantNode Is Nothing Then
                Return DescendantNode 'matching case
            End If
        Next

        Return Nothing

    End Function

    Private Sub ChangeTree()
        Dim NodeKey As String = GetSelectedNodeKey()
        CollapseAndRefresh()
        If LcUtility.KeyNotSet(NodeKey) = False Then
            SelectNode(NodeKey, False)
        End If

    End Sub

    Private Function GetSelectedNodeKey()
        Dim node As TreeNode = TreeView1.SelectedNode
        If node Is Nothing Then
            Return -1
        Else
            Dim tag As TaxTreeNode = node.Tag
            Return tag.NameGuid
        End If


    End Function


    'Private Sub LoadAlternateHierarchy()

    '    cddAlternateHierarchy.Clear()
    '    Dim colItems As LCComboItemCollection = New LCComboItemCollection

    '    Dim marshall As LcNameLiteratureInterface = New LcNameLiteratureInterface
    '    Dim objDsClassification As DsClassification = marshall.WebFillClassifications()

    '    Dim table As DsClassification.tblClassificationDataTable = objDsClassification.tblClassification
    '    Dim row As DsClassification.tblClassificationRow

    '    colItems.Add(New LCComboItem("Concensus", 0))
    '    Dim item As LCComboItem
    '    For Each row In table
    '        colItems.Add(New LCComboItem(row.ClassificationDescription, row.ClassificationCounterPk))
    '    Next

    '    Dim OldText As String = cddAlternateHierarchy.DisplayedText
    '    cddAlternateHierarchy.ItemCollection = colItems
    '    If OldText = "" Then
    '        cddAlternateHierarchy.ShowFirst()
    '    Else
    '        cddAlternateHierarchy.ShowItem(OldText)
    '    End If

    'End Sub


    Private Sub LoadTaxTreeNodeDs(ByVal NameKey As String)
        If TaxTreeDs IsNot Nothing Then TaxTreeDs.Clear()

        TaxTreeDs = ChecklistDataAccess.TreeData.GetTaxTreeNodes(1, NameKey, mClassificationKey)

    End Sub

    Private Sub LoadNodeToRootDs(ByVal Namekey As String)

        If NodeToRootDs IsNot Nothing Then NodeToRootDs.Clear()

        NodeToRootDs = ChecklistDataAccess.TreeData.GetNodeToRoot(1, Namekey, mClassificationKey)

    End Sub

    'adds the children for a given node
    'adds a dummy node under those with grandchildren so the plus is shown
    Private Sub Populate(ByVal Parent As TreeNode)

        Dim tag As TaxTreeNode = Parent.Tag
        Dim NameKey As String = tag.NameGuid

        'do not show if role does not have permission to see children under this node
        'If tag.InheritedPermissionsRead = False Then
        '    Return
        'End If

        LoadTaxTreeNodeDs(NameKey) 'load dataset from database

        Parent.Nodes.Clear() 'get rid of existing place holders

        Dim table As DataTable = TaxTreeDs.Tables(0)
        Dim count As Long = table.Rows.Count

        For Each row As DataRow In table.Rows


            If LcUtility.KeyNotSet(row("NameGuid")) = False Then  'something is wrong if the name counter is negitive

                'add a node for the child
                Dim node As TreeNode = Parent.Nodes.Add(row("NameCanonical"))
                If node.Tag Is Nothing Then
                    node.Tag = New TaxTreeNode
                End If
                tag = node.Tag
                tag.NameGuid = row("NameGuid")
                tag.NameLSID = row("NameLSID")

                'add various fields 

                node.ImageIndex = LcUtility.GetImageIndex(row("NameTaxonRankFk"))
                node.SelectedImageIndex = LcUtility.GetImageIndex(row("NameTaxonRankFk"))
                tag.RankKey = row("NameTaxonRankFk")
                tag.RankSort = 0
                If Not row.IsNull("TaxonRankSort") Then tag.RankSort = row("TaxonRankSort")


                If row("NameMisapplied") = True Then
                    SetIsMisapplied(node)
                    tag.Misapplied = True
                End If


                If Not row.IsNull("NameFull") Then
                    tag.FullName = row("NameFull")
                Else
                    tag.FullName = ""
                End If

                If row("ChildCount") > 0 Then
                    SetHasChildren(node)
                    tag.ChildCount = row("ChildCount")
                End If

                If Not row.IsNull("NameCurrentFK") Then
                    If row("NameCurrentFK") = row("NameGuid") Then
                        SetIsCurrentName(node)
                    End If
                End If

                If row("NameGuid") = MergeKey Then
                    SetIsMergeName(node)
                End If

                'If row.IsInheritedPermissionsReadNull = False Then
                '    tag.InheritedPermissionsRead = row.InheritedPermissionsRead
                'End If

                If Not row.IsNull("NameAuthors") Then
                    tag.Authors = row("NameAuthors")
                End If

                If Not row.IsNull("NameYearOfPublication") Then
                    tag.YearOf = row("NameYearOfPublication")
                End If


            End If
        Next

        If Parent.Nodes.Count < 1 And table.Rows.Count > 0 Then
            SetHasChildren(Parent)
        End If

        TaxTreeDs.Clear() 'clear dataset
    End Sub

    Private Sub SetIsMisapplied(ByVal node As TreeNode)
        node.ForeColor = Color.Red
    End Sub

    Private Sub SetIsInEdByVal(ByVal node As TreeNode)
        node.ForeColor = Color.Red
    End Sub

    Private Sub SetIsCurrentName(ByVal node As TreeNode)
        node.ForeColor = Color.Black
    End Sub

    Private Sub SetIsMergeName(ByVal node As TreeNode)
        node.ForeColor = Color.Green
    End Sub

    Private Sub SetHasChildren(ByVal node As TreeNode)
        Dim newNode As TreeNode = node.Nodes.Add("HasChildren")
        Dim tag As New TaxTreeNode
        tag.NameGuid = NO_KEY
        newNode.Tag = tag
    End Sub

    Private Function GetChildNodeByKey(ByRef CurrentNode As TreeNode, ByVal NameKey As String) As TreeNode
        Try
            Dim tag As TaxTreeNode = CurrentNode.Nodes(0).Tag
            If tag.NameGuid = NO_KEY Then Return Nothing
        Catch
            Return Nothing
        End Try
        Dim childNode As TreeNode
        For Each childNode In CurrentNode.Nodes
            Dim tag As TaxTreeNode = childNode.Tag
            If tag.NameGuid = NameKey Then Return childNode
        Next

        Return Nothing
    End Function



#End Region





    Private Sub TreeView1_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles TreeView1.MouseDown
        If DragEnabled = True Then
            Dim node As TreeNode = TreeView1.GetNodeAt(New Point(e.X, e.Y))
            If node Is Nothing Then Return
            TreeView1.SelectedNode = node
            Dim TagInfo As TaxTreeNode = node.Tag
            'TagInfo.NameCanonical = node.Text

            TreeView1.DoDragDrop(TagInfo, DragDropEffects.Copy)
        End If

    End Sub

    Public Event TreeDoubleClick(ByVal NameGuid As String, ByVal NameFull As String, ByVal NameLSID As String)

    Private Sub TreeView1_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles TreeView1.DoubleClick

        Dim node As TreeNode = TreeView1.SelectedNode
        If node Is Nothing Then Return

        Dim TagInfo As TaxTreeNode = node.Tag
        RaiseEvent TreeDoubleClick(TagInfo.NameGuid, TagInfo.FullName, TagInfo.NameLSID)

    End Sub

End Class
