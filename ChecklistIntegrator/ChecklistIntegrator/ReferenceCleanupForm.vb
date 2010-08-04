Imports ChecklistDataAccess
Imports ChecklistObjects
Imports ChecklistBusinessRules

Public Class ReferenceCleanupForm

    Public ParentName As DataRow

    Private Class MergeRef
        Public Ref1 As String
        Public Ref2 As String

        Public Sub New(ByVal ref1 As String, ByVal ref2 As String)
            Me.Ref1 = ref1
            Me.Ref2 = ref2
        End Sub
    End Class

    Private Cancel As Boolean = False
    Private MergedReferences As New ArrayList

    Private Sub ReferenceCleanupForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If ParentName IsNot Nothing Then
            NameText.Text = ParentName("NameFull").ToString
        End If
    End Sub


    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click

    End Sub

    Private Sub GoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GoButton.Click
        Dim mergeAbove As Double = 0
        Dim discardBelow As Double = 0
        Try
            mergeAbove = Double.Parse(AutoThresholdText.Text)
            discardBelow = Double.Parse(DontMergeText.Text)

            If mergeAbove > 100 Or mergeAbove < 1 Then Throw New Exception("error")
            If discardBelow > 100 Or discardBelow < 1 Then Throw New Exception("error")
        Catch ex As Exception
            MsgBox("Threshold values must be valid (1-100)")
            Return
        End Try

        Try
            Dim count As Integer = 0
            Dim dupCount As Integer = 0

            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim ds As DataSet = ReferenceData.GetDuplicateNameReferences(ParentName("NameGuid").ToString, True)
            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                dupCount = ds.Tables(0).Rows.Count

                For index As Integer = 0 To dupCount - 1
                    Dim row As DataRow = ds.Tables(0).Rows(index)

                    If Not HasBeenMerged(row("ReferenceGuid1").ToString, row("ReferenceGuid2").ToString) Then
                        Dim ref1 As DataSet = ReferenceData.GetReferenceDs(row("ReferenceGuid1").ToString)
                        Dim ref2 As DataSet = ReferenceData.GetReferenceDs(row("ReferenceGuid2").ToString)

                        If ref1 IsNot Nothing AndAlso ref1.Tables.Count > 0 AndAlso ref1.Tables(0).Rows.Count > 0 _
                            AndAlso ref2 IsNot Nothing AndAlso ref2.Tables.Count > 0 AndAlso ref2.Tables(0).Rows.Count > 0 Then

                            If MergeReferences(ref1, ref2) Then count += 1
                        End If
                    End If

                    ProgressBar1.Value = (index + 1) * 100 / dupCount

                    If Cancel Then Exit For
                Next
            End If

            Windows.Forms.Cursor.Current = Cursors.Default
            MsgBox(count.ToString + " references merged, of " + dupCount.ToString + " duplicate references")
        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            ChecklistException.LogError(ex)
            MsgBox("Error merging references")
        End Try
    End Sub

    Private Function MergeReferences(ByVal ref1 As DataSet, ByVal ref2 As DataSet) As Boolean
        Dim merged As Boolean = False

        Dim id1 As String = ref1.Tables(0).Rows(0)("ReferenceGuid").ToString
        Dim id2 As String = ref2.Tables(0).Rows(0)("ReferenceGuid").ToString

        Dim refStr1 As String = ref1.Tables(0).Rows(0)("ReferenceCitation").ToString.Trim
        Dim refStr2 As String = ref2.Tables(0).Rows(0)("ReferenceCitation").ToString.Trim

        'remove "in " from start
        If refStr1.StartsWith("in ") Then refStr1 = refStr1.Remove(0, 3)
        If refStr2.StartsWith("in ") Then refStr2 = refStr2.Remove(0, 3)

        'remove punctuation
        refStr1 = refStr1.Replace("(", " ")
        refStr1 = refStr1.Replace(")", " ")
        refStr2 = refStr2.Replace("(", " ")
        refStr2 = refStr2.Replace(")", " ")

        'remove double spaces
        refStr1 = refStr1.Replace("  ", " ")
        refStr2 = refStr2.Replace("  ", " ")

        'remove end comments
        If refStr1.IndexOf(";") <> -1 Then refStr1 = refStr1.Substring(0, refStr1.IndexOf(";"))
        If refStr2.IndexOf(";") <> -1 Then refStr2 = refStr2.Substring(0, refStr2.IndexOf(";"))

        'get separate words
        Dim refWords1 As String() = refStr1.Split(" ")
        Dim refWords2 As String() = refStr2.Split(" ")

        'convert numbers to roman
        For index As Integer = 0 To refWords1.Length - 1
            Dim w As String = refWords1(index)
            If IsNumeric(w) Then
                refWords1(index) = Utility.ConvertToRomanNumerals(w)
            End If
        Next
        For index As Integer = 0 To refWords2.Length - 1
            Dim w As String = refWords2(index)
            If IsNumeric(w) Then
                refWords2(index) = Utility.ConvertToRomanNumerals(w)
            End If
        Next

        'comapre levenshtein
        'compare ref with shortest number of words
        'get equivalent word in other ref, for each word
        Dim minLen As Integer = Math.Min(refWords1.Length, refWords2.Length)
        Dim compWords As ArrayList
        Dim otherWords As ArrayList
        If refWords1.Length = minLen Then
            compWords = New ArrayList(refWords1)
            otherWords = New ArrayList(refWords2)
        Else
            compWords = New ArrayList(refWords2)
            otherWords = New ArrayList(refWords1)
        End If

        Dim pm As Double = Double.Parse(LevenWordPercText.Text)

        Dim matches As Integer = 0
        For Each w As String In compWords

            'find match in other ref words
            'exact first
            Dim found As Boolean = False
            For Each ow As String In otherWords
                If w.ToLower = ow.ToLower Then
                    found = True
                    otherWords.Remove(ow)
                    matches += 1
                    Exit For
                End If
            Next

            'try levenshtein
            If Not found Then
                For Each ow As String In otherWords
                    Dim ld As Double = Utility.LevenshteinPercent(w, ow)
                    If ld >= pm Then
                        found = True
                        otherWords.Remove(ow)
                        matches += 1
                        Exit For
                    End If
                Next
            End If
        Next

        'merge/ask?
        Dim matchPerc As Double = matches * 100 / minLen
        Dim autoMerge As Double = Double.Parse(AutoThresholdText.Text)
        Dim askPerc As Double = Double.Parse(DontMergeText.Text)

        Dim merge As Boolean = (matchPerc >= autoMerge)

        Dim BToA As Boolean = False

        If Not merge AndAlso matchPerc >= askPerc Then
            Dim mf As New MergeSelForm
            mf.ValueA = refStr1
            mf.ValueB = refStr2
            mf.PercentMatch = matchPerc
            mf.ShowDialog()
            If mf.MergeSelection = MergeSelForm.MergeSel.AToB Then
                merge = True
            ElseIf mf.MergeSelection = MergeSelForm.MergeSel.BToA Then
                merge = True
                BToA = True
            ElseIf mf.MergeSelection = MergeSelForm.MergeSel.Cancel Then
                Cancel = True
            End If
        End If

        If merge Then
            If BToA Then
                MergeReferences(id2, id1)
                MergedReferences.Add(New MergeRef(id2, id1))
            Else
                MergeReferences(id1, id2)
                MergedReferences.Add(New MergeRef(id1, id2))
            End If

            merged = True
        End If

            Return merged
    End Function

    Private Function HasBeenMerged(ByVal ref1 As String, ByVal ref2 As String) As Boolean
        Dim hasMerge As Boolean = False

        For Each mr As MergeRef In MergedReferences
            'have these refs been merged together previously?
            If (mr.Ref1 = ref1 And mr.Ref2 = ref2) Or (mr.Ref1 = ref2 And mr.Ref2 = ref1) Then
                hasMerge = True
                Exit For
            End If

            'have either of these refs been merged into another ref (and now no longer exists)
            ' this is true if any Ref1 = the refGuids because all Ref1s are merged into Ref2s, then Ref1s are deleted
            If mr.Ref1 = ref1 Or mr.Ref1 = ref2 Then
                hasMerge = True
                Exit For
            End If
        Next

        Return hasMerge
    End Function

    Private Sub MergeReferences(ByVal refId1 As String, ByVal refId2 As String)
        Try
            Dim refDs As DataSet = ReferenceData.GetReferenceRISByReferenceDs(refId1)
            Dim oldRIS1 As DataRow
            If refDs IsNot Nothing AndAlso refDs.Tables(0).Rows.Count > 0 Then
                oldRIS1 = refDs.Tables(0).Rows(0)
            End If

            refDs = ReferenceData.GetReferenceRISByReferenceDs(refId2)
            Dim oldRIS2 As DataRow
            If refDs IsNot Nothing AndAlso refDs.Tables(0).Rows.Count > 0 Then
                oldRIS2 = refDs.Tables(0).Rows(0)
            End If

            If oldRIS1 IsNot Nothing Or oldRIS2 IsNot Nothing Then

                BrReferences.MergeReferences(refId1, refId2)

                Dim mDs As New DataTable
                mDs.Columns.Add("Field")
                mDs.Columns.Add("OldValue1")
                mDs.Columns.Add("OldValue2")
                mDs.Columns.Add("Value")
                mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                Dim newRef As DataRow = ReferenceData.GetReferenceRISByReferenceDs(refId2).Tables(0).Rows(0)

                Dim tbl As DataTable
                If oldRIS1 IsNot Nothing Then tbl = oldRIS1.Table
                If oldRIS2 IsNot Nothing Then tbl = oldRIS2.Table
                For Each col As DataColumn In tbl.Columns
                    If col.ColumnName <> "RISPk" And col.ColumnName <> "RISReferenceFk" Then
                        Dim val1 As Object = DBNull.Value
                        Dim val2 As Object = DBNull.Value
                        If oldRIS1 IsNot Nothing Then val1 = oldRIS1(col.ColumnName)
                        If oldRIS2 IsNot Nothing Then val2 = oldRIS2(col.ColumnName)
                        mDs.Rows.Add(New Object() {col.ColumnName, val1, val2, newRef(col.ColumnName), Nothing})
                    End If
                Next

                mDs.AcceptChanges()

                Dim mForm As New MergeForm
                mForm.MergeData = mDs
                If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then

                    Dim ch As DataTable = mForm.MergeData.GetChanges()
                    If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                        'insert editor ref?

                        'get system prov ref
                        Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(refId2)

                        If pr Is Nothing Then
                            pr = New ProviderReference
                            pr.PRReferenceId = Guid.NewGuid.ToString
                        End If

                        'get existing system RIS
                        Dim ris As ProviderRIS = ReferenceData.GetProviderRISByReference(pr.Id)
                        If ris Is Nothing Then ris = New ProviderRIS

                        ris.UpdateFieldsFromTable(ch, BrProviderReferences.RISMappings)

                        BrProviderReferences.InsertUpdateSystemProviderReference(refId2, pr, ris)

                    End If
                End If
            Else
                'only ref data
                Dim oldRef1 As DataRow = ReferenceData.GetReferenceDs(refId2).Tables(0).Rows(0)
                Dim oldRef2 As DataRow = ReferenceData.GetReferenceDs(refId1).Tables(0).Rows(0)

                BrReferences.MergeReferences(refId1, refId2)

                Dim mDs As New DataTable
                mDs.Columns.Add("Field")
                mDs.Columns.Add("OldValue1")
                mDs.Columns.Add("OldValue2")
                mDs.Columns.Add("Value")
                mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                Dim newRef As DataRow = ReferenceData.GetReferenceDs(refId2).Tables(0).Rows(0)

                mDs.Rows.Add(New Object() {"ReferenceCitation", oldRef1("ReferenceCitation"), oldRef2("ReferenceCitation"), newRef("ReferenceCitation"), Nothing})
                mDs.Rows.Add(New Object() {"ReferenceFullCitation", oldRef1("ReferenceFullCitation"), oldRef2("ReferenceFullCitation"), newRef("ReferenceFullCitation"), Nothing})

                mDs.AcceptChanges()

                Dim mForm As New MergeForm
                mForm.MergeData = mDs
                If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then

                    Dim ch As DataTable = mForm.MergeData.GetChanges()
                    If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                        'insert editor ref?

                        'get system prov ref
                        Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(refId2)

                        If pr Is Nothing Then
                            pr = New ProviderReference
                            pr.PRReferenceId = Guid.NewGuid.ToString
                        End If

                        For Each r As DataRow In ch.Rows
                            If r("Field").ToString = "ReferenceCitation" Then pr.PRCitation = r("Value").ToString
                            If r("Field").ToString = "ReferenceFullCitation" Then pr.PRFullCitation = r("Value").ToString
                        Next

                        BrProviderReferences.InsertUpdateSystemProviderReference(refId2, pr, Nothing)

                    End If
                End If
            End If
        Catch ex As Exception
            MsgBox("Failed to merge reference")
            ChecklistException.LogError(ex)
        End Try
    End Sub
End Class