Imports ChecklistObjects
Imports ChecklistBusinessRules

Public Class ProviderRefRecordsForm

    Public Property SelectMode() As RecordSelectMode
        Get
            Return ProviderRefRecords1.SelectMode
        End Get
        Set(ByVal value As RecordSelectMode)
            ProviderRefRecords1.SelectMode = value
        End Set
    End Property

    Public SelectedRecord As ChecklistObjects.ProviderReference

    Public Property ProviderPk() As Integer
        Get
            Return ProviderRefRecords1.ProviderPk
        End Get
        Set(ByVal value As Integer)
            ProviderRefRecords1.ProviderPk = value
        End Set
    End Property

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub ProviderNameRecordsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AcceptButton = ProviderRefRecords1.ListButton
    End Sub

    Private Sub ProviderRefRecords1_LinkReference(ByVal PRPk As Integer) Handles ProviderRefRecords1.LinkReference
        Dim row As DataRow = ProviderRefRecords1.SelectedRecord
        If row Is Nothing Then
            DialogResult = Windows.Forms.DialogResult.Cancel
        Else
            If row IsNot Nothing Then SelectedRecord = New ChecklistObjects.ProviderReference(row, row("PRPk").ToString)

            If SelectMode = RecordSelectMode.SelectRecord Then
                DialogResult = Windows.Forms.DialogResult.OK
            Else
                'relink ref
                'select reference to link to 
                Dim selRef As New SelectReferenceForm

                If selRef.ShowDialog = Windows.Forms.DialogResult.OK Then

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    Try
                        BrProviderReferences.UpdateProviderReferenceLink(SelectedRecord, selRef.SelectedReferenceId)
                    Catch ex As Exception
                        MsgBox("Failed to relink reference")
                        ChecklistException.LogError(ex)
                    End Try

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    DialogResult = Windows.Forms.DialogResult.Yes
                End If
            End If
        End If
    End Sub

    Private Sub GotoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GotoButton.Click
        Dim row As DataRow = ProviderRefRecords1.SelectedRecord
        If row IsNot Nothing Then SelectedRecord = New ChecklistObjects.ProviderReference(row, row("PRPk").ToString)
        If SelectedRecord IsNot Nothing Then DialogResult = Windows.Forms.DialogResult.Yes
    End Sub
End Class