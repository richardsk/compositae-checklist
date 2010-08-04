Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class AuthorData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString


    Public Shared Function ListAuthors(ByVal searchText As String, ByVal anywhereInText As Boolean) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Authors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@searchTxt", SqlDbType.NVarChar).Value = searchText
                cmd.Parameters.Add("@anywhereInText", SqlDbType.Bit).Value = anywhereInText

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetAuthor(ByVal authorPk As Integer) As Author
        Dim auth As Author = Nothing
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_Author"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@authorPk", SqlDbType.Int).Value = authorPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    auth = New Author(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("AuthorPk"))
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return auth
    End Function

    Public Shared Function GetAuthorByName(ByVal author As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_AuthorByName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@author", SqlDbType.NVarChar).Value = author

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Sub SaveAuthor(ByVal auth As Author, ByVal user As String)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_Author"
                cmd.CommandType = CommandType.StoredProcedure

                cmd.Parameters.Add("@authorPk", SqlDbType.Int).Value = auth.AuthorPk
                cmd.Parameters.Add("@IPNIAuthor_Id", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.IPNIAuthor_id)
                cmd.Parameters.Add("@IPNIVersion", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.IPNIVersion)
                cmd.Parameters.Add("@abbreviation", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.Abbreviation)
                cmd.Parameters.Add("@forename", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.Forename)
                cmd.Parameters.Add("@surname", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.Surname)
                cmd.Parameters.Add("@TaxonGroups", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.TaxonGroups)
                cmd.Parameters.Add("@Dates", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.Dates)
                cmd.Parameters.Add("@IPNIAlternativeNames", SqlDbType.NVarChar).Value = Utility.GetDBString(auth.IPNIAlternativeNames)
                cmd.Parameters.Add("@correctAuthorFk", SqlDbType.Int).Value = Utility.GetDBInt(auth.CorrectAuthorFk)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                auth.AuthorPk = cmd.ExecuteScalar()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub


End Class
