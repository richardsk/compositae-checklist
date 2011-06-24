Imports System.Data
Imports System.Data.SqlClient

Imports ChecklistObjects

Public Class NameData

    Private Shared ConnectionString As String = Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString
    Private Shared UnknwonTaxaGuid As String

#Region "Names"
    Public Shared Function GetUknownTaxaGuid() As String
        If UnknwonTaxaGuid IsNot Nothing Then Return UnknwonTaxaGuid

        Dim ds As New DataSet
        Dim guid As String = ""

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UknownTaxaNode"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    guid = ds.Tables(0).Rows(0)("NameGuid").ToString
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return guid
    End Function

    Public Shared Function GetNameDs(ByVal trans As SqlTransaction, ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Dim cnn As SqlConnection

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprSelect_Name"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)
            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
        
        Return ds
    End Function

    Public Shared Function GetName(ByVal trans As SqlTransaction, ByVal nameGuid As String) As Name
        Dim n As Name
        Dim ds As New DataSet

        Dim cnn As SqlConnection

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprSelect_Name"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                n = New Name(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("NameGuid").ToString)
            End If
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return n
    End Function

    Public Shared Function GetNameChildren(ByVal trans As SqlTransaction, ByVal nameGuid As String) As List(Of Name)
        Dim children As New List(Of Name)
        Dim ds As New DataSet

        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprSelect_NameChildren"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)

            If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                For Each row As DataRow In ds.Tables(0).Rows
                    Dim n As New Name(row, row("NameGuid").ToString)
                    children.Add(n)
                Next
            End If
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return children
    End Function

    Public Shared Function GetNamesWithDiffPrefParent(ByVal parentId As String) As DataSet
        Dim names As New DataSet

        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)
        cnn.Open()

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprSelect_NamesWithDiffPrefParent"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@parentNameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(parentId)

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(names)
        End Using

        If cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return names
    End Function

    Public Shared Function GetNamesForUpdate(ByVal trans As SqlTransaction) As DataSet
        Dim ds As New DataSet

        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprSelect_NamesForUpdate"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandTimeout = Utility.LongSPTimeout

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return ds
    End Function

    Public Shared Function GetAllNamesForUpdate(ByVal trans As SqlTransaction) As DataSet
        Dim ds As New DataSet

        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprSelect_AllNamesForUpdate"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandTimeout = Utility.LongSPTimeout

            Dim da As New SqlDataAdapter(cmd)
            da.Fill(ds)
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return ds
    End Function

    'Public Shared Sub UpdateNameAuthors(ByVal trans As SqlTransaction, ByVal nameGuid As String, ByVal user As String)
    '    Dim cnn As SqlConnection
    '    If trans IsNot Nothing Then
    '        cnn = trans.Connection
    '    Else
    '        cnn = New SqlConnection(ConnectionString)
    '        cnn.Open()
    '    End If

    '    Using cmd As SqlCommand = cnn.CreateCommand()
    '        If trans IsNot Nothing Then cmd.Transaction = trans
    '        'cmd.CommandText = "sprUpdate_NameAuthors"
    '        cmd.CommandText = "sprUpdate_ConsensusAuthors"
    '        cmd.CommandType = CommandType.StoredProcedure
    '        cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
    '        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
    '        cmd.ExecuteNonQuery()
    '    End Using

    '    If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
    'End Sub

    Public Shared Function GetNamesInReference(ByVal refGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NamesInReference"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@refGuid", SqlDbType.UniqueIdentifier).Value = New Guid(refGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNameRefCitation(ByVal nameGuid As String) As String
        Dim ref As String = Nothing

        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)
        cnn.Open()
        
        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprSelect_NameRefCitation"
            cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)
            cmd.CommandType = CommandType.StoredProcedure
            cmd.CommandTimeout = Utility.LongSPTimeout

            Dim obj As Object = cmd.ExecuteScalar
            If obj IsNot DBNull.Value AndAlso obj.ToString.Length > 0 Then
                ref = obj.ToString
            End If
        End Using

        Return ref
    End Function

    Public Shared Sub DeleteNameRecord(ByVal trans As SqlTransaction, ByVal nameLsid As String, ByVal newNameLsid As String, ByVal user As String)
        Dim cnn As SqlConnection
        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprDelete_Name"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@nameLsid", SqlDbType.NVarChar).Value = nameLsid
            cmd.Parameters.Add("@newNameLsid", SqlDbType.NVarChar).Value = newNameLsid
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
    End Sub

    Public Shared Sub MoveNameChildren(ByVal trans As SqlTransaction, ByVal fromNameGuid As String, ByVal toNameGuid As String, ByVal user As String)
        Dim cnn As SqlConnection
        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            cmd.CommandText = "sprUpdate_MoveNameChildren"
            cmd.CommandType = CommandType.StoredProcedure
            If trans IsNot Nothing Then cmd.Transaction = trans

            cmd.Parameters.Add("@fromNameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(fromNameGuid)
            cmd.Parameters.Add("@toNameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(toNameGuid)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
    End Sub

    Public Shared Function GetMatchingNamesDs(ByVal PNPk As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameMatches"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerNamePk", SqlDbType.Int).Value = Utility.GetDBInt(PNPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetMatchingNames(ByVal PNPk As Integer, ByRef matchScore As Integer) As List(Of NameMatch)
        Dim names As New List(Of NameMatch)

        Dim ds As DataSet = GetMatchingNamesDs(PNPk)

        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            For Each row As DataRow In ds.Tables(0).Rows
                Dim nm As New NameMatch
                nm.NameId = row("NameGuid").ToString
                nm.NameFull = row("NameFull").ToString
                names.Add(nm)
            Next

            If ds.Tables.Count > 1 AndAlso ds.Tables(1).Rows.Count > 0 Then
                matchScore = ds.Tables(1).Rows(0)("MatchScore")
            End If
        End If

        Return names
    End Function

    Public Shared Function GetMatchedParentName(ByVal PNPk As Integer) As Name
        Dim n As Name

        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_MatchParentName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = Utility.GetDBInt(PNPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    n = New Name(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("NameGuid").ToString)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return n
    End Function

    Public Shared Sub UpdateName(ByVal n As Name, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_Name"
                cmd.CommandType = CommandType.StoredProcedure

                InsertUpdateNameRecord(cmd, n, User)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Private Shared Sub InsertUpdateNameRecord(ByVal cmd As SqlCommand, ByVal newName As Name, ByVal user As String)
        If newName.Id.Length = 0 Then newName.Id = Guid.NewGuid.ToString

        cmd.Parameters.Add("@NameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.Id)
        cmd.Parameters.Add("@NameLSID", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameLSID)
        cmd.Parameters.Add("@NameFull", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameFull)
        cmd.Parameters.Add("@NameRank", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameRank)
        cmd.Parameters.Add("@NameRankFk", SqlDbType.Int).Value = Utility.GetDBInt(newName.NameRankFk)
        cmd.Parameters.Add("@NameParentFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameParentFk)
        cmd.Parameters.Add("@NameParentName", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameParent)
        cmd.Parameters.Add("@NamePreferredFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NamePreferredFk)
        cmd.Parameters.Add("@NamePreferredName", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NamePreferred)
        cmd.Parameters.Add("@NameCanonical", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameCanonical)
        cmd.Parameters.Add("@NameAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(newName.NameAuthors)
        cmd.Parameters.Add("@NameBasionymAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(newName.NameBasionymAuthors)
        cmd.Parameters.Add("@NameCombinationAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(newName.NameCombinationAuthors)
        cmd.Parameters.Add("@NamePublishedIn", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NamePublishedIn)
        cmd.Parameters.Add("@NameReferenceFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameReferenceFk)
        cmd.Parameters.Add("@NameYear", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameYear)
        cmd.Parameters.Add("@NameMicroReference", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameMicroReference)
        cmd.Parameters.Add("@NameTypeVoucher", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameTypeVoucher)
        cmd.Parameters.Add("@NameTypeName", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameTypeName)
        cmd.Parameters.Add("@NameTypeNameFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameTypeNameFk)
        cmd.Parameters.Add("@NameOrthography", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameOrthography)
        cmd.Parameters.Add("@NameBasionym", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameBasionym)
        cmd.Parameters.Add("@NameBasionymFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameBasionymFk)
        cmd.Parameters.Add("@NameBasedOn", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameBasedOn)
        cmd.Parameters.Add("@NameBasedOnFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameBasedOnFk)
        cmd.Parameters.Add("@NameConservedAgainst", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameConservedAgainst)
        cmd.Parameters.Add("@NameConservedAgainstFk", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameConservedAgainstFk)
        cmd.Parameters.Add("@NameHomonymOf", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameHomonymOf)
        cmd.Parameters.Add("@NameHomonymOfFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameHomonymOfFk)
        cmd.Parameters.Add("@NameReplacementFor", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameReplacementFor)
        cmd.Parameters.Add("@NameReplacementForFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameReplacementForFk)
        cmd.Parameters.Add("@NameBlocking", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameBlocking)
        cmd.Parameters.Add("@NameBlockingFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(newName.NameBlockingFk)
        cmd.Parameters.Add("@NameInCitation", SqlDbType.Bit).Value = newName.NameInCitation
        cmd.Parameters.Add("@NameInvalid", SqlDbType.Bit).Value = newName.NameInvalid
        cmd.Parameters.Add("@NameIllegitimate", SqlDbType.Bit).Value = newName.NameIllegitimate
        cmd.Parameters.Add("@NameMisapplied", SqlDbType.Bit).Value = newName.NameMisapplied
        cmd.Parameters.Add("@NameProParte", SqlDbType.Bit).Value = newName.NameProParte
        cmd.Parameters.Add("@NameNomNotes", SqlDbType.NVarChar).Value = Utility.GetDBString(newName.NameNomNotes)
        cmd.Parameters.Add("@NameStatusNotes", SqlDbType.NText).Value = Utility.GetDBString(newName.NameStatusNotes)
        cmd.Parameters.Add("@NameNotes", SqlDbType.NText).Value = Utility.GetDBString(newName.NameNotes)
        cmd.Parameters.Add("@NameCounter", SqlDbType.Int).Value = Utility.GetDBInt(newName.NameCounter)
        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

        cmd.ExecuteNonQuery()
    End Sub

    Public Shared Sub SetNameRelationships(ByVal nameGuid As String, ByVal providerNamePk As Integer, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprUpdate_NameRelationships"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@providerNamePk", SqlDbType.Int).Value = providerNamePk
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub RefreshNameRelationData(ByVal nameGuid As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandText = "sprUpdate_NameRelationData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub RefreshNameLinkData(ByVal nameGuid As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandText = "sprUpdate_NameLinkData"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function InsertName(ByVal newName As Name, ByVal user As String) As Name

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            'create name
            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_Name"
                cmd.CommandType = CommandType.StoredProcedure

                InsertUpdateNameRecord(cmd, newName, user)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newName
    End Function

    Public Shared Sub DeleteNameAuthors(ByVal nameGuid As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_NameAuthors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
             
                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub DeleteProviderNameAuthors(ByVal pnpk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprDelete_ProviderNameAuthors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@pnpk", SqlDbType.Int).Value = pnpk

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function InsertUpdateNameAuthor(ByVal nameAuthorPk As Integer, ByVal nameGuid As String, ByVal basAuthors As String, ByVal combAuthors As String, ByVal basExAuth As String, ByVal combExAuth As String, ByVal isCorrected As Boolean, ByVal user As String) As DataSet
        Dim newAuth As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_NameAuthor"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameAuthorPk", SqlDbType.Int).Value = Utility.GetDBInt(nameAuthorPk)
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@basAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(basAuthors)
                cmd.Parameters.Add("@combAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(combAuthors)
                cmd.Parameters.Add("@basExAuth", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(basExAuth)
                cmd.Parameters.Add("@combExAuth", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(combExAuth)
                cmd.Parameters.Add("@isCorrected", SqlDbType.Bit).Value = isCorrected
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(newAuth)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newAuth
    End Function

    Public Shared Function InsertUpdateProviderNameAuthor(ByVal PNAuthorPk As Integer, ByVal pnpk As Integer, ByVal basAuthors As String, ByVal combAuthors As String, ByVal basExAuth As String, ByVal combExAuth As String, ByVal isCorrected As Boolean, ByVal user As String) As DataSet
        Dim newAuth As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_ProviderNameAuthor"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNAuthorPk", SqlDbType.Int).Value = Utility.GetDBInt(PNAuthorPk)
                cmd.Parameters.Add("@pnpk", SqlDbType.Int).Value = Utility.GetDBInt(pnpk)
                cmd.Parameters.Add("@basAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(basAuthors)
                cmd.Parameters.Add("@combAuthors", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(combAuthors)
                cmd.Parameters.Add("@basExAuth", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(basExAuth)
                cmd.Parameters.Add("@combExAuth", SqlDbType.NVarChar).Value = Utility.GetDBStringNonEmpty(combExAuth)
                cmd.Parameters.Add("@isCorrected", SqlDbType.Bit).Value = isCorrected
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(newAuth)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newAuth
    End Function

    Public Shared Function GetProviderNameAuthors(ByVal nameGuid As String) As DataSet
        Dim recs As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_ProviderNameAuthors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(recs)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return recs
    End Function

    Public Shared Function GetNameAuthors(ByVal nameGuid As String) As DataSet
        Dim recs As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_NameAuthors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(recs)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return recs
    End Function

    Public Shared Function UpdateProviderNameRelationships(ByVal PNPk As Integer, ByVal user As String) As DataRow
        Dim dr As DataRow

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ProviderNameRelationships"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerNamePk", SqlDbType.Int).Value = PNPk
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    dr = ds.Tables(0).Rows(0)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return dr
    End Function


    Public Shared Function LinkNameRank(ByVal nameGuid As String, ByVal user As String) As Integer
        'returns the rankPk of the linked rank if linked successfully
        Dim newRank As Integer = -1
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_NameRank"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim rnk As Object = cmd.ExecuteScalar()
                If rnk IsNot DBNull.Value Then newRank = rnk
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return newRank
    End Function

    Public Shared Function GetNameMappings() As List(Of NameMapping)
        Dim names As New List(Of NameMapping)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameMappings"
                cmd.CommandType = CommandType.StoredProcedure

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        names.Add(New NameMapping(row, row("NameMappingPk").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names
    End Function

    Public Shared Function ListNameRecords(ByVal searchText As String, ByVal maxRecords As Integer) As DataSet
        Dim recs As New DataSet
        If searchText IsNot Nothing AndAlso searchText.Length = 0 Then searchText = Nothing

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_SearchNames"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@searchText", SqlDbType.NVarChar).Value = Utility.GetDBString(searchText)
                cmd.Parameters.Add("@maxResults", SqlDbType.Int).Value = Utility.GetDBInt(maxRecords)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(recs)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return recs
    End Function

    Public Shared Function GetNameSynonyms(ByVal nameGuid As String) As List(Of Name)
        Dim names As New List(Of Name)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameSynonyms"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        names.Add(New Name(row, row("NameGuid").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names
    End Function

    Public Shared Function GetNameSynonymsDs(ByVal nameGuid As String) As DataSet
        Dim names As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameSynonyms"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(names)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names
    End Function

    Public Shared Function GetNameLSIDs(ByVal pageNumber As Integer, ByVal pageSize As Integer) As DataSet
        Dim lsids As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameLSIDs"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@pageNumber", SqlDbType.Int).Value = pageNumber
                cmd.Parameters.Add("@pageSize", SqlDbType.Int).Value = pageSize

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(lsids)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return lsids
    End Function

    Public Shared Function GetNameRelatedIds(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameRelatedIds"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNamesWithRankAndCanonical(ByVal nameRankFk As Integer, ByVal nameCanonical As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NamesWithRankAndCanonical"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameRankFk", SqlDbType.Int).Value = Utility.GetDBInt(nameRankFk)
                cmd.Parameters.Add("@nameCanonical", SqlDbType.NVarChar).Value = Utility.GetDBString(nameCanonical)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetChildNameCount(ByVal nameGuid As String) As Integer
        Dim count As Integer = 0

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameChildCount"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim obj As Object = cmd.ExecuteScalar()
                If obj IsNot DBNull.Value Then
                    count = obj
                End If

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return count
    End Function

    Public Shared Function GetChildNames(ByVal parentNameGuid As String, ByVal recurseChildren As Boolean) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ChildNames"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@parentNameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(parentNameGuid)
                cmd.Parameters.Add("@recurseChildren", SqlDbType.Bit).Value = recurseChildren

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNamesWithSameBasionym(ByVal nameGuid As String) As List(Of Name)
        Dim names As New List(Of Name)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NamesWithSameBasionym"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        names.Add(New Name(row, row("NameGuid").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names
    End Function

    Public Shared Function GetNamesWithAuthor(ByVal authorPk As Integer) As List(Of Name)
        Dim names As New List(Of Name)

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NamesWithAuthor"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@authorPk", SqlDbType.Int).Value = authorPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        names.Add(New Name(row, row("NameGuid").ToString))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names
    End Function

    Public Shared Function GetNameContributors(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameContributors"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNameEditTrail(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NameEditTrail"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetNameAutonymIssues() As DsAutonymIssues
        Dim ds As New DsAutonymIssues

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_AutonymIssues"
                cmd.CommandType = CommandType.StoredProcedure

                Dim da As New SqlDataAdapter(cmd)
                da.TableMappings.Add("Table", "UnacceptedAutonyms")
                da.TableMappings.Add("Table1", "NoConceptAutonyms")
                da.TableMappings.Add("Table2", "MissingAutonyms")

                da.Fill(ds)
            End Using
        End Using

        Return ds
    End Function
#End Region


#Region "Provider Names"

    Public Shared Function GetProviderName(ByVal PNPk As Integer) As ProviderName
        Dim pn As ProviderName
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pn = New ProviderName(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PNPk").ToString, True)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pn
    End Function

    Public Shared Function GetProviderName(ByVal providerPk As Integer, ByVal PNNameId As String) As ProviderName
        Dim pn As ProviderName
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderNameById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@PNNameId", SqlDbType.NVarChar).Value = PNNameId

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pn = New ProviderName(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PNPk").ToString, True)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pn
    End Function

    Public Shared Function GetProviderNameDs(ByVal providerPk As Integer, ByVal PNNameId As String) As DataSet
        Dim pn As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderNameById"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@PNNameId", SqlDbType.NVarChar).Value = PNNameId

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(pn)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pn
    End Function

    Public Shared Function GetProviderNameDs(ByVal PNPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetProviderNameRecords(ByVal nameGuid As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderNames"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@nameGuid", SqlDbType.UniqueIdentifier).Value = New Guid(nameGuid)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetProviderNameRelatedIds(ByVal providerPk As Integer, ByVal providerNameId As String) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_ProviderNameRelatedIds"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@providerNameId", SqlDbType.NVarChar).Value = providerNameId

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    'Public Shared Sub UpdateProviderNameAuthors(ByVal trans As SqlTransaction, ByVal PNPk As Integer, ByVal user As String)
    '    Dim cnn As SqlConnection
    '    If trans IsNot Nothing Then
    '        cnn = trans.Connection
    '    Else
    '        cnn = New SqlConnection(ConnectionString)
    '        cnn.Open()
    '    End If

    '    Using cmd As SqlCommand = cnn.CreateCommand()
    '        If trans IsNot Nothing Then cmd.Transaction = trans
    '        cmd.CommandText = "sprUpdate_ProviderNameAuthors"
    '        cmd.CommandType = CommandType.StoredProcedure
    '        cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk
    '        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user
    '        cmd.ExecuteNonQuery()
    '    End Using

    '    If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
    'End Sub

    Public Shared Sub UpdateProviderNameLink(ByVal PNPk As Integer, ByVal PNNameFk As String, ByVal PNLinkStatus As String, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprUpdate_ProviderNameLink"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk
                cmd.Parameters.Add("@PNNameFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(PNNameFk)
                cmd.Parameters.Add("@PNLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(PNLinkStatus)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub UpdateProviderNameMatchScore(ByVal PNPk As Integer, ByVal matchScore As Integer, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprUpdate_ProviderNameMatchScore"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk
                cmd.Parameters.Add("@MatchScore", SqlDbType.Int).Value = matchScore
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    'Public Shared Sub UpdateProviderConceptLinks(ByVal PNPk As Integer, ByVal user As String)
    '    Using cnn As New SqlConnection(ConnectionString)
    '        cnn.Open()

    '        Using cmd As SqlCommand = cnn.CreateCommand
    '            cmd.CommandText = "sprUpdate_ProviderConceptLinks"
    '            cmd.CommandType = CommandType.StoredProcedure
    '            cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk
    '            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

    '            cmd.ExecuteNonQuery()
    '        End Using

    '        If cnn.State <> ConnectionState.Closed Then cnn.Close()
    '    End Using
    'End Sub

    Public Shared Function UpdateProviderNameConceptLinks(ByVal PNPk As Integer, ByVal user As String) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ProviderNameConceptLinks"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Sub UnlinkProviderConcepts(ByVal pnpk As Integer, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand("sprUpdate_UnlinkProviderConcepts")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Connection = cnn
                cmd.Parameters.Add("@pnpk", SqlDbType.Int).Value = pnpk
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using
        End Using
    End Sub

    Public Shared Function GetProviderNameConcepts(ByVal pnpk As Integer) As DataSet
        Dim ds As New DataSet
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand("sprSelect_ProviderNameConcepts")
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Connection = cnn
                cmd.Parameters.Add("@pnpk", SqlDbType.Int).Value = pnpk

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using
        End Using
        Return ds
    End Function

    Public Shared Sub DeleteProviderName(ByVal PNPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprDelete_ProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = PNPk

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub

    Public Shared Sub DeleteProviderNameRecord(ByVal trans As SqlTransaction, ByVal providerPk As Integer, ByVal providerNameId As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand()
            cmd.CommandText = "sprDelete_ProviderNameRecord"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
            cmd.Parameters.Add("@providerNameId", SqlDbType.NVarChar).Value = providerNameId
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Public Shared Sub DeleteProviderNameRecord(ByVal providerPk As Integer, ByVal providerNameId As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprDelete_ProviderNameRecord"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = providerPk
                cmd.Parameters.Add("@providerNameId", SqlDbType.NVarChar).Value = providerNameId

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub

    Private Shared Sub InsertProviderNameRecord(ByVal cmd As SqlCommand, ByVal providerName As ProviderName, ByVal user As String)
        cmd.Parameters.Add("@PNPk", SqlDbType.Int).Value = providerName.IdAsInt
        cmd.Parameters.Add("@PNNameFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNNameFk)
        cmd.Parameters.Add("@PNLinkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNLinkStatus)
        cmd.Parameters.Add("@PNNameMatchScore", SqlDbType.Int).Value = Utility.GetDBInt(providerName.PNNameMatchScore)
        cmd.Parameters.Add("@PNProviderImportFk", SqlDbType.Int).Value = Utility.GetDBInt(providerName.PNProviderImportFk)
        cmd.Parameters.Add("@PNProviderUpdatedDate", SqlDbType.DateTime).Value = Utility.GetDBDate(providerName.PNProviderUpdatedDate)
        cmd.Parameters.Add("@PNProviderAddedDate", SqlDbType.DateTime).Value = Utility.GetDBDate(providerName.PNProviderAddedDate)
        cmd.Parameters.Add("@PNNameId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameId)
        cmd.Parameters.Add("@PNNameFull", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameFull)
        cmd.Parameters.Add("@PNNameRank", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameRank)
        cmd.Parameters.Add("@PNNameRankFk", SqlDbType.Int).Value = Utility.GetDBInt(providerName.PNNameRankFk)
        cmd.Parameters.Add("@PNNameCanonical", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameCanonical)
        cmd.Parameters.Add("@PNNameAuthors", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameAuthors)
        cmd.Parameters.Add("@PNBasionymAuthors", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBasionymAuthors)
        cmd.Parameters.Add("@PNCombinationAuthors", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNCombinationAuthors)
        cmd.Parameters.Add("@PNPublishedIn", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNPublishedIn)
        cmd.Parameters.Add("@PNReferenceId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNReferenceId)
        cmd.Parameters.Add("@PNReferenceFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNReferenceFk)
        cmd.Parameters.Add("@PNYear", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNYear)
        cmd.Parameters.Add("@PNMicroReference", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNMicroReference)
        cmd.Parameters.Add("@PNTypeVoucher", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNTypeVoucher)
        cmd.Parameters.Add("@PNTypeName", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNTypeName)
        cmd.Parameters.Add("@PNTypeNameId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNTypeNameId)
        cmd.Parameters.Add("@PNTypeNameFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNTypeNameFk)
        cmd.Parameters.Add("@PNOrthography", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNOrthography)
        cmd.Parameters.Add("@PNBasionym", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBasionym)
        cmd.Parameters.Add("@PNBasionymId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBasionymId)
        cmd.Parameters.Add("@PNBasionymFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNBasionymFk)
        cmd.Parameters.Add("@PNBasedOn", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBasedOn)
        cmd.Parameters.Add("@PNBasedOnId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBasedOnId)
        cmd.Parameters.Add("@PNBasedOnFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNBasedOnFk)
        cmd.Parameters.Add("@PNConservedAgainst", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNConservedAgainst)
        cmd.Parameters.Add("@PNConservedAgainstId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNConservedAgainstId)
        cmd.Parameters.Add("@PNConservedAgainstFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNConservedAgainstFk)
        cmd.Parameters.Add("@PNHomonymOf", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNHomonymOf)
        cmd.Parameters.Add("@PNHomonymOfId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNHomonymOfId)
        cmd.Parameters.Add("@PNHomonymOfFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNHomonymOfFk)
        cmd.Parameters.Add("@PNReplacementFor", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNReplacementFor)
        cmd.Parameters.Add("@PNReplacementForId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNReplacementForId)
        cmd.Parameters.Add("@PNReplacementForFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNReplacementForFk)
        cmd.Parameters.Add("@PNBlocking", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBlocking)
        cmd.Parameters.Add("@PNBlockingId", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNBlockingId)
        cmd.Parameters.Add("@PNBlockingFk", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(providerName.PNBlockingFk)
        cmd.Parameters.Add("@PNInCitation", SqlDbType.Bit).Value = providerName.PNInCitation
        cmd.Parameters.Add("@PNInvalid", SqlDbType.Bit).Value = providerName.PNInvalid
        cmd.Parameters.Add("@PNIllegitimate", SqlDbType.Bit).Value = providerName.PNIllegitimate
        cmd.Parameters.Add("@PNMisapplied", SqlDbType.Bit).Value = providerName.PNMisapplied
        cmd.Parameters.Add("@PNProParte", SqlDbType.Bit).Value = providerName.PNProParte
        cmd.Parameters.Add("@PNGeographyText", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNGeographyText)
        cmd.Parameters.Add("@PNGeographyCodes", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNGeographyCodes)
        cmd.Parameters.Add("@PNClimate", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNClimate)
        cmd.Parameters.Add("@PNLifeform", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNLifeform)
        cmd.Parameters.Add("@PNIUCN", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNIUCN)
        cmd.Parameters.Add("@PNNotes", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNNotes)
        cmd.Parameters.Add("@PNStatusNotes", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNStatusNotes)
        cmd.Parameters.Add("@PNNonNotes", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNNonNotes)
        cmd.Parameters.Add("@PNQualityStatement", SqlDbType.NText).Value = Utility.GetDBString(providerName.PNQualityStatement)
        cmd.Parameters.Add("@PNNameVersion", SqlDbType.NVarChar).Value = Utility.GetDBString(providerName.PNNameVersion)
        cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

        Dim newId As Object = cmd.ExecuteScalar()

        If Not newId Is DBNull.Value AndAlso providerName.IdAsInt = -1 Then providerName.IdAsInt = newId
    End Sub

    Public Shared Sub InsertUpdateProviderNameRecord(ByVal providerName As ProviderName, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsertUpdate_ProviderName"
                cmd.CommandType = CommandType.StoredProcedure
                InsertProviderNameRecord(cmd, providerName, user)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

    End Sub

    Public Shared Sub InsertUpdateProviderNameRecord(ByVal trans As SqlTransaction, ByVal providerName As ProviderName, ByVal user As String)
        Using cmd As SqlCommand = trans.Connection.CreateCommand()
            cmd.CommandText = "sprInsertUpdate_ProviderName"
            cmd.Transaction = trans
            cmd.CommandType = CommandType.StoredProcedure
            InsertProviderNameRecord(cmd, providerName, user)
        End Using
    End Sub

    Public Shared Function GetUnlinkedProviderNamesDs(ByVal providerPk As Integer) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedNames"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return ds
    End Function

    Public Shared Function GetUnlinkedProviderNames(ByVal providerPk As Integer) As ProviderName()
        Dim names As New ArrayList

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedNames"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    For Each row As DataRow In ds.Tables(0).Rows
                        names.Add(New ProviderName(row, row("PNPk"), True))
                    Next
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return names.ToArray(GetType(ProviderName))
    End Function

    Public Shared Sub ResetLinkStatuses()
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprUpdate_ResetFailedStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetUnlinkedProviderNamesCount(ByVal providerPk As Integer) As Integer
        Dim count As Integer = -1

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_UnlinkedNamesCount"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                count = cmd.ExecuteScalar()

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return count
    End Function

    Public Shared Sub InsertNamesIntegrationOrder(ByVal providerPk As Integer)
        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprInsert_NamesIntegrationOrder"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Function GetNextUnlinkedProviderName(ByVal index As Integer) As ProviderName
        Dim pn As ProviderName

        Using cnn As New SqlConnection(ConnectionString)
            Dim ds As New DataSet
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_NextUnlinkedName"
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@index", SqlDbType.Int).Value = index

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pn = New ProviderName(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PNPk").ToString, True)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return pn
    End Function

    Public Shared Function LinkProviderNameRank(ByVal trans As SqlTransaction, ByVal PNPk As Integer, ByVal user As String) As Integer
        Dim cnn As SqlConnection = New SqlConnection(ConnectionString)

        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn.Open()
        End If

        'returns the rankPk of the linked rank if linked successfully
        Dim newRank As Integer = -1
        Dim ds As New DataSet

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprUpdate_ProviderNameRank"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@providerNamePk", SqlDbType.Int).Value = Utility.GetDBInt(PNPk)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim rnk As Object = cmd.ExecuteScalar()
            If rnk IsNot DBNull.Value Then newRank = rnk
        End Using

        If trans Is Nothing And cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return newRank
    End Function


    Public Shared Function LinkProviderConceptRelationship(ByVal trans As SqlTransaction, ByVal PCRPk As Integer, ByVal user As String) As Integer
        Dim newId As Integer = -1

        Dim cnn As SqlConnection
        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Dim ds As New DataSet

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprUpdate_ProviderConceptRelationship"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@PCRPk", SqlDbType.Int).Value = Utility.GetDBInt(PCRPk)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            Dim id As Object = cmd.ExecuteScalar()
            If Not id Is DBNull.Value Then newId = id
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()

        Return newId
    End Function


    Public Shared Sub RelinkProviderNames(ByVal trans As SqlTransaction, ByVal fromNameGuid As String, ByVal toNameGuid As String, ByVal linkStatus As String, ByVal user As String)

        Dim cnn As SqlConnection
        If trans IsNot Nothing Then
            cnn = trans.Connection
        Else
            cnn = New SqlConnection(ConnectionString)
            cnn.Open()
        End If

        Using cmd As SqlCommand = cnn.CreateCommand()
            If trans IsNot Nothing Then cmd.Transaction = trans
            cmd.CommandText = "sprUpdate_LinkedProviderNames"
            cmd.CommandType = CommandType.StoredProcedure
            cmd.Parameters.Add("@fromNameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(fromNameGuid)
            cmd.Parameters.Add("@toNameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(toNameGuid)
            cmd.Parameters.Add("@linkStatus", SqlDbType.NVarChar).Value = Utility.GetDBString(linkStatus)
            cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

            cmd.ExecuteNonQuery()
        End Using

        If trans Is Nothing AndAlso cnn.State <> ConnectionState.Closed Then cnn.Close()
    End Sub

    Public Shared Function ListProviderNameRecords(ByVal providerPk As Integer, ByVal linkType As LinkType, ByVal filterText As String, ByVal maxRecords As Integer) As DataSet
        Dim recs As New DataSet
        If filterText IsNot Nothing AndAlso filterText.Length = 0 Then filterText = Nothing

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand
                cmd.CommandText = "sprSelect_SearchProviderNames"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.CommandTimeout = Utility.LongSPTimeout
                cmd.Parameters.Add("@providerPk", SqlDbType.Int).Value = Utility.GetDBInt(providerPk)
                cmd.Parameters.Add("@linkType", SqlDbType.NVarChar).Value = Utility.GetDBString(linkType.ToString.ToLower)
                cmd.Parameters.Add("@filterText", SqlDbType.NVarChar).Value = Utility.GetDBString(filterText)
                cmd.Parameters.Add("@maxRecords", SqlDbType.Int).Value = Utility.GetDBInt(maxRecords)

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(recs)

            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using

        Return recs
    End Function

    Public Shared Function GetSystemProviderNameForName(ByVal NameGuid As String) As ProviderName
        Dim pn As ProviderName
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "sprSelect_SystemProviderNameForName"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@NameGuid", SqlDbType.UniqueIdentifier).Value = Utility.GetDBGuid(NameGuid)

                Dim ds As New DataSet
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                    pn = New ProviderName(ds.Tables(0).Rows(0), ds.Tables(0).Rows(0)("PNPk").ToString, True)
                End If
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
        Return pn
    End Function

#End Region

#Region "Field Status"

    Public Shared Sub InsertUpdateFieldStatus(ByVal recordId As String, ByVal fieldStatusId As Integer, ByVal statusLevelFk As Integer, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "spInsertUpdate_FieldStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@recordId", SqlDbType.NVarChar).Value = recordId
                cmd.Parameters.Add("@fieldStatusId", SqlDbType.Int).Value = fieldStatusId
                cmd.Parameters.Add("@statusLevelFk", SqlDbType.Int).Value = Utility.GetDBInt(statusLevelFk)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

    Public Shared Sub InsertFieldStatus(ByVal recordId As String, ByVal tableName As String, ByVal fieldName As String, ByVal statusLevelFk As Integer, ByVal user As String)
        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As SqlCommand = cnn.CreateCommand()
                cmd.CommandText = "spInsert_FieldStatus"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@recordId", SqlDbType.NVarChar).Value = recordId
                cmd.Parameters.Add("@tableName", SqlDbType.NVarChar).Value = tableName
                cmd.Parameters.Add("@fieldName", SqlDbType.NVarChar).Value = fieldName
                cmd.Parameters.Add("@statusLevelFk", SqlDbType.Int).Value = Utility.GetDBInt(statusLevelFk)
                cmd.Parameters.Add("@user", SqlDbType.NVarChar).Value = user

                cmd.ExecuteNonQuery()
            End Using

            If cnn.State <> ConnectionState.Closed Then cnn.Close()
        End Using
    End Sub

#End Region

End Class
