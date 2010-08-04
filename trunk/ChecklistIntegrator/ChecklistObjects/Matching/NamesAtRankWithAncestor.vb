Imports System.Data.SqlClient

Public Class NamesAtRankWithAncestor
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
        'adds matches, not removes them
        'gets the descendent names with correct rank

        Dim ds As New DsNameMatch

        Dim ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Dim ancestorRank As String = ""
            Dim ancestorId As Guid = Guid.Empty

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "select ar.rankname from tblrank r inner join tblrank ar on ar.rankpk = r.ancestorrankfk where r.rankpk = " + pn.PNNameRankFk.ToString

                ancestorRank = cmd.ExecuteScalar().ToString()
            End Using

            If ancestorRank <> "" Then

                Using cmd As SqlCommand = cnn.CreateCommand
                    cmd.CommandText = "sprSelect_ParentAtRank"
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = names.Name(0).NameGuid
                    cmd.Parameters.Add("@rank", SqlDbType.NVarChar).Value = ancestorRank

                    ancestorId = cmd.ExecuteScalar()
                End Using

                If ancestorId <> Guid.Empty Then

                    For Each row As DsNameMatch.NameRow In names.Name

                        Using cmd As SqlCommand = cnn.CreateCommand
                            cmd.CommandText = "sprSelect_ChildrenAtRank"
                            cmd.CommandType = CommandType.StoredProcedure
                            cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = row.NameGuid
                            cmd.Parameters.Add("@rank", SqlDbType.NVarChar).Value = pn.PNNameRank

                            Dim da As New SqlDataAdapter(cmd)
                            da.TableMappings.Add("Table", "Name")
                            da.Fill(ds)
                        End Using

                    Next

                    names = ds
                End If
            End If

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub


End Class
