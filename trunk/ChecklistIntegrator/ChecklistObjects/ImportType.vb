Public Class ImportType
    Inherits BaseObject

    Public Const FileTypeMDB As String = "MDB"
    Public Const FileTypeXML As String = "XML"

    Public Const ObjectTypeAll As String = "All"
    Public Const ObjectTypeName As String = "Name"
    Public Const ObjectTypeReference As String = "Reference"
    Public Const ObjectTypeOtherData As String = "Other Data"

    Public FileExtension As String
    Public XSLTFile As String
    Public FileType As String  'MDB or XML
    Public ObjectType As String 'Name or Reference

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow)

        IdAsInt = row("ImportTypePk")
        Name = row("ImportTypeName").ToString
        FileExtension = row("ImportTypeFileExt").ToString
        XSLTFile = row("ImportTypeXSLTFile").ToString
        FileType = row("ImportTypeFileType").ToString
        ObjectType = row("ImportTypeObjectType").ToString

    End Sub

End Class
