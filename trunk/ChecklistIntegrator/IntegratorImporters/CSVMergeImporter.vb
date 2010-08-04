'imports sets of IDs to merge, for deduplication

Public Class CSVMergeImporter

    Public Delegate Sub StatusDelegate(ByVal percComplete As Integer, ByVal msg As String)

    Public StatusCallback As StatusDelegate
    Public Success As Boolean = False
    Public Cancel As Boolean = False
    Public Filename As String = ""

    Protected PercentComplete As Integer '0 to 100

    Public ReadOnly Property Complete() As Boolean
        Get
            Return (PercentComplete = 100)
        End Get
    End Property

    Protected Sub PostStatusMessage(ByVal percComplete As Integer, ByVal msg As String)
        If Not StatusCallback Is Nothing Then
            StatusCallback.Invoke(percComplete, msg)
        End If
    End Sub

    Public Sub StartImport()
        ImportMergeFile(Filename)
    End Sub


    'merge file has following format
    ' [merge id] NameGUID
    ' if [merge id]s are the same then those names are merged
    ' eg
    ' 1,123456
    ' 1,34566
    ' 2,543332
    ' 2,87888
    ' 2,77744
    ' 3,63534
    ' - where the first two names are merged, and the next 3 names are merged

    Public Function ImportMergeFile(ByVal file As String) As Boolean
        Dim ok As Boolean = True
        Try
            Dim lines As String() = IO.File.ReadAllLines(file)

            Dim cnt As Integer = lines.Length
            Dim pos As Integer = 0

            Dim mergeId As String = ""
            Dim nameToKeeepId As String = ""
            Dim namesToMerge As New List(Of String)

            For Each line As String In lines
                Dim parts As String() = line.Split(",")

                If mergeId = "" Then
                    mergeId = parts(0)
                    nameToKeeepId = parts(1)
                    namesToMerge.Add(parts(1))
                ElseIf mergeId <> parts(0) Then
                    DoMerge(namesToMerge, nameToKeeepId)
                    namesToMerge.Clear()

                    mergeId = parts(0)
                    nameToKeeepId = parts(1)
                    namesToMerge.Add(parts(1))
                Else
                    namesToMerge.Add(parts(1))
                End If

                pos += 1
                PercentComplete = 100 * pos / cnt
                If PercentComplete > 99 Then PercentComplete = 99
                StatusCallback(PercentComplete, "")

                If Cancel Then Exit For
            Next

            If namesToMerge.Count > 0 Then DoMerge(namesToMerge, nameToKeeepId)

            Success = True
            PercentComplete = 100
            StatusCallback(PercentComplete, "Complete")

        Catch ex As Exception
            ok = False
            ChecklistObjects.ChecklistException.LogError(ex)
            PercentComplete = 100
            StatusCallback(PercentComplete, "Failed")

        End Try

        Return ok
    End Function

    Private Sub DoMerge(ByVal names As List(Of String), ByVal nameToKeep As String)
        For Each id As String In names
            Try
                If id <> nameToKeep Then ChecklistBusinessRules.BrNames.MergeNames(nameToKeep, id)

            Catch ex As Exception
                StatusCallback(PercentComplete, "Failed to merge name " + id + " : " + ex.Message)
            End Try
        Next
    End Sub

End Class
