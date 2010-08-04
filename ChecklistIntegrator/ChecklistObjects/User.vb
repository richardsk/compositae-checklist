Public Class User
    Inherits BaseObject

    Public Login As String = ""
    Public Contact As String = ""

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow)

        IdAsInt = row("UserPk")
        Name = row("UserFullName").ToString
        Login = row("UserLogin").ToString
        Contact = row("UserContact").ToString

    End Sub

    Public Overrides Function ToString() As String
        Return Login
    End Function
End Class
