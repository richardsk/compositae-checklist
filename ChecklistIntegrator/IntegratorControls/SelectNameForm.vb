Public Class SelectNameForm
    Public InitialNameId As String
    Public Title As String = "Select Name"
    Public ShowNoneOption As Boolean = False

    Private SelNameId As String

    Public ReadOnly Property SelectedNameId() As String
        Get
            Return SelNameId
        End Get
    End Property

    Public ReadOnly Property SelectedNameText() As String
        Get
            Return NameSelector1.SelectedNodeName
        End Get
    End Property

    Private Sub SelectNameForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If FormSettings.Settings IsNot Nothing Then FormSettings.Settings.SaveFormState(Me)
    End Sub

    Private Sub SelectNameForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        If FormSettings.Settings IsNot Nothing Then FormSettings.Settings.LoadFormState(Me)

        Me.Text = Title

        SetToNoneButton.Visible = ShowNoneOption
        ClrButton.Visible = ShowNoneOption

        If InitialNameId IsNot Nothing AndAlso InitialNameId.Length > 0 Then
            NameSelector1.SelectNode(InitialNameId)
        End If

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        SelNameId = NameSelector1.SelectedUniqueKey
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub ClrButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ClrButton.Click
        SelNameId = Nothing
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub SetToNoneButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SetToNoneButton.Click
        SelNameId = Guid.Empty.ToString
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub
End Class