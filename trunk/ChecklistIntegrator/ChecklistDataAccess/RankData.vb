Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class RankData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Private Shared ranks() As Rank

    Public Shared Function GetRanks() As Rank()
        If ranks IsNot Nothing Then
            Return ranks
        End If

        Dim list As New ArrayList
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Ranks"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                Dim ds As New DataSet
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        list.Add(New Rank(row, row("RankPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        ranks = list.ToArray(GetType(Rank))
        Return ranks
    End Function

    Public Shared Function RankByPk(ByVal pk As Integer) As Rank
        Dim rnk As Rank

        For Each r As Rank In GetRanks()
            If r.Id = pk.ToString Then
                rnk = r
                Exit For
            End If
        Next

        Return rnk
    End Function

    Public Shared Function RankByName(ByVal name As String) As Rank
        Dim rnk As Rank

        name = name.ToLower

        For Each r As Rank In GetRanks()
            If r.Name.ToLower = name Or r.RankKnownAbbreviations.IndexOf("@" + name + "@") <> -1 Then
                rnk = r
                Exit For
            End If
        Next

        Return rnk
    End Function

    Public Shared Function GetRankSort(ByVal rankPk As Integer) As Integer
        Dim sort As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_RankSort"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@rankPk", SqlDbType.Int).Value = rankPk

                Dim s As Object = cmd.ExecuteScalar()
                If Not s Is DBNull.Value Then sort = s

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return sort
    End Function

    Public Shared Function GetRankTCS(ByVal rankPk As Integer) As String
        Dim rank As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_RankTCS"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@rankPk", SqlDbType.Int).Value = rankPk

                Dim r As Object = cmd.ExecuteScalar()
                If Not r Is DBNull.Value Then rank = r

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return rank
    End Function
End Class
