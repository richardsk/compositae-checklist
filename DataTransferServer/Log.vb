Imports System.IO

Public Class Log
    Private Shared LogFile As String = "log.txt"

    Public Shared Sub LogError(ByVal ex As Exception)
        If ex IsNot Nothing Then
            Dim msg As String = "Data Transfer Error - " + DateTime.Now.ToString + " : " + ex.Message + " : " + ex.StackTrace
            LogMessage(msg)
        End If
    End Sub

    Public Shared Sub LogMessage(ByVal msg As String)
        Try
            File.AppendAllText(LogFile, DateTime.Now.ToString + " : " + msg + Environment.NewLine)
        Catch
        End Try
    End Sub
End Class
