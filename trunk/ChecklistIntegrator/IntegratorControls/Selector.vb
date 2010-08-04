Imports System.Windows.Forms
Imports System.Drawing
Imports ChecklistObjects

Public Class NameSelector
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

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
    Friend WithEvents Search1 As Search
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents TaxTree1 As TaxTree

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.Container

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents hdcHistory As HistoryDropdownControl
    Public WithEvents TreeLabel As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Search1 = New Search
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.TaxTree1 = New TaxTree
        Me.hdcHistory = New HistoryDropdownControl
        Me.TreeLabel = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'Search1
        '
        Me.Search1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Search1.Location = New System.Drawing.Point(0, 0)
        Me.Search1.Name = "Search1"
        Me.Search1.Size = New System.Drawing.Size(208, 200)
        Me.Search1.TabIndex = 0
        Me.Search1.UserSettingsEnabled = False
        '
        'Splitter1
        '
        Me.Splitter1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Splitter1.Location = New System.Drawing.Point(0, 200)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(208, 6)
        Me.Splitter1.TabIndex = 1
        Me.Splitter1.TabStop = False
        '
        'TaxTree1
        '
        Me.TaxTree1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.TaxTree1.DragEnabled = False
        Me.TaxTree1.Location = New System.Drawing.Point(0, 244)
        Me.TaxTree1.Name = "TaxTree1"
        Me.TaxTree1.Size = New System.Drawing.Size(208, 188)
        Me.TaxTree1.TabIndex = 2
        '
        'hdcHistory
        '
        Me.hdcHistory.BackColor = System.Drawing.Color.WhiteSmoke
        Me.hdcHistory.Dock = System.Windows.Forms.DockStyle.Top
        Me.hdcHistory.HistoryName = Nothing
        Me.hdcHistory.Location = New System.Drawing.Point(0, 206)
        Me.hdcHistory.Name = "hdcHistory"
        Me.hdcHistory.Size = New System.Drawing.Size(208, 22)
        Me.hdcHistory.TabIndex = 1
        '
        'TreeLabel
        '
        Me.TreeLabel.Dock = System.Windows.Forms.DockStyle.Top
        Me.TreeLabel.Location = New System.Drawing.Point(0, 228)
        Me.TreeLabel.Name = "TreeLabel"
        Me.TreeLabel.Size = New System.Drawing.Size(208, 16)
        Me.TreeLabel.TabIndex = 3
        Me.TreeLabel.Text = "Tree"
        '
        'NameSelector
        '
        Me.Controls.Add(Me.TaxTree1)
        Me.Controls.Add(Me.TreeLabel)
        Me.Controls.Add(Me.hdcHistory)
        Me.Controls.Add(Me.Splitter1)
        Me.Controls.Add(Me.Search1)
        Me.Name = "NameSelector"
        Me.Size = New System.Drawing.Size(208, 432)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Constants"
#End Region

#Region "Enums"
#End Region

#Region "Member Variables"
    Private mText As String
    Private mEnabled As Boolean
  




#End Region

#Region "Properties"


    Public Property MergeKey() As String
        Get
            Return TaxTree1.MergeKey
        End Get
        Set(ByVal Value As String)
            TaxTree1.MergeKey = Value
        End Set
    End Property

    Public Property HistoryName() As String
        Get
            Return hdcHistory.HistoryName
        End Get
        Set(ByVal Value As String)
            hdcHistory.HistoryName = Value
        End Set
    End Property

    Public Property HistoryVisible() As Boolean
        Get
            Return hdcHistory.Visible
        End Get
        Set(ByVal Value As Boolean)
            hdcHistory.Visible = Value
        End Set
    End Property

    Public ReadOnly Property HistoryDropdown() As HistoryDropdownControl
        Get
            Return hdcHistory
        End Get

    End Property

    Public ReadOnly Property SelectedNodeName() As String
        Get
            Return TaxTree1.SelectedNodeName
        End Get
    End Property

    Public ReadOnly Property SelectedNodeKey() As String
        Get
            Return TaxTree1.SelectedGuid
        End Get
    End Property

    Public ReadOnly Property SelectedUniqueKey() As String
        Get
            Return TaxTree1.SelectedGuid
        End Get
    End Property

    'Property CustomEnabled() As Boolean
    '    Get
    '        Return mEnabled
    '    End Get
    '    Set(ByVal Value As Boolean)
    '        mEnabled = Value
    '        If mEnabled = True Then
    '            'Search1.Enabled = True
    '            TaxTree1.CustomEnabled = True
    '        Else
    '            'Search1.Enabled = False
    '            TaxTree1.CustomEnabled = False
    '        End If
    '    End Set
    'End Property

    Public Property DropEnable() As Boolean
        Get
            Return TaxTree1.TreeView1.AllowDrop
        End Get
        Set(ByVal Value As Boolean)
            TaxTree1.TreeView1.AllowDrop = Value
        End Set
    End Property

    Public Property DragEnabled() As Boolean
        Get
            If TaxTree1 Is Nothing Then Return False
            Return TaxTree1.DragEnabled
        End Get
        Set(ByVal Value As Boolean)
            If TaxTree1 Is Nothing Then Return
            TaxTree1.DragEnabled = Value
        End Set
    End Property

#End Region

#Region "Events"
    Public Event selected(ByVal NameGuid As String, ByVal NameLSID As String)

    Private Sub Splitter1_MouseHover(ByVal sender As System.Object, ByVal e As EventArgs) Handles Splitter1.MouseEnter
        Splitter1.BackColor = Color.DeepSkyBlue
    End Sub

    Private Sub Splitter1_MouseLeave(ByVal sender As System.Object, ByVal e As EventArgs) Handles Splitter1.MouseLeave
        Splitter1.BackColor = System.Drawing.SystemColors.Control
    End Sub

    Private Sub TaxTree1_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TaxTree1.Load
        TaxTree1.SelectedNodeName = ""
        TaxTree1.SelectedGuid = ""
        TaxTree1.SelectedUPk = ""
    End Sub

    Public Event SelectedWhileDisabled(ByVal NameUniqueKey As String)

    Private Sub TaxTree1_TreeviewNodeSelectedWhileDisabled(ByVal NameUniqueKey As String) Handles TaxTree1.TreeviewNodeSelectedWhileDisabled
        RaiseEvent SelectedWhileDisabled(NameUniqueKey)

    End Sub

    Public Event EnterPressed(ByVal e As System.Windows.Forms.KeyEventArgs)

    Private Sub TaxTree1_KeyDown(ByVal e As System.Windows.Forms.KeyEventArgs) Handles TaxTree1.EnterPressed
        RaiseEvent EnterPressed(e)
    End Sub

#End Region

#Region "Public Functions and Sub"

    Public Sub SetSearchFields(ByVal fields As String())
        Search1.SearchFields = fields
    End Sub

    Public Sub RefreshTree()
        TaxTree1.InitialiseTree()
    End Sub

    Public Sub SelectNode(ByVal UniqueKey As String, Optional ByVal SendEvent As Boolean = True)
        If UniqueKey Is Nothing Then Return
        Me.TaxTree1.SelectNode(UniqueKey, SendEvent)
    End Sub

    'Public Sub SelectLSIDNode(ByVal lsid As String)
    '    Me.TaxTree1.SelectLSIDNode(lsid)
    'End Sub

    Public Sub Search1_Selected(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Search1.Selected
        Dim key As String
        Dim NumberOfItems As Long = Me.Search1.lvwResults.SelectedItems.Count
        If NumberOfItems < 1 Then Exit Sub
        Try
            key = Me.Search1.lvwResults.SelectedItems.Item(0).Tag
        Catch ex As Exception

        End Try

        If key <> TaxTree1.SelectedKey Then
            TaxTree1.SelectNode(key)
        End If
        TaxTree1.Select()
        TaxTree1.TreeView1.Select()
        'TaxTree1.TreeView1.Focus()

        'RaiseEvent selected(key)
    End Sub

    Public Sub NodeSelected(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles TaxTree1.NodeSelected

        'mSelectedNodeName = e.Node.Text
        Dim tag As TaxTreeNode = e.Node.Tag
        If tag Is Nothing Then
            Return
        End If

        RaiseEvent selected(tag.NameGuid, tag.NameLSID)
    End Sub

    'Public Sub SaveControlSettings(ByVal UserKey As Long)
    '    Search1.SaveControlSettings(UserKey)
    '    TaxTree1.SaveControlSettings(UserKey)
    'End Sub

    'Public Sub LoadControlSettings(ByVal UserKey As Long)
    '    Search1.LoadControlSettings(UserKey)
    '    TaxTree1.LoadControlSettings(UserKey)
    'End Sub

    Public ReadOnly Property SelectedNameNode() As TreeNode
        Get
            Return TaxTree1.SelectedNode
        End Get
    End Property

#End Region

#Region "Private Functions and Subs"


#End Region






    Public Event SelectorDoubleClick(ByVal NameGuid As String, ByVal NameFull As String, ByVal NameLSID As String)

    Private Sub TaxTree1_TreeDoubleClick(ByVal NameGuid As String, ByVal NameFull As String, ByVal NameLSID As String) Handles TaxTree1.TreeDoubleClick
        RaiseEvent SelectorDoubleClick(NameGuid, NameFull, NameLSID)
    End Sub


    Private Sub hdcHistory_HistorySelectionChangeEvent(ByVal sender As Object, ByVal item As HistoryItem) Handles hdcHistory.HistorySelectionChangeEvent
        TaxTree1.SelectNode(item.Key)
        TaxTree1.Select()
        TaxTree1.TreeView1.Select()
    End Sub

    Private Sub NameSelector_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Search1.Focus()
    End Sub

    Private Sub Search1_SearchDoubleClick(ByVal NameGuid As String, ByVal NameFull As String, ByVal NameLSID As String) Handles Search1.SearchDoubleClick
        RaiseEvent SelectorDoubleClick(NameGuid, NameFull, NameLSID)
    End Sub

End Class

