Imports ChecklistDataAccess
Imports ChecklistBusinessRules
Imports ChecklistObjects

Imports C1.Win.C1FlexGrid

Imports System.Collections.Specialized

Public Class ProviderReferenceForm

    Public PRPk As Integer = -1
    Private provRef As DataRow
    Private FieldStatusDs As DataSet

    Private Sub ProviderReferenceForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        LoadProviderReference()
    End Sub

    Private Sub LoadProviderReference()
        If PRPk <> -1 Then
            FieldStatusDs = ChecklistDataAccess.FieldStatusData.LoadStatus(PRPk.ToString, "tblProviderRIS")

            Dim ds As DataSet = ReferenceData.GetProviderReferenceDs(PRPk)

            provRef = ds.Tables(0).Rows(0)

            Dim dt As New DataTable
            dt.Columns.Add("Field")
            dt.Columns.Add("Value", GetType(Object))
            dt.Columns.Add("Status", GetType(Integer))

            For Each col As DataColumn In ds.Tables(0).Columns
                Dim sr As DataRow
                If FieldStatusDs IsNot Nothing Then sr = FieldStatusData.GetProviderNameFieldStatus(FieldStatusDs, col.ColumnName)
                Dim stat As Integer = -1
                If sr IsNot Nothing AndAlso Not sr.IsNull("FieldStatusLevelFk") Then stat = sr("FieldStatusLevelFk")

                dt.Rows.Add(New Object() {col.ColumnName, ds.Tables(0).Rows(0)(col.ColumnName), stat})
            Next

            ProviderRefGrid.DataSource = dt

            Dim statStyle As CellStyle = ProviderRefGrid.Styles("StatusStyle")
            If statStyle Is Nothing Then
                statStyle = ProviderRefGrid.Styles.Add("StatusStyle", "Normal")
                Dim sdt As New ListDictionary
                sdt.Add(-1, "")
                For Each s As DataRow In FieldStatusData.AuxFieldStatusData.Tables("tblFieldStatusLevel").Rows
                    sdt.Add(s("FieldStatusLevelCounterPk"), s("FieldStatusLevelText"))
                Next
                statStyle.DataMap = sdt
            End If
            ProviderRefGrid.Cols(2).Style = statStyle

            ProviderRefGrid.Cols(0).Width = 190
            ProviderRefGrid.Cols(1).Width = 300
            ProviderRefGrid.Cols(2).Width = 150
        End If
    End Sub


    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        Try
            If PRPk <> -1 Then
                Dim selForm As New SelectReferenceForm

                If selForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    Try
                        BrProviderReferences.UpdateProviderReferenceLink(New ProviderReference(provRef, PRPk.ToString), selForm.SelectedReferenceId)
                    Catch ex As Exception
                        MsgBox("Failed to relink reference")
                        ChecklistException.LogError(ex)
                    End Try

                    LoadProviderReference()

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor
                End If
            End If

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub
End Class
