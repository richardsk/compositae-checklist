Public Class TreeItemListControl
    Inherits System.Windows.Forms.UserControl

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
    Friend WithEvents lvwItems As System.Windows.Forms.ListView
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents lblName As System.Windows.Forms.Label
    Friend WithEvents colName As System.Windows.Forms.ColumnHeader
    Friend WithEvents colRank As System.Windows.Forms.ColumnHeader
    Friend WithEvents imlTaxTreeImages As System.Windows.Forms.ImageList
    Private components As System.ComponentModel.IContainer

    'Required by the Windows Form Designer
    
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(TreeItemListControl))
        Me.lvwItems = New System.Windows.Forms.ListView()
        Me.colName = New System.Windows.Forms.ColumnHeader()
        Me.colRank = New System.Windows.Forms.ColumnHeader()
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.lblName = New System.Windows.Forms.Label()
        Me.PictureBox1 = New System.Windows.Forms.PictureBox()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.imlTaxTreeImages = New System.Windows.Forms.ImageList(Me.components)
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lvwItems
        '
        Me.lvwItems.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colName, Me.colRank})
        Me.lvwItems.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwItems.LargeImageList = Me.imlTaxTreeImages
        Me.lvwItems.Location = New System.Drawing.Point(0, 20)
        Me.lvwItems.Name = "lvwItems"
        Me.lvwItems.Size = New System.Drawing.Size(150, 130)
        Me.lvwItems.SmallImageList = Me.imlTaxTreeImages
        Me.lvwItems.StateImageList = Me.imlTaxTreeImages
        Me.lvwItems.TabIndex = 0
        Me.lvwItems.View = System.Windows.Forms.View.Details
        '
        'colName
        '
        Me.colName.Text = "Name"
        Me.colName.Width = 109
        '
        'colRank
        '
        Me.colRank.Text = "Rank"
        '
        'ImageList1
        '
        Me.ImageList1.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.ImageList1.ImageSize = New System.Drawing.Size(16, 16)
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        '
        'lblName
        '
        Me.lblName.Anchor = ((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right)
        Me.lblName.Location = New System.Drawing.Point(24, 0)
        Me.lblName.Name = "lblName"
        Me.lblName.Size = New System.Drawing.Size(104, 16)
        Me.lblName.TabIndex = 1
        Me.lblName.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'PictureBox1
        '
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(16, 16)
        Me.PictureBox1.TabIndex = 0
        Me.PictureBox1.TabStop = False
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.Color.WhiteSmoke
        Me.Panel1.Controls.AddRange(New System.Windows.Forms.Control() {Me.lblName, Me.PictureBox1})
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(150, 20)
        Me.Panel1.TabIndex = 1
        '
        'imlTaxTreeImages
        '
        Me.imlTaxTreeImages.ColorDepth = System.Windows.Forms.ColorDepth.Depth8Bit
        Me.imlTaxTreeImages.ImageSize = New System.Drawing.Size(16, 16)
        Me.imlTaxTreeImages.ImageStream = CType(resources.GetObject("imlTaxTreeImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlTaxTreeImages.TransparentColor = System.Drawing.Color.Transparent
        '
        'TreeItemListControl
        '
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.lvwItems, Me.Panel1})
        Me.Name = "TreeItemListControl"
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


#Region "Constants"
#End Region

#Region "Enums"
#End Region

#Region "Member Variables"
    Private mImage As Image
    Private mLeft As Boolean
    Private mUtility As LcUtility
    Private mControlDown As Boolean

#End Region

#Region "Properties"

    Public Property LeftImage() As Boolean
        Get
            Return mLeft
        End Get
        Set(ByVal Value As Boolean)
            SetLeft(Value)
        End Set
    End Property

#End Region

#Region "Events"

    Private Sub TreeItemListControl_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        SetLeft(mLeft)
    End Sub

    Private Sub lvwItems_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwItems.MouseDown
        If e.Button <> MouseButtons.Left Then
            Exit Sub
        End If

        'if control held down exit sub
        If mControlDown = True Then
            Exit Sub
        End If

        Dim item As ListViewItem = lvwItems.GetItemAt(e.X, e.Y)
        If Not item Is Nothing Then
            If item.Selected = False Then
                Dim item2 As ListViewItem
                For Each item2 In lvwItems.Items
                    item2.Selected = False
                Next
            End If
            item.Selected = True
        End If

        If lvwItems.SelectedItems.Count < 1 Then
            Exit Sub
        End If

        lvwItems.DoDragDrop(Me, DragDropEffects.Copy Or DragDropEffects.Move)
    End Sub

    Private Sub lvwItems_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lvwItems.KeyUp
        If e.KeyCode = Keys.ControlKey Then
            mControlDown = False
        End If

        If e.KeyCode = Keys.A And e.Modifiers = Keys.Control Then
            SelectAll()
        End If

    End Sub

    Private Sub lvwItems_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles lvwItems.KeyDown
        If e.KeyCode = Keys.ControlKey Then
            mControlDown = True
        End If
    End Sub

#End Region

#Region "Public Functions and Sub"

    Public Sub LoadList(ByVal NodeKey As String, ByVal ClassificationKey As Long)
        If DesignMode = True Then Return
        Dim TaxTreeNode1 As DataSet
        TaxTreeNode1 = ChecklistDataAccess.TreeData.GetTaxTreeNodes(1, NodeKey, ClassificationKey)
        Dim table As DataTable = TaxTreeNode1.Tables(0)
        Dim count As Long = table.Rows.Count

        lvwItems.Items.Clear()
        For Each row As DataRow In table.Rows

            If LcUtility.KeyNotSet(row("NameGuid")) = False Then
                Dim Name As String = row("NameCanonical")
                Dim Key As String = row("NameGuid")

                Dim Rank As Long = 0

                AddItem(Key, Name, row("NameTaxonRankFk"))
            End If

        Next
    End Sub


#End Region

#Region "Private Functions and Subs"

    Private Sub AddItem(ByVal NameKey As String, ByVal Name As String, ByVal RankKey As Long)
        Dim ImageIndex As Integer = mUtility.GetImageIndex(RankKey)

        Dim item As ListViewItem

        item = lvwItems.Items.Add(Name, ImageIndex)

        item.Tag = NameKey
        item.SubItems.Add(RankKey)
    End Sub

    Private Sub SetLeft(ByVal Value As Boolean)
        mLeft = Value
        If mLeft = True Then
            mImage = ImageList1.Images(0)
            PictureBox1.Image = mImage
            PictureBox1.Location = New Point(0, 0)
        Else
            mImage = ImageList1.Images(1)
            PictureBox1.Image = mImage
            PictureBox1.Location = New Point(Panel1.Size.Width - PictureBox1.Size.Width, 0)
        End If
    End Sub

    Private Sub SelectAll()
        Dim item As ListViewItem
        For Each item In lvwItems.Items
            item.Selected = True
        Next
    End Sub

#End Region







    Private Sub lvwItems_MouseMove(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles lvwItems.MouseMove
        If e.Button <> MouseButtons.Left And lvwItems.SelectedItems.Count > 0 Then
            'lvwItems.MultiSelect = False
            'lvwItems.MultiSelect = True
        End If
    End Sub
End Class
