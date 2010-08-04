Public Class RefreshData
    Public NameGuid As String
    Public PNPk As Integer
    Public IsNew As Boolean = False

    Public Sub New()
    End Sub

    Public Sub New(ByVal nameGuid As String, ByVal pnPk As Integer, ByVal isNew As Boolean)
        Me.NameGuid = nameGuid
        Me.PNPk = pnPk
        Me.IsNew = isNew
    End Sub
End Class
