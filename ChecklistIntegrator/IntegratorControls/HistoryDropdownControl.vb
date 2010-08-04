Imports ChecklistObjects

Public Class HistoryDropdownControl
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

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents cmbHistory As System.Windows.Forms.ComboBox
    Friend WithEvents ComboLabel As System.Windows.Forms.Label
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.cmbHistory = New System.Windows.Forms.ComboBox
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.ComboLabel = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'cmbHistory
        '
        Me.cmbHistory.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmbHistory.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbHistory.Location = New System.Drawing.Point(0, 0)
        Me.cmbHistory.Name = "cmbHistory"
        Me.cmbHistory.Size = New System.Drawing.Size(150, 21)
        Me.cmbHistory.TabIndex = 0
        '
        'ComboLabel
        '
        Me.ComboLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ComboLabel.Location = New System.Drawing.Point(3, 3)
        Me.ComboLabel.Name = "ComboLabel"
        Me.ComboLabel.Size = New System.Drawing.Size(120, 13)
        Me.ComboLabel.TabIndex = 1
        Me.ComboLabel.Visible = False
        '
        'HistoryDropdownControl
        '
        Me.Controls.Add(Me.ComboLabel)
        Me.Controls.Add(Me.cmbHistory)
        Me.Name = "HistoryDropdownControl"
        Me.Size = New System.Drawing.Size(150, 20)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Const HISTORY_DISPLAY_PREFIX_TAG As String = "History_Display_"
    'Private Const HISTORY_PK_PREFIX_TAG As String = "History_PK_"
    Private Const HISTORY_PK_PREFIX_TAG As String = "History_PK_"

    Private HISTORY_COUNT As Long = 10

    Private Const HISTORY_CONTROL_NAME As String = "HistoryControl"
    Private Const DEFAULT_HISTORY_NAME As String = "HistoryControl"


    Private mReadOnly As Boolean = False
    Private mHistoryName As String
    Private browseItem As HistoryItem = New HistoryItem("Browse", "Browse...")

    Public Delegate Sub HistoryBrowseDelegate(ByVal historyCtrl As HistoryDropdownControl)
    Public BrowseDelegate As HistoryBrowseDelegate

    Public Event HistorySelectionChangeEvent(ByVal sender As Object, ByVal item As HistoryItem)


    'probably relates to item being selected
    Public Property HistoryName() As String
        Get
            Return mHistoryName
        End Get
        Set(ByVal Value As String)
            mHistoryName = Value
        End Set
    End Property

    Public Property MaxCount() As Long
        Get
            Return HISTORY_COUNT
        End Get
        Set(ByVal value As Long)
            If value > 0 Then
                HISTORY_COUNT = value
            End If
        End Set
    End Property

    Public Property PReadOnly() As Boolean
        Get
            Return mReadOnly
        End Get
        Set(ByVal Value As Boolean)
            mReadOnly = Value
            If Value = True Then
                cmbHistory.Visible = False
                ComboLabel.Text = cmbHistory.Text
                ComboLabel.Visible = True
            Else
                cmbHistory.Visible = True
                ComboLabel.Visible = False
            End If
        End Set
    End Property


    Public Sub SaveHistoryToDb()
        If mHistoryName = "" Then mHistoryName = DEFAULT_HISTORY_NAME

        Dim index As Long = 0
        Dim item As HistoryItem
        For Each item In cmbHistory.Items
            If item.DisplayText <> browseItem.DisplayText Then
                Dim DisplayTag As String = HISTORY_DISPLAY_PREFIX_TAG & index

                Dim PkTag As String = HISTORY_PK_PREFIX_TAG & index
                'TODO
                'LcUtility.UpdateUserSetting(HISTORY_CONTROL_NAME, HistoryName, DisplayTag, item.DisplayText)

                'LcUtility.UpdateUserSetting(HISTORY_CONTROL_NAME, HistoryName, PkTag, item.Key)
                index += 1
            End If
        Next

        Dim IndexStart As Long = index
        For index = IndexStart To HISTORY_COUNT - 1
            Dim DisplayTag As String = HISTORY_DISPLAY_PREFIX_TAG & index

            Dim PkTag As String = HISTORY_PK_PREFIX_TAG & index
            'TODO
            'LcUtility.UpdateUserSetting(HISTORY_CONTROL_NAME, HistoryName, DisplayTag, "")

            'LcUtility.UpdateUserSetting(HISTORY_CONTROL_NAME, HistoryName, PkTag, "")
        Next
    End Sub

    'get  # HISTORY_COUNT history settings from db
    Public Sub LoadHistoryFromDb()
        If mHistoryName = "" Then mHistoryName = DEFAULT_HISTORY_NAME

        cmbHistory.Items.Clear()

        Dim index As Long
        For index = 0 To HISTORY_COUNT - 1
            Dim DisplayTag As String = HISTORY_DISPLAY_PREFIX_TAG & index

            Dim PkTag As String = HISTORY_PK_PREFIX_TAG & index
            'TODO
            'Dim DisplayText As String = Trim(LcUtility.GetUserSetting(HISTORY_CONTROL_NAME, HistoryName, DisplayTag))

            'Dim Key As String = Trim(LcUtility.GetUserSetting(HISTORY_CONTROL_NAME, HistoryName, PkTag))

            'If DisplayText <> "" And Key <> "" Then
            '    AddItem(Key, DisplayText, True)
            'End If
        Next

        If Not BrowseDelegate Is Nothing Then
            cmbHistory.Items.Add(browseItem)
        End If
    End Sub

    Public Sub CopyHistory(ByVal CopyFrom As HistoryDropdownControl, ByVal IncludeBrowse As Boolean)
        Dim index As Integer
        'cmbHistory.Items.Clear()
        If IncludeBrowse Then
            If Not BrowseDelegate Is Nothing Then
                cmbHistory.Items.Add(browseItem)
            End If
        End If
        For index = 0 To CopyFrom.cmbHistory.Items.Count - 1
            Dim Item As HistoryItem = CopyFrom.cmbHistory.Items(index)
            If Item.DisplayText <> "<Self>" And (Not Item.Key Is Nothing) And Not (Item.DisplayText = "Browse...") Then
                AddItem(Item.Key, Item.DisplayText, False)
            End If
        Next

    End Sub


    Public Function GetItemDisplayname(ByVal Key As String) As String
        Dim index As Integer
        For index = 0 To cmbHistory.Items.Count - 1
            Dim Item As HistoryItem = cmbHistory.Items(index)
            If Item.Key = Key Then
                Return Item.DisplayText
            End If
        Next
    End Function


    'haven't decided which key is to be used...
    Public Sub AddItem(ByVal Key As String, ByVal DisplayName As String, Optional ByVal AtEnd As Boolean = False)

        'the new item
        Dim item As New HistoryItem(Key, DisplayName)
        Dim blnIsInList As Boolean = False
        If Key Is Nothing Then Key = ""

        'remove existing item in list
        Dim index As Integer
        Dim RemoveIndex As Integer = -1
        For index = 0 To cmbHistory.Items.Count - 1
            Dim OldItem As HistoryItem = cmbHistory.Items(index)
            If OldItem.Key = Key Then
                blnIsInList = True
                RemoveIndex = index
            End If
        Next
        If RemoveIndex >= 0 And RemoveIndex < cmbHistory.Items.Count Then
            cmbHistory.Items.RemoveAt(RemoveIndex)
        End If
        If DisplayName = "" And Not blnIsInList Then Exit Sub

        If AtEnd = True Then
            cmbHistory.Items.Add(item) 'place at end when loading from db
        Else
            cmbHistory.Items.Insert(0, item) 'at front when adding after select
        End If

        'remove last item if count has got greater than HISTORY_COUNT
        Dim count As Integer = cmbHistory.Items.Count
        If count > HISTORY_COUNT Then 'keep list <= HISTORY_COUNT
            cmbHistory.Items.RemoveAt(count - 1)
        End If

    End Sub

    Private Sub cmbHistory_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles cmbHistory.KeyPress
        If e.KeyChar = Chr(13) And Not BrowseDelegate Is Nothing Then
            BrowseDelegate(Me)
        End If
    End Sub


    Private Sub cmbHistory_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbHistory.SelectedIndexChanged
        ToolTip1.SetToolTip(cmbHistory, cmbHistory.Text)
        Dim item As HistoryItem = cmbHistory.SelectedItem

        If item.DisplayText = "Browse..." AndAlso Not BrowseDelegate Is Nothing Then
            BrowseDelegate(Me)
        Else
            'tell parent from or control a history has being selected
            ComboLabel.Text = item.DisplayText
            RaiseEvent HistorySelectionChangeEvent(Me, item)
        End If
    End Sub


    Private Sub HistoryDropdownControl_Resize(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Resize
        cmbHistory.DropDownWidth = Math.Max(Me.Width, 400)
    End Sub


End Class
