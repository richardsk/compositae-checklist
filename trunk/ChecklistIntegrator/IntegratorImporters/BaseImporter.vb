Imports System.Windows.Forms

Imports ChecklistObjects
Imports ChecklistBusinessRules
Imports ChecklistDataAccess

Public Class BaseImporter

    Public Enum ETreatFalseAsNull
        None = 0
        NameInvalid = 1
        NameIllegitimate = 2
        NameMisapplied = 4
        NameProParte = 8
        NameInCitation = 16
    End Enum

    Public Delegate Sub StatusDelegate(ByVal percComplete As Integer, ByVal msg As String)

    Public StatusCallback As StatusDelegate
    Public Success As Boolean = False
    Public ImportType As ImportType
    Public ProvImport As ProviderImport
    Public Provider As Provider
    Public Cancel As Boolean = False
    Public TreatFalseAsNull As ETreatFalseAsNull = ETreatFalseAsNull.None

    Protected PercentComplete As Integer '0 to 100

    Public ReadOnly Property Complete() As Boolean
        Get
            Return (PercentComplete = 100)
        End Get
    End Property

    Public Overridable Sub ImportFile()
    End Sub

    Protected Sub PostStatusMessage(ByVal percComplete As Integer, ByVal msg As String)
        If Not StatusCallback Is Nothing Then
            StatusCallback.Invoke(percComplete, msg)
        End If
    End Sub

    ''' <summary>
    ''' Save dataset of provider names or references
    ''' </summary>
    ''' <param name="providerRecords"></param>
    ''' <remarks>
    ''' Dataset contains tblProviderReference and tblProviderRIS or tblProviderName and tblProviderConcept tables. 
    ''' If a record already exists from a previous import then the record is updated with any new non-null values
    ''' </remarks>
    Protected Sub SaveImportedDataset(ByVal providerRecords As DataSet)

        Try
            'insert provider import record
            ChecklistDataAccess.ImportData.InsertUpdateProviderImport(ProvImport, SessionState.CurrentUser.Login)

            Dim recordCount As Integer = 0
            Dim recordPosition As Integer = 0

            Dim table As DataTable
            Dim tableName As String = ""
            If ImportType.ObjectType = ImportType.ObjectTypeName Then
                If providerRecords.Tables.Contains("tblProviderName") Then recordCount += providerRecords.Tables("tblProviderName").Rows.Count
                If providerRecords.Tables.Contains("tblProviderConcept") Then recordCount += providerRecords.Tables("tblProviderConcept").Rows.Count
                If providerRecords.Tables.Contains("tblProviderConceptRelationship") Then recordCount += providerRecords.Tables("tblProviderConceptRelationship").Rows.Count
                table = providerRecords.Tables("tblProviderName")
                tableName = "tblProviderName"
            ElseIf ImportType.ObjectType = ImportType.ObjectTypeReference Then
                If providerRecords.Tables.Contains("tblProviderReference") Then recordCount += providerRecords.Tables("tblProviderReference").Rows.Count
                If providerRecords.Tables.Contains("tblProviderRIS") Then recordCount += providerRecords.Tables("tblProviderRIS").Rows.Count
                table = providerRecords.Tables("tblProviderReference")
                tableName = "tblProviderReference"
            ElseIf ImportType.ObjectType = ImportType.ObjectTypeOtherData Then
                If providerRecords.Tables.Contains("tblProviderOtherData") Then recordCount += providerRecords.Tables("tblProviderOtherData").Rows.Count
                table = providerRecords.Tables("tblProviderOtherData")
                tableName = "tblProviderOtherData"
            ElseIf ImportType.ObjectType = ImportType.ObjectTypeAll Then
                If providerRecords.Tables.Contains("tblProviderName") Then recordCount += providerRecords.Tables("tblProviderName").Rows.Count
                If providerRecords.Tables.Contains("tblProviderConcept") Then recordCount += providerRecords.Tables("tblProviderConcept").Rows.Count
                If providerRecords.Tables.Contains("tblProviderConceptRelationship") Then recordCount += providerRecords.Tables("tblProviderConceptRelationship").Rows.Count
                If providerRecords.Tables.Contains("tblProviderReference") Then recordCount += providerRecords.Tables("tblProviderReference").Rows.Count
                If providerRecords.Tables.Contains("tblProviderRIS") Then recordCount += providerRecords.Tables("tblProviderRIS").Rows.Count
                If providerRecords.Tables.Contains("tblProviderOtherData") Then recordCount += providerRecords.Tables("tblProviderOtherData").Rows.Count
                table = providerRecords.Tables("tblProviderName")
                tableName = "tblProviderName"
            End If


            Dim done As Boolean = False
            While Not done

                If table IsNot Nothing Then
                    For Each row As DataRow In table.Rows
                        If Cancel Then
                            PercentComplete = 100
                            Success = False
                            PostStatusMessage(PercentComplete, "Cancelled")
                            Exit Sub
                        Else
                            recordPosition += 1
                            PercentComplete = 10 + (recordPosition / recordCount * 90) '10 percent was done in loading
                            If PercentComplete > 99 Then PercentComplete = 99 ' cant be greater than 99 until DONE

                            Dim cnn As SqlClient.SqlConnection
                            Dim trans As SqlClient.SqlTransaction
                            Try
                                cnn = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString)
                                cnn.Open()
                                trans = cnn.BeginTransaction()

                                'insert new record
                                InsertUpdateRecord(trans, row)

                                trans.Commit()

                                PostStatusMessage(PercentComplete, "")
                            Catch ex As Exception
                                If Not trans Is Nothing Then trans.Rollback()
                                Dim msg As String = "ERROR importing record at position : " + recordPosition.ToString() + " : " + ex.Message
                                PostStatusMessage(PercentComplete, msg)
                                ChecklistException.LogError(ex)
                            Finally
                                If Not cnn Is Nothing Then cnn.Close()
                            End Try
                        End If
                    Next
                End If

                If ImportType.ObjectType = ImportType.ObjectTypeName Then
                    If tableName = "tblProviderName" Then
                        table = providerRecords.Tables("tblProviderConcept")
                        tableName = "tblProviderConcept"
                    ElseIf tableName = "tblProviderConcept" Then
                        table = providerRecords.Tables("tblProviderConceptRelationship")
                        tableName = "tblProviderConceptRelationship"
                    Else
                        done = True
                    End If
                ElseIf ImportType.ObjectType = ImportType.ObjectTypeReference Then
                    If tableName = "tblProviderReference" Then
                        table = providerRecords.Tables("tblProviderRIS")
                        tableName = "tblProviderRIS"
                    Else
                        done = True
                    End If
                ElseIf ImportType.ObjectType = ImportType.ObjectTypeAll Then
                    If tableName = "tblProviderName" Then
                        table = providerRecords.Tables("tblProviderConcept")
                        tableName = "tblProviderConcept"
                    ElseIf tableName = "tblProviderConcept" Then
                        table = providerRecords.Tables("tblProviderConceptRelationship")
                        tableName = "tblProviderConceptRelationship"
                    ElseIf tableName = "tblProviderConceptRelationship" Then
                        table = providerRecords.Tables("tblProviderReference")
                        tableName = "tblProviderReference"
                    ElseIf tableName = "tblProviderReference" Then
                        table = providerRecords.Tables("tblProviderRIS")
                        tableName = "tblProviderRIS"
                    ElseIf tableName = "tblProviderRIS" Then
                        table = providerRecords.Tables("tblProviderOtherData")
                        tableName = "tblProviderOtherData"
                    Else
                        done = True
                    End If
                Else
                    done = True
                End If

            End While

            'status message for success/failure + perc complete
            PercentComplete = 100
            Success = True
            PostStatusMessage(PercentComplete, "SUCCESS")
        Catch ex As Exception
            ChecklistException.LogError(ex)
            PercentComplete = 100
            Success = False
            PostStatusMessage(PercentComplete, "FAILED")
        End Try

    End Sub

    Private Sub InsertUpdateRecord(ByVal trans As SqlClient.SqlTransaction, ByVal row As DataRow)
        If row.Table.TableName = "tblProviderName" Then
            Dim pn As New ProviderName(row, -1, False)

            'get existing record?
            Dim updatePN As ProviderName
            If row.Table.Columns.Contains("PNNameId") Then updatePN = NameData.GetProviderName(Provider.IdAsInt, row("PNNameId").ToString)
            If updatePN IsNot Nothing AndAlso updatePN.PNNameFk IsNot Nothing Then
                updatePN.UpdateFieldsFromProviderName(pn)
                Dim oldId As String = updatePN.PNNameFk
                'we need to refresh the name that thie provider name was connected to (for those cases
                'where the prov name will now connect to a different consensus name
                'BUT only if there is more than one PN attached to this name (non editor name)
                Dim sysName As ProviderName = NameData.GetSystemProviderNameForName(oldId)
                Dim pns As DataSet = NameData.GetProviderNameRecords(oldId)
                If pns.Tables.Count > 0 AndAlso _
                    (pns.Tables(0).Rows.Count > 2 Or (pns.Tables(0).Rows.Count = 2 And sysName Is Nothing)) Then

                    updatePN.PNLinkStatus = LinkStatus.Unmatched.ToString 'reset so it will be relinked
                    updatePN.PNNameFk = Nothing
                End If

                BrNames.RefreshNameData(oldId, True)
            Else
                updatePN = pn
                updatePN.PNLinkStatus = LinkStatus.Unmatched.ToString
            End If
            updatePN.PNProviderImportFk = ProvImport.IdAsInt

            'treat false as null?
            If (TreatFalseAsNull And ETreatFalseAsNull.NameInvalid) = ETreatFalseAsNull.NameInvalid Then
                If updatePN.PNInvalid.IsFalse Then updatePN.PNInvalid = SqlTypes.SqlBoolean.Null
            End If
            If (TreatFalseAsNull And ETreatFalseAsNull.NameIllegitimate) = ETreatFalseAsNull.NameIllegitimate Then
                If updatePN.PNIllegitimate.IsFalse Then updatePN.PNIllegitimate = SqlTypes.SqlBoolean.Null
            End If
            If (TreatFalseAsNull And ETreatFalseAsNull.NameMisapplied) = ETreatFalseAsNull.NameMisapplied Then
                If updatePN.PNMisapplied.IsFalse Then updatePN.PNMisapplied = SqlTypes.SqlBoolean.Null
            End If
            If (TreatFalseAsNull And ETreatFalseAsNull.NameProParte) = ETreatFalseAsNull.NameProParte Then
                If updatePN.PNProParte.IsFalse Then updatePN.PNProParte = SqlTypes.SqlBoolean.Null
            End If
            If (TreatFalseAsNull And ETreatFalseAsNull.NameInCitation) = ETreatFalseAsNull.NameInCitation Then
                If updatePN.PNInCitation.IsFalse Then updatePN.PNInCitation = SqlTypes.SqlBoolean.Null
            End If

            'update name
            ChecklistDataAccess.NameData.InsertUpdateProviderNameRecord(trans, updatePN, SessionState.CurrentUser.Login)

            'set rank so integration order can be done in rank top down order
            updatePN.PNNameRankFk = NameData.LinkProviderNameRank(trans, updatePN.IdAsInt, SessionState.CurrentUser.Login)
        End If

        If row.Table.TableName = "tblProviderConcept" Then
            Dim pc As New ProviderConcept(row, -1)

            'get existing record?
            Dim updateC As ProviderConcept
            If row.Table.Columns.Contains("PCConceptId") Then updateC = ConceptData.GetProviderConcept(Provider.IdAsInt, row("PCConceptId").ToString)
            If updateC IsNot Nothing Then
                updateC.UpdateFieldsFromProviderConcept(pc)
                updateC.PCLinkStatus = LinkStatus.Unmatched.ToString 'reset so it will be relinked when integration is done
                updateC.PCConceptFk = -1
            Else
                updateC = pc
                updateC.PCLinkStatus = LinkStatus.Unmatched.ToString
            End If
            updateC.PCProviderImportFk = ProvImport.IdAsInt

            'update concept
            ConceptData.InsertUpdateProviderConcept(trans, updateC, SessionState.CurrentUser.Login)

        End If

        If row.Table.TableName = "tblProviderConceptRelationship" Then
            Dim pcr As New ProviderConceptRelationship(row, -1)

            'get existing record?
            Dim updateCR As ProviderConceptRelationship = Nothing
            If row.Table.Columns.Contains("PCRId") Then
                updateCR = ConceptData.GetProviderConceptRelationshipById(Provider.IdAsInt, row("PCRId").ToString)
            End If
            If updateCR Is Nothing AndAlso row.Table.Columns.Contains("PCRConcept1Id") AndAlso row.Table.Columns.Contains("PCRConcept2Id") AndAlso row.Table.Columns.Contains("PCRRelationship") Then
                updateCR = ConceptData.GetProviderConceptRelationship(Provider.IdAsInt, row("PCRConcept1Id").ToString, row("PCRConcept2Id").ToString(), row("PCRRelationship").ToString)
            End If
            If updateCR IsNot Nothing Then
                updateCR.UpdateFieldsFromProviderConceptRelationship(pcr)
                updateCR.PCRLinkStatus = LinkStatus.Unmatched.ToString 'reset so it will be relinked when integration is done
                updateCR.PCRConceptRelationshipFk = Nothing
            Else
                updateCR = pcr
                updateCR.PCRLinkStatus = LinkStatus.Unmatched.ToString
            End If
            updateCR.PCRProviderImportFk = ProvImport.IdAsInt

            'update concept
            ConceptData.InsertUpdateProviderConceptRelationship(trans, updateCR, SessionState.CurrentUser.Login)

            'link relationship type for when we integrate names (need to know the parent concept linkage to integarte a name)
            updateCR.PCRRelationshipFk = NameData.LinkProviderConceptRelationship(trans, updateCR.IdAsInt, SessionState.CurrentUser.Login)
        End If

        If row.Table.TableName = "tblProviderReference" Then
            Dim r As New ProviderReference(row, -1)

            'get existing record?
            Dim updateRef As ProviderReference
            If row.Table.Columns.Contains("PRReferenceId") Then updateRef = ReferenceData.GetProviderReference(Provider.IdAsInt, row("PRReferenceId").ToString)
            If updateRef IsNot Nothing Then
                updateRef.UpdatedFieldsFromProviderReference(r)
                updateRef.PRLinkStatus = LinkStatus.Unmatched.ToString
                updateRef.PRReferenceFk = Nothing
            Else
                updateRef = r
                updateRef.PRLinkStatus = LinkStatus.Unmatched.ToString
            End If
            updateRef.PRProviderImportFk = ProvImport.IdAsInt

            ChecklistDataAccess.ReferenceData.InsertProviderReferenceRecord(trans, updateRef, SessionState.CurrentUser.Login)
        End If

        If row.Table.TableName = "tblProviderRIS" Then
            Dim r As New ProviderRIS(row, -1)

            'get existing record?
            Dim updateRis As ProviderRIS = ReferenceData.GetProviderRIS(row("PRISId").ToString)
            If updateRis IsNot Nothing Then
                updateRis.UpdatedFieldsFromProviderRIS(r)
                updateRis.PRISRISFk = -1
            Else
                updateRis = r
            End If

            ChecklistDataAccess.ReferenceData.InsertUpdateProviderRISRecord(trans, row("PRISId").ToString, updateRis, SessionState.CurrentUser.Login)
        End If

        If row.Table.TableName = "tblProviderOtherData" Then
            'delete existing record
            OtherData.DeleteProviderOtherData(trans, Provider.IdAsInt, row("POtherDataRecordId").ToString)
            'insert update
            OtherData.InsertUpdateProviderOtherData(trans, ProvImport.IdAsInt, row, SessionState.CurrentUser.Login)
        End If

    End Sub

End Class
