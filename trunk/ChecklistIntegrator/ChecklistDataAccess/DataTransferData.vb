Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class DataTransferData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString

    Public Sub New()
    End Sub

    Public Shared Function GetDataToTransfer(ByVal fromDate As DateTime) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_DataToTransfer"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@fromDate", SqlDbType.DateTime).Value = Utility.GetDBDate(fromDate)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                ds.Tables(0).TableName = "tblAuthors"
                ds.Tables(1).TableName = "tblNameAuthors"
                ds.Tables(2).TableName = "tblProviderNameAuthors"
                ds.Tables(3).TableName = "tblConcept"
                ds.Tables(4).TableName = "tblConceptRelationship"
                ds.Tables(5).TableName = "tblDeprecated"
                ds.Tables(6).TableName = "tblFieldStatus"
                ds.Tables(7).TableName = "tblName"
                ds.Tables(8).TableName = "tblProvider"
                ds.Tables(9).TableName = "tblProviderConcept"
                ds.Tables(10).TableName = "tblProviderConcept_Change"
                ds.Tables(11).TableName = "tblProviderConceptRelationship"
                ds.Tables(12).TableName = "tblProviderConceptRelationship_Change"
                ds.Tables(13).TableName = "tblProviderImport"
                ds.Tables(14).TableName = "tblProviderName"
                ds.Tables(15).TableName = "tblProviderName_Change"
                ds.Tables(16).TableName = "tblProviderOtherData"
                ds.Tables(17).TableName = "tblProviderReference"
                ds.Tables(18).TableName = "tblProviderReference_Change"
                ds.Tables(19).TableName = "tblProviderRIS"
                ds.Tables(20).TableName = "tblProviderRIS_Change"
                ds.Tables(21).TableName = "tblReference"
                ds.Tables(22).TableName = "tblReferenceRIS"

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

#Region "Insert Update Methods"

    Private Shared Function GetRowValue(ByVal row As DataRow, ByVal valType As SqlDbType, ByVal colName As String) As Object
        If row Is Nothing OrElse colName Is Nothing Then Return DBNull.Value

        If Not row.Table.Columns.Contains(colName) Then Return DBNull.Value

        Try
            If valType = SqlDbType.NVarChar Or valType = SqlDbType.VarChar Or valType = SqlDbType.NText Then Return row(colName).ToString
            If valType = SqlDbType.Int Then Return Integer.Parse(row(colName))
            If valType = SqlDbType.UniqueIdentifier Then Return New Guid(row(colName).ToString)
            If valType = SqlDbType.Bit Then Return (row(colName).ToString = "True")
            If valType = SqlDbType.DateTime Then Return DateTime.Parse(row(colName))
        Catch ex As Exception
        End Try

        Return DBNull.Value
    End Function

    Public Shared Sub InsertUpdateAuthor(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Author"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@AuthorPK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "AuthorPK")
                cmd.Parameters.Add("@IPNIAuthor_id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "IPNIAuthor_id")
                cmd.Parameters.Add("@IPNIversion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "IPNIversion")
                cmd.Parameters.Add("@Abbreviation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Abbreviation")
                cmd.Parameters.Add("@Forename", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Forename")
                cmd.Parameters.Add("@Surname", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "TaxonGroups")
                cmd.Parameters.Add("@Dates", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Dates")
                cmd.Parameters.Add("@IPNIAlternativeNames", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "IPNIAlternativeNames")
                cmd.Parameters.Add("@CorrectAuthorFK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "CorrectAuthorFK")
                cmd.Parameters.Add("@AddedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "AddedDate")
                cmd.Parameters.Add("@AddedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "AddedBy")
                cmd.Parameters.Add("@UpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@UpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateNameAuthor(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_NameAuthor"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@NameAuthorsPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "NameAuthorsPk")
                cmd.Parameters.Add("@NameAuthorsNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameAuthorsNameFk")
                cmd.Parameters.Add("@NameAuthorsBasionymAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthorsBasionymAuthors")
                cmd.Parameters.Add("@NameAuthorsCombinationAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthorsCombinationAuthors")
                cmd.Parameters.Add("@NameAuthorsBasEx", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthorsBasEx")
                cmd.Parameters.Add("@NameAuthorsCombEx", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthorsCombEx")
                cmd.Parameters.Add("@NameAuthorsIsCorrected", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameAuthorsIsCorrected")
                cmd.Parameters.Add("@NameAuthorsCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "NameAuthorsCreatedDate")
                cmd.Parameters.Add("@NameAuthorsCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthorsCreatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderNameAuthor(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderNameAuthor"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNAPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNAPk")
                cmd.Parameters.Add("@PNAProviderNameFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNAProviderNameFk")
                cmd.Parameters.Add("@PNABasionymAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNABasionymAuthors")
                cmd.Parameters.Add("@PNACombinationAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNACombinationAuthors")
                cmd.Parameters.Add("@PNABasExAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNABasExAuthors")
                cmd.Parameters.Add("@PNACombExAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNACombExAuthors")
                cmd.Parameters.Add("@PNAIsCorrected", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNAIsCorrected")
                cmd.Parameters.Add("@PNACreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNACreatedDate")
                cmd.Parameters.Add("@PNACreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNACreatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateConcept(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Concept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@conceptPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConceptPk")
                cmd.Parameters.Add("@conceptLSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptLSID")
                cmd.Parameters.Add("@name1", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptName1")
                cmd.Parameters.Add("@name1Fk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ConceptName1Fk")
                cmd.Parameters.Add("@accordingTo", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptAccordingTo")
                cmd.Parameters.Add("@accToFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ConceptAccordingToFk")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ConceptCreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptCreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ConceptUpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateConceptRelationship(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@CRGuid", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ConceptRelationshipGuid")
                cmd.Parameters.Add("@CRLSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptRelationshipLSID")
                cmd.Parameters.Add("@CRConcept1Fk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConceptRelationshipConcept1Fk")
                cmd.Parameters.Add("@CRConcept2Fk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConceptRelationshipConcept2Fk")
                cmd.Parameters.Add("@CRRelationship", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptRelationshipRelationship")
                cmd.Parameters.Add("@CRRelationshipFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConceptRelationshipRelationshipFk")
                cmd.Parameters.Add("@CRHybridOrder", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConceptRelationshipHybridOrder")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ConceptCreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptCreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ConceptUpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ConceptUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateDeprecated(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Deprecated"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@LSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "DeprecatedLSID")
                cmd.Parameters.Add("@newLSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "DeprecatedNewLSID")
                cmd.Parameters.Add("@tableName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "DeprecatedTable")
                cmd.Parameters.Add("@deprecatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "DeprecatedDate")
                cmd.Parameters.Add("@deprecatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "DeprecatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateFieldStatus(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_FieldStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@FieldStatusCounterPK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "FieldStatusCounterPK")
                cmd.Parameters.Add("@FieldStatusIdentifierFK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "FieldStatusIdentifierFK")
                cmd.Parameters.Add("@FieldStatusLevelFK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "FieldStatusLevelFK")
                cmd.Parameters.Add("@FieldStatusComment", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "FieldStatusComment")
                cmd.Parameters.Add("@FieldStatusCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "FieldStatusCreatedBy")
                cmd.Parameters.Add("@FieldStatusCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "FieldStatusCreatedDate")
                cmd.Parameters.Add("@FieldStatusUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "FieldStatusUpdatedBy")
                cmd.Parameters.Add("@FieldStatusUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "FieldStatusUpdatedDate")
                cmd.Parameters.Add("@FieldStatusRecordFk", SqlDbType.VarChar).Value = GetRowValue(row, SqlDbType.VarChar, "FieldStatusRecordFk")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateName(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Name"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@NameGuid", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameGuid")
                cmd.Parameters.Add("@NameLSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameLSID")
                cmd.Parameters.Add("@NameFull", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameFull")
                cmd.Parameters.Add("@NameRank", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameRank")
                cmd.Parameters.Add("@NameRankFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "NameRankFk")
                cmd.Parameters.Add("@NameParentFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameParentFk")
                cmd.Parameters.Add("@NameParentName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameParent")
                cmd.Parameters.Add("@NamePreferredFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NamePreferredFk")
                cmd.Parameters.Add("@NamePreferredName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NamePreferred")
                cmd.Parameters.Add("@NameCanonical", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameCanonical")
                cmd.Parameters.Add("@NameAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameAuthors")
                cmd.Parameters.Add("@NameBasionymAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameBasionymAuthors")
                cmd.Parameters.Add("@NameCombinationAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameCombinationAuthors")
                cmd.Parameters.Add("@NamePublishedIn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NamePublishedIn")
                cmd.Parameters.Add("@NameReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameReferenceFk")
                cmd.Parameters.Add("@NameYear", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameYear")
                cmd.Parameters.Add("@NameMicroReference", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameMicroReference")
                cmd.Parameters.Add("@NameTypeVoucher", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameTypeVoucher")
                cmd.Parameters.Add("@NameTypeName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameTypeName")
                cmd.Parameters.Add("@NameTypeNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameTypeNameFk")
                cmd.Parameters.Add("@NameOrthography", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameOrthography")
                cmd.Parameters.Add("@NameBasionym", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameBasionym")
                cmd.Parameters.Add("@NameBasionymFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameBasionymFk")
                cmd.Parameters.Add("@NameBasedOn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameBasedOn")
                cmd.Parameters.Add("@NameBasedOnFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameBasedOnFk")
                cmd.Parameters.Add("@NameConservedAgainst", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameConservedAgainst")
                cmd.Parameters.Add("@NameConservedAgainstFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameConservedAgainstFk")
                cmd.Parameters.Add("@NameHomonymOf", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameHomonymOf")
                cmd.Parameters.Add("@NameHomonymOfFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameHomonymOfFk")
                cmd.Parameters.Add("@NameReplacementFor", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameReplacementFor")
                cmd.Parameters.Add("@NameReplacementForFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameReplacementForFk")
                cmd.Parameters.Add("@NameBlocking", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameBlocking")
                cmd.Parameters.Add("@NameBlockingFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "NameBlockingFk")
                cmd.Parameters.Add("@NameInCitation", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameInCitation")
                cmd.Parameters.Add("@NameInvalid", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameInvalid")
                cmd.Parameters.Add("@NameIllegitimate", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameIllegitimate")
                cmd.Parameters.Add("@NameMisapplied", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameMisapplied")
                cmd.Parameters.Add("@NameProParte", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "NameProParte")
                cmd.Parameters.Add("@NameNomNotes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameNomNotes")
                cmd.Parameters.Add("@NameStatusNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "NameStatusNotes")
                cmd.Parameters.Add("@NameNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "NameNotes")
                cmd.Parameters.Add("@NameCounter", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "NameCounter")
                cmd.Parameters.Add("@NameCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "NameCreatedDate")
                cmd.Parameters.Add("@NameCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameCreatedBy")
                cmd.Parameters.Add("@NameUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "NameUpdatedDate")
                cmd.Parameters.Add("@NameUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "NameUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProvider(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Provider"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerId", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ProviderPk")
                cmd.Parameters.Add("@providerName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderName")
                cmd.Parameters.Add("@providerHomeUrl", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderHomeUrl")
                cmd.Parameters.Add("@providerProjectUrl", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderProjectUrl")
                cmd.Parameters.Add("@providerContactName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderContactName")
                cmd.Parameters.Add("@providerContactPhone", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderContactPhone")
                cmd.Parameters.Add("@providerContactEmail", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderContactEmail")
                cmd.Parameters.Add("@providerContactAddress", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderContactAddress")
                cmd.Parameters.Add("@providerNameFull", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderNameFull")
                cmd.Parameters.Add("@providerStatement", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "ProviderStatement")
                cmd.Parameters.Add("@providerIsEditor", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "ProviderIsEditor")
                cmd.Parameters.Add("@providerUseForParentage", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "ProviderUseForParentage")
                cmd.Parameters.Add("@providerPrefConceptRanking", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PreferredConceptRanking")
                cmd.Parameters.Add("@providerCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ProviderCreatedDate")
                cmd.Parameters.Add("@providerCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderCreatedBy")
                cmd.Parameters.Add("@providerUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ProviderUpdatedDate")
                cmd.Parameters.Add("@providerUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderConcept(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderConcept"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCPk")
                cmd.Parameters.Add("@PCProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCProviderImportFk")
                cmd.Parameters.Add("@PCLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCLinkStatus")
                cmd.Parameters.Add("@PCMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCMatchScore")
                cmd.Parameters.Add("@PCConceptFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCConceptFk")
                cmd.Parameters.Add("@PCConceptId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCConceptId")
                cmd.Parameters.Add("@PCName1", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCName1")
                cmd.Parameters.Add("@PCName1Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCName1Id")
                cmd.Parameters.Add("@PCAccordingTo", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCAccordingTo")
                cmd.Parameters.Add("@PCAccordingToId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCAccordingToId")
                cmd.Parameters.Add("@PCConceptVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCConceptVersion")
                cmd.Parameters.Add("@PCCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCCreatedDate")
                cmd.Parameters.Add("@PCCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCCreatedBy")
                cmd.Parameters.Add("@PCUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCUpdatedDate")
                cmd.Parameters.Add("@PCUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderConceptRelationship(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderConceptRelationship"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRPk")
                cmd.Parameters.Add("@PCRProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRProviderImportFk")
                cmd.Parameters.Add("@PCRLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRLinkStatus")
                cmd.Parameters.Add("@PCRMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRMatchScore")
                cmd.Parameters.Add("@PCRConceptRelationshipFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PCRConceptRelationshipFk")
                cmd.Parameters.Add("@PCRConcept1Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConcept1Id")
                cmd.Parameters.Add("@PCRConcept2Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConcept2Id")
                cmd.Parameters.Add("@PCRIsPreferredConcept", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PCRIsPreferred")
                cmd.Parameters.Add("@PCRId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRId")
                cmd.Parameters.Add("@PCRRelationship", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRRelationship")
                cmd.Parameters.Add("@PCRRelationshipId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRRelationshipId")
                cmd.Parameters.Add("@PCRRelationshipFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRRelationshipFk")
                cmd.Parameters.Add("@PCRHybridOrder", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRHybridOrder")
                cmd.Parameters.Add("@PCRVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConceptVersion")
                cmd.Parameters.Add("@PCRCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCRCreatedDate")
                cmd.Parameters.Add("@PCRCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRCreatedBy")
                cmd.Parameters.Add("@PCRUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCRUpdatedDate")
                cmd.Parameters.Add("@PCRUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderConceptChange(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderConceptChange"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCPk")
                cmd.Parameters.Add("@PCProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCProviderImportFk")
                cmd.Parameters.Add("@PCLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCLinkStatus")
                cmd.Parameters.Add("@PCMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCMatchScore")
                cmd.Parameters.Add("@PCConceptFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCConceptFk")
                cmd.Parameters.Add("@PCConceptId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCConceptId")
                cmd.Parameters.Add("@PCName1", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCName1")
                cmd.Parameters.Add("@PCName1Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCName1Id")
                cmd.Parameters.Add("@PCAccordingTo", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCAccordingTo")
                cmd.Parameters.Add("@PCAccordingToId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCAccordingToId")
                cmd.Parameters.Add("@PCConceptVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCConceptVersion")
                cmd.Parameters.Add("@PCCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCCreatedDate")
                cmd.Parameters.Add("@PCCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCCreatedBy")
                cmd.Parameters.Add("@PCUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCUpdatedDate")
                cmd.Parameters.Add("@PCUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCUpdatedBy")
                cmd.Parameters.Add("@ChangedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ChangedDate")
                cmd.Parameters.Add("@ChangedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ChangedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderConceptRelationshipChange(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderConceptRelationshipChange"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRPk")
                cmd.Parameters.Add("@PCRProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRProviderImportFk")
                cmd.Parameters.Add("@PCRLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRLinkStatus")
                cmd.Parameters.Add("@PCRMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRMatchScore")
                cmd.Parameters.Add("@PCRConceptRelationshipFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PCRConceptRelationshipFk")
                cmd.Parameters.Add("@PCRConcept1Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConcept1Id")
                cmd.Parameters.Add("@PCRConcept2Id", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConcept2Id")
                cmd.Parameters.Add("@PCRIsPreferredConcept", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PCRIsPreferred")
                cmd.Parameters.Add("@PCRId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRId")
                cmd.Parameters.Add("@PCRRelationship", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRRelationship")
                cmd.Parameters.Add("@PCRRelationshipId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRRelationshipId")
                cmd.Parameters.Add("@PCRRelationshipFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRRelationshipFk")
                cmd.Parameters.Add("@PCRHybridOrder", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PCRHybridOrder")
                cmd.Parameters.Add("@PCRVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRConceptVersion")
                cmd.Parameters.Add("@PCRCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCRCreatedDate")
                cmd.Parameters.Add("@PCRCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRCreatedBy")
                cmd.Parameters.Add("@PCRUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PCRUpdatedDate")
                cmd.Parameters.Add("@PCRUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PCRUpdatedBy")
                cmd.Parameters.Add("@ChangedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ChangedDate")
                cmd.Parameters.Add("@ChangedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ChangedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderImport(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderImport"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerImportPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ProviderImportPk")
                cmd.Parameters.Add("@providerFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ProviderImportProviderFk")
                cmd.Parameters.Add("@importTypeFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ProviderImportImportTypeFk")
                cmd.Parameters.Add("@fileName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportFileName")
                cmd.Parameters.Add("@importStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportStatus")
                cmd.Parameters.Add("@importDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ProviderImportDate")
                cmd.Parameters.Add("@notes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportNotes")
                cmd.Parameters.Add("@higherNameId", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ProviderImportHigherNameId")
                cmd.Parameters.Add("@higherPNId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportHigherPNId")
                cmd.Parameters.Add("@genusNameId", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ProviderImportGenusNameId")
                cmd.Parameters.Add("@genusPNId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportGenusPNId")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ProviderImportCreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportCreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ProviderImportUpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ProviderImportUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderName(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNPk")
                cmd.Parameters.Add("@PNNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNNameFk")
                cmd.Parameters.Add("@PNLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNLinkStatus")
                cmd.Parameters.Add("@PNNameMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNNameMatchScore")
                cmd.Parameters.Add("@PNProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNProviderImportFk")
                cmd.Parameters.Add("@PNProviderUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNProviderUpdatedDate")
                cmd.Parameters.Add("@PNProviderAddedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNProviderAddedDate")
                cmd.Parameters.Add("@PNNameId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameId")
                cmd.Parameters.Add("@PNNameFull", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameFull")
                cmd.Parameters.Add("@PNNameRank", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameRank")
                cmd.Parameters.Add("@PNNameRankFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNNameRankFk")
                cmd.Parameters.Add("@PNNameCanonical", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameCanonical")
                cmd.Parameters.Add("@PNNameAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameAuthors")
                cmd.Parameters.Add("@PNBasionymAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionymAuthors")
                cmd.Parameters.Add("@PNCombinationAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNCombinationAuthors")
                cmd.Parameters.Add("@PNPublishedIn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNPublishedIn")
                cmd.Parameters.Add("@PNReferenceId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReferenceId")
                cmd.Parameters.Add("@PNReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNReferenceFk")
                cmd.Parameters.Add("@PNYear", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNYear")
                cmd.Parameters.Add("@PNMicroReference", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNMicroReference")
                cmd.Parameters.Add("@PNTypeVoucher", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNTypeVoucher")
                cmd.Parameters.Add("@PNTypeName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNTypeName")
                cmd.Parameters.Add("@PNTypeNameId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNTypeNameId")
                cmd.Parameters.Add("@PNTypeNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNTypeNameFk")
                cmd.Parameters.Add("@PNOrthography", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNOrthography")
                cmd.Parameters.Add("@PNBasionym", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionym")
                cmd.Parameters.Add("@PNBasionymId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionymId")
                cmd.Parameters.Add("@PNBasionymFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBasionymFk")
                cmd.Parameters.Add("@PNBasedOn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasedOn")
                cmd.Parameters.Add("@PNBasedOnId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasedOnId")
                cmd.Parameters.Add("@PNBasedOnFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBasedOnFk")
                cmd.Parameters.Add("@PNConservedAgainst", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNConservedAgainst")
                cmd.Parameters.Add("@PNConservedAgainstId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNConservedAgainstId")
                cmd.Parameters.Add("@PNConservedAgainstFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNConservedAgainstFk")
                cmd.Parameters.Add("@PNHomonymOf", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNHomonymOf")
                cmd.Parameters.Add("@PNHomonymOfId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNHomonymOfId")
                cmd.Parameters.Add("@PNHomonymOfFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNHomonymOfFk")
                cmd.Parameters.Add("@PNReplacementFor", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReplacementFor")
                cmd.Parameters.Add("@PNReplacementForId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReplacementForId")
                cmd.Parameters.Add("@PNReplacementForFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNReplacementForFk")
                cmd.Parameters.Add("@PNBlocking", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBlocking")
                cmd.Parameters.Add("@PNBlockingId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBlockingId")
                cmd.Parameters.Add("@PNBlockingFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBlockingFk")
                cmd.Parameters.Add("@PNInCitation", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNInCitation")
                cmd.Parameters.Add("@PNInvalid", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNInvalid")
                cmd.Parameters.Add("@PNIllegitimate", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNIllegitimate")
                cmd.Parameters.Add("@PNMisapplied", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNMisapplied")
                cmd.Parameters.Add("@PNProParte", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNProParte")
                cmd.Parameters.Add("@PNGeographyText", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNGeographyText")
                cmd.Parameters.Add("@PNGeographyCodes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNGeographyCodes")
                cmd.Parameters.Add("@PNClimate", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNClimate")
                cmd.Parameters.Add("@PNLifeform", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNLifeform")
                cmd.Parameters.Add("@PNIUCN", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNIUCN")
                cmd.Parameters.Add("@PNNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNNotes")
                cmd.Parameters.Add("@PNStatusNotes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNStatusNotes")
                cmd.Parameters.Add("@PNNonNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNNonNotes")
                cmd.Parameters.Add("@PNQualityStatement", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNQualityStatement")
                cmd.Parameters.Add("@PNNameVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameVersion")
                cmd.Parameters.Add("@PNCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNCreatedDate")
                cmd.Parameters.Add("@PNCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNCreatedBy")
                cmd.Parameters.Add("@PNUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNUpdatedDate")
                cmd.Parameters.Add("@PNUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderNameChange(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderNameChange"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNPk")
                cmd.Parameters.Add("@PNNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNNameFk")
                cmd.Parameters.Add("@PNLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNLinkStatus")
                cmd.Parameters.Add("@PNNameMatchScore", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNNameMatchScore")
                cmd.Parameters.Add("@PNProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNProviderImportFk")
                cmd.Parameters.Add("@PNProviderUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNProviderUpdatedDate")
                cmd.Parameters.Add("@PNProviderAddedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNProviderAddedDate")
                cmd.Parameters.Add("@PNNameId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameId")
                cmd.Parameters.Add("@PNNameFull", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameFull")
                cmd.Parameters.Add("@PNNameRank", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameRank")
                cmd.Parameters.Add("@PNNameRankFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PNNameRankFk")
                cmd.Parameters.Add("@PNNameCanonical", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameCanonical")
                cmd.Parameters.Add("@PNNameAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameAuthors")
                cmd.Parameters.Add("@PNBasionymAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionymAuthors")
                cmd.Parameters.Add("@PNCombinationAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNCombinationAuthors")
                cmd.Parameters.Add("@PNPublishedIn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNPublishedIn")
                cmd.Parameters.Add("@PNReferenceId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReferenceId")
                cmd.Parameters.Add("@PNReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNReferenceFk")
                cmd.Parameters.Add("@PNYear", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNYear")
                cmd.Parameters.Add("@PNMicroReference", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNMicroReference")
                cmd.Parameters.Add("@PNTypeVoucher", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNTypeVoucher")
                cmd.Parameters.Add("@PNTypeName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNTypeName")
                cmd.Parameters.Add("@PNTypeNameId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNTypeNameId")
                cmd.Parameters.Add("@PNTypeNameFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNTypeNameFk")
                cmd.Parameters.Add("@PNOrthography", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNOrthography")
                cmd.Parameters.Add("@PNBasionym", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionym")
                cmd.Parameters.Add("@PNBasionymId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasionymId")
                cmd.Parameters.Add("@PNBasionymFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBasionymFk")
                cmd.Parameters.Add("@PNBasedOn", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasedOn")
                cmd.Parameters.Add("@PNBasedOnId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBasedOnId")
                cmd.Parameters.Add("@PNBasedOnFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBasedOnFk")
                cmd.Parameters.Add("@PNConservedAgainst", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNConservedAgainst")
                cmd.Parameters.Add("@PNConservedAgainstId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNConservedAgainstId")
                cmd.Parameters.Add("@PNConservedAgainstFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNConservedAgainstFk")
                cmd.Parameters.Add("@PNHomonymOf", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNHomonymOf")
                cmd.Parameters.Add("@PNHomonymOfId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNHomonymOfId")
                cmd.Parameters.Add("@PNHomonymOfFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNHomonymOfFk")
                cmd.Parameters.Add("@PNReplacementFor", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReplacementFor")
                cmd.Parameters.Add("@PNReplacementForId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNReplacementForId")
                cmd.Parameters.Add("@PNReplacementForFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNReplacementForFk")
                cmd.Parameters.Add("@PNBlocking", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBlocking")
                cmd.Parameters.Add("@PNBlockingId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNBlockingId")
                cmd.Parameters.Add("@PNBlockingFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PNBlockingFk")
                cmd.Parameters.Add("@PNInCitation", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNInCitation")
                cmd.Parameters.Add("@PNInvalid", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNInvalid")
                cmd.Parameters.Add("@PNIllegitimate", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNIllegitimate")
                cmd.Parameters.Add("@PNMisapplied", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNMisapplied")
                cmd.Parameters.Add("@PNProParte", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "PNProParte")
                cmd.Parameters.Add("@PNGeographyText", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNGeographyText")
                cmd.Parameters.Add("@PNGeographyCodes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNGeographyCodes")
                cmd.Parameters.Add("@PNClimate", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNClimate")
                cmd.Parameters.Add("@PNLifeform", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNLifeform")
                cmd.Parameters.Add("@PNIUCN", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNIUCN")
                cmd.Parameters.Add("@PNNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNNotes")
                cmd.Parameters.Add("@PNStatusNotes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNStatusNotes")
                cmd.Parameters.Add("@PNNonNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNNonNotes")
                cmd.Parameters.Add("@PNQualityStatement", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PNQualityStatement")
                cmd.Parameters.Add("@PNNameVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNNameVersion")
                cmd.Parameters.Add("@PNCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNCreatedDate")
                cmd.Parameters.Add("@PNCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNCreatedBy")
                cmd.Parameters.Add("@PNUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PNUpdatedDate")
                cmd.Parameters.Add("@PNUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PNUpdatedBy")
                cmd.Parameters.Add("@ChangedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ChangedDate")
                cmd.Parameters.Add("@ChangedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ChangedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderOtherData(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderOtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "POtherDataTextPk")
                cmd.Parameters.Add("@providerImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "POtherDataProviderImportFk")
                cmd.Parameters.Add("@dataType", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataType")
                cmd.Parameters.Add("@dataName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataName")
                cmd.Parameters.Add("@dataRecordId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataRecordId")
                cmd.Parameters.Add("@dataVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataVersion")
                cmd.Parameters.Add("@data", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "POtherDataData")
                cmd.Parameters.Add("@xml", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "POtherDataXml")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "POtherDataCreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataCreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "POtherDataUpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderReference(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRPk")
                cmd.Parameters.Add("@PRProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRProviderImportFk")
                cmd.Parameters.Add("@PRReferenceId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRReferenceId")
                cmd.Parameters.Add("@PRReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PRReferenceFk")
                cmd.Parameters.Add("@PRLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRLinkStatus")
                cmd.Parameters.Add("@PRCitation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRCitation")
                cmd.Parameters.Add("@PRFullCitation", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PRFullCitation")
                cmd.Parameters.Add("@PRXML", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PRXML")
                cmd.Parameters.Add("@PRReferenceVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRReferenceVersion")
                cmd.Parameters.Add("@PRCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRCreatedDate")
                cmd.Parameters.Add("@PRCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRCreatedBy")
                cmd.Parameters.Add("@PRUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRUpdatedDate")
                cmd.Parameters.Add("@PRUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderReferenceChange(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderReferenceChange"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRPk")
                cmd.Parameters.Add("@PRProviderImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRProviderImportFk")
                cmd.Parameters.Add("@PRReferenceId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRReferenceId")
                cmd.Parameters.Add("@PRReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "PRReferenceFk")
                cmd.Parameters.Add("@PRLinkStatus", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRLinkStatus")
                cmd.Parameters.Add("@PRCitation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRCitation")
                cmd.Parameters.Add("@PRFullCitation", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PRFullCitation")
                cmd.Parameters.Add("@PRXML", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "PRXML")
                cmd.Parameters.Add("@PRReferenceVersion", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRReferenceVersion")
                cmd.Parameters.Add("@PRCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRCreatedDate")
                cmd.Parameters.Add("@PRCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRCreatedBy")
                cmd.Parameters.Add("@PRUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRUpdatedDate")
                cmd.Parameters.Add("@PRUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRUpdatedBy")
                cmd.Parameters.Add("@ChangedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ChangedDate")
                cmd.Parameters.Add("@ChangedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ChangedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderRIS(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderRIS"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRISPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISPk")
                cmd.Parameters.Add("@PRISProviderReferenceFK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISProviderReferencefk")
                cmd.Parameters.Add("@PRISRISFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISRISFk")
                cmd.Parameters.Add("@PRISId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISId")
                cmd.Parameters.Add("@PRISType", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISType")
                cmd.Parameters.Add("@PRISAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors")
                cmd.Parameters.Add("@PRISTitle", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle")
                cmd.Parameters.Add("@PRISDate", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISDate")
                cmd.Parameters.Add("@PRISNotes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISNotes")
                cmd.Parameters.Add("@PRISKeywords", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISKeywords")
                cmd.Parameters.Add("@PRISStartPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISStartPage")
                cmd.Parameters.Add("@PRISEndPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISEndPage")
                cmd.Parameters.Add("@PRISJournalName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISJournalName")
                cmd.Parameters.Add("@PRISStandardAbbreviation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISStandardAbbreviation")
                cmd.Parameters.Add("@PRISVolume", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISVolume")
                cmd.Parameters.Add("@PRISIssue", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISIssue")
                cmd.Parameters.Add("@PRISCityOfPublication", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISCityOfPublication")
                cmd.Parameters.Add("@PRISPublisher", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISPublisher")
                cmd.Parameters.Add("@PRISISSNNumber", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISISSNNumber")
                cmd.Parameters.Add("@PRISWebUrl", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISWebUrl")
                cmd.Parameters.Add("@PRISTitle2", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle2")
                cmd.Parameters.Add("@PRISTitle3", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle3")
                cmd.Parameters.Add("@PRISAuthors2", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors2")
                cmd.Parameters.Add("@PRISAuthors3", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors3")
                cmd.Parameters.Add("@PRISCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRISCreatedDate")
                cmd.Parameters.Add("@PRISCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISCreatedBy")
                cmd.Parameters.Add("@PRISUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRISUpdatedDate")
                cmd.Parameters.Add("@PRISUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateProviderRISChange(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ProviderRISChange"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PRISPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISPk")
                cmd.Parameters.Add("@PRISProviderReferenceFK", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISProviderReferencefk")
                cmd.Parameters.Add("@PRISRISFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "PRISRISFk")
                cmd.Parameters.Add("@PRISId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISId")
                cmd.Parameters.Add("@PRISType", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISType")
                cmd.Parameters.Add("@PRISAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors")
                cmd.Parameters.Add("@PRISTitle", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle")
                cmd.Parameters.Add("@PRISDate", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISDate")
                cmd.Parameters.Add("@PRISNotes", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISNotes")
                cmd.Parameters.Add("@PRISKeywords", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISKeywords")
                cmd.Parameters.Add("@PRISStartPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISStartPage")
                cmd.Parameters.Add("@PRISEndPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISEndPage")
                cmd.Parameters.Add("@PRISJournalName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISJournalName")
                cmd.Parameters.Add("@PRISStandardAbbreviation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISStandardAbbreviation")
                cmd.Parameters.Add("@PRISVolume", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISVolume")
                cmd.Parameters.Add("@PRISIssue", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISIssue")
                cmd.Parameters.Add("@PRISCityOfPublication", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISCityOfPublication")
                cmd.Parameters.Add("@PRISPublisher", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISPublisher")
                cmd.Parameters.Add("@PRISISSNNumber", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISISSNNumber")
                cmd.Parameters.Add("@PRISWebUrl", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISWebUrl")
                cmd.Parameters.Add("@PRISTitle2", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle2")
                cmd.Parameters.Add("@PRISTitle3", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISTitle3")
                cmd.Parameters.Add("@PRISAuthors2", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors2")
                cmd.Parameters.Add("@PRISAuthors3", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISAuthors3")
                cmd.Parameters.Add("@PRISCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRISCreatedDate")
                cmd.Parameters.Add("@PRISCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISCreatedBy")
                cmd.Parameters.Add("@PRISUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "PRISUpdatedDate")
                cmd.Parameters.Add("@PRISUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "PRISUpdatedBy")
                cmd.Parameters.Add("@ChangedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ChangedDate")
                cmd.Parameters.Add("@ChangedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ChangedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateReference(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Reference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@ReferenceGuid", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "ReferenceGuid")
                cmd.Parameters.Add("@ReferenceLSID", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ReferenceLSID")
                cmd.Parameters.Add("@ReferenceCitation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ReferenceCitation")
                cmd.Parameters.Add("@ReferenceFullCitation", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "ReferenceFullCitation")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ReferenceCreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ReferenceCreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "ReferenceUpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "ReferenceUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateReferenceRIS(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_ReferenceRIS"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@RISPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "RISPk")
                cmd.Parameters.Add("@RISReferenceFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "RISReferenceFk")
                cmd.Parameters.Add("@RISId", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISId")
                cmd.Parameters.Add("@RISType", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISType")
                cmd.Parameters.Add("@RISTitle", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "RISTitle")
                cmd.Parameters.Add("@RISAuthors", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISAuthors")
                cmd.Parameters.Add("@RISDate", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISDate")
                cmd.Parameters.Add("@RISNotes", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "RISNotes")
                cmd.Parameters.Add("@RISKeywords", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISKeywords")
                cmd.Parameters.Add("@RISStartPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISStartPage")
                cmd.Parameters.Add("@RISEndPage", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISEndPage")
                cmd.Parameters.Add("@RISJournalName", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISJournalName")
                cmd.Parameters.Add("@RISStandardAbbreviation", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISStandardAbbreviation")
                cmd.Parameters.Add("@RISVolume", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISVolume")
                cmd.Parameters.Add("@RISIssue", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISIssue")
                cmd.Parameters.Add("@RISCityOfPublication", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISCityOfPublication")
                cmd.Parameters.Add("@RISPublisher", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISPublisher")
                cmd.Parameters.Add("@RISSNNumber", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISSNNumber")
                cmd.Parameters.Add("@RISWebUrl", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISWebUrl")
                cmd.Parameters.Add("@RISTitle2", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "RISTitle2")
                cmd.Parameters.Add("@RISTitle3", SqlDbType.NText).Value = GetRowValue(row, SqlDbType.NText, "RISTitle3")
                cmd.Parameters.Add("@RISAuthors2", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISAuthors2")
                cmd.Parameters.Add("@RISAuthors3", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISAuthors3")
                cmd.Parameters.Add("@RISCreatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "RISCreatedDate")
                cmd.Parameters.Add("@RISCreatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISCreatedBy")
                cmd.Parameters.Add("@RISUpdatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "RISUpdatedDate")
                cmd.Parameters.Add("@RISUpdatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RISUpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateOtherData(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_OtherData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataPk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "OtherDataPk")
                cmd.Parameters.Add("@otherDataTypeFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "OtherDataTypeFk")
                cmd.Parameters.Add("@recordFk", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "RecordFk")
                cmd.Parameters.Add("@xml", SqlDbType.Xml).Value = GetRowValue(row, SqlDbType.Xml, "OtherDataXml")
                cmd.Parameters.Add("@data", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "OtherDataData")
                cmd.Parameters.Add("@createdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "CreatedDate")
                cmd.Parameters.Add("@createdBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "CreatedBy")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateTransformation(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_Transformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@transformationPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "TransformationPk")
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Name")
                cmd.Parameters.Add("@description", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Description")
                cmd.Parameters.Add("@xslt", SqlDbType.Xml).Value = GetRowValue(row, SqlDbType.Xml, "Xslt")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateStandardOutput(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_StandardOutput"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@stdOutputPk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "StandardOutputPk")
                cmd.Parameters.Add("@potherdatafk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "POtherDataFk")
                cmd.Parameters.Add("@otherTypeFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "OtherTypeFk")
                cmd.Parameters.Add("@stdXml", SqlDbType.Xml).Value = GetRowValue(row, SqlDbType.Xml, "StandardXml")
                cmd.Parameters.Add("@stdDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "StandardDate")
                cmd.Parameters.Add("@userForConsensus", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "UseForConsensus")
                cmd.Parameters.Add("@otherDataFk", SqlDbType.UniqueIdentifier).Value = GetRowValue(row, SqlDbType.UniqueIdentifier, "OtherDataFk")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateOtherDataTransformation(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_OtherDataTransformation"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerImportFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ProviderImportFk")
                cmd.Parameters.Add("@potherDataType", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "POtherDataType")
                cmd.Parameters.Add("@useDataXml", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "UseDataXml")
                cmd.Parameters.Add("@transformationFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "TransformationFk")
                cmd.Parameters.Add("@addRoot", SqlDbType.Bit).Value = GetRowValue(row, SqlDbType.Bit, "AddRoot")
                cmd.Parameters.Add("@outputTypeFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "OutputTypeFk")
                cmd.Parameters.Add("@runDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "RunDate")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertUpdateOtherDataType(ByVal row As DataRow)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprTransferInsertUpdate_OtherDataType"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@otherDataTypePk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "OtherDataTypePk")
                cmd.Parameters.Add("@name", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "Name")
                cmd.Parameters.Add("@consTransformationFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "ConsensusTransformationFk")
                cmd.Parameters.Add("@webTransformationFk", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "WebTransformationFk")
                cmd.Parameters.Add("@webSequence", SqlDbType.Int).Value = GetRowValue(row, SqlDbType.Int, "WebSequence")
                cmd.Parameters.Add("@displayTab", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "DisplayTab")
                cmd.Parameters.Add("@updatedDate", SqlDbType.DateTime).Value = GetRowValue(row, SqlDbType.DateTime, "UpdatedDate")
                cmd.Parameters.Add("@updatedBy", SqlDbType.NVarChar).Value = GetRowValue(row, SqlDbType.NVarChar, "UpdatedBy")

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

#End Region

End Class
