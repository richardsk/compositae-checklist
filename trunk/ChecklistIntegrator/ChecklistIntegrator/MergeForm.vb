Imports System.Collections.Specialized
Imports C1.Win.C1FlexGrid

Public Class MergeForm

    'data must be a table with columns Field, OldValue1, OldValue2, Value, OtherValues
    'OtherValues = list of object of other values for this row/field
    Public MergeData As DataTable

    Private Sub MergeForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        MergeDetailsGrid.DataSource = MergeData

        SetupGrid()

    End Sub

    Private Sub SetupGrid()
        Try
            'setup combo for new value
            For Each r As Row In MergeDetailsGrid.Rows
                If r.Index = 0 Then Continue For
                Dim st As CellStyle = MergeDetailsGrid.Styles.Add(r("Field").ToString, "Normal")
                Dim sdt As New ListDictionary
                sdt.Add(DBNull.Value, "")
                If r("OldValue1").ToString.Length > 0 Then sdt.Add(r("OldValue1"), r("OldValue1"))
                If r("OldValue2").ToString <> r("OldValue1").ToString And r("OldValue2").ToString.Length > 0 Then sdt.Add(r("OldValue2"), r("OldValue2"))
                If r("OtherValues") IsNot Nothing AndAlso r("OtherValues") IsNot DBNull.Value Then
                    Dim ov As List(Of Object) = r("OtherValues")
                    For Each v As Object In ov
                        If Not sdt.Contains(v) Then sdt.Add(v, v)
                    Next
                End If
                st.DataMap = sdt

                MergeDetailsGrid.SetCellStyle(r.Index, 3, st)
            Next

            MergeDetailsGrid.Cols(1).Width = 250
            MergeDetailsGrid.Cols(2).Width = 250
            MergeDetailsGrid.Cols(4).Visible = False
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try

    End Sub

    Private Sub MergeDetailsGrid_BeforeEdit(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles MergeDetailsGrid.BeforeEdit
        If e.Col <> 3 Then e.Cancel = True
    End Sub
End Class