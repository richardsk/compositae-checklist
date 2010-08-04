Public Class ConceptMapping
    Inherits BaseObject

    Public MappingSourceCol As String
    Public MappingDestCol As String


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)

        MappingDestCol = row("ConceptMappingDestCol").ToString
        MappingSourceCol = row("ConceptMappingSourceCol").ToString
    End Sub
End Class

