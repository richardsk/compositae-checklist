Imports ChecklistBusinessRules
Imports ChecklistObjects

Public Class ImportAuthorsForm

    Public ImportMDBFilename As String
    Private PercComplete As Integer = 0
    Private Failed As Boolean = False

    Private Sub ImportAuthorsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            If ImportMDBFilename IsNot Nothing Then
                BrAuthors.ImportStatusCallback = New BrAuthors.ImportStatusDelegate(AddressOf Me.Status)

                Dim t As New System.Threading.Thread(AddressOf Me.DoImport)
                t.Start()
            End If
        Catch ex As Exception
            BrAuthors.ImportStatusCallback = Nothing
            ChecklistException.LogError(ex)
            MsgBox("Failed to import authors")
            DialogResult = Windows.Forms.DialogResult.Cancel
        End Try
    End Sub

    Public Sub DoImport()
        Try
            BrAuthors.ImportAuthors(ImportMDBFilename)
        Catch ex As Exception
            ChecklistException.LogError(ex)
            'close
            Failed = True
            PercComplete = 100
            Dim mi As New MethodInvoker(AddressOf UpdateProgress)
            Me.Invoke(mi)
        End Try
    End Sub

    Public Sub UpdateProgress()
        ProgressBar1.Value = PercComplete
        If PercComplete = 100 Then
            BrAuthors.ImportStatusCallback = Nothing
            If Not Failed Then
                MsgBox("Import Complete")
                DialogResult = Windows.Forms.DialogResult.OK
            Else
                MsgBox("Failed to import authors")
                DialogResult = Windows.Forms.DialogResult.Cancel
            End If
        End If
    End Sub

    Public Sub Status(ByVal percentComplete As Integer)
        PercComplete = percentComplete
        Dim mi As New MethodInvoker(AddressOf UpdateProgress)
        Me.Invoke(mi)
    End Sub
End Class