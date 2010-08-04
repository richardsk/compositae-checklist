Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class ReferenceSearch

    Public Event ReferenceSelected(ByVal item As ResultItem)

    Public ReadOnly Property SelectedReference() As ResultItem
        Get
            Return ResultsListBox.SelectedItem
        End Get
    End Property

    Public Sub SelectReference(ByVal refGuid As String)
        Try
            Dim ds As DataSet = ReferenceData.GetReferenceDs(refGuid)
            Dim rr As New ResultItem
            rr.Id = refGuid
            rr.Text = ds.Tables(0).Rows(0)("ReferenceCitation").ToString
            ResultsListBox.Items.Clear()
            ResultsListBox.Items.Add(rr)
            ResultsListBox.SelectedIndex = 0
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Try
            If SearchText.Text.Length > 0 Then
                ResultsListBox.Items.Clear()
                Dim ds As DataSet = ChecklistDataAccess.ReferenceData.SearchReferences(SearchText.Text)
                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        Dim citation As String = row("ReferenceCitation").ToString
                        If citation Is Nothing OrElse citation.Length = 0 Then
                            citation = row("ReferenceFullCitation").ToString
                        End If
                        ResultsListBox.Items.Add(New ResultItem(row("ReferenceGuid").ToString, citation))
                    Next
                Else
                    MsgBox("No references found")
                End If
            Else
                Beep()
            End If
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Error : " + ex.Message)
        End Try
        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub ResultsListBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResultsListBox.SelectedIndexChanged
        RaiseEvent ReferenceSelected(ResultsListBox.SelectedItem)
    End Sub

    Private Sub SearchText_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles SearchText.KeyPress
        If e.KeyChar = Chr(13) Then
            SearchButton_Click(Me, EventArgs.Empty)
        End If
    End Sub

    Private Sub ReferenceSearch_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.GotFocus
        SearchText.Focus()
    End Sub
End Class

Public Class ResultItem
    Public Id As String
    Public Text As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal itemId As String, ByVal itemTxt As String)
        Id = itemId
        Text = itemTxt
    End Sub

    Public Overrides Function ToString() As String
        Return Text
    End Function
End Class
