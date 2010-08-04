Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class ProviderData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

#Region "Provider"
    Public Shared Function GetProvider(ByVal providerPk As Integer) As Provider
        Dim prov As Provider

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Provider"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    Dim row As DataRow = ds.Tables(0).Rows(0)
                    prov = New Provider(row)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return prov
    End Function

    Public Shared Function GetProviders() As Provider()
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Providers"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        ps.Add(New Provider(row))
                    Next
                End If

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ps.ToArray(GetType(Provider))
    End Function

    Public Shared Function GetProvidersDs() As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Providers"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Sub DeleteProvider(ByVal providerPk As Integer)
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_Provider"
                cmd.Connection = cnn
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProvider(ByVal prov As Provider, ByVal user As String)
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_Provider"
                cmd.Connection = cnn
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@providerId", SqlDbType.Int).Value = prov.IdAsInt
                cmd.Parameters.Add("@providerName", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.Name)
                cmd.Parameters.Add("@providerHomeUrl", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ProjectUrl)
                cmd.Parameters.Add("@providerProjectUrl", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ProjectUrl)
                cmd.Parameters.Add("@providerContactName", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ContactName)
                cmd.Parameters.Add("@providerContactPhone", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ContactPhone)
                cmd.Parameters.Add("@providerContactEmail", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ContactEmail)
                cmd.Parameters.Add("@providerContactAddress", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.ContactAddress)
                cmd.Parameters.Add("@providerNameFull", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.FullName)
                cmd.Parameters.Add("@providerStatement", SqlDbType.NVarChar).Value = Utility.GetDBString(prov.Statement)
                cmd.Parameters.Add("@providerIsEditor", SqlDbType.Bit).Value = prov.IsEditor
                cmd.Parameters.Add("@providerUseForParentage", SqlDbType.Bit).Value = prov.UseForParentage
                cmd.Parameters.Add("@providerPrefConceptRanking", SqlDbType.Int).Value = Utility.GetDBInt(prov.PreferredConceptRanking)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim newId As Object = cmd.ExecuteScalar()

                If Not newId Is DBNull.Value AndAlso prov.IdAsInt = -1 Then prov.IdAsInt = newId
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub


    Public Shared Function GetProvidersForName(ByVal nameGuid As String) As Provider()
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProvidersForName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        ps.Add(New Provider(row))
                    Next
                End If

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ps.ToArray(GetType(Provider))
    End Function

    Public Shared Function GetProvidersForReference(ByVal referenceGuid As String) As Provider()
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProvidersForReference"

                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@referenceGuid", SqlDbType.UniqueIdentifier).Value = New Guid(referenceGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        ps.Add(New Provider(row))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ps.ToArray(GetType(Provider))
    End Function

#End Region


End Class
