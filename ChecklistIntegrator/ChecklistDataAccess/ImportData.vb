Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class ImportData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Function GetImportTypes() As ImportType()
        Dim its As New ArrayList
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ImportTypes"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        its.Add(New ImportType(row))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return its.ToArray(GetType(ImportType))
    End Function

    Public Shared Function GetProviderImport(ByVal piId As Integer) As ProviderImport
        Dim pi As ProviderImport
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderImport"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pi = New ProviderImport(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("ProviderImportPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pi
    End Function

    Public Shared Function GetProviderImports(ByVal providerPk As Integer) As ProviderImport()
        Dim ps As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderImports"

                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        ps.Add(New ProviderImport(row, row("ProviderImportPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ps.ToArray(GetType(ProviderImport))
    End Function

    Public Shared Function InsertUpdateProviderImport(ByVal provImport As ProviderImport, ByVal user As String) As Boolean
        Dim ps As New ArrayList
        Dim ok As Boolean = True

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()

                cmd.CommandText = "sprInsertUpdate_ProviderImport"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@providerImportPk", SqlDbType.Int).Value = provImport.IdAsInt
                cmd.Parameters.Add("@providerFk", SqlDbType.Int).Value = provImport.ProviderImportProviderFk
                cmd.Parameters.Add("@importTypeFk", SqlDbType.Int).Value = Utility.GetDBInt(provImport.ProviderImportImportTypeFk)
                cmd.Parameters.Add("@fileName", SqlDbType.NVarChar).Value = Utility.GetDBString(provImport.ProviderImportFileName)
                cmd.Parameters.Add("@importStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(provImport.ProviderImportStatus)
                cmd.Parameters.Add("@importDate", SqlDbType.DateTime).Value = Utility.GetDBDate(provImport.ProviderImportDate)
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = Utility.GetDBString(provImport.ProviderImportNotes)
                cmd.Parameters.Add("@higherNameId", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(provImport.ProviderImportHigherNameId)
                cmd.Parameters.Add("@higherPNId", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(provImport.ProviderImportHigherPNId)
                cmd.Parameters.Add("@genusNameId", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(provImport.ProviderImportGenusNameId)
                cmd.Parameters.Add("@genusPNId", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(provImport.ProviderImportGenusPNId)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim newId As Object = cmd.ExecuteScalar()

                If Not newId Is DBNull.Value AndAlso provImport.IdAsInt = -1 Then provImport.IdAsInt = newId

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ok
    End Function
End Class
