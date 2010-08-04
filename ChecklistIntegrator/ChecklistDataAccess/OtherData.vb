Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class OtherData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Shared Sub DeleteProviderOtherData(ByVal trans As SqlTransaction, ByVal providerPk As Integer, ByVal otherDataId As String)
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.Transaction = trans
            cmd.CommandText = "sprDelete_ProviderOtherData"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
            cmd.Parameters.Add("@otherDataId", SqlDbType.NVarChar).Value = otherDataId

            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

    End Sub

    Public Shared Sub InsertUpdateProviderOtherData(ByVal trans As SqlTransaction, ByVal providerImportPk As Integer, ByVal row As DataRow, ByVal user As String)
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.Transaction = trans
            cmd.CommandText = "sprInsertUpdate_ProviderOtherData"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@otherDataPk", SqlDbType.Int).Value = -1 'always insert at present
            cmd.Parameters.Add("@providerImportFk", SqlDbType.Int).Value = providerImportPk
            cmd.Parameters.Add("@dataType", SqlDbType.NVarChar).Value = row("POtherDataType").ToString
            cmd.Parameters.Add("@dataName", SqlDbType.NVarChar).Value = row("POtherDataName").ToString
            cmd.Parameters.Add("@dataRecordId", SqlDbType.NVarChar).Value = row("POtherDataRecordId").ToString
            cmd.Parameters.Add("@dataVersion", SqlDbType.NVarChar).Value = DBNull.Value 'todo - should this be in here??  row("POtherDataVersion").ToString
            cmd.Parameters.Add("@data", SqlDbType.NText).Value = row("POtherDataData").ToString
            cmd.Parameters.Add("@xml", SqlDbType.NText).Value = row("POtherDataXml").ToString
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

    End Sub

    Public Shared Function GetNameOtherData(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameOtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderNameOtherData(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderNameOtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetTransformations() As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Transformations"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetOtherDataMappings() As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_OtherDataTransformations"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetOtherDataTypes() As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_OtherDataTypes"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return ds
    End Function

    Public Shared Function GetProviderOtherDataTypes() As DataTable
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderOtherDataTypes"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds.Tables(0)
    End Function


    Public Shared Sub InsertUpdateTransformation(ByVal row As DataRow, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_Transformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@transPk", SqlDbType.Int).Value = row("TransformationPk")
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = row("Name")
                cmd.Parameters.Add("@description", SqlDbType.NVarChar).Value = row("Description")
                cmd.Parameters.Add("@xslt", SqlDbType.Xml).Value = row("Xslt")
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub DeleteTransformation(ByVal transPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_Transformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@transPk", SqlDbType.Int).Value = transPk
                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub


    Public Shared Sub InsertUpdateOtherDataType(ByVal row As DataRow, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_OtherDataType"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataTypePk", SqlDbType.Int).Value = row("OtherDataTypePk")
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = row("Name")
                cmd.Parameters.Add("@consensusTransFk", SqlDbType.Int).Value = row("ConsensusTransformationFk")
                cmd.Parameters.Add("@webTransFk", SqlDbType.Int).Value = row("WebTransformationFk")
                cmd.Parameters.Add("@webSequence", SqlDbType.Int).Value = row("WebSequence")
                cmd.Parameters.Add("@displayTab", SqlDbType.NVarChar).Value = row("DisplayTab")
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub DeleteOtherDataType(ByVal otherDataTypePk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_OtherDataType"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataTypePk", SqlDbType.Int).Value = otherDataTypePk
                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateOtherDataMapping(ByVal row As DataRow, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_OtherDataTransformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@provImportFk", SqlDbType.Int).Value = row("ProviderImportFk")
                cmd.Parameters.Add("@otherDataType", SqlDbType.NVarChar).Value = row("POtherDataType")
                cmd.Parameters.Add("@UseXml", SqlDbType.Bit).Value = row("UseDataXml")
                cmd.Parameters.Add("@transFk", SqlDbType.Int).Value = row("TransformationFk")
                cmd.Parameters.Add("@addRoot", SqlDbType.Int).Value = row("AddRoot")
                cmd.Parameters.Add("@outTypeFk", SqlDbType.Int).Value = row("OutputTypeFk")
                cmd.Parameters.Add("@runDate", SqlDbType.DateTime).Value = row("RunDate")
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub DeleteOtherDataMapping(ByVal provImportFk As Integer, ByVal otherDataType As String, ByVal outputTypeFk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_OtherDataTransformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@provImportFk", SqlDbType.Int).Value = provImportFk
                cmd.Parameters.Add("@otherDataType", SqlDbType.NVarChar).Value = otherDataType
                cmd.Parameters.Add("@outputTypeFk", SqlDbType.Int).Value = Utility.GetDBInt(outputTypeFk)
                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub


    Public Shared Function GetOtherDataForUpdate(ByVal provPk As Integer) As DataTable
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_OtherDataToUpdate"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(provPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds.Tables(0)
    End Function

    Public Shared Function GetUnlinkedOtherDataDs(ByVal providerPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedOtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetUnlinkedOtherDataCount(ByVal providerPk As Integer) As Integer
        Dim count As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedOtherDataCount"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                count = cmd.ExecuteScalar()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return count
    End Function

    Public Shared Sub InsertOtherDataIntegrationOrder(ByVal providerPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_OtherDataIntegrationOrder"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetNextUnlinkedOtherData(ByVal index As Integer) As DataRow
        Dim pod As DataRow = Nothing

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NextUnlinkedOtherData"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@index", SqlDbType.Int).Value = index

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pod = ds.Tables(0).Rows(0)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pod
    End Function

    Public Shared Function InsertUpdateStandardOutput(ByVal stdOutput As DataRow, ByVal user As String) As Integer
        Dim newId As Integer = -1
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_StandardOutput"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@stdOutputPk", SqlDbType.Int).Value = stdOutput("StandardOutputPk")
                cmd.Parameters.Add("@potherDataFk", SqlDbType.Int).Value = stdOutput("POtherDataFk")
                cmd.Parameters.Add("@otherDataTypeFk", SqlDbType.Int).Value = stdOutput("OtherTypeFk")
                cmd.Parameters.Add("@stdXml", SqlDbType.NVarChar).Value = stdOutput("StandardXml")
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = stdOutput("StandardDate")
                cmd.Parameters.Add("@useForConsensus", SqlDbType.Bit).Value = stdOutput("UseForConsensus")
                cmd.Parameters.Add("@otherDataFk", SqlDbType.UniqueIdentifier).Value = stdOutput("OtherDataFk")
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                newId = cmd.ExecuteScalar()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newId
    End Function

    Public Shared Function InsertUpdateStandardOutput(ByVal stdOutputPk As Integer, ByVal POtherDataFk As Integer, ByVal otherDataTypeFk As Integer, ByVal xml As String, ByVal stdDate As DateTime, ByVal useForConsensus As Boolean, ByVal otherDataFk As String, ByVal user As String) As Integer
        Dim newId As Integer = -1
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_StandardOutput"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@stdOutputPk", SqlDbType.Int).Value = Utility.GetDBInt(stdOutputPk)
                cmd.Parameters.Add("@potherDataFk", SqlDbType.Int).Value = Utility.GetDBInt(POtherDataFk)
                cmd.Parameters.Add("@otherDataTypeFk", SqlDbType.Int).Value = Utility.GetDBInt(otherDataTypeFk)
                cmd.Parameters.Add("@stdXml", SqlDbType.NVarChar).Value = Utility.GetDBString(xml)
                cmd.Parameters.Add("@date", SqlDbType.DateTime).Value = Utility.GetDBDate(stdDate)
                cmd.Parameters.Add("@useForConsensus", SqlDbType.Bit).Value = useForConsensus
                cmd.Parameters.Add("@otherDataFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(otherDataFk)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                newId = cmd.ExecuteScalar()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newId
    End Function

    Public Shared Function InsertUpdateOtherData(ByVal nameGuid As String, ByVal stdXml As String, ByVal othDataPk As String, ByVal othDataTypePk As Integer, ByVal user As String) As DataRow
        Dim res As DataRow = Nothing

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_OtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataPk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(othDataPk)
                cmd.Parameters.Add("@otherDataTypeFk", SqlDbType.Int).Value = Utility.GetDBInt(othDataTypePk)
                cmd.Parameters.Add("@recordFk", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(nameGuid)
                cmd.Parameters.Add("@xml", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(stdXml)
                cmd.Parameters.Add("@data", SqlDbType.DateTime).Value = DBNull.Value 'todo ??
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    res = ds.Tables(0).Rows(0)
                End If

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return res
    End Function

    Public Shared Sub UpdateStandardOutputUseForConsensus(ByVal stdOutput As DataRow, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_StandardOutputUseForConsensus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@stdOutputPk", SqlDbType.Int).Value = stdOutput("StandardOutputPk")
                cmd.Parameters.Add("@useForConsensus", SqlDbType.Bit).Value = stdOutput("UseForConsensus")
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetStandardXmlForConsensus(ByVal nameGuid As String, ByVal dataTypeFk As Integer) As String
        Dim xml As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_StandardXmlForConsensus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@otherDataTypeFk", SqlDbType.Int).Value = Utility.GetDBInt(dataTypeFk)

                Dim obj As Object = cmd.ExecuteScalar()
                If obj IsNot DBNull.Value Then xml = obj.ToString

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return xml
    End Function

    Public Shared Function GetConsensusXslt(ByVal dataTypePk As Integer) As String
        Dim xml As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ConsensusXslt"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataTypePk", SqlDbType.Int).Value = Utility.GetDBInt(dataTypePk)

                xml = cmd.ExecuteScalar()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return xml
    End Function

    Public Shared Function GetTransformation(ByVal transfPk As Integer) As DataRow
        Dim tr As DataRow

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Transformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@transfPk", SqlDbType.Int).Value = Utility.GetDBInt(transfPk)

                Dim da As New SqlDataAdapter(cmd)

                da.Fill(ds)
                If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    tr = ds.Tables(0).Rows(0)
                End If

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return tr
    End Function


End Class
