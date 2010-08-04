Imports ChecklistObjects
Imports System.Data
Imports System.Data.SqlClient

Public Class Search

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Function SelectSearchResults(ByVal roleId As Integer, ByVal Search1 As SearchStruct, ByVal UseOr As Boolean, ByVal Search2 As SearchStruct, Optional ByVal StartIndex As Long = 0, Optional ByVal EndIndex As Long = 0, Optional ByRef TotalCount As Long = -1, Optional ByVal FilterByTag As Boolean = False) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()

                cmd.CommandText = "sprSelect_SearchNames2"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@nvcSearchText1", SqlDbType.NVarChar).Value = Search1.SearchText
                cmd.Parameters.Add("@nvcField1", SqlDbType.NVarChar).Value = Search1.Field
                cmd.Parameters.Add("@bitWholeWord1", SqlDbType.Bit).Value = Search1.WholeWord
                cmd.Parameters.Add("@bitAnywhere1", SqlDbType.Bit).Value = Search1.AnywhereInText

                cmd.Parameters.Add("@bitUseOr", SqlDbType.Bit).Value = UseOr

                cmd.Parameters.Add("@nvcSearchText2", SqlDbType.NVarChar).Value = Search2.SearchText
                cmd.Parameters.Add("@nvcField2", SqlDbType.NVarChar).Value = Search2.Field
                cmd.Parameters.Add("@bitWholeWord2", SqlDbType.Bit).Value = Search2.WholeWord
                cmd.Parameters.Add("@bitAnywhere2", SqlDbType.Bit).Value = Search2.AnywhereInText

                cmd.Parameters.Add("@bitMisappliedOnly", SqlDbType.Bit).Value = Search1.MisappliedOnly
                cmd.Parameters.Add("@bitHybridOnly", SqlDbType.Bit).Value = Search1.HybridOnly
                cmd.Parameters.Add("@bitCurrentNamesOnly", SqlDbType.Bit).Value = Search1.CurrentNamesOnly

                cmd.Parameters.Add("@intRoleKey", SqlDbType.Int).Value = roleId

                cmd.Parameters.Add("@nvcOrderBy1", SqlDbType.NVarChar).Value = Search1.OrderField
                cmd.Parameters.Add("@bitDescending1", SqlDbType.Bit).Value = Search1.OrderDirection
                cmd.Parameters.Add("@nvcOrderBy2", SqlDbType.NVarChar).Value = Search2.OrderField
                cmd.Parameters.Add("@bitDescending2", SqlDbType.Bit).Value = Search2.OrderDirection

                cmd.Parameters.Add("@intStartIndex", SqlDbType.Int).Value = StartIndex
                cmd.Parameters.Add("@intEndIndex", SqlDbType.Int).Value = EndIndex
                cmd.Parameters.Add("@bitDoNotShowSuppressed", SqlDbType.Bit).Value = Search1.DoNotShowSuppressed

                cmd.Parameters.Add("@intYearStart", SqlDbType.Int).Value = Search1.YearStart
                cmd.Parameters.Add("@intYearEnd", SqlDbType.Int).Value = Search1.YearEnd

                cmd.Parameters.Add("@uidCancelQuery", SqlDbType.UniqueIdentifier).Value = Search1.CancelId

                cmd.Parameters.Add("@FilterByTag", SqlDbType.Bit).Value = FilterByTag

                cmd.Parameters.Add("@intTotalRows", SqlDbType.Int).Direction = ParameterDirection.Output


                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                Dim objTotalCount As Object = cmd.Parameters("@intTotalRows").Value
                If Not objTotalCount Is DBNull.Value Then
                    TotalCount = objTotalCount
                End If
            End Using
        End Using

        Return ds
    End Function


End Class
