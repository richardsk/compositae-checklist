Imports DataAccess
Imports System.Xml

Public Class WebTaxTree

#Region "Tree Constants"


    Const NODE_ID_TAG As String = "NodeId"
    Const NODE_TAG As String = "Node"
    Const NODES_TAG As String = "Nodes"
    Const STATE_ID_TAG As String = "StateId"
    Const CHILDREN_STATE_TAG As String = "State"
    Const RANK_TAG As String = "Rank"
    Const MINUS_TAG As String = "-"
    Const PLUS_TAG As String = "+"
    Const EMPTY_TAG As String = "x"
    Const TAX_NAME_TAG As String = "TaxName"
    Const NAME_FULL_TAG As String = "NameFull"
    Const CURRENT_NAME_KEY_TAG As String = "CurrentKey"
    Const STYLE_TAG As String = "style"


#End Region


#Region "Member Variables"



    Private mDaTrees As DaTrees
    Private mXmlTreeDoc As XmlDocument
    Private mSession As Long
    Private mXmlOut As String
    Private XSL_Filename As String
    Private Output_Filename As String


#End Region

    Public SelectedNodeId As String = ""

    Public Sub New()
        MyBase.new()

        mDaTrees = New DaTrees()
        mDaTrees.DaInitialise(ConfigurationManager.AppSettings.Get("ConnectionString"))

        'TODO create instance of DANameDetails
        '"C:\Documents and Settings\wilsonm\My Documents\Visual Studio Projects\DBITN\BusinessRules\Nodes.xsl"
        'Dim config As Configuration.ConfigurationSettings = New Configuration.ConfigurationSettings()
        XSL_Filename = ConfigurationManager.AppSettings.Get("XSL_FilePath")

        Output_Filename = ConfigurationManager.AppSettings.Get("HTML_FilePath")
    End Sub

#Region "Properties"

    Public ValidNamesOnly As Boolean = False

    Public ReadOnly Property TreeXml() As String
        Get
            Return mXmlOut
        End Get
    End Property

#End Region

#Region "Public Functions and Subs"

    'selects node in tree, 
    'if node is not presently in the tree, 
    'the tree is populated with the ancestors of the selected node
    Public Sub SelectNode(ByVal NodeId As String, Optional ByVal StateId As Long = -1)
        PopulateTree(StateId)
        
        'add ancestors from root to node
        SelectNodeFromNameTable(NodeId)

        SetStateId(0) 'do not know new StateId until identity has create new int 
        Dim NewStateId As Long = SaveTreeToDb()
        SetStateId(NewStateId)
        Transform(Output_Filename)
    End Sub

    Public Sub AddMissingChildren()

    End Sub

    'adds all the children of a node to chosen node, 
    Public Sub AddChildren(ByVal NodeUniqueId As String, ByVal StateId As Long)
        PopulateTree(StateId)

        AddChildrenFromNamesTable(NodeUniqueId, "")

        SetStateId(0) 'do not know new StateId until identity has create new int 
        Dim NewStateId As Long = SaveTreeToDb()
        SetStateId(NewStateId)
        Transform(Output_Filename)
    End Sub

    Public Sub RemoveNodeChildren(ByVal NodeUniqueId As String, ByVal StateId As Long)
        PopulateTree(StateId)

        Dim Node As XmlElement
        FindNode(Node, NodeUniqueId)
        If Node IsNot Nothing Then
            SetState(Node, PLUS_TAG)
            RemoveChildren(Node)
        End If

        SetStateId(0) 'do not know new StateId until identity has create new int 
        Dim NewStateID As Long = SaveTreeToDb()
        SetStateId(NewStateID)
        Transform(Output_Filename)
    End Sub


    Public Sub GetTreeState(ByVal StateId As Long)
        PopulateTree(StateId)
        SetStateId(StateId)
        Transform(Output_Filename)
    End Sub

#End Region

#Region "Private Functions and Subs"

    Private Function SaveTreeToDb() As Long
        Dim strXmlTree As String = mXmlTreeDoc.OuterXml

        Return mDaTrees.InsertTaxTreeState(strXmlTree, mSession)
    End Function

    Public Function GetStartingNode() As String
        Return System.Configuration.ConfigurationManager.AppSettings.Get("StartingNode")
    End Function

    Private Function GetTree(ByVal StateId As Long) As String

        Return mDaTrees.GetTaxTreeState(StateId)

    End Function

    Private Sub PopulateTree(ByVal StateId As Long)
        If StateId > 0 Then
            Dim strXmlTree As String = GetTree(StateId)
            mXmlTreeDoc = New XmlDocument()
            mXmlTreeDoc.LoadXml(strXmlTree)
        Else
            mXmlTreeDoc = New XmlDocument() 'create new tree state
            CreateRoot()
            SelectNodeFromNameTable(GetStartingNode())
        End If

    End Sub


    Private Function RootKey() As String
        Return ConfigurationManager.AppSettings.Get("StartingNode")
    End Function

    Private Sub Transform(ByVal Filename As String)
        Dim XmlNodesTransform As Xsl.XslCompiledTransform = New Xsl.XslCompiledTransform()

        XmlNodesTransform.Load(XSL_Filename)

        Try
            Dim ms As New IO.MemoryStream
            XmlNodesTransform.Transform(mXmlTreeDoc, Nothing, ms)
            ms.Position = 0
            mXmlOut = New IO.StreamReader(ms).ReadToEnd
        Catch ex As Exception
            'MsgBox("custom errror:" & Chr(13) & ex.Message)
            Exit Sub
        End Try

    End Sub

    Private Function GetNodesNode(ByVal ParentNode As XmlElement) As XmlElement
        Dim node As XmlNode
        If ParentNode Is Nothing Then Return Nothing
        For Each node In ParentNode.ChildNodes
            If node.Name = NODES_TAG Then
                Return node
            End If
        Next
        Return Nothing
    End Function


    Private Function GetChildCount(ByVal ParentNode As XmlElement) As Long
        Dim node As XmlNode

        Dim NodesNode As XmlNode = GetNodesNode(ParentNode)

        If NodesNode Is Nothing Then
            Return 0
        End If

        Dim count = 0
        For Each node In NodesNode.ChildNodes
            If node.NodeType = XmlNodeType.Element Then
                count += 1
            End If
        Next
        Return count
    End Function


    Private Sub SelectNodeFromNameTable(ByVal NodeUniqueId As String)

        'Start from the root
        Dim ParentNode As XmlElement = FindRoot()
        Dim CurrentNode As XmlElement

        'get list of nodes, root to selected node
        Dim ds As DsNodeToRoot = mDaTrees.GetNodeToRoot(NodeUniqueId, 0)
        Dim table As DsNodeToRoot.sprSelect_NodeToRootDataTable = ds.sprSelect_NodeToRoot
        Dim row As DsNodeToRoot.sprSelect_NodeToRootRow
        Dim index As Long

        'special case: root node
        If table.Rows.Count > 0 Then
            'populate node if necessary
            If GetChildCount(ParentNode) = 0 Then
                row = table.Rows(0)
                AddChildrenFromNamesTable(row.NameGuid, table(1).NameGuid)
            End If
        End If

        'start from root and work downwards, populating as necessary  
        For index = 1 To table.Rows.Count - 1

            row = table.Rows(index)
            Dim NameKey As String = row.NameGuid

            'find node in tree
            FindNode(CurrentNode, NameKey)
            If CurrentNode Is Nothing Then Exit Sub

            Dim nextName As String = ""
            If table.Rows.Count > index + 1 Then nextName = table(index + 1).NameGuid

            'populate node if necessary
            If GetChildCount(CurrentNode) = 0 Then
                AddChildrenFromNamesTable(NameKey, nextName)
            End If

        Next

    End Sub

    'looks at tblname in DB to find the children of a given node, adds them showing '+' or ' ' whether they have children or not
    Private Sub AddChildrenFromNamesTable(ByVal NodeUniqueId As String, ByVal requiredNameId As String)
        Dim Node As XmlElement

        'find node in XML Document
        FindNode(Node, NodeUniqueId)
        If Node Is Nothing Then
            Exit Sub
        End If


        SetState(Node, EMPTY_TAG)

        'get children of name indicated by name key, do not get suppressed children
        Dim ds As DsTaxTreeNode = mDaTrees.GetTaxTreeNodes(NodeUniqueId, 0, True)
        If ds Is Nothing Then
            Exit Sub
        End If

        'iterate through the child names
        Dim table As DsTaxTreeNode.sprGetNodeDataTable = ds.sprGetNode

        If table.Count > 0 Then
            SetState(Node, MINUS_TAG) 'Show the node has been expanded '-'
        Else
            SetState(Node, EMPTY_TAG)
        End If

        Dim row As DsTaxTreeNode.sprGetNodeRow
        For Each row In table
            If row.IsNameParentFKNull = False Then

                'only show node if role has read permission
                Dim HasReadPermission As Boolean = True
                If row.IsPermissionsReadNull = False Then
                    HasReadPermission = row.PermissionsRead
                End If

                'only show node if name is not suppressed
                Dim Suppress As Boolean = row.NameSuppress

                Dim illeg As Boolean = False
                If row.NameIllegitimate Or row.NameInvalid Or row.NameMisapplied Then
                    illeg = True
                End If

                'only show name if valid and not supressed?
                If row.NameGuid <> requiredNameId And ValidNamesOnly And row("AcceptedChildCount") = 0 Then
                    If row.IsNameCurrentFKNull Then
                        Suppress = True
                    End If
                End If

                If row.NameGuid <> "" And HasReadPermission = True And Suppress = False Then
                    Dim RankKey As Long = 0

                    RankKey = row.NameTaxonRankFk

                    'decide whether node has children by the child count
                    Dim ChildrenState As String
                    If row.ChildCount < 1 Then
                        ChildrenState = EMPTY_TAG ' '
                    Else
                        ChildrenState = PLUS_TAG  '+'
                    End If

                    'Get the node key
                    Dim CurrentNameKey As String = ""
                    If row.IsNameCurrentFKNull = False Then
                        CurrentNameKey = row.NameCurrentFK
                    End If

                    'add node to XML Document
                    AddChild(Node, row.NameGuid, row.NameCanonical, ChildrenState, RankKey, CurrentNameKey, illeg, row.NameFull)

                End If
            End If
        Next

    End Sub

    Private Function FindRoot() As XmlElement
        Dim Node As XmlElement = Nothing
        FindNode(Node, RootKey)
        Return Node
    End Function


    Private Sub FindNode(ByRef Node As XmlElement, ByVal NodeUniqueId As String)
        Dim strPath As String = "descendant::Node[@NodeId='" & NodeUniqueId & "']"

        Try
            Node = mXmlTreeDoc.SelectSingleNode(strPath)
        Catch ex As Exception
            'Debug.WriteLine(">>> " & ex.Message)
        End Try

    End Sub

    Private Sub SetStateId(ByVal StateID As Long)
        Dim TaxTreeRoot As XmlElement = mXmlTreeDoc.DocumentElement
        Dim Attribute As XmlAttribute
        'Debug.Write(mXmlTreeDoc.OuterXml)
        For Each Attribute In TaxTreeRoot.Attributes
            If Attribute.Name = STATE_ID_TAG Then
                Attribute.Value = StateID
                Exit Sub
            End If
        Next

    End Sub

    Private Function GetStateId() As String
        Dim TaxTreeRoot As XmlElement = mXmlTreeDoc.DocumentElement
        Dim Attribute As XmlAttribute
        'Debug.Write(mXmlTreeDoc.OuterXml)
        For Each Attribute In TaxTreeRoot.Attributes
            If Attribute.Name = STATE_ID_TAG Then
                Return Attribute.Value
            End If
        Next
        Return ""
    End Function

    Private Sub CreateRoot()

        Dim TaxTreeRoot As XmlElement = mXmlTreeDoc.CreateElement(NODE_TAG)
        Dim StateId As XmlAttribute = mXmlTreeDoc.CreateAttribute(STATE_ID_TAG)
        StateId.Value = "0"
        Dim NodeId As XmlAttribute = mXmlTreeDoc.CreateAttribute(NODE_ID_TAG)
        NodeId.Value = RootKey()
        Dim Rank As XmlAttribute = mXmlTreeDoc.CreateAttribute(RANK_TAG)
        Rank.Value = "1"
        Dim ChildState As XmlAttribute = mXmlTreeDoc.CreateAttribute(CHILDREN_STATE_TAG)
        ChildState.Value = PLUS_TAG
        Dim stAtt As XmlAttribute = mXmlTreeDoc.CreateAttribute(STYLE_TAG)
        stAtt.Value = "color:Black; text-decoration:none; font-size:12px;"

        TaxTreeRoot.Attributes.Append(NodeId)
        TaxTreeRoot.Attributes.Append(StateId)
        TaxTreeRoot.Attributes.Append(Rank)
        TaxTreeRoot.Attributes.Append(ChildState)
        TaxTreeRoot.Attributes.Append(stAtt)

        Dim nm As ChecklistObjects.Name = ChecklistDataAccess.NameData.GetName(Nothing, NodeId.Value)

        AddTaxName(TaxTreeRoot, nm.NameCanonical)
        mXmlTreeDoc.AppendChild(TaxTreeRoot)
        AddNodes(TaxTreeRoot)
    End Sub

    Private Sub GetNodesElement(ByRef Parent As XmlElement, ByRef Nodes As XmlElement)
        Dim ChildNode As XmlElement
        For Each ChildNode In Parent.ChildNodes
            If ChildNode.Name = NODES_TAG Then
                Nodes = ChildNode
                Exit Sub
            End If
        Next
        Nodes = Nothing
    End Sub

    Private Function GetRank(ByRef Node As XmlElement) As Long
        Dim Attribute As XmlAttribute
        'Debug.Write(mXmlTreeDoc.OuterXml)
        For Each Attribute In Node.Attributes
            If Attribute.Name = RANK_TAG Then
                Return Attribute.Value
            End If
        Next
        Return -1
    End Function

    Private Function GetState(ByRef Node As XmlElement) As String
        Dim Attribute As XmlAttribute
        'Debug.Write(mXmlTreeDoc.OuterXml)
        For Each Attribute In Node.Attributes
            If Attribute.Name = CHILDREN_STATE_TAG Then
                Return Attribute.Value
            End If
        Next
        Return ""
    End Function

    Private Sub SetState(ByRef Node As XmlElement, ByVal State As String)
        Dim Attribute As XmlAttribute
        'Debug.Write(mXmlTreeDoc.OuterXml)
        For Each Attribute In Node.Attributes
            If Attribute.Name = CHILDREN_STATE_TAG Then
                Attribute.Value = State
                Exit Sub
            End If
        Next

    End Sub

    Private Function GetTaxName(ByRef Node As XmlElement) As String
        Dim ChildNode As XmlElement
        For Each ChildNode In Node.ChildNodes
            If ChildNode.Name = TAX_NAME_TAG Then
                Return ChildNode.InnerText
                Exit Function
            End If
        Next
        Return ""
    End Function

    Private Sub AddNodeId(ByRef Node As XmlElement, ByVal NodeId As String)
        Dim NodeIdAttribute As XmlAttribute = mXmlTreeDoc.CreateAttribute(NODE_ID_TAG)
        NodeIdAttribute.Value = NodeId
        Node.Attributes.Append(NodeIdAttribute)

    End Sub

    Private Sub AddChildrenState(ByRef Node As XmlElement, ByVal ChildrenState As String)
        Dim ChildrenStateAttribute As XmlAttribute = mXmlTreeDoc.CreateAttribute(CHILDREN_STATE_TAG)
        ChildrenStateAttribute.Value = ChildrenState
        Node.Attributes.Append(ChildrenStateAttribute)

    End Sub

    Private Sub AddNodes(ByRef Node As XmlElement)
        Dim Nodes As XmlElement = mXmlTreeDoc.CreateElement(NODES_TAG)
        Node.AppendChild(Nodes)
    End Sub

    Private Sub AddRank(ByRef Node As XmlElement, ByVal Rank As Long)
        Dim RankAttribute As XmlAttribute = mXmlTreeDoc.CreateAttribute(RANK_TAG)
        RankAttribute.Value = Rank
        Node.Attributes.Append(RankAttribute)
    End Sub

    Private Sub AddStyle(ByRef Node As XmlElement, ByVal nameId As String, ByVal currentNameId As String, ByVal illeg As Boolean)
        Dim Attribute As XmlAttribute = mXmlTreeDoc.CreateAttribute(STYLE_TAG)
        Dim st As String = "text-decoration:none; font-size:12px; "
        If nameId = SelectedNodeId Then
            st += "color:White; background-color:#ADAD74; "
        ElseIf illeg Then
            If currentNameId <> "" And currentNameId = nameId Then
                st += "color:Red; "
            Else
                st += "color:Purple; "
            End If
        ElseIf currentNameId = "" Then
            st += "color:Green; "
        ElseIf currentNameId = nameId Then
            st += "color:Black; font-weight:Bold; "
        Else
            st += "color:Black"
        End If
        Attribute.Value = st
        Node.Attributes.Append(Attribute)
    End Sub

    Private Sub AddCurrentName(ByRef Node As XmlElement, ByVal CurrentNameKey As String)
        Dim Attribute As XmlAttribute = mXmlTreeDoc.CreateAttribute(CURRENT_NAME_KEY_TAG)
        Attribute.Value = CurrentNameKey
        Node.Attributes.Append(Attribute)
    End Sub

    Private Sub AddTaxName(ByRef Node As XmlElement, ByVal TaxName As String)
        Dim TaxNameNode As XmlElement = mXmlTreeDoc.CreateElement(TAX_NAME_TAG)
        TaxNameNode.InnerText = TaxName
        Node.AppendChild(TaxNameNode)
    End Sub

    Private Sub AddFullName(ByRef Node As XmlElement, ByVal NameFull As String)
        Dim TaxNameNode As XmlElement = mXmlTreeDoc.CreateElement(NAME_FULL_TAG)
        TaxNameNode.InnerText = NameFull
        Node.AppendChild(TaxNameNode)
    End Sub

    Private Sub RemoveChildren(ByRef Parent As XmlElement)
        Dim NodesOfParent As XmlElement = Nothing
        GetNodesElement(Parent, NodesOfParent)
        If NodesOfParent Is Nothing Then
            Exit Sub
        End If
        NodesOfParent.RemoveAll()
    End Sub

    'adds a child node to the node specified in the XML Document
    Private Sub AddChild(ByRef Parent As XmlElement, ByVal NameUniqueKey As String, ByVal TaxName As String, ByVal State As String, ByVal RankKey As Long, ByVal CurrentNameUniqueKey As String, ByVal illeg As Boolean, ByVal NameFull As String)

        'get the node that contains the child nodes
        Dim NodesOfParent As XmlElement = Nothing
        GetNodesElement(Parent, NodesOfParent)
        If NodesOfParent Is Nothing Then
            Exit Sub 'shouldn't happen 
        End If

        'create a new node with the name "Node"
        Dim Node As XmlElement = mXmlTreeDoc.CreateElement(NODE_TAG)

        'add the attributes to the new node
        AddStyle(Node, NameUniqueKey, CurrentNameUniqueKey, illeg)
        AddCurrentName(Node, CurrentNameUniqueKey)

        AddRank(Node, RankKey)

        AddNodeId(Node, NameUniqueKey)

        AddChildrenState(Node, State)

        AddTaxName(Node, TaxName)
        AddFullName(Node, NameFull)
        AddNodes(Node)

        'add the node to the parents
        NodesOfParent.AppendChild(Node)
    End Sub



#End Region


End Class
