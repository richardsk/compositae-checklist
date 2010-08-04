Public Class AnnotationResultsForm

    Public Edits As List(Of ChecklistBusinessRules.AnnotationEdit)


    Private Sub AnnotationResultsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        DataGridView1.DataSource = Edits
    End Sub

End Class