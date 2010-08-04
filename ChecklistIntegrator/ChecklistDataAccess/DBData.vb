Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class DBData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Sub CleanDatabase()
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_CleanDatabase"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function ResolveDeprecatedLSID(ByVal oldLSID As String) As String
        Dim lsid As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_LSIDFromDeprecated"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@oldLSID", SqlDbType.NVarChar).Value = oldLSID

                lsid = cmd.ExecuteScalar
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return lsid
    End Function

    Public Shared Sub InsertCancelRequest(ByVal id As Guid)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                'TODO
                'cmd.CommandText = "spr"
                'cmd.CommandType = CommandType.StoredProcedure

                'cmd.Parameters.Add("@uidCancelId", SqlDbType.UniqueIdentifier).Value = id

                'cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub
End Class
