Imports System.Data.SqlClient

Public Class NamesWithSameParent
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

        Dim ds As New DsNameMatch
        Dim guid As String = ""

        Dim ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Dim parentId As String = ""

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "declare @provPk int; select @provPk = providerpk from vwprovidername where pnpk = " + pn.Id + "; " + _
                     "select PNNameFk " + _
                     "from vwProviderConceptRelationship pcr " + _
                     "inner join vwProviderName pn on pn.PNNameId = pcr.PCName2Id and pn.ProviderPk = pcr.ProviderPk " + _
                     "where PCName1Id = '" + pn.PNNameId + "' and PCRRelationshipFk = 6 and pcr.ProviderPk = @provPk"

                parentId = cmd.ExecuteScalar()
            End Using

            If parentId <> "" Then
                Using cmd As SqlCommand = cnn.CreateCommand
                    cmd.CommandText = "select nameguid, namecanonical, namefull, namerank, nameauthors, nameyear, 100 " + _
                        "from tblName inner join tblrank on rankpk = namerankfk where NameParentFk = '" + parentId + "'"

                    Dim da As New SqlDataAdapter(cmd)
                    da.TableMappings.Add("Table", "Name")
                    da.Fill(ds)

                End Using
            End If

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Sub RemoveNonMatches(ByVal pn As ChecklistObjects.ProviderName, ByRef names As DsNameMatch) Implements INameMatcher.RemoveNonMatches

    End Sub

End Class
