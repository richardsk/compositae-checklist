Public Class BaseObject
    Public Name As String = ""
    Public Id As String = ""
    Public CreatedDate As DateTime = DateTime.MinValue
    Public CreatedBy As String = ""
    Public UpdatedDate As DateTime = DateTime.MinValue
    Public UpdatedBy As String = ""

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        If Not row Is Nothing Then
            Try
                CreatedBy = row(ColumnThatEndsWith(row, "CreatedBy").ColumnName).ToString
                Dim dt As DateTime = DateTime.MinValue
                Dim dtObj As Object = row(ColumnThatEndsWith(row, "CreatedDate").ColumnName)
                If dtObj IsNot DBNull.Value Then dt = dtObj
                CreatedDate = dt
                UpdatedBy = row(ColumnThatEndsWith(row, "UpdatedBy").ColumnName).ToString
                dt = DateTime.MinValue
                dtObj = row(ColumnThatEndsWith(row, "UpdatedDate").ColumnName)
                If dtObj IsNot DBNull.Value Then dt = dtObj
                UpdatedDate = dt

            Catch ex As Exception
            End Try

            If recId IsNot Nothing Then Id = recId
        End If
    End Sub

    Public Property IdAsInt() As Integer
        Get
            Dim numId As Integer = -1
            If Not Integer.TryParse(Id, numId) Then numId = -1
            Return numId
        End Get
        Set(ByVal value As Integer)
            Id = value.ToString
        End Set
    End Property

    Public Overrides Function ToString() As String
        Return Name
    End Function

    Public Sub LoadFieldsFromRow(ByVal row As DataRow)
        Dim fields As Reflection.FieldInfo() = Me.GetType().GetFields()
        For Each f As Reflection.FieldInfo In fields
            Try
                If f.IsPublic AndAlso Not row.IsNull(f.Name) Then f.SetValue(Me, row(f.Name))
            Catch ex As Exception
            End Try
        Next
    End Sub

    ''' <summary>
    ''' Update the object from data in the table.
    ''' The columns of the table must include Field and Value columns
    ''' The values in the Field colun must match the name and type of the object's property
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <remarks></remarks>
    Public Sub UpdateFieldsFromTable(ByVal dt As DataTable, ByVal mappings As List(Of NameMapping))
        For Each row As DataRow In dt.Rows
            Dim nm As NameMapping = NameMapping.MappingWithDestinationCol(mappings, row("Field").ToString)
            If nm IsNot Nothing Then
                Dim field As Reflection.FieldInfo = Me.GetType().GetField(nm.NameMappingSourceCol)
                Try
                    Dim val As Object = row("Value")
                    If val Is DBNull.Value Then
                        If field.FieldType Is GetType(String) Then
                            val = Nothing
                        ElseIf field.FieldType Is GetType(Integer) Then
                            val = -1
                        ElseIf field.FieldType Is GetType(DateTime) Then
                            val = DateTime.MinValue
                        ElseIf field.FieldType Is GetType(Boolean) Then
                            val = False
                        Else
                            val = Nothing
                        End If
                    End If
                    If field.FieldType Is GetType(SqlTypes.SqlBoolean) Then
                        field.SetValue(Me, New SqlTypes.SqlBoolean(CBool(val)))
                    Else
                        field.SetValue(Me, val)
                    End If
                Catch ex As Exception
                End Try
            End If
        Next
    End Sub

    ''' <summary>
    ''' Update the object from data in the table.
    ''' The columns of the table must include Field and Value columns
    ''' The values in the Field colun must match the name and type of the object's property
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <remarks></remarks>
    Public Sub UpdateFieldsFromTable(ByVal dt As DataTable, ByVal mappings As List(Of RISMapping))
        For Each row As DataRow In dt.Rows
            Dim rm As RISMapping = RISMapping.MappingWithDestinationCol(mappings, row("Field").ToString)
            If rm IsNot Nothing Then
                Dim field As Reflection.FieldInfo = Me.GetType().GetField(rm.RISMappingSourceCol)
                Try
                    Dim val As Object = row("Value")
                    If val Is DBNull.Value Then
                        If field.FieldType Is GetType(String) Then
                            val = Nothing
                        ElseIf field.FieldType Is GetType(Integer) Then
                            val = -1
                        ElseIf field.FieldType Is GetType(DateTime) Then
                            val = DateTime.MinValue
                        ElseIf field.FieldType Is GetType(Boolean) Then
                            val = False
                        Else
                            val = Nothing
                        End If
                    End If
                    field.SetValue(Me, val)
                Catch ex As Exception
                End Try
            End If
        Next
    End Sub

    ''' <summary>
    ''' Update the object from data in the table.
    ''' The columns of the table must include Field and Value columns
    ''' The values in the Field colun must match the name and type of the object's property
    ''' </summary>
    ''' <param name="dt"></param>
    ''' <remarks></remarks>
    Public Sub UpdateFieldsFromTable(ByVal dt As DataTable)
        For Each row As DataRow In dt.Rows
            Dim field As Reflection.FieldInfo = Me.GetType().GetField(row("Field").ToString)
            Try
                field.SetValue(Me, row("Value"))
            Catch ex As Exception
            End Try
        Next
    End Sub

    Private Function ColumnThatEndsWith(ByVal row As DataRow, ByVal endStr As String) As DataColumn
        Dim col As DataColumn
        For Each c As DataColumn In row.Table.Columns
            If c.ColumnName.EndsWith(endStr) Then
                col = c
            End If
        Next
        Return col
    End Function

    Protected Function GetRowString(ByVal row As DataRow, ByVal fieldName As String) As String
        If row IsNot Nothing AndAlso row.Table IsNot Nothing AndAlso row.Table.Columns.Contains(fieldName) AndAlso _
            Not row.IsNull(fieldName) Then
            Return row(fieldName).ToString
        End If
        Return Nothing
    End Function

    Protected Function GetRowStringNonBlank(ByVal row As DataRow, ByVal fieldName As String) As String
        If row IsNot Nothing AndAlso row.Table IsNot Nothing AndAlso row.Table.Columns.Contains(fieldName) AndAlso _
            Not row.IsNull(fieldName) AndAlso row(fieldName).ToString.Length > 0 Then
            Return row(fieldName).ToString
        End If
        Return Nothing
    End Function

    Protected Function GetRowInt(ByVal row As DataRow, ByVal fieldName As String) As Integer
        If row IsNot Nothing AndAlso row.Table IsNot Nothing AndAlso row.Table.Columns.Contains(fieldName) AndAlso _
            Not row.IsNull(fieldName) Then
            Return row(fieldName)
        End If
        Return -1
    End Function

    Protected Function GetRowDateTime(ByVal row As DataRow, ByVal fieldName As String) As DateTime
        If row IsNot Nothing AndAlso row.Table IsNot Nothing AndAlso row.Table.Columns.Contains(fieldName) AndAlso _
            Not row.IsNull(fieldName) Then
            Return row(fieldName)
        End If
        Return DateTime.MinValue
    End Function

    Protected Function GetRowBool(ByVal row As DataRow, ByVal fieldName As String) As SqlTypes.SqlBoolean
        Dim val As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null

        If row IsNot Nothing AndAlso row.Table IsNot Nothing AndAlso row.Table.Columns.Contains(fieldName) AndAlso _
            Not row.IsNull(fieldName) Then

            Try
                val = SqlTypes.SqlBoolean.Parse(row(fieldName).ToString())
            Catch ex As Exception
            End Try
        End If
        Return val
    End Function

End Class
