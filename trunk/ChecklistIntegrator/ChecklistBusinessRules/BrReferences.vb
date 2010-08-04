Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class BrReferences

    ''' <summary>
    ''' Refreshes Reference record data
    ''' Update all Reference data from source ProviderReference records
    ''' </summary>
    ''' <param name="refIdList">ArrayList of ReferenceGuids for References to update</param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshReferenceData(ByVal refIdList As ArrayList)
        For Each rId As String In refIdList
            'refresh Ref data
            ReferenceData.RefreshReferenceData(rId, SessionState.CurrentUser.Login)
        Next
    End Sub

    Public Shared Sub RefreshReferenceData(ByVal refGuid As String)
        ReferenceData.RefreshReferenceData(refGuid, SessionState.CurrentUser.Login)
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="refToMergeGuid"></param>
    ''' <param name="refToKeepGuid"></param>
    ''' <remarks></remarks>
    Public Shared Function MergeReferences(ByVal refToMergeGuid As String, ByVal refToKeepGuid As String) As DataRow
        Dim keepRefRow As DataRow
        Dim cnn As SqlClient.SqlConnection
        Dim trans As SqlClient.SqlTransaction
        Try
            cnn = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString)
            cnn.Open()
            trans = cnn.BeginTransaction()

            'set all provider refs for other ref to this ref
            ReferenceData.RelinkProviderReferences(trans, refToMergeGuid, refToKeepGuid, LinkStatus.Merge.ToString, SessionState.CurrentUser.Login)

            'merge any concepts etc linking to the merged references
            ReferenceData.UpdateMergedReferenceLinks(trans, refToMergeGuid, refToKeepGuid, SessionState.CurrentUser.Login)

            'update any names pointing to old name


            Dim oldRef As DataSet = ReferenceData.GetReferenceDs(refToMergeGuid)
            Dim keepRef As DataSet = ReferenceData.GetReferenceDs(refToKeepGuid)
            keepRefRow = keepRef.Tables(0).Rows(0)

            'delete other ref
            ReferenceData.DeleteReferenceRecord(trans, oldRef.Tables(0).Rows(0)("ReferenceLsid").ToString, keepRef.Tables(0).Rows(0)("ReferenceLsid").ToString, SessionState.CurrentUser.Login)

            trans.Commit()
            trans = Nothing

            'refresh this refs data
            ReferenceData.RefreshReferenceData(refToKeepGuid, SessionState.CurrentUser.Login)

        Catch ex As Exception
            If trans IsNot Nothing Then trans.Rollback()
            Throw New ChecklistException("Failed to merge names : " + ex.Message)
        Finally
            If cnn IsNot Nothing Then cnn.Close()
        End Try

        Return keepRefRow
    End Function
End Class
