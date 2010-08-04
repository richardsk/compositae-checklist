
Public Class ChecklistGlobal
    Private Shared DoLog As Boolean = False

    Public Shared Sub Init()
        Try
            DoLog = (Configuration.ConfigurationManager.AppSettings("Logging") = "on")

        Catch ex As Exception
        End Try
    End Sub

    Public Shared ReadOnly Property DoLogging() As Boolean
        Get
            Return DoLog
        End Get
    End Property
End Class
