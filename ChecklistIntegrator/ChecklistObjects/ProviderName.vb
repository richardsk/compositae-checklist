Public Class ProviderName
    Inherits BaseObject

    'field names should match column names in table to allow programmatic loading
    Public ProviderIsEditor As SqlTypes.SqlBoolean = False
    Public PNNameFk As String
    Public PNLinkStatus As String
    Public PNNameMatchScore As Integer = -1
    Public PNProviderImportFk As Integer = -1
    Public PNProviderUpdatedDate As DateTime = DateTime.MinValue
    Public PNProviderAddedDate As DateTime = DateTime.MinValue
    Public PNNameId As String
    Public PNNameFull As String
    Public PNNameRank As String
    Public PNNameRankFk As Integer = -1
    Public PNNameCanonical As String
    Public PNNameAuthors As String
    Public PNBasionymAuthors As String
    Public PNCombinationAuthors As String
    Public PNPublishedIn As String
    Public PNReferenceId As String
    Public PNReferenceFk As String
    Public PNYear As String
    Public PNMicroReference As String
    Public PNTypeVoucher As String
    Public PNTypeName As String
    Public PNTypeNameId As String
    Public PNTypeNameFk As String
    Public PNOrthography As String
    Public PNBasionym As String
    Public PNBasionymId As String
    Public PNBasionymFk As String
    Public PNBasedOn As String
    Public PNBasedOnId As String
    Public PNBasedOnFk As String
    Public PNConservedAgainst As String
    Public PNConservedAgainstId As String
    Public PNConservedAgainstFk As String
    Public PNHomonymOf As String
    Public PNHomonymOfId As String
    Public PNHomonymOfFk As String
    Public PNReplacementFor As String
    Public PNReplacementForId As String
    Public PNReplacementForFk As String
    Public PNBlocking As String
    Public PNBlockingId As String
    Public PNBlockingFk As String
    Public PNInCitation As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null
    Public PNInvalid As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null
    Public PNIllegitimate As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null
    Public PNMisapplied As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null
    Public PNProParte As SqlTypes.SqlBoolean = SqlTypes.SqlBoolean.Null
    Public PNGeographyText As String
    Public PNGeographyCodes As String
    Public PNClimate As String
    Public PNLifeform As String
    Public PNIUCN As String
    Public PNNotes As String
    Public PNStatusNotes As String
    Public PNNonNotes As String
    Public PNQualityStatement As String
    Public PNNameVersion As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String, ByVal allowBlank As Boolean)
        MyBase.New(row, recId)

        
        ProviderIsEditor = GetRowBool(row, "ProviderIsEditor")
        If ProviderIsEditor.IsNull Then ProviderIsEditor = False
        PNNameFk = GetRowString(row, "PNNameFk")
        PNLinkStatus = GetRowString(row, "PNLinkStatus")
        PNNameMatchScore = GetRowString(row, "PNNameMatchScore")
        PNProviderImportFk = GetRowInt(row, "PNProviderImportFk")
        PNProviderUpdatedDate = GetRowDateTime(row, "PNProviderUpdatedDate")
        PNProviderAddedDate = GetRowDateTime(row, "PNProviderAddedDate")
        PNNameId = GetRowString(row, "PNNameId")
        PNNameRankFk = GetRowInt(row, "PNNameRankFk")

        If Not allowBlank Then
            PNNameFull = GetRowStringNonBlank(row, "PNNameFull")
            PNNameRank = GetRowStringNonBlank(row, "PNNameRank")
            PNNameCanonical = GetRowStringNonBlank(row, "PNNameCanonical")
            PNNameAuthors = GetRowStringNonBlank(row, "PNNameAuthors")
            PNBasionymAuthors = GetRowStringNonBlank(row, "PNBasionymAuthors")
            PNCombinationAuthors = GetRowStringNonBlank(row, "PNCombinationAuthors")
            PNPublishedIn = GetRowStringNonBlank(row, "PNPublishedIn")
            PNReferenceId = GetRowStringNonBlank(row, "PNReferenceId")
            PNReferenceFk = GetRowStringNonBlank(row, "PNReferenceFk")
            PNYear = GetRowStringNonBlank(row, "PNYear")
            PNMicroReference = GetRowStringNonBlank(row, "PNMicroReference")
            PNTypeVoucher = GetRowStringNonBlank(row, "PNTypeVoucher")
            PNTypeName = GetRowStringNonBlank(row, "PNTypeName")
            PNTypeNameFk = GetRowStringNonBlank(row, "PNTypeNameFk")
            PNOrthography = GetRowStringNonBlank(row, "PNOrthography")
            PNBasionym = GetRowStringNonBlank(row, "PNBasionym")
            PNBasionymId = GetRowStringNonBlank(row, "PNBasionymId")
            PNBasionymFk = GetRowStringNonBlank(row, "PNBasionymFk")
            PNBasedOn = GetRowStringNonBlank(row, "PNBasedOn")
            PNBasedOnId = GetRowStringNonBlank(row, "PNBasedOnId")
            PNBasedOnFk = GetRowStringNonBlank(row, "PNBasedOnFk")
            PNConservedAgainst = GetRowStringNonBlank(row, "PNConservedAgainst")
            PNConservedAgainstId = GetRowStringNonBlank(row, "PNConservedAgainstId")
            PNConservedAgainstFk = GetRowStringNonBlank(row, "PNConservedAgainstFk")
            PNHomonymOf = GetRowStringNonBlank(row, "PNHomonymOf")
            PNHomonymOfId = GetRowStringNonBlank(row, "PNHomonymOfId")
            PNHomonymOfFk = GetRowStringNonBlank(row, "PNHomonymOfFk")
            PNReplacementFor = GetRowStringNonBlank(row, "PNReplacementFor")
            PNReplacementForId = GetRowStringNonBlank(row, "PNReplacementForId")
            PNReplacementForFk = GetRowStringNonBlank(row, "PNReplacementForFk")
            PNBlocking = GetRowStringNonBlank(row, "PNBlocking")
            PNBlockingId = GetRowStringNonBlank(row, "PNBlockingId")
            PNBlockingFk = GetRowStringNonBlank(row, "PNBlockingFk")
            PNGeographyText = GetRowStringNonBlank(row, "PNGeographyText")
            PNGeographyCodes = GetRowStringNonBlank(row, "PNGeographyCodes")
            PNClimate = GetRowStringNonBlank(row, "PNClimate")
            PNLifeform = GetRowStringNonBlank(row, "PNLifeform")
            PNIUCN = GetRowStringNonBlank(row, "PNIUCN")
            PNNotes = GetRowStringNonBlank(row, "PNNotes")
            PNStatusNotes = GetRowStringNonBlank(row, "PNStatusNotes")
            PNNonNotes = GetRowStringNonBlank(row, "PNNonNotes")
            PNQualityStatement = GetRowStringNonBlank(row, "PNQualityStatement")
            PNNameVersion = GetRowStringNonBlank(row, "PNNameVersion")
        Else
            PNNameFull = GetRowString(row, "PNNameFull")
            PNNameRank = GetRowString(row, "PNNameRank")
            PNNameRankFk = GetRowInt(row, "PNNameRankFk")
            PNNameCanonical = GetRowString(row, "PNNameCanonical")
            PNNameAuthors = GetRowString(row, "PNNameAuthors")
            PNBasionymAuthors = GetRowString(row, "PNBasionymAuthors")
            PNCombinationAuthors = GetRowString(row, "PNCombinationAuthors")
            PNPublishedIn = GetRowString(row, "PNPublishedIn")
            PNReferenceId = GetRowString(row, "PNReferenceId")
            PNReferenceFk = GetRowString(row, "PNReferenceFk")
            PNYear = GetRowString(row, "PNYear")
            PNMicroReference = GetRowString(row, "PNMicroReference")
            PNTypeVoucher = GetRowString(row, "PNTypeVoucher")
            PNTypeName = GetRowString(row, "PNTypeName")
            PNTypeNameFk = GetRowString(row, "PNTypeNameFk")
            PNOrthography = GetRowString(row, "PNOrthography")
            PNBasionym = GetRowString(row, "PNBasionym")
            PNBasionymId = GetRowString(row, "PNBasionymId")
            PNBasionymFk = GetRowString(row, "PNBasionymFk")
            PNBasedOn = GetRowString(row, "PNBasedOn")
            PNBasedOnId = GetRowString(row, "PNBasedOnId")
            PNBasedOnFk = GetRowString(row, "PNBasedOnFk")
            PNConservedAgainst = GetRowString(row, "PNConservedAgainst")
            PNConservedAgainstId = GetRowString(row, "PNConservedAgainstId")
            PNConservedAgainstFk = GetRowString(row, "PNConservedAgainstFk")
            PNHomonymOf = GetRowString(row, "PNHomonymOf")
            PNHomonymOfId = GetRowString(row, "PNHomonymOfId")
            PNHomonymOfFk = GetRowString(row, "PNHomonymOfFk")
            PNReplacementFor = GetRowString(row, "PNReplacementFor")
            PNReplacementForId = GetRowString(row, "PNReplacementForId")
            PNReplacementForFk = GetRowString(row, "PNReplacementForFk")
            PNBlocking = GetRowString(row, "PNBlocking")
            PNBlockingId = GetRowString(row, "PNBlockingId")
            PNBlockingFk = GetRowString(row, "PNBlockingFk")
            PNInCitation = GetRowBool(row, "PNInCitation")
            PNInvalid = GetRowBool(row, "PNInvalid")
            PNIllegitimate = GetRowBool(row, "PNIllegitimate")
            PNMisapplied = GetRowBool(row, "PNMisapplied")
            PNProParte = GetRowBool(row, "PNProParte")
            PNGeographyText = GetRowString(row, "PNGeographyText")
            PNGeographyCodes = GetRowString(row, "PNGeographyCodes")
            PNClimate = GetRowString(row, "PNClimate")
            PNLifeform = GetRowString(row, "PNLifeform")
            PNIUCN = GetRowString(row, "PNIUCN")
            PNNotes = GetRowString(row, "PNNotes")
            PNStatusNotes = GetRowString(row, "PNStatusNotes")
            PNNonNotes = GetRowString(row, "PNNonNotes")
            PNQualityStatement = GetRowString(row, "PNQualityStatement")
            PNNameVersion = GetRowString(row, "PNNameVersion")
        End If

        PNInCitation = GetRowBool(row, "PNInCitation")
        PNInvalid = GetRowBool(row, "PNInvalid")
        PNIllegitimate = GetRowBool(row, "PNIllegitimate")
        PNMisapplied = GetRowBool(row, "PNMisapplied")
        PNProParte = GetRowBool(row, "PNProParte")

    End Sub

    ''' <summary>
    ''' Update PN from another PN
    ''' Update Fields where the passed in PN field is not null
    ''' </summary>
    ''' <param name="pn"></param>
    ''' <remarks></remarks>
    Public Sub UpdateFieldsFromProviderName(ByVal pn As ProviderName)
        If pn.PNProviderUpdatedDate <> DateTime.MinValue Then PNProviderUpdatedDate = pn.PNProviderUpdatedDate
        If pn.PNProviderAddedDate <> DateTime.MinValue Then PNProviderAddedDate = pn.PNProviderAddedDate
        If Not pn.PNNameId Is Nothing Then PNNameId = pn.PNNameId
        If Not pn.PNNameFull Is Nothing Then PNNameFull = pn.PNNameFull
        If Not pn.PNNameRank Is Nothing Then PNNameRank = pn.PNNameRank
        If pn.PNNameRankFk <> -1 Then PNNameRankFk = pn.PNNameRankFk
        If Not pn.PNNameCanonical Is Nothing Then PNNameCanonical = pn.PNNameCanonical
        If Not pn.PNNameAuthors Is Nothing Then PNNameAuthors = pn.PNNameAuthors
        If Not pn.PNBasionymAuthors Is Nothing Then PNBasionymAuthors = pn.PNBasionymAuthors
        If Not pn.PNCombinationAuthors Is Nothing Then PNCombinationAuthors = pn.PNCombinationAuthors
        If Not pn.PNPublishedIn Is Nothing Then PNPublishedIn = pn.PNPublishedIn
        If Not pn.PNReferenceId Is Nothing Then PNReferenceId = pn.PNReferenceId
        If Not pn.PNYear Is Nothing Then PNYear = pn.PNYear
        If Not pn.PNMicroReference Is Nothing Then PNMicroReference = pn.PNMicroReference
        If Not pn.PNTypeVoucher Is Nothing Then PNTypeVoucher = pn.PNTypeVoucher
        If Not pn.PNTypeName Is Nothing Then PNTypeName = pn.PNTypeName
        If Not pn.PNTypeNameId Is Nothing Then PNTypeNameId = pn.PNTypeNameId
        If Not pn.PNOrthography Is Nothing Then PNOrthography = pn.PNOrthography
        If Not pn.PNBasionym Is Nothing Then PNBasionym = pn.PNBasionym
        If Not pn.PNBasionymId Is Nothing Then PNBasionymId = pn.PNBasionymId
        If Not pn.PNBasedOn Is Nothing Then PNBasedOn = pn.PNBasedOn
        If Not pn.PNBasedOnId Is Nothing Then PNBasedOnId = pn.PNBasedOnId
        If Not pn.PNConservedAgainst Is Nothing Then PNConservedAgainst = pn.PNConservedAgainst
        If Not pn.PNConservedAgainstId Is Nothing Then PNConservedAgainstId = pn.PNConservedAgainstId
        If Not pn.PNHomonymOf Is Nothing Then PNHomonymOf = pn.PNHomonymOf
        If Not pn.PNHomonymOfId Is Nothing Then PNHomonymOfId = pn.PNHomonymOfId
        If Not pn.PNReplacementFor Is Nothing Then PNReplacementFor = pn.PNReplacementFor
        If Not pn.PNReplacementForId Is Nothing Then PNReplacementForId = pn.PNReplacementForId
        If Not pn.PNBlocking Is Nothing Then PNBlocking = pn.PNBlocking
        If Not pn.PNBlockingId Is Nothing Then PNBlockingId = pn.PNBlockingId
        If Not pn.PNInCitation.IsNull Then PNInCitation = pn.PNInCitation
        If Not pn.PNInvalid.IsNull Then PNInvalid = pn.PNInvalid
        If Not pn.PNIllegitimate.IsNull Then PNIllegitimate = pn.PNIllegitimate
        If Not pn.PNMisapplied.IsNull Then PNMisapplied = pn.PNMisapplied
        If Not pn.PNProParte.IsNull Then PNProParte = pn.PNMisapplied
        If Not pn.PNGeographyText Is Nothing Then PNGeographyText = pn.PNGeographyText
        If Not pn.PNGeographyCodes Is Nothing Then PNGeographyCodes = pn.PNGeographyCodes
        If Not pn.PNClimate Is Nothing Then PNClimate = pn.PNClimate
        If Not pn.PNLifeform Is Nothing Then PNLifeform = pn.PNLifeform
        If Not pn.PNIUCN Is Nothing Then PNIUCN = pn.PNIUCN
        If Not pn.PNNotes Is Nothing Then PNNotes = pn.PNNotes
        If Not pn.PNStatusNotes Is Nothing Then PNStatusNotes = pn.PNStatusNotes
        If Not pn.PNNonNotes Is Nothing Then PNNonNotes = pn.PNNonNotes
        If Not pn.PNQualityStatement Is Nothing Then PNQualityStatement = pn.PNQualityStatement
    End Sub
End Class
