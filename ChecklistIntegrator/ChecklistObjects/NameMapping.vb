Public Class NameMapping
    Inherits BaseObject

    Public NameMappingSourceCol As String
    Public NameMappingDestCol As String
    Public MatchWeighting As Integer = 1


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        'LoadFieldsFromRow(row)

        NameMappingDestCol = row("NameMappingDestCol").ToString
        NameMappingSourceCol = row("NameMappingSourceCol").ToString

        If Not row.IsNull("NameMappingMatchWeighting") Then
            MatchWeighting = row("NameMappingMatchWeighting")
        End If
    End Sub

    Public Shared Function MappingWithDestinationCol(ByVal mappings As List(Of NameMapping), ByVal destColName As String) As NameMapping
        Dim snm As New NameMapping
        snm.NameMappingDestCol = destColName
        Return mappings.Find(New Predicate(Of NameMapping)(AddressOf snm.SameDestinationCol))
    End Function

    Public Shared Function MappingWithSourceCol(ByVal mappings As List(Of NameMapping), ByVal sourceColName As String) As NameMapping
        Dim snm As New NameMapping
        snm.NameMappingSourceCol = sourceColName
        Return mappings.Find(New Predicate(Of NameMapping)(AddressOf snm.SameSourceCol))
    End Function

    Public Shared Function SourceColumnNameOfDest(ByVal mappings As List(Of NameMapping), ByVal destColName As String) As String
        Dim nm As NameMapping = MappingWithDestinationCol(mappings, destColName)
        Dim nmName As String = ""
        If nm IsNot Nothing Then nmName = nm.NameMappingSourceCol
        Return nmName
    End Function

    Public Function SameDestinationCol(ByVal nm As NameMapping) As Boolean
        Return (nm.NameMappingDestCol = NameMappingDestCol)
    End Function

    Public Function SameSourceCol(ByVal nm As NameMapping) As Boolean
        Return (nm.NameMappingSourceCol = NameMappingSourceCol)
    End Function
End Class
