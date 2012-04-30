Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class ReferenceData
    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

#Region "References"
    Public Shared Function GetReferenceDs(ByVal referenceGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_Reference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = New Guid(referenceGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function SearchReferences(ByVal searchTxt As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSearch_References"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@searchTxt", SqlDbType.NVarChar).Value = searchTxt

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetMatchingReferencesDs(ByVal PRPk As Integer, ByVal matchRuleSet As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ReferenceMatches"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerReferencePk", SqlDbType.Int).Value = Utility.GetDBInt(PRPk)
                cmd.Parameters.Add("@matchRuleSet", SqlDbType.Int).Value = Utility.GetDBInt(matchRuleSet)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetMatchingReferences(ByVal PRPk As Integer, ByVal matchRuleSet As Integer) As Reference()
        Dim refs As New ArrayList

        Dim ds As DataSet = GetMatchingReferencesDs(PRPk, matchRuleSet)

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            For Each row As DataRow In ds.Tables(0).Rows
                refs.Add(New Reference(row, row("ReferenceGuid")))
            Next
        End If

        Return refs.ToArray(GetType(Reference))
    End Function

    Public Shared Sub InsertReferenceRecord(ByVal cmd As SqlCommand, ByVal newRef As Reference, ByVal user As String)
        If newRef.Id.Length = 0 Then newRef.Id = Guid.NewGuid.ToString

        cmd.Parameters.Add("@ReferenceGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newRef.Id)
        cmd.Parameters.Add("@ReferenceLSID", SqlDbType.NVarChar).Value = Utility.GetDBString(newRef.ReferenceLSID)
        cmd.Parameters.Add("@ReferenceCitation", SqlDbType.NVarChar).Value = Utility.GetDBString(newRef.ReferenceCitation)
        cmd.Parameters.Add("@ReferenceFullCitation", SqlDbType.NText).Value = Utility.GetDBString(newRef.ReferenceFullCitation)
        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

        cmd.ExecuteNonQuery()
    End Sub


    Public Shared Function InsertReferenceFromProviderReference(ByVal provRef As ProviderReference, ByVal user As String) As Reference
        Dim newRef As Reference = Reference.FromProviderReference(provRef)

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            'create name
            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_Reference"
                cmd.CommandType = CommandType.StoredProcedure

                InsertReferenceRecord(cmd, newRef, user)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newRef
    End Function

    Public Shared Sub RefreshReferenceData(ByVal refGuid As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprUpdate_ReferenceData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@refGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub UpdateMergedReferenceLinks(ByVal trans As SqlTransaction, ByVal refGuid As String, ByVal newRefGuid As String, ByVal user As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand()
            cmd.CommandText = "sprUpdate_MergedReferenceLinks"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newRefGuid)
            cmd.Parameters.Add("@mergedReferenceGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteReferenceRecord(ByVal trans As SqlTransaction, ByVal refLsid As String, ByVal newRefLsid As String, ByVal user As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand()
            cmd.CommandText = "sprDelete_Reference"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@refLsid", SqlDbType.NVarChar).Value = refLsid
            cmd.Parameters.Add("@newRefLsid", SqlDbType.NVarChar).Value = newRefLsid
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Function GetReferenceLSIDs(ByVal pageNumber As Integer, ByVal pageSize As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_ReferenceLSIDs"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber
                cmd.Parameters.Add("@pageSize", SqlDbType.Int).Value = pageSize

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetDuplicateNameReferences(ByVal parentNameGuid As String, ByVal recurseChildren As Boolean) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_DuplicateNameReferences"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@parentNameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(parentNameGuid)
                cmd.Parameters.Add("@recurseChildren", SqlDbType.Bit).Value = recurseChildren

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetReferencesForName(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_ReferencesForName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function



#End Region

#Region "ReferenceRIS"

    Public Shared Function GetReferenceRISByReference(ByVal refGuid As String) As ReferenceRIS
        Dim ris As ReferenceRIS
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_RISByReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@refGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    ris = New ReferenceRIS(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("RISPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

    Public Shared Function GetReferenceRISByReferenceDs(ByVal refGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_RISByReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@refGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetRISMappings() As List(Of RISMapping)
        Dim ris As New List(Of RISMapping)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_RISMappings"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        ris.Add(New RISMapping(row, row("RISMappingPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

#End Region

#Region "Provider References"

    Public Shared Function GetProviderReference(ByVal PRPk As Integer) As ProviderReference
        Dim pr As ProviderReference

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = PRPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pr = New ProviderReference(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pr
    End Function

    Public Shared Function GetProviderReferenceDs(ByVal PRPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = PRPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetProviderReference(ByVal providerPk As Integer, ByVal PRRefId As String) As ProviderReference
        Dim ref As ProviderReference

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderReferenceById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@PRReferenceId", SqlDbType.NVarChar).Value = PRRefId

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    ref = New ProviderReference(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ref
    End Function

    Public Shared Function GetProviderReferenceDs(ByVal providerPk As Integer, ByVal PRRefId As String) As DataSet
        Dim ref As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderReferenceById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@PRReferenceId", SqlDbType.NVarChar).Value = PRRefId

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ref)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ref
    End Function

    Public Shared Function GetProviderReferenceRecords(ByVal referenceGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_ProviderReferences"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = New Guid(referenceGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        
        Return ds
    End Function

    Public Shared Sub DeleteProviderReferenceRecord(ByVal providerPk As Integer, ByVal providerReferenceId As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprDelete_ProviderReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.NVarChar).Value = providerPk
                cmd.Parameters.Add("@providerReferenceId", SqlDbType.NVarChar).Value = providerReferenceId

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub

    Public Shared Sub DeleteProviderReferenceRecord(ByVal trans As SqlTransaction, ByVal providerPk As Integer, ByVal providerReferenceId As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand
            cmd.CommandText = "sprDelete_ProviderReference"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@providerPk", SqlDbType.NVarChar).Value = providerPk
            cmd.Parameters.Add("@providerReferenceId", SqlDbType.NVarChar).Value = providerReferenceId

            cmd.ExecuteNonQuery()
        End Using

    End Sub

    Private Shared Sub InsertProviderReferenceRecord(ByVal cmd As SqlCommand, ByVal providerRef As ProviderReference, ByVal user As String)
        cmd.CommandText = "sprInsertUpdate_ProviderReference"
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = providerRef.IdAsInt
        cmd.Parameters.Add("@PRProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(providerRef.PRProviderImportFk)
        cmd.Parameters.Add("@PRReferenceId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerRef.PRReferenceId)
        cmd.Parameters.Add("@PRReferenceFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerRef.PRReferenceFk)
        cmd.Parameters.Add("@PRLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(providerRef.PRLinkStatus)
        cmd.Parameters.Add("@PRCitation", SqlDbType.NVarChar).Value = Utility.GetDBString(providerRef.PRCitation)
        cmd.Parameters.Add("@PRFullCitation", SqlDbType.NText).Value = Utility.GetDBString(providerRef.PRFullCitation)
        cmd.Parameters.Add("@PRXML", SqlDbType.NText).Value = Utility.GetDBString(providerRef.PRXML)
        cmd.Parameters.Add("@PRReferenceVersion", SqlDbType.NVarChar).Value = Utility.GetDBString(providerRef.PRReferenceVersion)
        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

        Dim newId As Object = cmd.ExecuteScalar()

        If Not newId Is DBNull.Value AndAlso providerRef.IdAsInt = -1 Then providerRef.IdAsInt = newId
    End Sub

    Public Shared Sub InsertUpdateProviderReferenceRecord(ByVal providerRef As ProviderReference, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                InsertProviderReferenceRecord(cmd, providerRef, user)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub

    Public Shared Sub InsertProviderReferenceRecord(ByVal trans As SqlTransaction, ByVal providerRef As ProviderReference, ByVal user As String)
        Dim cnn As New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand
            cmd.Transaction = trans
            InsertProviderReferenceRecord(cmd, providerRef, user)
        End Using

        If trans Is Nothing Then cnn.Close()
    End Sub

    Public Shared Function GetUnlinkedProviderReferencesDs(ByVal providerPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedReferences"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetUnlinkedProviderReferences(ByVal providerPk As Integer) As ChecklistObjects.ProviderReference()
        Dim refs As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedReferences"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        refs.Add(New ProviderReference(row, row("PRPk")))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return refs.ToArray(GetType(ProviderReference))
    End Function

    Public Shared Sub InsertReferencesIntegrationOrder(ByVal providerPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_ReferencesIntegrationOrder"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetNextUnlinkedProviderReference(ByVal index As Integer) As ChecklistObjects.ProviderReference
        Dim pr As ProviderReference

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NextUnlinkedReference"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@index", SqlDbType.Int).Value = index

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pr = New ProviderReference(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRPk"))
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pr
    End Function

    Public Shared Function GetUnlinkedProviderReferencesCount(ByVal providerPk As Integer) As Integer
        Dim count As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedReferencesCount"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                count = cmd.ExecuteScalar
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return count
    End Function

    Public Shared Function GetSystemProviderRefForRef(ByVal RefGuid As String) As ProviderReference
        Dim pr As ProviderReference
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_SystemProviderRefForRef"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@refGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(RefGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pr = New ProviderReference(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pr
    End Function

    Public Shared Function ListProviderReferenceRecords(ByVal providerPk As Integer, ByVal linkType As LinkType, ByVal filterText As String, ByVal maxRecords As Integer) As DataSet
        Dim recs As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_SearchProviderRefs"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)
                cmd.Parameters.Add("@linkType", SqlDbType.NVarChar).Value = Utility.GetDBString(linkType.ToString)
                cmd.Parameters.Add("@filterText", SqlDbType.NVarChar).Value = Utility.GetDBString(filterText)
                cmd.Parameters.Add("@maxRecords", SqlDbType.Int).Value = Utility.GetDBInt(maxRecords)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(recs)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return recs
    End Function

#End Region

#Region "Provider RIS"

    Public Shared Function GetProviderRIS(ByVal PRISID As String) As ProviderRIS
        Dim ris As ProviderRIS

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderRISByReferenceId"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ReferenceId", SqlDbType.NVarChar).Value = PRISID

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    ris = New ProviderRIS(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRISPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

    Public Shared Function GetProviderRISByReference(ByVal PRPk As String) As ProviderRIS
        Dim ris As ProviderRIS

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderRISByReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.NVarChar).Value = PRPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    ris = New ProviderRIS(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PRISPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

    Public Shared Function GetProviderRISByReferenceDs(ByVal PRPk As String) As DataSet
        Dim ris As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderRISByReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.NVarChar).Value = PRPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ris)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

    Public Shared Function GetProviderRISByReferenceGuidDs(ByVal refGuid As String) As DataSet
        Dim ris As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderRISByReferenceGuid"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ris)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ris
    End Function

    Public Shared Sub InsertUpdateProviderRISRecord(ByVal trans As SqlTransaction, ByVal refId As String, ByVal pris As ProviderRIS, ByVal user As String)
        Dim cnn As New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprInsertUpdate_ProviderRIS"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PRISPk", SqlDbType.Int).Value = pris.IdAsInt
            cmd.Parameters.Add("@PRISProviderReferenceFK", SqlDbType.Int).Value = Utility.GetDBInt(pris.PRISProviderReferencefk)
            cmd.Parameters.Add("@PRISRISFk", SqlDbType.Int).Value = Utility.GetDBInt(pris.PRISRISFk)
            cmd.Parameters.Add("@PRISId", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISId)
            cmd.Parameters.Add("@PRISType", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISType)
            cmd.Parameters.Add("@PRISAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISAuthors)
            cmd.Parameters.Add("@PRISTitle", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISTitle)
            cmd.Parameters.Add("@PRISDate", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISDate)
            cmd.Parameters.Add("@PRISNotes", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISNotes)
            cmd.Parameters.Add("@PRISKeywords", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISKeywords)
            cmd.Parameters.Add("@PRISStartPage", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISStartPage)
            cmd.Parameters.Add("@PRISEndPage", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISEndPage)
            cmd.Parameters.Add("@PRISJournalName", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISJournalName)
            cmd.Parameters.Add("@PRISStandardAbbreviation", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISStandardAbbreviation)
            cmd.Parameters.Add("@PRISVolume", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISVolume)
            cmd.Parameters.Add("@PRISIssue", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISIssue)
            cmd.Parameters.Add("@PRISCityOfPublication", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISCityOfPublication)
            cmd.Parameters.Add("@PRISPublisher", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISPublisher)
            cmd.Parameters.Add("@PRISISSNNumber", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISISSNNumber)
            cmd.Parameters.Add("@PRISWebUrl", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISWebUrl)
            cmd.Parameters.Add("@PRISTitle2", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISTitle2)
            cmd.Parameters.Add("@PRISTitle3", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISTitle3)
            cmd.Parameters.Add("@PRISAuthors2", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISAuthors2)
            cmd.Parameters.Add("@PRISAuthors3", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pris.PRISAuthors3)
            cmd.Parameters.Add("@RefId", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(refId)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = Utility.GetDBString(user)

            Dim newId As Object = cmd.ExecuteScalar()

            If Not newId Is DBNull.Value AndAlso pris.IdAsInt = -1 Then pris.IdAsInt = newId
        End Using

        If trans Is Nothing Then cnn.Close()

    End Sub

    Public Shared Function InsertRISRecord(ByVal refGuid As String, ByVal provRIS As ProviderRIS, ByVal user As String) As Integer
        Dim newId As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_ReferenceRIS"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(refGuid)
                cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = Utility.GetDBInt(provRIS.PRISProviderReferencefk)
                cmd.Parameters.Add("@PRISPk", SqlDbType.Int).Value = Utility.GetDBInt(provRIS.IdAsInt)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = Utility.GetDBString(user)

                Dim id As Object = cmd.ExecuteScalar()
                If id IsNot DBNull.Value Then newId = id
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newId
    End Function

    Public Shared Sub DeleteSystemProviderRISRecord(ByVal providerReferenceFk As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprDelete_SystemProviderRIS"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerReferenceFk", SqlDbType.Int).Value = providerReferenceFk

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub


    Public Shared Sub RelinkProviderReferences(ByVal trans As SqlTransaction, ByVal fromRefGuid As String, ByVal toRefGuid As String, ByVal linkStatus As String, ByVal user As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand()
            cmd.Transaction = trans
            cmd.CommandText = "sprUpdate_LinkedProviderReferences"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@fromRefGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(fromRefGuid)
            cmd.Parameters.Add("@toRefGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(toRefGuid)
            cmd.Parameters.Add("@linkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(linkStatus)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            cmd.ExecuteNonQuery()
        End Using

    End Sub

    Public Shared Function ListRISTypes() As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.CommandText = "sprSelect_RISTypes"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Connection = cnn

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using
        End Using

        Return ds
    End Function

#End Region

End Class
