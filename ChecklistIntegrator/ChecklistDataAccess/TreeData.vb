Imports System.Data
Imports System.Data.SqlClient

Public Class TreeData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Function GetRootId() As String
        Dim id As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_RootKey"
                cmd.CommandType = CommandType.StoredProcedure

                id = cmd.ExecuteScalar()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return id
    End Function

    Public Shared Function GetTaxTreeNodes(ByVal roleId As Integer, ByVal ParentNodeId As String, ByVal ClassificationKey As Long, Optional ByVal DoSuppress As Boolean = False) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprGetNode"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@NameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(ParentNodeId)
                cmd.Parameters.Add("@intClassificationKey", SqlDbType.Int).Value = ClassificationKey
                cmd.Parameters.Add("@bitDoSuppress", SqlDbType.Bit).Value = DoSuppress
                cmd.Parameters.Add("@intRoleKey", SqlDbType.Int).Value = roleId
                cmd.CommandTimeout = 60

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds

    End Function

    Public Shared Function GetNodeToRoot(ByVal roleId As Integer, ByVal NodeKey As String, ByVal ClassificationKey As Long) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_NodeToRoot"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@StartNodeKey", SqlDbType.UniqueIdentifier).Value = New Guid(NodeKey)
                cmd.Parameters.Add("@intClassificationKey", SqlDbType.Int).Value = ClassificationKey
                cmd.Parameters.Add("@intRoleKey", SqlDbType.Int).Value = roleId

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

End Class
