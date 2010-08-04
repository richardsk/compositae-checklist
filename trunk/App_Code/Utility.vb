Imports Microsoft.VisualBasic

Public Class Utility
    Public Shared Function GetLSIDObjectVal(ByVal lsid As String) As String
        Dim obj As String = ""

        Dim pos As Integer = lsid.LastIndexOf(":")
        If pos <> -1 Then
            obj = lsid.Substring(pos + 1)
        End If
        Return obj
    End Function
End Class
