Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class ReportData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Function ListReports(ByVal forWeb As Boolean) As List(Of Report)
        Dim reps As New List(Of Report)

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Reports"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@forWeb", SqlDbType.Bit).Value = forWeb

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        reps.Add(New Report(row, row("ReportPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return reps
    End Function

    Public Shared Function GetReport(ByVal reportPk As Integer) As Report
        Dim rep As Report

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Report"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@reportPk", SqlDbType.Int).Value = reportPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    rep = New Report(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("ReportPk").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return rep
    End Function

    Public Shared Function GetReportData(ByVal report As Report) As DataSet
        'todo take parameters to restrict report data
        Dim ds As New DataSet

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_RunReport"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@reportPk", SqlDbType.Int).Value = report.IdAsInt

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNameReportData(ByVal report As Report, ByVal nameId As String) As DataSet
        Dim ds As New DataSet

        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = report.ReportStoredProc
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@nameId", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameId)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Sub InsertReportError(ByVal rep As Report, ByVal recordId As String, ByVal tableName As String, ByVal errorStatusFk As Integer, ByVal comment As String)
        Using cnn As SqlConnection = New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_ReportError"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@reportFk", SqlDbType.Int).Value = rep.IdAsInt
                cmd.Parameters.Add("@tableName", SqlDbType.NVarChar).Value = tableName
                cmd.Parameters.Add("@recordId", SqlDbType.NVarChar).Value = recordId
                cmd.Parameters.Add("@statusFk", SqlDbType.Int).Value = errorStatusFk
                cmd.Parameters.Add("@comment", SqlDbType.NVarChar).Value = comment

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

End Class
