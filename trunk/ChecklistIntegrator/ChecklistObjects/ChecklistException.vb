Public Class ChecklistException
    Inherits Exception

    Public Sub New()

    End Sub

    Public Sub New(ByVal msg As String)
        MyBase.New(msg)
    End Sub

    Public Shared Sub LogMessage(ByVal msg As String)
        Diagnostics.EventLog.WriteEntry("Checklist Integrator", msg)
    End Sub

    Public Shared Sub LogError(ByVal e As Exception)
        Dim msg As String = ""
        If e.Data.Contains("CustomMessage") Then msg = e.Data.Item("CustomMessage").ToString + " : "
        msg += e.Message
        msg += " : " + e.StackTrace
        If msg.Length > 32000 Then msg = msg.Substring(0, 32000)
        Diagnostics.EventLog.WriteEntry("Checklist Integrator", msg, EventLogEntryType.Error)
    End Sub

    Public Sub LogError()
        LogError(Me)
    End Sub

End Class
