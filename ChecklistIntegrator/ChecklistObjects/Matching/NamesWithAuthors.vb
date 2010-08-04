Imports System.Data.SqlClient

Public Class NamesWithAuthors
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

        Dim ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Dim cnt As Integer = -1

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "select count(pnapk) from tblprovidernameauthors where PNAProviderNameFk = " + pn.Id

                cnt = cmd.ExecuteScalar().ToString()
            End Using

            If cnt = 0 Then Return 'succeed - no authors


            Dim basAuth As String = ""
            Dim combAuth As String = ""

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "select dbo.fngetcorrectedauthors(PNACombinationAuthors), " + _
                    "dbo.fngetcorrectedauthors(PNABasionymAuthors) from tblprovidernameauthors " + _
                    "where PNAProviderNameFk = " + pn.Id

                Dim da As New SqlDataAdapter(cmd)
                Dim dt As New DataTable
                da.Fill(dt)

                basAuth = dt.Rows(0)(0).ToString
                combAuth = dt.Rows(0)(1).ToString
            End Using

            For Each row As DsNameMatch.NameRow In names.Name
                Using cmd As SqlCommand = cnn.CreateCommand()
                    cmd.CommandText = "select NameAuthorsCombinationAuthors, " + _
                        "NameAuthorsBasionymAuthors from tblnameauthors " + _
                        "where NameAuthorsNameFk = '" + row.NameGuid.ToString + "'"

                    Dim da As New SqlDataAdapter(cmd)
                    Dim dt As New DataTable
                    da.Fill(dt)

                    Dim ba As String = dt.Rows(0)(0).ToString
                    Dim ca As String = dt.Rows(0)(1).ToString

                    If (ba <> "" And ba <> basAuth) Or (ca <> "" And ca <> combAuth) Then
                        row.Delete()
                    End If
                End Using
            Next

            If names.Name.Rows.Count = 0 Then
                'try prov names
                names.RejectChanges()

                For Each row As DsNameMatch.NameRow In names.Name
                    Using cmd As SqlCommand = cnn.CreateCommand()
                        cmd.CommandText = "select count(pnpk) from tblprovidername " + _
                            "inner join tblprovidernameauthors on pnaprovidernamefk = pnpk " + _
                            "where isnull(PNACombinationAuthors, '" + combAuth + "') = '" + combAuth + "' " + _
                            " and isnull(PNABasionymAuthors, '" + basAuth + "') = '" + basAuth + "' " + _
                            "where PNNameFk = '" + row.NameGuid.ToString + "'"

                        Dim pnacnt As Integer = cmd.ExecuteScalar

                        If pnacnt = 0 Then
                            row.Delete()
                        End If
                    End Using
                Next

            End If

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        names.AcceptChanges()

    End Sub

End Class
