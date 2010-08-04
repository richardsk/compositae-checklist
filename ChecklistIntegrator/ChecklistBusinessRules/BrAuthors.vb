Imports ChecklistDataAccess
Imports ChecklistObjects
Imports System.Data.OleDb

Public Class BrAuthors

    Public Delegate Sub ImportStatusDelegate(ByVal percComplete As Integer)

    Public Shared ImportStatusCallback As ImportStatusDelegate

    'returns as string of the corrected author ids
    ' eg 'Smith & Jones' passed in, then something like '1044 1662' is returned
    Public Shared Function ParseAuthors(ByVal authors As String) As String
        Dim result As String = ""

        Dim origAuthors As String = authors

        authors = authors.ToLower()

        'remove before brackets
        If authors.LastIndexOf(")") <> -1 Then
            authors = authors.Substring(authors.LastIndexOf(")") + 1)
            origAuthors = origAuthors.Substring(origAuthors.LastIndexOf(")") + 1)
        End If

        'remove 'in citation', 'ex' etc

        While authors.IndexOf("  ") <> -1
            authors = authors.Replace("  ", " ")
            origAuthors = origAuthors.Replace("  ", " ")
        End While

        authors = authors.Replace(" et ", " & ")
        origAuthors = origAuthors.Replace(" et ", " & ")

        If authors.IndexOf(" ex ") <> -1 Then
            authors = authors.Substring(authors.IndexOf(" ex ") + 4)
            origAuthors = origAuthors.Substring(origAuthors.IndexOf(" ex ") + 4)
        End If

        If authors.IndexOf(" in ") <> -1 Then
            authors = authors.Substring(0, authors.IndexOf(" in "))
            origAuthors = origAuthors.Substring(0, origAuthors.IndexOf(" in "))
        End If

        authors = authors.Trim
        origAuthors = origAuthors.Trim


        If authors.Length > 0 Then
            'split by '&', ','
            Dim endpos1 As Integer = authors.IndexOf("&")
            Dim endpos2 As Integer = authors.IndexOf(",")
            Dim endpos As Integer = Math.Min(endpos1, endpos2)
            If endpos = -1 Then endpos = Math.Max(endpos1, endpos2)
            Dim pos As Integer = 0

            While pos <> -1
                Dim auth As String = ""
                Dim origAuth As String = ""
                If endpos = -1 Then
                    auth = authors.Substring(pos).Trim
                    origAuth = origAuthors.Substring(pos).Trim
                Else
                    auth = authors.Substring(pos, endpos - pos).Trim
                    origAuth = origAuthors.Substring(pos, endpos - pos).Trim
                End If

                If auth.Length > 0 Then
                    Dim authId As Integer = -1
                    Dim a As Author = BrAuthors.GetAuthorByName(auth)
                    If a IsNot Nothing Then
                        authId = a.CorrectAuthorFk
                    Else
                        'insert new author
                        a = New Author
                        a.Abbreviation = origAuth
                        AuthorData.SaveAuthor(a, SessionState.CurrentUser.Login)
                        authId = a.AuthorPk
                    End If

                    result += authId.ToString + " "
                End If

                If endpos = -1 Then
                    pos = -1
                Else
                    pos = endpos + 1
                    endpos1 = authors.IndexOf("&", pos)
                    endpos2 = authors.IndexOf(",", pos)
                    endpos = Math.Min(endpos1, endpos2)
                    If endpos = -1 Then endpos = Math.Max(endpos1, endpos2)
                End If

            End While
        End If

        Return result.Trim
    End Function

    'find any ex authors in the authors string
    Public Shared Function GetExAuthors(ByVal authors As String) As String
        Dim auth As String = ""

        authors = authors.ToLower
        'remove preceding basionym authors ?
        Dim brPos As Integer = authors.LastIndexOf(")")
        If brPos <> -1 Then
            authors = authors.Substring(brPos + 1)
        End If

        If authors.IndexOf(" ex ") <> -1 Then
            Dim exAuth As String = authors.Substring(0, authors.IndexOf(" ex "))

            auth = ParseAuthors(exAuth)
        End If

        Return auth
    End Function

    'list of space separated ids passed in, eg 14423 66332
    'list of corrected ids passed back, eg 14888 66332
    Public Shared Function GetCorrectedAuthors(ByVal authorIdList As String) As String
        Dim corrIds As String = ""

        If authorIdList.Length > 0 Then
            Dim endpos As Integer = authorIdList.IndexOf(" ")
            Dim pos As Integer = 0

            While pos <> -1
                Dim id As String = ""
                If endpos = -1 Then
                    id = authorIdList.Substring(pos).Trim
                Else
                    id = authorIdList.Substring(pos, endpos - pos).Trim
                End If

                If id.Length > 0 Then
                    Dim a As Author = AuthorData.GetAuthor(id)
                    If a IsNot Nothing Then
                        corrIds += a.CorrectAuthorFk.ToString + " "
                    End If
                End If

                If endpos = -1 Then
                    pos = -1
                Else
                    pos = endpos + 1
                    endpos = authorIdList.IndexOf(" ", pos)
                End If

            End While
        End If

        Return corrIds.Trim
    End Function

    'lists of space delimited corrected author ids passed in
    'fullName is true if the name should be formatted for a full name
    Public Shared Function GetFullAuthorString(ByVal basAuth As String, ByVal combAuth As String, ByVal basEx As String, ByVal combEx As String, ByVal fullName As Boolean) As String
        Dim basAuthStr As String = ""
        Dim combAuthStr As String = ""


        If combAuth.Length > 0 Then
            combAuthStr = GetAuthorString(combAuth)
            If combEx.Length > 0 Then
                combAuthStr = GetAuthorString(combEx) + " ex " + combAuthStr
            End If
        End If

        If basAuth.Length > 0 Then
            basAuthStr = GetAuthorString(basAuth)
            If basEx.Length > 0 Then
                basAuthStr = GetAuthorString(basEx) + " ex " + basAuthStr
            End If
        End If

        Dim authorStr As String = ""

        If basAuthStr.Length > 0 Then
            If fullName Then
                authorStr = "(" + basAuthStr + ")"
            Else
                authorStr = basAuthStr
            End If
            If combAuthStr.Length > 0 Then authorStr += " "
        End If
        If combAuthStr.Length > 0 Then authorStr += combAuthStr

        Return authorStr
    End Function

    'list of space delimited ids passed in, eg 2432 7642
    'author string passed back
    Public Shared Function GetAuthorString(ByVal authors As String) As String
        Dim authorStr As String = ""

        Dim endpos As Integer = authors.IndexOf(" ")
        Dim pos As Integer = 0

        Dim delim As String = ""

        While pos <> -1
            Dim id As String = ""
            If endpos = -1 Then
                id = authors.Substring(pos).Trim
            Else
                id = authors.Substring(pos, endpos - pos).Trim
            End If

            If id.Length > 0 Then
                Dim a As Author = AuthorData.GetAuthor(id)
                If a IsNot Nothing AndAlso a.Abbreviation.Length > 0 Then
                    authorStr += delim + a.Abbreviation
                    delim = ", " 'after first one
                End If
            End If

            If endpos = -1 Then
                pos = -1 'end
                'replace last ,
                Dim lastPos As Integer = authorStr.LastIndexOf(",")
                If lastPos <> -1 Then authorStr = authorStr.Substring(0, lastPos) + " &" + authorStr.Substring(lastPos + 1)
            Else
                pos = endpos + 1
                endpos = authors.IndexOf(" ", pos)
            End If
        End While

        Return authorStr
    End Function

    Public Shared Sub SaveAuthors(ByVal ds As DataSet)
        Dim ch As DataTable = ds.Tables(0).GetChanges()
        Dim origCh As DataTable = ch.Copy()

        'do new authors first
        For Each row As DataRow In ch.Rows
            If row("AuthorPk") < 0 Then
                Dim oldId As Integer = row("AuthorPk")

                row("AuthorPk") = -1

                AuthorData.SaveAuthor(New Author(row, -1), SessionState.CurrentUser.Login)

                'update dataset
                Dim oldRow As DataRow() = ds.Tables(0).Select("AuthorPk = " + oldId.ToString())
                If oldRow.Length > 0 Then oldRow(0)("AuthorPk") = row("AuthorPk")

                'update other authors that pointed to this one
                For Each r As DataRow In ch.Rows
                    If r("CorrectAuthorFk") = oldId Then r("CorrectAuthorFk") = row("AuthorPk")
                Next
            End If
        Next

        'do correct author updates
        For Each row As DataRow In origCh.Rows
            If row("AuthorPk") > 0 Then
                AuthorData.SaveAuthor(New Author(row, row("AuthorPk")), SessionState.CurrentUser.Login)
            End If
        Next
    End Sub

    Public Shared Function GetAuthorByName(ByVal author As String) As Author
        If author Is Nothing Then Return Nothing

        Dim ds As DataSet = AuthorData.GetAuthorByName(author)
        Dim auth As Author
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            auth = New Author(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("AuthorPk"))
        End If
        Return auth
    End Function

    Public Shared Sub ImportAuthors(ByVal mdbFilename As String)
        Dim cnn As OleDbConnection
        Dim ds As New DataSet

        'load data from mdb
        Try
            cnn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + mdbFilename + ";")
            cnn.Open()

            Using cmd As OleDbCommand = cnn.CreateCommand()
                Dim da As New OleDbDataAdapter(cmd)

                cmd.CommandText = "select * from tblAuthors"
                da.Fill(ds)
            End Using

        Catch ex As Exception
            ChecklistException.LogError(ex)
        Finally
            If cnn IsNot Nothing Then cnn.Close()
        End Try


        If ds.Tables.Count > 0 Then
            Dim count As Integer = ds.Tables(0).Rows.Count
            Dim pos As Integer = 1

            For Each row As DataRow In ds.Tables(0).Rows
                AuthorData.SaveAuthor(New Author(row, row("AuthorPk")), SessionState.CurrentUser.Login)

                Dim p As Integer = pos * 100 / count
                If p > 99 Then p = 99 'dont finsih till really done
                If ImportStatusCallback IsNot Nothing Then ImportStatusCallback.Invoke(p)
                pos += 1
            Next
            'done
            If ImportStatusCallback IsNot Nothing Then ImportStatusCallback.Invoke(100)
        End If
    End Sub
End Class
