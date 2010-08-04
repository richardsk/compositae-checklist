
Public Class MatchResult
    Public MatchedId As String
    Public MatchedName As String
    Public MatchedReference As String
    Public MatchedConceptRelationship As String
    Public MatchedOtherData As DataRow
    Public Status As LinkStatus = LinkStatus.Unmatched
End Class

Public Class NameMatch
    Public NameId As String = ""
    Public NameFull As String = ""
    Public MatchScore As Integer = 0
End Class
