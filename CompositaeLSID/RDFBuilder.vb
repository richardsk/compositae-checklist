Imports ChecklistBusinessRules
Imports ChecklistDataAccess
Imports ChecklistObjects
Imports TDWG_RDF

Public Class RDFBuilder

    Public Shared Function GetNameRdf(ByVal nameLSID As String) As String
        Dim rdf As String = ""

        Dim tn As DwcTaxon = GetDwcName(GetName(nameLSID))
        If tn IsNot Nothing Then
            Proxy.LSIDProxy = System.Configuration.ConfigurationManager.AppSettings.Get("LSIDProxyUrl")

            Dim dwc2 As New TDWG_RDF.DarwinCore2
            dwc2.TaxonNames.Add(tn)
            rdf = dwc2.GetDwcXml("")
        End If

        Return rdf
    End Function

    Public Shared Function GetConceptRdf(ByVal conceptLSID As String) As String
        Dim rdf As String = ""

        Dim tc As DwcConcept = GetDwcConcept(GetConcept(conceptLSID))
        If tc IsNot Nothing Then
            Proxy.LSIDProxy = System.Configuration.ConfigurationManager.AppSettings.Get("LSIDProxyUrl")

            Dim dwc2 As New TDWG_RDF.DarwinCore2
            dwc2.AddConcept(tc)
            rdf = dwc2.GetDwcXml("")
        End If

        Return rdf
    End Function

    Public Shared Function GetReferenceRdf(ByVal refLSID As String) As String
        Dim rdf As String = ""

        'hmmmmm ...  No DwC references ???  Maybe should use PRISM - http://www.idealliance.org/industry_resources/intelligent_content_informed_workflow/prism

        Dim ref As Reference = GetReference(refLSID)
        rdf = ref.ReferenceCitation

        Return rdf
    End Function

    Private Shared Function GetReference(ByVal refLSID As String) As Reference
        Dim pos As Integer = refLSID.LastIndexOf(":")
        Dim refId As String = refLSID.Substring(pos + 1)
        Dim ref As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceDs(refId)
        Dim r As New ChecklistObjects.Reference
        r.LoadFieldsFromRow(ref.Tables(0).Rows(0))
        Return r
    End Function

    Private Shared Function GetName(ByVal nameLSID As String) As ChecklistObjects.Name
        Dim pos As Integer = nameLSID.LastIndexOf(":")
        Dim nameId As String = nameLSID.Substring(pos + 1)
        Return ChecklistDataAccess.NameData.GetName(Nothing, nameId)
    End Function

    Private Shared Function GetConcept(ByVal conceptLSID As String) As ChecklistObjects.Concept
        Dim pos As Integer = conceptLSID.LastIndexOf(":")
        Dim cId As String = conceptLSID.Substring(pos + 1)
        Dim cDs As DataSet = ChecklistDataAccess.ConceptData.GetConceptDs(cId)
        Dim c As New ChecklistObjects.Concept
        c.LoadFieldsFromRow(cDs.Tables(0).Rows(0))
        Return c
    End Function

    Protected Shared Function GetDwcConcept(ByVal conc As Concept) As DwcConcept
        If conc Is Nothing Then Return Nothing

        Dim dwcConc As New DwcConcept

        dwcConc.conceptID = conc.ConceptLSID

        Dim gccName As Name = GetName(Name.CreateLSID(conc.ConceptName1Fk))
        dwcConc.Taxon = GetDwcName(gccName)

        dwcConc.accordingTo = conc.ConceptAccordingTo
        dwcConc.accordingToID = Reference.CreateLSID(conc.ConceptAccordingToFk)

        For Each rel As ConceptRelationship In conc.Relationships
            Dim toConc As New DwcConcept
            toConc.conceptID = Concept.CreateLSID(rel.ConceptRelationshipConcept2Fk)
            dwcConc.AddRelationship(toConc, conc.ConceptAccordingTo, rel.ConceptRelationshipRelationship, DateTime.MinValue, "")
        Next

        Return dwcConc
    End Function

    Protected Shared Function GetDwcName(ByVal taxon As Name) As DwcTaxon
        If taxon Is Nothing Then Return Nothing

        Dim nameId As String = taxon.NameLSID
        'If Not LSID.LSIDUtil.IsLSID(nameLSID) Then nameLSID = LSID.LSID.NewLSID(LSID.LSIDUtil.LandcareTaxonNamesNamespace, taxon.NameId).ToString()

        Dim tn As New DwcTaxon
        tn.scientificNameID = nameId
        tn.scientificName = taxon.NameFull
        If taxon.NameAuthors IsNot Nothing AndAlso taxon.NameAuthors <> "" Then tn.scientificNameAuthorship = taxon.NameAuthors
        tn.recordCreator = "Global Compositae Checklist"
        If taxon.CreatedDate <> DateTime.MinValue Then tn.recordModifiedDate = taxon.CreatedDate
        If taxon.UpdatedDate <> DateTime.MinValue Then tn.recordModifiedDate = taxon.UpdatedDate
        tn.nomenclaturalCode = TDWG_RDF.TCSNomenclaturalCode.ICBN.ToString

        Dim rnkSort As Integer = RankData.GetRankSort(taxon.NameRankFk)

        'rank
        If rnkSort > 4200 Then 'infraspecific
            tn.infraspecificEpithet = taxon.NameCanonical
        End If
        If rnkSort > 3000 Then 'below genus
            Dim pos As Integer = taxon.NameFull.IndexOf(" ")
            If pos <> -1 Then
                Dim nextPos As Integer = taxon.NameFull.IndexOf(" ", pos + 1)
                If nextPos <> -1 Then
                    tn.specificEpithet = taxon.NameFull.Substring(pos + 1, nextPos - pos - 1)
                Else
                    tn.specificEpithet = taxon.NameFull.Substring(pos + 1)
                End If
            End If
        End If
        If rnkSort >= 3000 Then 'genus and below
            Dim len As Integer = taxon.NameFull.IndexOf(" ")
            If len = -1 Then len = taxon.NameFull.Length
            tn.genus = taxon.NameFull.Substring(0, len)
        End If

        tn.taxonRank = taxon.NameRank

        If taxon.NameReferenceFk IsNot Nothing AndAlso taxon.NameReferenceFk <> "" Then
            Dim ref As DataSet = ReferenceData.GetReferenceDs(taxon.NameReferenceFk)

            If ref IsNot Nothing AndAlso ref.Tables.Count > 0 AndAlso ref.Tables(0).Rows.Count > 0 Then
                tn.namePublishedInID = ref.Tables(0).Rows(0)("ReferenceCitation").ToString
            End If
        End If

        If taxon.NameBasionymFk IsNot Nothing AndAlso taxon.NameBasionymFk <> "" Then tn.originalNameUsageID = Name.CreateLSID(taxon.NameBasionymFk)
        If taxon.NamePreferredFk IsNot Nothing AndAlso taxon.NamePreferredFk <> "" Then
            tn.acceptedNameUsage = taxon.NamePreferred
            tn.acceptedNameUsageID = Name.CreateLSID(taxon.NamePreferredFk)
        End If
        If taxon.NameParentFk IsNot Nothing AndAlso taxon.NameParentFk <> "" Then
            tn.parentNameUsage = taxon.NameParent
            tn.parentNameUsageID = Name.CreateLSID(taxon.NameParentFk)
        End If

        'year ? tn.

        If taxon.NameStatusNotes IsNot Nothing Then tn.nomenclaturalStatus = taxon.NameStatusNotes

        Return tn
    End Function
End Class
