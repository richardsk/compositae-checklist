Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class UserData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Function GetUsers() As User()
        Dim us As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_Users"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        us.Add(New User(row))
                    Next
                End If
            End Using

            If cnn.State > ConnectionState.Closed Then cnn.Close()
        End Using
        
        Return us.ToArray(GetType(User))
    End Function

    Public Shared Function Login(ByVal u As User, ByVal password As String) As Boolean
        Dim ok As Boolean = False

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            If password = "" Then password = Nothing

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprLogin"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@userPk", SqlDbType.Int).Value = u.IdAsInt
                cmd.Parameters.Add("@pwd", SqlDbType.NVarChar).Value = Utility.GetDBString(password)

                ok = cmd.ExecuteScalar()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        
        Return ok
    End Function

    Public Shared Function GetUserProviders(ByVal userId As Integer) As UserProvider()
        Dim us As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_UserProviders"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@userPk", SqlDbType.Int).Value = userId

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        Dim up As New ChecklistObjects.UserProvider
                        Dim pk As Integer = row("UserProviderProviderFk")
                        up.UserPk = userId
                        up.Provider = ProviderData.GetProvider(pk)
                        up.ProviderImports = ImportData.GetProviderImports(pk)
                        us.Add(up)
                    Next
                End If
            End Using

            If cnn.State > ConnectionState.Closed Then cnn.Close()
        End Using

        Return us.ToArray(GetType(UserProvider))
    End Function

End Class
