Public Class RISMapping
    Inherits BaseObject

    Public RISMappingSourceCol As String
    Public RISMappingDestCol As String


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        'LoadFieldsFromRow(row)

        RISMappingDestCol = row("RISMappingDestCol").ToString
        RISMappingSourceCol = row("RISMappingSourceCol").ToString

    End Sub

    Public Shared Function MappingWithDestinationCol(ByVal mappings As List(Of RISMapping), ByVal destColName As String) As RISMapping
        Dim snm As New RISMapping
        snm.RISMappingDestCol = destColName
        Return mappings.Find(New Predicate(Of RISMapping)(AddressOf snm.SameDestinationCol))
    End Function

    Public Shared Function SourceColumnNameOfDest(ByVal mappings As List(Of RISMapping), ByVal destColName As String) As String
        Dim rm As RISMapping = MappingWithDestinationCol(mappings, destColName)
        Dim rmName As String = ""
        If rm IsNot Nothing Then rmName = rm.RISMappingSourceCol
        Return rmName
    End Function

    Public Function SameDestinationCol(ByVal nm As RISMapping) As Boolean
        Return (nm.RISMappingDestCol = RISMappingDestCol)
    End Function
End Class

