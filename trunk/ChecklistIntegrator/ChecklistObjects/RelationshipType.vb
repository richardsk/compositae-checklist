Public Class RelationshipType
    Inherits BaseObject

    Public Shared RelationshipTypeParent As Integer = 6
    Public Shared RelationshipTypePreferred As Integer = 15

    Public RelationshipTypeName As String
    Public RelationshipTypeInverse As String
    Public RelationshipTypeDescription As String
    Public RelationshipTypeTCS As String
    Public RelationshipTypeTCSInverse As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub
End Class
