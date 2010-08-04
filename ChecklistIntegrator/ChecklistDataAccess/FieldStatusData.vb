Imports ChecklistObjects
Imports System.Data
Imports System.Data.SqlClient

Public Class FieldStatusData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Private Shared statii As DsFieldStatus

    Public Shared ReadOnly Property AuxFieldStatusData() As DataSet
        Get
            If statii Is Nothing Then
                statii = GetAuxFieldStatusData()
            End If
            Return statii
        End Get
    End Property

    Public Shared Function GetAuxFieldStatusData() As DsFieldStatus
        Dim ds As New DsFieldStatus

        'identifiers
        ds.Merge(SelectFieldStatusIdentifiers())

        'levels
        ds.Merge(SelectFieldStatusLevels())

        Return ds
    End Function

    'load Field Status Aux Data
    Public Shared Function SelectFieldStatusLevels() As DsFieldStatus
        Dim ds As New DsFieldStatus

        Dim cmd As New SqlCommand("sprSelect_FieldStatusLevels")
        cmd.Connection = New SqlConnection(ConnectionString)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))

        Dim da As New SqlDataAdapter(cmd)
        da.TableMappings.Add("Table", "tblFieldStatusLevel")
        da.Fill(ds)

        Return ds
    End Function

    'load Field Status Aux Data
    Public Shared Function SelectFieldStatusIdentifiers() As DsFieldStatus
        Dim ds As New DsFieldStatus
        Dim cmd As New SqlCommand("sprSelect_FieldStatusIdentifiers")
        cmd.Connection = New SqlConnection(ConnectionString)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))

        Dim da As New SqlDataAdapter(cmd)
        da.TableMappings.Add("Table", "tblFieldStatusIdentifier")
        da.Fill(ds)

        Return ds
    End Function

    'load Validation Status 
    Public Shared Function LoadStatus(ByVal RecordKey As String, ByVal TableName As String) As DataSet
        Dim ds As New DsFieldStatus

        Dim cmd As New SqlCommand("sprSelect_FieldStatus_RecordByKeyAndTableName")
        cmd.Connection = New SqlConnection(ConnectionString)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusRecordFK", System.Data.SqlDbType.VarChar, 50)).Value = RecordKey
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusIdentifierTableName", System.Data.SqlDbType.VarChar, 50)).Value = TableName

        Dim da As New SqlDataAdapter(cmd)
        da.TableMappings.Add("Table", "tblFieldStatus")
        da.Fill(ds)

        Return ds
    End Function


    'update Validation Status
    Public Shared Sub UpdateStatus(ByVal ds As DataSet, ByVal userId As Integer)
        Dim cmd As New SqlCommand("sprInsertUpdate_FieldStatus")
        cmd.Connection = New SqlConnection(ConnectionString)
        cmd.CommandType = CommandType.StoredProcedure

        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusCounterPK", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.InputOutput, False, CType(10, Byte), CType(0, Byte), "FieldStatusCounterPK", System.Data.DataRowVersion.Current, Nothing))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusIdentifierFK", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "FieldStatusIdentifierFK", System.Data.DataRowVersion.Current, Nothing))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusRecordFK", System.Data.SqlDbType.VarChar, 50, "FieldStatusRecordFK"))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusLevelFK", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "FieldStatusLevelFK", System.Data.DataRowVersion.Current, Nothing))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@FieldStatusComment", System.Data.SqlDbType.NVarChar, 500, "FieldStatusComment"))
        cmd.Parameters.Add(New System.Data.SqlClient.SqlParameter("@UserKey", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing)).Value = userId

        cmd.Parameters("@UserKey").Value = userId

        cmd.Connection.Open()
        Try
            For Each row As DataRow In ds.Tables("tblFieldStatus").Rows
                cmd.Parameters("@FieldStatusCounterPK").Value = row("FieldStatusCounterPK")
                cmd.Parameters("@FieldStatusIdentifierFK").Value = row("FieldStatusIdentifierFK")
                cmd.Parameters("@FieldStatusRecordFK").Value = row("FieldStatusRecordFK")
                cmd.Parameters("@FieldStatusLevelFK").Value = row("FieldStatusLevelFK")
                cmd.Parameters("@FieldStatusComment").Value = row("FieldStatusComment")

                cmd.ExecuteNonQuery()

                row("FieldStatusCounterPK") = cmd.Parameters("@FieldStatusCounterPK").Value
            Next
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
            Throw ex
        End Try
        cmd.Connection.Close()

    End Sub

    ''' <summary>
    ''' Gets the field validation status row for the specified provider name
    ''' </summary>
    ''' <param name="fieldName"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetProviderNameFieldStatus(ByVal statusDs As DataSet, ByVal fieldName As String) As DataRow
        Dim res As DataRow

        Try
            Dim fieldId As Integer = -1
            For Each dr As DataRow In AuxFieldStatusData.Tables("tblFieldStatusIdentifier").Rows
                If dr("FieldStatusIdentifierFieldName").ToString = fieldName And dr("FieldStatusIdentifierTableName").ToString = "tblProviderName" Then
                    fieldId = dr("FieldStatusIdentifierCounterPk")
                    Exit For
                End If
            Next

            For Each dr As DataRow In statusDs.Tables("tblFieldStatus").Rows
                If dr("FieldStatusIdentifierFk") = fieldId Then
                    res = dr
                    Exit For
                End If
            Next
        Catch ex As Exception
        End Try

        Return res
    End Function

    Public Shared Function GetProviderReferenceFieldStatus(ByVal statusDs As DataSet, ByVal fieldName As String) As DataRow
        Dim res As DataRow

        Try
            Dim fieldId As Integer = -1
            For Each dr As DataRow In AuxFieldStatusData.Tables("tblFieldStatusIdentifier").Rows
                If dr("FieldStatusIdentifierFieldName").ToString = fieldName And dr("FieldStatusIdentifierTableName").ToString = "tblProviderRIS" Then
                    fieldId = dr("FieldStatusIdentifierCounterPk")
                    Exit For
                End If
            Next

            For Each dr As DataRow In statusDs.Tables("tblFieldStatus").Rows
                If dr("FieldStatusIdentifierFk") = fieldId Then
                    res = dr
                    Exit For
                End If
            Next
        Catch ex As Exception
        End Try

        Return res
    End Function
End Class
