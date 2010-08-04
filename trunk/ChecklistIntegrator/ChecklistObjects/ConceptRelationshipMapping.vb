Public Class ConceptRelationshipMapping
    Inherits BaseObject

    Public ConceptRelationshipMappingSourceCol As String
    Public ConceptRelationshipMappingDestCol As String


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)

        ConceptRelationshipMappingDestCol = row("ConceptRelMappingDestCol").ToString
        ConceptRelationshipMappingSourceCol = row("ConceptRelMappingSourceCol").ToString
    End Sub
End Class
