Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class ConceptData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

#Region "Concept"

    'Public Shared Sub RefreshConceptData(ByVal ConceptPk As Integer, ByVal user As String)

    '    Using cnn As New SqlConnection(ConnectionString)
    '        cnn.Open()

    '        Using cmd As SqlCommand = cnn.CreateCommand()
    '            cmd.CommandText = "sprUpdate_ConceptData"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            cmd.Parameters.Add("@ConceptPk", SqlDbType.Int).Value = ConceptPk
    '            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

    '            cmd.ExecuteNonQuery()
    '        End Using

    '        If cnn.State <> ConnectionState.Closed Then cnn.Close()
    '    End Using
    'End Sub

    Public Shared Function GetConceptDs(ByVal conceptPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Concept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@conceptPk", SqlDbType.Int).Value = conceptPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Sub UpdateConcept(ByVal conc As Concept, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_Concept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@cPk", SqlDbType.Int).Value = conc.IdAsInt
                cmd.Parameters.Add("@cLSID", SqlDbType.NVarChar).Value = conc.ConceptLSID
                cmd.Parameters.Add("@cName1", SqlDbType.NVarChar).Value = Utility.GetDBString(conc.ConceptName1)
                cmd.Parameters.Add("@cName1Fk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(conc.ConceptName1Fk)
                cmd.Parameters.Add("@cAccordingTo", SqlDbType.NVarChar).Value = Utility.GetDBString(conc.ConceptAccordingTo)
                cmd.Parameters.Add("@cAccordingToFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(conc.ConceptAccordingToFk)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    'Public Shared Sub UpdateConceptLinks(ByVal nameGuid As String, ByVal user As String)
    '    Using cnn As New SqlConnection(ConnectionString)
    '        cnn.Open()

    '        Using cmd As SqlCommand = cnn.CreateCommand()
    '            cmd.CommandTimeout = Utility.LongSPTimeout
    '            cmd.CommandText = "sprUpdate_ConceptLinks"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            cmd.Parameters.Add("@nameGuid", SqlDbType.NVarChar).Value = nameGuid
    '            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

    '            cmd.ExecuteNonQuery()
    '        End Using

    '        If cnn.State <> ConnectionState.Closed Then cnn.Close()
    '    End Using
    'End Sub

    Public Shared Sub MergeNameConcepts(ByVal trans As SqlTransaction, ByVal name1Guid As String, ByVal name2Guid As String, ByVal user As String)
        Dim cnn As SqlConnection
        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandTimeout = Utility.LongSPTimeout
            If Not trans Is Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprUpdate_MergeNameConcepts"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@name1Guid", SqlDbType.UniqueIdentifier).Value = New Guid(name1Guid)
            cmd.Parameters.Add("@name2Guid", SqlDbType.UniqueIdentifier).Value = New Guid(name2Guid)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

    End Sub

    Public Shared Sub DeleteConcept(ByVal ConceptLSID As String, ByVal NewConceptLSID As String, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_Concept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ConceptLSID", SqlDbType.NVarChar).Value = ConceptLSID
                cmd.Parameters.Add("@NewConceptLSID", SqlDbType.NVarChar).Value = NewConceptLSID
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub


#End Region

#Region "ConceptRelationship"

    Public Shared Function GetRelationshipTypes() As List(Of RelationshipType)
        Dim rels As New List(Of RelationshipType)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_RelationshipTypes"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each r As DataRow In ds.Tables(0).Rows
                        rels.Add(New RelationshipType(r, r("RelationshipTypePk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return rels
    End Function

    'Public Shared Sub RefreshConceptRelationshipData(ByVal conceptRelGuid As String, ByVal user As String)
    '    Dim ds As New DataSet

    '    Using cnn As New SqlConnection(ConnectionString)
    '        cnn.Open()

    '        Using cmd As SqlCommand = cnn.CreateCommand()
    '            cmd.CommandText = "sprUpdate_ConceptRelationshipData"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            cmd.Parameters.Add("@conceptRelationshipGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(conceptRelGuid)
    '            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

    '            cmd.ExecuteNonQuery()
    '        End Using

    '        If cnn.State <> ConnectionState.Closed Then cnn.Close()
    '    End Using
    'End Sub

    Public Shared Function GetNameConceptsDs(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameConcepts"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNameConceptRelationshipRecordsDs(ByVal nameGuid As String, ByVal includeToConcepts As Boolean) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameConceptRelationships"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@incToConcepts", SqlDbType.Bit).Value = includeToConcepts

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetConceptRelationship(ByVal ConceptRelGuid As String) As ConceptRelationship
        Dim cr As ConceptRelationship

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ConceptRelGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(ConceptRelGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    cr = New ConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("ConceptRelationshipGuid"))
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return cr
    End Function

    Public Shared Function GetConceptRelationshipDs(ByVal ConceptRelGuid As String) As DataSet
        Dim cr As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ConceptRelGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(ConceptRelGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(cr)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return cr
    End Function

    Public Shared Function InsertConceptRelationshipFromProviderConceptRelationship(ByVal pcrPk As Integer, ByVal user As String) As ConceptRelationship
        Dim newConc As ConceptRelationship

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = pcrPk
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim p1 As New SqlParameter("@conceptRelGuid", SqlDbType.UniqueIdentifier)
                p1.Direction = ParameterDirection.Output
                cmd.Parameters.Add(p1)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    newConc = New ConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("ConceptRelationshipGuid").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newConc
    End Function

    Public Shared Sub UpdateConceptRelationship(ByVal cr As ConceptRelationship, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@crGuid", SqlDbType.UniqueIdentifier).Value = New Guid(cr.Id)
                cmd.Parameters.Add("@crLSID", SqlDbType.NVarChar).Value = cr.ConceptRelationshipLSID
                cmd.Parameters.Add("@crConcept1Fk", SqlDbType.Int).Value = Utility.GetDBInt(cr.ConceptRelationshipConcept1Fk)
                cmd.Parameters.Add("@crConcept2Fk", SqlDbType.Int).Value = Utility.GetDBInt(cr.ConceptRelationshipConcept2Fk)
                cmd.Parameters.Add("@crRelationship", SqlDbType.NVarChar).Value = Utility.GetDBString(cr.ConceptRelationshipRelationship)
                cmd.Parameters.Add("@crRelationshipFk", SqlDbType.Int).Value = Utility.GetDBInt(cr.ConceptRelationshipRelationshipFk)
                cmd.Parameters.Add("@crHybridOrder", SqlDbType.Int).Value = Utility.GetDBInt(cr.ConceptRelationshipHybridOrder)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = User

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub DeleteConceptRelationship(ByVal ConceptRelLSID As String, ByVal NewConceptRelLSID As String, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ConceptRelLSID", SqlDbType.NVarChar).Value = ConceptRelLSID
                cmd.Parameters.Add("@NewConceptRelLSID", SqlDbType.NVarChar).Value = NewConceptRelLSID
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

#End Region

#Region "Provider Concept"

    Public Shared Function GetConceptMappings() As List(Of ConceptMapping)
        Dim crm As New List(Of ConceptMapping)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConceptMappings"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        crm.Add(New ConceptMapping(row, row("ConceptMappingPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return crm
    End Function

    Public Shared Function GetProviderConcept(ByVal providerPk As Integer, ByVal PCConceptId As String) As ProviderConcept
        Dim pc As ProviderConcept
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@PCConceptId", SqlDbType.NVarChar).Value = PCConceptId

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pc = New ProviderConcept(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pc
    End Function

    Public Shared Function GetProviderConceptRecords(ByVal ConceptPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRecords"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ConceptPk", SqlDbType.Int).Value = ConceptPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderConceptDs(ByVal PCPk As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConcept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = PCPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderConceptData(ByVal PNPk As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderConcept(ByVal PCPk As Integer) As ProviderConcept
        Dim pc As ProviderConcept
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConcept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = PCPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pc = New ProviderConcept(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pc
    End Function

    ''' <summary>
    ''' Gets the parent ProviderName for the specified provider name, if it exists.
    ''' </summary>
    ''' <param name="PNPk"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetParentProviderName(ByVal PNPk As Integer) As ProviderName
        Dim pn As ProviderName
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ParentProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pn = New ProviderName(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PNPk").ToString, True)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pn
    End Function

    Public Shared Sub InsertUpdateProviderConcept(ByVal trans As SqlTransaction, ByVal pc As ProviderConcept, ByVal user As String)
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprInsertUpdate_ProviderConcept"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = pc.IdAsInt
            cmd.Parameters.Add("@PCProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCProviderImportFk)
            cmd.Parameters.Add("@PCLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCLinkStatus)
            cmd.Parameters.Add("@PCMatchScore", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCMatchScore)
            cmd.Parameters.Add("@PCConceptFk", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCConceptFk)
            cmd.Parameters.Add("@PCConceptId", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCConceptId)
            cmd.Parameters.Add("@PCName1", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCName1)
            cmd.Parameters.Add("@PCName1Id", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCName1Id)
            cmd.Parameters.Add("@PCAccordingTo", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCAccordingTo)
            cmd.Parameters.Add("@PCAccordingToId", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCAccordingToId)
            cmd.Parameters.Add("@PCConceptVersion", SqlDbType.NVarChar).Value = Utility.GetDBInt(pc.PCConceptVersion)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim newId As Object = cmd.ExecuteScalar()

            If Not newId Is DBNull.Value AndAlso pc.IdAsInt = -1 Then pc.IdAsInt = newId

            If trans Is Nothing Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub UpdateProviderConceptStatus(ByVal PCPk As Integer, ByVal linkStatus As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ProviderConceptStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCPK", SqlDbType.Int).Value = PCPk
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = linkStatus
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateSystemProviderConcept(ByVal trans As SqlTransaction, ByVal pc As ProviderConcept, ByVal user As String)
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprInsertUpdate_SystemProviderConcept"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = pc.IdAsInt
            cmd.Parameters.Add("@PCProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCProviderImportFk)
            cmd.Parameters.Add("@PCLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCLinkStatus)
            cmd.Parameters.Add("@PCMatchScore", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCMatchScore)
            cmd.Parameters.Add("@PCConceptFk", SqlDbType.Int).Value = Utility.GetDBInt(pc.PCConceptFk)
            cmd.Parameters.Add("@PCConceptId", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCConceptId)
            cmd.Parameters.Add("@PCName1", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCName1)
            cmd.Parameters.Add("@PCName1Id", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCName1Id)
            cmd.Parameters.Add("@PCAccordingTo", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCAccordingTo)
            cmd.Parameters.Add("@PCAccordingToId", SqlDbType.NVarChar).Value = Utility.GetDBString(pc.PCAccordingToId)
            cmd.Parameters.Add("@PCConceptVersion", SqlDbType.NVarChar).Value = Utility.GetDBInt(pc.PCConceptVersion)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim newId As Object = cmd.ExecuteScalar()

            If Not newId Is DBNull.Value AndAlso pc.IdAsInt = -1 Then pc.IdAsInt = newId

            If trans Is Nothing Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetSystemProviderConcept(ByVal importFk As Integer, ByVal name1Guid As String, ByVal accordingToFk As String) As ProviderConcept
        Dim sysPC As ProviderConcept

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_SystemProviderConcept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@sysProvImportFk", SqlDbType.Int).Value = importFk
                cmd.Parameters.Add("@name1Guid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(name1Guid)
                cmd.Parameters.Add("@accToFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(accordingToFk)

                Dim da As New SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    sysPC = New ProviderConcept(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCPk").ToString)
                End If
            End Using

        End Using

        Return sysPC
    End Function



#End Region

#Region "Provider Concept Relationship"

    Public Shared Function GetConceptRelationshipMappings() As List(Of ConceptRelationshipMapping)
        Dim crm As New List(Of ConceptRelationshipMapping)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConceptRelationshipMappings"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        crm.Add(New ConceptRelationshipMapping(row, row("ConceptRelMappingPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return crm
    End Function

    Public Shared Function GetProviderConceptRelationship(ByVal providerPk As Integer, ByVal Concept1Id As String, ByVal Concept2Id As String, ByVal relType As String) As ProviderConceptRelationship
        Dim pcr As ProviderConceptRelationship
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRelationshipById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@Concept1Id", SqlDbType.NVarChar).Value = Concept1Id
                cmd.Parameters.Add("@Concept2Id", SqlDbType.NVarChar).Value = Concept2Id
                cmd.Parameters.Add("@relType", SqlDbType.NVarChar).Value = relType

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pcr = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pcr
    End Function

    Public Shared Function GetProviderConceptRelationshipById(ByVal providerPk As Integer, ByVal pcrId As String) As ProviderConceptRelationship
        Dim pcr As ProviderConceptRelationship
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_PCRById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@pcrId", SqlDbType.NVarChar).Value = pcrId

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pcr = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pcr
    End Function


    Public Shared Function GetProviderConceptRelationshipDs(ByVal PCRPk As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = PCRPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetConflictingProviderConcepts(ByVal nameGuid As String, ByVal nameTo As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConflictingConcepts"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)
                cmd.Parameters.Add("@nameTo", SqlDbType.NVarChar).Value = nameTo

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderConceptRelationship(ByVal PCRPk As Integer) As ProviderConceptRelationship
        Dim pcr As ProviderConceptRelationship
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = PCRPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pcr = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pcr
    End Function

    Public Shared Sub InsertUpdateProviderConceptRelationship(ByVal trans As SqlTransaction, ByVal pcr As ProviderConceptRelationship, ByVal user As String)
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprInsertUpdate_ProviderConceptRelationship"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = pcr.PCRProviderConceptFk
            cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = pcr.IdAsInt
            cmd.Parameters.Add("@PCRProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRProviderImportFk)
            cmd.Parameters.Add("@PCRLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRLinkStatus)
            cmd.Parameters.Add("@PCRMatchScore", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRMatchScore)
            cmd.Parameters.Add("@PCRConceptRelationshipFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(pcr.PCRConceptRelationshipFk)
            cmd.Parameters.Add("@PCRId", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRId)
            cmd.Parameters.Add("@PCRConcept1Id", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRConcept1Id)
            cmd.Parameters.Add("@PCRConcept2Id", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRConcept2Id)
            cmd.Parameters.Add("@PCRRelationship", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRRelationship)
            cmd.Parameters.Add("@PCRRelationshipId", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRRelationshipId)
            cmd.Parameters.Add("@PCRRelationshipFk", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRRelationshipFk)
            cmd.Parameters.Add("@PCRHybridOrder", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRHybridOrder)
            cmd.Parameters.Add("@PCRIsPreferredConcept", SqlDbType.Bit).Value = pcr.PCRIsPreferredConcept
            cmd.Parameters.Add("@PCRVersion", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRVersion)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim newId As Object = cmd.ExecuteScalar()

            If Not newId Is DBNull.Value AndAlso pcr.IdAsInt = -1 Then pcr.IdAsInt = newId

            If trans Is Nothing Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub UpdateProviderConceptRelationshipStatus(ByVal PCRPk As Integer, ByVal linkStatus As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ProviderConceptRelationshipStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPK", SqlDbType.Int).Value = PCRPk
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar).Value = linkStatus
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function InsertUpdateSystemProviderConceptRelationship(ByVal trans As SqlTransaction, ByVal PCPk As Integer, ByVal pcr As ProviderConceptRelationship, ByVal user As String) As ProviderConceptRelationship
        Dim sysPCR As ProviderConceptRelationship
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprInsertUpdate_SystemProviderConceptRelationship"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure

            cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = PCPk
            cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = pcr.IdAsInt
            cmd.Parameters.Add("@PCRProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRProviderImportFk)
            cmd.Parameters.Add("@PCRLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRLinkStatus)
            cmd.Parameters.Add("@PCRMatchScore", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRMatchScore)
            cmd.Parameters.Add("@PCRConceptRelationshipFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(pcr.PCRConceptRelationshipFk)
            cmd.Parameters.Add("@PCRId", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRId)
            cmd.Parameters.Add("@PCRConcept1Id", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRConcept1Id)
            cmd.Parameters.Add("@PCRConcept2Id", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(pcr.PCRConcept2Id)
            cmd.Parameters.Add("@PCRRelationship", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRRelationship)
            cmd.Parameters.Add("@PCRRelationshipId", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRRelationshipId)
            cmd.Parameters.Add("@PCRRelationshipFk", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRRelationshipFk)
            cmd.Parameters.Add("@PCRHybridOrder", SqlDbType.Int).Value = Utility.GetDBInt(pcr.PCRHybridOrder)
            cmd.Parameters.Add("@PCRIsPreferredConcept", SqlDbType.Bit).Value = pcr.PCRIsPreferredConcept
            cmd.Parameters.Add("@PCRVersion", SqlDbType.NVarChar).Value = Utility.GetDBString(pcr.PCRVersion)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim da As New SqlDataAdapter(cmd)
            Dim ds As New DataSet
            da.Fill(ds)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                sysPCR = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk").ToString)
            End If
            If trans Is Nothing Then cnn.Close()

        End Using

        Return sysPCR
    End Function

    Public Shared Function GetSystemProviderConceptRelationship(ByVal importFk As Integer, ByVal concept1Id As String, ByVal concept2Id As String, ByVal relTypeFk As Integer) As ProviderConceptRelationship
        Dim sysPCR As ProviderConceptRelationship

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_SystemProviderConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@sysProvImportFk", SqlDbType.Int).Value = importFk
                cmd.Parameters.Add("@concept1Id", SqlDbType.NVarChar).Value = Utility.GetDBString(concept1Id)
                cmd.Parameters.Add("@concept2Id", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(concept2Id)
                cmd.Parameters.Add("@relTypeFk", SqlDbType.Int).Value = relTypeFk

                Dim da As New SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    sysPCR = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk").ToString)
                End If
            End Using

        End Using

        Return sysPCR
    End Function

    Public Shared Function GetMatchingConceptRelationships(ByVal PCRPk As Integer) As ConceptRelationship()
        Dim conRels As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConceptRelationshipMatches"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPK", SqlDbType.Int).Value = PCRPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        conRels.Add(New ConceptRelationship(row, row("ConceptRelationshipGuid")))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return conRels.ToArray(GetType(ConceptRelationship))
    End Function

    Public Shared Function GetUnlinkedProviderConceptRelationships(ByVal providerPk As Integer) As ProviderConceptRelationship()
        Dim conRels As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedConcepts"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        conRels.Add(New ProviderConceptRelationship(row, row("PCRPk")))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return conRels.ToArray(GetType(ProviderConceptRelationship))
    End Function

    Public Shared Function GetUnlinkedProviderConceptsDs(ByVal providerPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedConcepts"
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

    Public Shared Sub InsertConceptsIntegrationOrder(ByVal providerPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_ConceptsIntegrationOrder"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetNextUnlinkedProviderConceptRelationship(ByVal index As Integer) As ProviderConceptRelationship
        Dim pcr As ProviderConceptRelationship

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NextUnlinkedConceptRelationship"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@index", SqlDbType.Int).Value = index

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pcr = New ProviderConceptRelationship(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PCRPk"))
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pcr
    End Function

    Public Shared Function GetUnlinkedProviderConceptRelationshipsCount(ByVal providerPk As Integer) As Integer
        Dim count As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedConceptsCount"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                count = cmd.ExecuteScalar
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return count
    End Function

    Public Shared Function GetProviderConceptRelationshipRecords(ByVal nameGuid As String, ByVal inclToConcepts As Boolean) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRelationships"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)
                cmd.Parameters.Add("@inclToConcepts", SqlDbType.Bit).Value = inclToConcepts

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetProviderConceptRelationshipsForCR(ByVal CRGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderConceptRelationshipsForCR"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CRGuid", SqlDbType.UniqueIdentifier).Value = New Guid(CRGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

#End Region

End Class
