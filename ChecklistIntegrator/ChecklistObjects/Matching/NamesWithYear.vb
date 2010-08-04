Imports System.Data.SqlClient

Public Class NamesWithYear
    Implements INameMatcher

    Private m_Id As Integer = -1
    Private m_FailId As Integer = -1
    Private m_SuccessId As Integer = -1

    Sub New(ByVal id As Integer, ByVal failId As Integer, ByVal successId As Integer)
        m_Id = id
        m_FailId = failId
        m_SuccessId = successId
    End Sub

    Public Property Id() As Integer Implements INameMatcher.Id
        Get
            Return m_Id
        End Get
        Set(ByVal value As Integer)
            m_Id = value
        End Set
    End Property

    Public Property FailId() As Integer Implements INameMatcher.FailId
        Get
            Return m_FailId
        End Get
        Set(ByVal value As Integer)
            m_FailId = value
        End Set
    End Property

    Public Property SuccessId() As Integer Implements INameMatcher.SuccessId
        Get
            Return m_SuccessId
        End Get
        Set(ByVal value As Integer)
            m_SuccessId = value
        End Set
    End Property


    Public Function GetMatchingNames(ByVal pn As ChecklistObjects.ProviderName) As DsNameMatch Implements INameMatcher.GetMatchingNames
        Return Nothing
    End Function

    Public Sub RemoveNonMatches(ByVal pn As ChecklistObjects.ProviderName, ByRef names As DsNameMatch) Implements INameMatcher.RemoveNonMatches

        If pn.PNYear Is Nothing OrElse pn.PNYear.Length = 0 Then Return 'succeed

        For Each row As DsNameMatch.NameRow In names.Name
            If row("NameYear").ToString.Trim <> pn.PNYear.ToString.Trim Then
                row.Delete()
            End If
        Next

        If names.Name.Count = 0 Then
            names.RejectChanges()

            'check prov names
            Dim ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString
            Using cnn As New SqlConnection(ConnectionString)
                cnn.Open()

                For Each row As DsNameMatch.NameRow In names.Name
                    Dim cnt As Integer = -1

                    Using cmd As SqlCommand = cnn.CreateCommand()
                        cmd.CommandText = "select count(pnpk) from tblprovidername where pnnamefk = '" + _
                            row.NameGuid.ToString + "' and pnyear is null or pnyear = '" + pn.PNYear + "'"

                        cnt = cmd.ExecuteScalar()
                    End Using

                    If cnt < 1 Then
                        row.Delete()
                    End If

                Next
                
                If cnn.State <> ConnectionState.Closed Then cnn.Close()
            End Using

        End If

        names.AcceptChanges()
        
    End Sub

End Class
