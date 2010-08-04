Public Class HistoryItem

    Public Sub New(ByVal Key As String, ByVal DisplayText As String)

        Me.Key = Key
        Me.DisplayText = DisplayText
    End Sub


    Public Key As String
    Public DisplayText As String

    Public Overrides Function toString() As String
        If DisplayText Is Nothing Then Return ""

        Return DisplayText.ToString
    End Function

End Class
