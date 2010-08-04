Public Class MulitGridControl

    Private _type As MultiGridControlType = MultiGridControlType.TextType

    Public Property Type() As MultiGridControlType
        Get
            Return _type
        End Get
        Set(ByVal value As MultiGridControlType)
            _type = value
            EditCombo.Visible = False
            EditText.Visible = False
            EditCheckBox.Visible = False
            EditDateTimePicker.Visible = False
            If _type = MultiGridControlType.ComboType Then
                EditCombo.Visible = True
                EditCombo.Location = New Point(0, 0)
            ElseIf _type = MultiGridControlType.TextType Then
                EditText.Visible = True
                EditText.Location = New Point(0, 0)
            ElseIf _type = MultiGridControlType.CheckType Then
                EditCheckBox.Visible = True
                EditCheckBox.Location = New Point(0, 0)
            ElseIf _type = MultiGridControlType.DateType Then
                EditDateTimePicker.Visible = True
                EditDateTimePicker.Location = New Point(0, 0)
            End If
        End Set
    End Property

    Public ComboItems As New ArrayList

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        Type = MultiGridControlType.TextType

    End Sub

    'initialize editor
    Public Sub C1EditorInitialize(ByVal value As Object, ByVal editorAttributes As IDictionary)
        Try
            If _type = MultiGridControlType.CheckType Then EditCheckBox.Checked = value
            If _type = MultiGridControlType.ComboType Then
                EditCombo.Items.Clear()
                EditCombo.Items.AddRange(ComboItems.ToArray())
                EditCombo.SelectedItem = value
            End If
            If _type = MultiGridControlType.DateType Then EditDateTimePicker.Value = value
            If _type = MultiGridControlType.TextType Then EditText.Text = value
        Catch ex As Exception
        End Try
    End Sub

    'get editor value
    Public Function C1EditorGetValue() As Object
        If _type = MultiGridControlType.TextType Then Return EditText.Text
        If _type = MultiGridControlType.ComboType Then Return EditCombo.SelectedItem
        If _type = MultiGridControlType.CheckType Then Return EditCheckBox.Checked
        If _type = MultiGridControlType.DateType Then Return EditDateTimePicker.Value
        Return Nothing
    End Function

    ' determine which keys exit edit mode
    Public Function C1EditorKeyDownFinishEdit(ByVal e As KeyEventArgs) As Boolean
        Select Case e.KeyCode
            Case Keys.Enter
            Case Keys.Escape
            Case Keys.Tab
            Case Keys.Up
            Case Keys.Down
            Case Keys.PageUp
            Case Keys.PageDown
                Return True
            Case Keys.Left
            Case Keys.Right
        End Select
        Return False
    End Function

    'show button with ellipsis while not in edit mode
    Public Function C1EditorGetStyle() As System.Drawing.Design.UITypeEditorEditStyle
        Return System.Drawing.Design.UITypeEditorEditStyle.Modal
    End Function

End Class

Public Enum MultiGridControlType
    ComboType
    TextType
    CheckType
    DateType
End Enum

Public Class MultiGridControlValue
    Public Text As String = ""
    Public Value As Object
    Public Type As MultiGridControlType = MultiGridControlType.TextType
End Class
