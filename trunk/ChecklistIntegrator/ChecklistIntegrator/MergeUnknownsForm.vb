Imports ChecklistDataAccess
Imports ChecklistObjects
Imports ChecklistBusinessRules

Public Class MergeUnknownsForm

    Private Enum FieldsToCompare
        None = 0
        FullName = 1
        Canonical = 2
        Authors = 4
        Year = 8
    End Enum

    Private UnknownNames As DataSet

    Private Message As String = ""
    Private Errors As String = ""
    Private Progress As Integer = 0

    Private ExactMatching As Boolean = True
    Private PercentMatch As Double = 100
    Private SelectedFields As FieldsToCompare = FieldsToCompare.None

    Private Cancel As Boolean = False

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

    End Sub

    Private Sub MatchOptionCombo_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MatchOptionCombo.SelectedIndexChanged
        PercentMatchLabel.Enabled = (MatchOptionCombo.SelectedIndex = 1)
        PercentMatchText.Enabled = (MatchOptionCombo.SelectedIndex = 1)
    End Sub

    Private Sub RunButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunButton.Click
        If RunButton.Text = "Run" Then

            MessageText.Text = "Getting names to update..."

            If MatchOptionCombo.SelectedIndex = 1 Then
                ExactMatching = False

                Try
                    PercentMatch = Double.Parse(PercentMatchText.Text)
                    If PercentMatch < 1 Or PercentMatch > 100 Then Throw New Exception("error")
                Catch ex As Exception
                    MsgBox("Percent match value must be valid (1-100)")
                    Return
                End Try
            Else
                ExactMatching = True
            End If

            If FieldsList.GetItemChecked(0) Then
                SelectedFields = SelectedFields Or FieldsToCompare.FullName
            End If
            If FieldsList.GetItemChecked(1) Then
                SelectedFields = SelectedFields Or FieldsToCompare.Canonical
            End If
            If FieldsList.GetItemChecked(2) Then
                SelectedFields = SelectedFields Or FieldsToCompare.Authors
            End If
            If FieldsList.GetItemChecked(3) Then
                SelectedFields = SelectedFields Or FieldsToCompare.Year
            End If


            Dim t As Threading.Thread = Nothing
            t = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.MergeUnknownNames))

            Cancel = False
            ProgressBar1.Value = 0
            RunButton.Text = "Cancel"
            CloseButton.Enabled = False

            t.Start()
        ElseIf RunButton.Text = "Cancel" Then

            Cancel = True
            CloseButton.Enabled = True
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

        End If
    End Sub

    Private Sub MergeUnknownNames()

        UnknownNames = NameData.GetChildNames(NameData.GetUknownTaxaGuid(), False)

        Try

            Dim count As Integer = UnknownNames.Tables(0).Rows.Count
            For pos As Integer = 0 To count - 1
                Dim msg As String = ""
                Try

                Catch ex As Exception

                End Try
                Dim row As DataRow = UnknownNames.Tables(0).Rows(pos)

                Dim matches As DataSet = NameData.GetNamesWithRankAndCanonical(row("NameRankFk"), row("NameCanonical").ToString)

                For Each compName As DataRow In matches.Tables(0).Rows
                    Dim same As Boolean = True
                    If same AndAlso (SelectedFields And FieldsToCompare.FullName = FieldsToCompare.FullName) Then
                        If Not Compare(row("NameFull").ToString, compName("NameFull").ToString) Then same = False
                    End If
                    If same AndAlso (SelectedFields And FieldsToCompare.Canonical = FieldsToCompare.Canonical) Then
                        If Not Compare(row("NameCanonical").ToString, compName("NameCanonical").ToString) Then same = False
                    End If
                    If same AndAlso (SelectedFields And FieldsToCompare.Authors = FieldsToCompare.Authors) Then
                        If Not Compare(row("NameAuthors").ToString, compName("NameAuthors").ToString) Then same = False
                    End If
                    If same AndAlso (SelectedFields And FieldsToCompare.Year = FieldsToCompare.Year) Then
                        If Not Compare(row("NameYear").ToString, compName("NameYear").ToString) Then same = False
                    End If

                    If same Then
                        Windows.Forms.Cursor.Current = Cursors.Default

                        Dim msf As New MergeSelForm
                        msf.ValueA = row("NameFull").ToString + " (Rank = " + row("NameRank").ToString + ")"
                        msf.ValueAId = row("NameGuid").ToString
                        msf.ValueB = compName("NameFull").ToString + " (Rank = " + compName("NameRank").ToString + ")"
                        msf.ValueBId = compName("NameGuid").ToString
                        msf.ShowViewButtons = True
                        AddHandler msf.ShowDetailsPopup, AddressOf ShowDetails
                        msf.ShowDialog()

                        If msf.MergeSelection = MergeSelForm.MergeSel.AToB Or msf.MergeSelection = MergeSelForm.MergeSel.BToA Then
                            MergeNames(compName, row)
                            Exit For
                        ElseIf msf.MergeSelection = MergeSelForm.MergeSel.Cancel Then
                            Cancel = True
                            Exit For
                        End If

                        Windows.Forms.Cursor.Current = Cursors.WaitCursor
                    End If
                Next

                If pos > 0 Then Progress = pos * 100 / count
                StatusHandler(pos * 100 / count, msg)

                If Cancel Then Exit For

            Next

            If Cancel Then
                StatusHandler(Progress, "Cancelled.")
            Else
                Progress = 100
                StatusHandler(Progress, "")
            End If

            Windows.Forms.Cursor.Current = Cursors.Default
        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            MsgBox("Failed to run merging")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Public Sub StatusHandler(ByVal perc As Integer, ByVal msg As String)
        Progress = perc

        If msg.StartsWith("ERROR") Then
            Errors += msg + Environment.NewLine
        Else
            Message = msg
        End If

        Dim mi As New MethodInvoker(AddressOf UpdateStatus)
        Me.Invoke(mi)
    End Sub

    Public Sub UpdateStatus()
        ProgressBar1.Value = Progress

        Dim msg As String = ""
        If Message.Length > 0 Then msg = Message + Environment.NewLine
        If Errors.Length > 0 Then msg += Errors + Environment.NewLine

        If Progress = 100 Then
            RunButton.Text = "Run"
            CloseButton.Enabled = True
            msg += "Done."
        End If

        If Cancel Then
            CloseButton.Enabled = True
            RunButton.Text = "Run"
        End If

        If msg = "" Then msg = "Finding next match..."

        MessageText.Text = msg
    End Sub

    Private Sub ShowDetails(ByVal itemId As String)
        Dim det As New NameDetailsForm
        det.NameData = NameData.GetNameDs(Nothing, itemId).Tables(0)
        det.Show()
    End Sub

    'name2 is the name to keep
    Private Sub MergeNames(ByVal name1 As DataRow, ByVal name2 As DataRow)
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        Try
            BrNames.MergeNames(name2("NameGuid").ToString, name1("NameGuid").ToString)

            Dim mDs As New DataTable
            mDs.Columns.Add("Field")
            mDs.Columns.Add("OldValue1")
            mDs.Columns.Add("OldValue2")
            mDs.Columns.Add("Value")
            mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

            Dim newName As DataRow = NameData.GetNameDs(Nothing, name2("NameGuid").ToString).Tables(0).Rows(0)

            For Each col As DataColumn In name1.Table.Columns
                If col.ColumnName <> "NameGuid" And col.ColumnName <> "NameCounter" And col.ColumnName <> "NameParent" And Not col.ColumnName.EndsWith("Fk") Then
                    mDs.Rows.Add(New Object() {col.ColumnName, name1(col.ColumnName), name2(col.ColumnName), newName(col.ColumnName), Nothing})
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
                    Dim pn As ProviderName = NameData.GetSystemProviderNameForName(name2("NameGuid").ToString)

                    If pn Is Nothing Then
                        pn = New ProviderName
                        pn.PNNameId = Guid.NewGuid.ToString
                    End If

                    pn.UpdateFieldsFromTable(ch, BrProviderNames.NameMappings)

                    BrProviderNames.InsertUpdateSystemProviderName(name2("NameGuid").ToString, pn)

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

        If ExactMatching Then
            same = (text1.ToLower = text2.ToLower)
        Else
            'levenshtein
            Dim ld As Double = Utility.LevenshteinPercent(text1, text2)
            If ld < PercentMatch Then same = False
        End If

        Return same
    End Function

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub



End Class