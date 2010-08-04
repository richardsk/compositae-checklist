Imports ChecklistObjects
Imports ChecklistBusinessRules
Imports ChecklistDataAccess
Imports IntegratorControls

Public Class NameRecordsForm

    Private Sub NameRecordsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AcceptButton = NameRecords1.ListButton
    End Sub

    Private Sub NameRecords1_LinkNames() Handles NameRecords1.LinkNames

        Dim selName As New SelectNameForm
        If selName.ShowDialog = Windows.Forms.DialogResult.OK Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Try
                For Each pnRow As DataRow In NameRecords1.SelectedProviderNames.Tables(0).Rows
                    BrProviderNames.UpdateProviderNameLink(New ProviderName(pnRow, pnRow("PNPk").ToString, True), selName.SelectedNameId)
                Next

            Catch ex As Exception
                MsgBox("Failed to relink names")
                ChecklistException.LogError(ex)
            End Try

            Windows.Forms.Cursor.Current = Cursors.WaitCursor
        End If

    End Sub

    Private Sub NameRecords1_MergeNames() Handles NameRecords1.MergeNames
        Try
            Dim selName As New SelectMergeNameForm
            selName.Names = NameRecords1.SelectedMergeNames

            If selName.ShowDialog = Windows.Forms.DialogResult.OK Then
                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                For Each r As DataRow In NameRecords1.SelectedMergeNames.Tables(0).Rows
                    If selName.SelectedNameGuid <> r("NameGuid").ToString Then
                        BrNames.MergeNames(selName.SelectedNameGuid, r("NameGuid").ToString)
                    End If
                Next

                BrNames.RefreshNameData(selName.SelectedNameGuid, True)

                Windows.Forms.Cursor.Current = Cursors.Default

                'show merge results
                Dim newName As DataRow = NameData.GetNameDs(Nothing, selName.SelectedNameGuid).Tables(0).Rows(0)

                Dim mDs As New DataTable
                mDs.Columns.Add("Field")
                mDs.Columns.Add("OldValue1")
                mDs.Columns.Add("OldValue2")
                mDs.Columns.Add("Value")
                mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                Dim oldName1 As DataRow = selName.Names.Tables(0).Rows(0)
                Dim oldName2 As DataRow = selName.Names.Tables(0).Rows(1)

                For Each col As DataColumn In oldName1.Table.Columns
                    If col.ColumnName <> "NameGuid" And col.ColumnName <> "NameCounter" And Not col.ColumnName.EndsWith("Fk") Then
                        Dim vals As List(Of Object) = Nothing
                        For i As Integer = 2 To selName.Names.Tables(0).Rows.Count - 1
                            If vals Is Nothing Then vals = New List(Of Object)
                            vals.Add(selName.Names.Tables(0).Rows(i)(col.ColumnName))
                        Next
                        mDs.Rows.Add(New Object() {col.ColumnName, oldName1(col.ColumnName), oldName2(col.ColumnName), newName(col.ColumnName), vals})
                    End If
                Next

                mDs.AcceptChanges()

                Dim mForm As New MergeForm
                mForm.MergeData = mDs
                If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                    Dim ch As DataTable = mForm.MergeData.GetChanges()
                    If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                        'insert editor prov name?

                        'get system prov name
                        Dim pn As ProviderName = NameData.GetSystemProviderNameForName(selName.SelectedNameGuid)

                        If pn Is Nothing Then
                            pn = New ProviderName
                            pn.PNNameId = Guid.NewGuid.ToString
                        End If

                        pn.UpdateFieldsFromTable(ch, BrProviderNames.NameMappings)

                        BrProviderNames.InsertUpdateSystemProviderName(selName.SelectedNameGuid, pn)
                    End If
                End If

            End If

        Catch ex As Exception
            MsgBox("Failed to merge names")
            ChecklistException.LogError(ex)
        End Try
    End Sub


    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub
End Class