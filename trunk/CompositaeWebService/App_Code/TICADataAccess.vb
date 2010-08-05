Imports Microsoft.VisualBasic
Imports System.Data

Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class TICADataAccess

#Region "Private functions"

    Private Shared Sub UpdateNameLSIDs(ByVal ds As DataSet, ByVal tableName As String)

        If ds.Tables.Contains(tableName) Then
            For Each row As DataRow In ds.Tables(tableName).Rows
                'fix LSIDs uppercase GUID thing
                row("NameLSID") = Name.CreateLSID(row("NameGUID").ToString())

                If row("NameParentFk") IsNot DBNull.Value Then
                    row("NameParentFk") = Name.CreateLSID(row("NameParentFk").ToString)
                End If

                If row("NamePreferredFk") IsNot DBNull.Value Then
                    row("NamePreferredFk") = Name.CreateLSID(row("NamePreferredFk").ToString)
                End If

                If row("NameTypeNameFk") IsNot DBNull.Value Then
                    row("NameTypeNameFk") = Name.CreateLSID(row("NameTypeNameFk").ToString)
                End If

                If row("NameBasionymFk") IsNot DBNull.Value Then
                    row("NameBasionymFk") = Name.CreateLSID(row("NameBasionymFk").ToString)
                End If

                If row("NameBasedOnFk") IsNot DBNull.Value Then
                    row("NameBasedOnFk") = Name.CreateLSID(row("NameBasedOnFk").ToString)
                End If

                If row("NameConservedAgainstFk") IsNot DBNull.Value Then
                    row("NameConservedAgainstFk") = Name.CreateLSID(row("NameConservedAgainstFk").ToString)
                End If

                If row("NameHomonymOfFk") IsNot DBNull.Value Then
                    row("NameHomonymOfFk") = Name.CreateLSID(row("NameHomonymOfFk").ToString)
                End If

                If row("NameReplacementForFk") IsNot DBNull.Value Then
                    row("NameReplacementForFk") = Name.CreateLSID(row("NameReplacementForFk").ToString)
                End If
            Next
        End If

        If ds.Tables.Contains("ProviderName") Then
            For Each row As DataRow In ds.Tables("ProviderName").Rows
                row("PNNameFk") = Name.CreateLSID(row("PNNameFk").ToString)
                row("PNReferenceFk") = Reference.CreateLSID(row("PNReferenceFk").ToString)
            Next
        End If
    End Sub

    Private Shared Sub UpdateReferenceLSIDs(ByVal ds As DataSet)
        If ds.Tables.Contains("Name") Then
            For Each r As DataRow In ds.Tables("Name").Rows
                r("NameReferenceFk") = Reference.CreateLSID(r("NameReferenceFk").ToString)
            Next
        End If

        If ds.Tables.Contains("Reference") Then
            'fix LSIDs uppercase GUID thing
            For Each r As DataRow In ds.Tables("Reference").Rows
                r("ReferenceLSID") = Reference.CreateLSID(r("ReferenceGuid").ToString())
            Next
        End If

        If ds.Tables.Contains("ReferenceRIS") Then
            For Each row As DataRow In ds.Tables("ReferenceRIS").Rows
                row("RISReferenceFk") = Reference.CreateLSID(row("RISReferenceFk"))
            Next
        End If

        If ds.Tables.Contains("ProviderReference") Then
            For Each row As DataRow In ds.Tables("ProviderReference").Rows
                row("PRReferenceFk") = Reference.CreateLSID(row("PRReferenceFk"))
            Next
        End If

        If ds.Tables.Contains("Concept") Then
            For Each row As DataRow In ds.Tables("Concept").Rows
                row("ConceptAccordingToFk") = Reference.CreateLSID(row("ConceptAccordingToFk").ToString)
            Next
        End If

    End Sub

    Private Shared Sub UpdatedConceptLSIDs(ByVal ds As DataSet)
        If ds.Tables.Contains("Concept") Then
            For Each r As DataRow In ds.Tables("Concept").Rows
                'fix LSIDs uppercase GUID thing
                r("ConceptLSID") = Reference.CreateLSID(r("ConceptPk").ToString())

                r("ConceptName1Fk") = Name.CreateLSID(r("ConceptName1Fk").ToString)
            Next
        End If

        If ds.Tables.Contains("ConceptRelationship") Then
            ds.Tables("ConceptRelationship").Columns.Add("ConceptRelationshipConcept1LSID")
            ds.Tables("ConceptRelationship").Columns.Add("ConceptRelationshipConcept2LSID")
            For Each row As DataRow In ds.Tables("ConceptRelationship").Rows
                'fix guid
                row("ConceptRelationshipGuid") = row("ConceptRelationshipGuid").ToString().ToUpper()
                row("ConceptRelationshipConcept1LSID") = ConceptRelationship.CreateLSID(row("ConceptRelationshipConcept1Fk"))
                row("ConceptRelationshipConcept2LSID") = ConceptRelationship.CreateLSID(row("ConceptRelationshipConcept2Fk"))
            Next
        End If

        If ds.Tables.Contains("ProviderConcept") Then
            ds.Tables("ProviderConcept").Columns.Add("PCConceptLSID")
            For Each r As DataRow In ds.Tables("ProviderConcept").Rows
                r("PCConceptLSID") = Concept.CreateLSID(r("PCConceptFk").ToString())
            Next
        End If

        If ds.Tables.Contains("ProviderConceptRelationship") Then
            For Each row As DataRow In ds.Tables("ProviderConceptRelationship").Rows
                row("PCRConceptRelationshipFk") = ConceptRelationship.CreateLSID(row("PCRConceptRelationshipFk"))
            Next
        End If
    End Sub

    Private Shared Sub GetReference(ByVal ds As DataSet, ByVal row As DataRow, ByVal field As String)
        If row(field) IsNot DBNull.Value Then
            Dim refId As String = row(field).ToString()

            Dim ref As DataRow() = Nothing
            If ds.Tables.Contains("Reference") Then
                ref = ds.Tables("Reference").Select("ReferenceGuid = '" + refId + "'")
            End If
            If ref Is Nothing OrElse ref.Length = 0 Then
                Dim refDs As DataSet = ReferenceData.GetReferenceDs(refId)
                refDs.Tables(0).TableName = "Reference"
                ds.Merge(refDs)
                refDs = ReferenceData.GetReferenceRISByReferenceDs(refId)
                refDs.Tables(0).TableName = "ReferenceRIS"
                ds.Merge(refDs)
            End If

        End If
    End Sub

    Private Shared Sub GetProviderName(ByVal ticaDs As DataSet, ByVal pnpk As Integer)
        Dim ds As DataSet = NameData.GetProviderNameDs(pnpk)

        Dim providerPk As Integer = ds.Tables(0).Rows(0)("ProviderPk")

        ds.Tables(0).Columns.Add("PNRankSort", GetType(Integer))
        ds.Tables(0).Columns.Add("PNRankTCS")
        Dim rnk As Integer = -1
        If Not ds.Tables(0).Rows(0).IsNull("PNNameRankFk") Then rnk = ds.Tables(0).Rows(0)("PNNameRankFk")
        ds.Tables(0).Rows(0)("PNRankSort") = RankData.GetRankSort(rnk)
        ds.Tables(0).Rows(0)("PNRankTCS") = RankData.GetRankTCS(rnk)
        ds.Tables(0).TableName = "ProviderName"

        ticaDS.Merge(ds)

        ds = ConceptData.GetProviderConceptData(pnpk)
        If ds.Tables.Count > 0 Then
            ds.Tables(0).TableName = "ProviderConcept"

            If ds.Tables.Count > 1 Then
                ds.Tables(1).TableName = "ProviderConceptRelationship"
            End If
            ticaDS.Merge(ds)
        End If

        If ticaDs.Tables("ProviderName").Rows(0)("PNReferenceId") IsNot DBNull.Value Then
            If Not ticaDs.Tables("ProviderName").Columns.Contains("PRPk") Then
                ticaDs.Tables("ProviderName").Columns.Add("PRPk", GetType(Integer))
            End If

            ds = ReferenceData.GetProviderReferenceDs(providerPk, ticaDs.Tables("ProviderName").Rows(0)("PNReferenceId").ToString)
            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                ds.Tables(0).TableName = "ProviderReference"
                ticaDs.Merge(ds)

                ticaDs.Tables("ProviderName").Rows(0)("PRPk") = ds.Tables(0).Rows(0)("PRPk")
            End If
            Dim risds As DataSet = ReferenceData.GetProviderRISByReferenceDs(ds.Tables(0).Rows(0)("PRPk"))
            If risds.Tables.Count > 0 Then
                risds.Tables(0).TableName = "ProviderReferenceRIS"
                ticaDs.Merge(risds)
            End If
        End If

        If Not ticaDs.Tables("ProviderConcept").Columns.Contains("PRPk") Then
            ticaDs.Tables("ProviderConcept").Columns.Add("PRPk", GetType(Integer))
        End If
        For Each row As DataRow In ticaDs.Tables("ProviderConcept").Rows
            If row("PCAccordingToId") IsNot DBNull.Value Then
                Dim ref As DataRow() = Nothing
                If ticaDs.Tables.Contains("ProviderReference") Then
                    ref = ticaDs.Tables("ProviderReference").Select("PRReferenceId = '" + row("PCAccordingToId").ToString + "'")
                End If
                If ref Is Nothing OrElse ref.Length = 0 Then
                    ds = ReferenceData.GetProviderReferenceDs(providerPk, row("PCAccordingToId").ToString)
                    If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                        ds.Tables(0).TableName = "ProviderReference"
                        ticaDs.Merge(ds)

                        row("PRPk") = ds.Tables(0).Rows(0)("PRPk")
                    End If

                    Dim risds As DataSet = ReferenceData.GetProviderRISByReferenceDs(ds.Tables(0).Rows(0)("PRPk"))
                    If risds.Tables.Count > 0 Then
                        risds.Tables(0).TableName = "ProviderReferenceRIS"
                        ticaDs.Merge(risds)
                    End If
                Else
                    row("PRPk") = ref(0)("PRPk")
                End If
            End If
        Next

        ds = OtherData.GetProviderNameOtherData(pnpk)
        If ds.Tables.Count > 0 Then
            ds.Tables(0).TableName = "ProviderOtherData"
            ticaDS.Merge(ds)
        End If

    End Sub

#End Region


    Public Shared Function GetNameRecordDs(ByVal nameGuid As String) As DataSet
        Dim ticaDS As New DataSet

        Dim ds As DataSet = NameData.GetNameDs(Nothing, nameGuid)

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            Throw New ChecklistException("Checklist Name with specified Id does not exist")
        End If

        ds.Tables(0).Columns.Add("NameRankSort", GetType(Integer))
        ds.Tables(0).Columns.Add("NameRankTCS")
        Dim rnk As Integer = -1
        If Not ds.Tables(0).Rows(0).IsNull("NameRankFk") Then rnk = ds.Tables(0).Rows(0)("NameRankFk")
        ds.Tables(0).Rows(0)("NameRankSort") = RankData.GetRankSort(rnk)
        ds.Tables(0).Rows(0)("NameRankTCS") = RankData.GetRankTCS(rnk)
        ds.Tables(0).TableName = "Name"
        ticaDS.Merge(ds)


        ds = ConceptData.GetNameConceptsDs(nameGuid)
        If ds.Tables.Count > 0 Then
            ds.Tables(0).TableName = "Concept"
            If ds.Tables.Count > 1 Then ds.Tables(1).TableName = "ConceptRelationship"

            ticaDS.Merge(ds)
        End If

        'synonyms?
        'ds = NameData.GetNameSynonymsDs(nameGuid)
        'If ds.Tables.Count > 0 Then
        '    ds.Tables(0).TableName = "Synonym"
        '    UpdateNameLSIDs(ds "Synonym")

        '    ticaDS.Merge(ds)
        'End If


        If ticaDS.Tables("Name").Rows(0)("NameReferenceFk") IsNot DBNull.Value Then
            Dim refGuid As String = ticaDS.Tables("Name").Rows(0)("NameReferenceFk").ToString
            ds = ReferenceData.GetReferenceDs(refGuid)
            If ds.Tables.Count > 0 Then ds.Tables(0).TableName = "Reference"
            Dim risds As DataSet = ReferenceData.GetReferenceRISByReferenceDs(refGuid)
            If risds.Tables.Count > 0 Then risds.Tables(0).TableName = "ReferenceRIS"

            If ds.Tables.Count > 0 Then
                ticaDS.Merge(ds)
            End If

            If risds.Tables.Count > 0 Then
                ticaDS.Merge(risds)
            End If

        End If

        For Each row As DataRow In ticaDS.Tables("Concept").Rows
            GetReference(ticaDS, row, "ConceptAccordingToFk")
        Next

        ds = OtherData.GetNameOtherData(nameGuid)
        If ds.Tables.Count > 0 Then
            ds.Tables(0).TableName = "OtherData"
            ticaDS.Merge(ds)
        End If

        'provider details
        ds = NameData.GetProviderNameRecords(nameGuid)
        If ds.Tables.Count > 0 Then
            For Each r As DataRow In ds.Tables(0).Rows
                GetProviderName(ticaDS, r("PNPk"))
            Next
        End If

        ds = GetProvidersDs()
        ticaDS.Merge(ds)

        UpdateNameLSIDs(ticaDS, "Name")
        UpdatedConceptLSIDs(ticaDS)
        UpdateReferenceLSIDs(ticaDS)

        Return ticaDS
    End Function


    Public Shared Function GetProviderNameRecordDs(ByVal providerPk As Integer, ByVal providerNameId As String) As DataSet
        Dim ticaDS As New DataSet

        Dim ds As DataSet = NameData.GetProviderNameDs(providerPk, providerNameId)

        If ds Is Nothing OrElse ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then
            Throw New ChecklistException("Checklist Provider Name with specified Id and Provider Id does not exist")
        End If

        Dim retDs As New DataSet
        GetProviderName(retDs, ds.Tables(0).Rows(0)("PNPk"))

        ds = GetProvidersDs()
        retDs.Merge(ds)

        UpdateNameLSIDs(retDs, "Name")
        UpdatedConceptLSIDs(retDs)
        UpdateReferenceLSIDs(retDs)

        Return retDs
    End Function

    Public Shared Function GetProvidersDs() As DataSet
        Dim ds As DataSet = ProviderData.GetProvidersDs()
        ds.Tables(0).TableName = "Provider"
        ds.Tables(0).Columns.Remove("ProviderStatement")
        Return ds
    End Function
End Class
