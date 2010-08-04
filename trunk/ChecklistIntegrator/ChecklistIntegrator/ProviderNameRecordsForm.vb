Imports ChecklistObjects
Imports ChecklistBusinessRules
Imports ChecklistDataAccess

Public Class ProviderNameRecordsForm

    Public Property SelectMode() As RecordSelectMode
        Get
            Return ProviderNameRecords1.SelectMode
        End Get
        Set(ByVal value As RecordSelectMode)
            ProviderNameRecords1.SelectMode = value
        End Set
    End Property

    Public SelectedRecord As ChecklistObjects.ProviderName
    Public Property ProviderPk() As Integer
        Get
            Return ProviderNameRecords1.ProviderPk
        End Get
        Set(ByVal value As Integer)
            ProviderNameRecords1.ProviderPk = value
        End Set
    End Property

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub ProviderNameRecordsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AcceptButton = ProviderNameRecords1.ListButton
    End Sub


    Private Sub ProviderNameRecords1_IntegrateName(ByVal PNPk As Integer) Handles ProviderNameRecords1.IntegrateName
        Dim row As DataRow = ProviderNameRecords1.SelectedRecord
        If row IsNot Nothing Then
            SelectedRecord = New ChecklistObjects.ProviderName(row, row("PNPk").ToString, True)
            
            'integrate name 
            Dim res As MatchResult = BrProviderNames.MatchAndUpdateProviderName(SelectedRecord)

            row("PNLinkStatus") = res.Status.ToString
            If res.MatchedName IsNot Nothing Then
                row("PNNameFk") = res.MatchedId
                MsgBox("Successfully integrated")
            Else
                MsgBox("Failed to integrate : " + res.Status.ToString)
            End If
        End If
    End Sub

    Private Sub ProviderNameRecords1_LinkName(ByVal PNPk As Integer) Handles ProviderNameRecords1.LinkName
        Dim row As DataRow = ProviderNameRecords1.SelectedRecord
        If row Is Nothing Then
            DialogResult = Windows.Forms.DialogResult.Cancel
        Else
            If row IsNot Nothing Then SelectedRecord = New ChecklistObjects.ProviderName(row, row("PNPk").ToString, True)
            If SelectMode = RecordSelectMode.SelectRecord Then
                DialogResult = Windows.Forms.DialogResult.OK
            Else 'relink name
                'select name to link to 
                Dim selName As New IntegratorControls.SelectNameForm

                If selName.ShowDialog = Windows.Forms.DialogResult.OK Then

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    Try
                        BrProviderNames.UpdateProviderNameLink(SelectedRecord, selName.SelectedNameId)
                    Catch ex As Exception
                        MsgBox("Failed to relink name")
                        ChecklistException.LogError(ex)
                    End Try

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    DialogResult = Windows.Forms.DialogResult.Yes
                End If
            End If
        End If
    End Sub

    Private Sub GotoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GotoButton.Click
        Dim row As DataRow = ProviderNameRecords1.SelectedRecord
        If row IsNot Nothing Then SelectedRecord = New ChecklistObjects.ProviderName(row, row("PNPk").ToString, True)
        If SelectedRecord IsNot Nothing Then DialogResult = Windows.Forms.DialogResult.Yes
    End Sub
End Class