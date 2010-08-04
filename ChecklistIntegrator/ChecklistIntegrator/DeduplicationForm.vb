Imports ChecklistDataAccess
Imports ChecklistObjects
Imports ChecklistBusinessRules

Public Class DeduplicationForm

    Public ParentName As DataRow

    Private Sub DeduplicationForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        FieldsList.Items.Add("Full name")
        FieldsList.Items.Add("Canonical name")
        FieldsList.Items.Add("Authors")
        FieldsList.Items.Add("Year")

        FieldsList.SetItemChecked(0, True)
        FieldsList.SetItemChecked(1, True)
        FieldsList.SetItemChecked(2, True)
        FieldsList.SetItemChecked(3, True)

        PercentMatchText.Text = 80
        MatchOptionCombo.SelectedIndex = 0

        If ParentName IsNot Nothing Then
            NameLabel.Text = ParentName("NameFull").ToString

            RecurseCheckbox.Enabled = False
            Try
                Dim sort As Integer = RankData.GetRankSort(ParentName("NameRankFk"))
                If sort > 2999 Then RecurseCheckbox.Enabled = True
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub MatchOptionCombo_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MatchOptionCombo.SelectedIndexChanged
        PercentMatchLabel.Enabled = (MatchOptionCombo.SelectedIndex = 1)
        PercentMatchText.Enabled = (MatchOptionCombo.SelectedIndex = 1)
    End Sub

    Private Sub RunButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunButton.Click
        ProgressBar1.Value = 0

        If MatchOptionCombo.SelectedIndex = 1 Then
            Try
                Dim pm As Double = Double.Parse(PercentMatchText.Text)
                If pm < 1 Or pm > 100 Then Throw New Exception("error")
            Catch ex As Exception
                MsgBox("Percent match value must be valid (1-100)")
                Return
            End Try
        End If

        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Dim errStr As String = ""
        Dim failCount As Integer = 0

        Try

            Dim names As DataSet = NameData.GetChildNames(ParentName("NameGuid").ToString, RecurseCheckbox.Checked)

            Dim cancel As Boolean = False
            Dim count As Integer = names.Tables(0).Rows.Count
            For pos As Integer = 0 To count - 2
                'a check that the names list is still as long as it was at the start
                If pos > count - 2 Then Exit For
                Dim curName As Name

                Try
                    curName = Nothing
                    curName = New Name(names.Tables(0).Rows(pos), names.Tables(0).Rows(pos)("NameGuid").ToString)

                    For compPos As Integer = pos + 1 To count - 1
                        Dim compName As Name = New Name(names.Tables(0).Rows(compPos), names.Tables(0).Rows(compPos)("NameGuid").ToString)
                        'compare
                        Dim same As Boolean = True
                        If curName.NameRankFk <> compName.NameRankFk Then same = False
                        If same AndAlso FieldsList.GetItemChecked(0) Then
                            If Not Compare(curName.NameFull, compName.NameFull) Then same = False
                        End If
                        If same AndAlso FieldsList.GetItemChecked(1) Then
                            If Not Compare(curName.NameCanonical, compName.NameCanonical) Then same = False
                        End If
                        If same AndAlso FieldsList.GetItemChecked(2) Then
                            If Not Compare(curName.NameAuthors, compName.NameAuthors) Then same = False
                        End If
                        If same AndAlso FieldsList.GetItemChecked(3) Then
                            If Not Compare(curName.NameYear, compName.NameYear) Then same = False
                        End If

                        If same Then
                            Windows.Forms.Cursor.Current = Cursors.Default

                            'Dim msf As New MergeSelForm
                            'msf.ValueA = curName.NameFull + " (Rank = " + curName.NameRank + ")"
                            'msf.ValueAId = curName.Id
                            'msf.ValueB = compName.NameFull + " (Rank = " + compName.NameRank + ")"
                            'msf.ValueBId = compName.Id
                            'msf.ShowViewButtons = True
                            'AddHandler msf.ShowDetailsPopup, AddressOf ShowDetails
                            'msf.ShowDialog()

                            'If msf.MergeSelection = MergeSelForm.MergeSel.AToB Then
                            'MergeNames(curName, compName)
                            '    Exit For
                            'ElseIf msf.MergeSelection = MergeSelForm.MergeSel.BToA Then
                            '    MergeNames(compName, curName)
                            '    names.Tables(0).Rows.RemoveAt(compPos)
                            '    pos -= 1
                            '    count = names.Tables(0).Rows.Count
                            '    Exit For
                            'ElseIf msf.MergeSelection = MergeSelForm.MergeSel.Cancel Then
                            '    cancel = True
                            '    Exit For
                            'End If

                            BrNames.MergeNames(compName.Id, curName.Id)

                            Windows.Forms.Cursor.Current = Cursors.WaitCursor
                        End If


                    Next

                    If cancel Then Exit For

                    If pos > 0 Then ProgressBar1.Value = pos * 100 / count

                Catch ex As Exception
                    errStr += "Name failed : "
                    If curName IsNot Nothing Then errStr += curName.NameFull + " : " + curName.Id + Environment.NewLine
                    failCount += 1
                End Try
            Next

            If Not cancel Then
                ProgressBar1.Value = 100
                If errStr.Length = 0 Then MsgBox("Deduplication complete")
            End If

            If errStr.Length > 0 Then
                ChecklistException.LogMessage(errStr)
                MsgBox(failCount.ToString + " names failed" + Environment.NewLine + errStr)
            End If
            Windows.Forms.Cursor.Current = Cursors.Default
        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            MsgBox("Failed to run deduplication")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub ShowDetails(ByVal itemId As String)
        Dim det As New NameDetailsForm
        det.NameData = NameData.GetNameDs(Nothing, itemId).Tables(0)
        det.Show()
    End Sub

    'name2 is the name to keep
    Private Sub MergeNames(ByVal name1 As Name, ByVal name2 As Name)
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        Try
            Dim oldName1 As DataRow = NameData.GetNameDs(Nothing, name1.Id).Tables(0).Rows(0)
            Dim oldName2 As DataRow = NameData.GetNameDs(Nothing, name2.Id).Tables(0).Rows(0)

            BrNames.MergeNames(name2.Id, name1.Id)

            Dim mDs As New DataTable
            mDs.Columns.Add("Field")
            mDs.Columns.Add("OldValue1")
            mDs.Columns.Add("OldValue2")
            mDs.Columns.Add("Value")
            mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

            Dim newName As DataRow = NameData.GetNameDs(Nothing, name2.Id).Tables(0).Rows(0)

            For Each col As DataColumn In oldName1.Table.Columns
                If col.ColumnName <> "NameGuid" And col.ColumnName <> "NameCounter" And col.ColumnName <> "NameParent" And Not col.ColumnName.EndsWith("Fk") Then
                    mDs.Rows.Add(New Object() {col.ColumnName, oldName1(col.ColumnName), oldName2(col.ColumnName), newName(col.ColumnName), Nothing})
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
                    Dim pn As ProviderName = NameData.GetSystemProviderNameForName(name2.Id)

                    If pn Is Nothing Then
                        pn = New ProviderName
                        pn.PNNameId = Guid.NewGuid.ToString
                    End If

                    pn.UpdateFieldsFromTable(ch, BrProviderNames.NameMappings)

                    BrProviderNames.InsertUpdateSystemProviderName(name2.Id, pn)

                End If
            End If
        Catch ex As Exception
            MsgBox("Failed to merge name")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Function Compare(ByVal text1 As String, ByVal text2 As String) As Boolean
        Dim same As Boolean = True

        If text1 Is Nothing And text2 Is Nothing Then Return True
        If text1 Is Nothing And text2 IsNot Nothing Then Return False
        If text1 IsNot Nothing And text2 Is Nothing Then Return False

        If MatchOptionCombo.SelectedIndex = 1 Then
            'levenshtein
            Dim ld As Double = Utility.LevenshteinPercent(text1, text2)
            Dim pm As Double = Double.Parse(PercentMatchText.Text)
            If ld < pm Then same = False
        Else
            same = (text1.ToLower = text2.ToLower)
        End If

        Return same
    End Function

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub



End Class