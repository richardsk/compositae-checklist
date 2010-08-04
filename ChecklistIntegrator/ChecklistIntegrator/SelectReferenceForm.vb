Public Class SelectReferenceForm

    Public Title As String = "Select Reference"
    Public ShowNoneOption As Boolean = False

    Private SelReferenceId As String

    Public ReadOnly Property SelectedReferenceId() As String
        Get
            Return SelReferenceId
        End Get
    End Property

    Public ReadOnly Property SelectedReferenceText() As String
        Get
            If ReferenceSearch1.SelectedReference Is Nothing Then Return Nothing
            Return ReferenceSearch1.SelectedReference.Text
        End Get
    End Property

    Private Sub SelectReferenceForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Me.Text = Title

        SetToNoneButton.Visible = ShowNoneOption
        ClrButton.Visible = ShowNoneOption

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        If ReferenceSearch1.SelectedReference IsNot Nothing Then
            SelReferenceId = ReferenceSearch1.SelectedReference.Id
            DialogResult = Windows.Forms.DialogResult.OK
        End If
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub ClrButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClrButton.Click
        SelReferenceId = Nothing
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub SetToNoneButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SetToNoneButton.Click
        SelReferenceId = Guid.Empty.ToString
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

End Class