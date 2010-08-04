Imports System.Data.SqlClient

Public Class NamesWithExactCanonical
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

        For Each row As DsNameMatch.NameRow In names.Name
            If row.NameCanonical.Trim <> pn.PNNameCanonical.Trim Then
                row.Delete()
            End If
        Next

        names.AcceptChanges()
    End Sub


End Class
