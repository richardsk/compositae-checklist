Imports System.Collections.Generic
Imports System.Data.SqlClient
Imports System.Data

Public Class SearchableField
    Public TableName As String
    Public FieldName As String
    Public FriendlyName As String

    Public Overrides Function ToString() As String
        Return FriendlyName
    End Function
End Class

Public Class SearchSetting
    Public ID As String = ""
    Public SearchField As String
    Public SearchText As String
    Public SearchUpperText As String
    Public IsOr As Boolean = False
    Public IsAnd As Boolean = False
    Public AnywhereInText As Boolean = True
    Public WholeWord As Boolean = False
End Class

Public Class SearchStatusSelection
    Public IncludeAccepted As Boolean = True
    Public IncludeSynonyms As Boolean = True
    Public IncludeUnknown As Boolean = True
End Class

Public Class Search

    Private Shared ReadOnly Property ConnectionString() As String
        Get
            Return System.Configuration.ConfigurationManager.AppSettings("ConnectionString")
        End Get
    End Property

    Public Shared Function ListSearchableFields(ByVal tableName As String) As List(Of SearchableField)
        Dim sfs As New List(Of SearchableField)

        Dim sf As New SearchableField
        sf.FieldName = "NameFull"
        sf.FriendlyName = "Full name"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NameAuthors"
        sf.FriendlyName = "Authors"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NameYear"
        sf.FriendlyName = "Year"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NamePublishedIn"
        sf.FriendlyName = "Name reference"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NamePreferred"
        sf.FriendlyName = "Accepted name"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NameParent"
        sf.FriendlyName = "Parent name"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NameRank"
        sf.FriendlyName = "Taxon rank"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "NameBasionym"
        sf.FriendlyName = "Basionym"
        sf.TableName = "tblName"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "ProviderName"
        sf.FriendlyName = "Data Provider"
        sf.TableName = "tblProvider"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "TDWGLevel1"
        sf.FriendlyName = "Continent"
        sf.TableName = "tblOtherData"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "TDWGLevel2"
        sf.FriendlyName = "Region"
        sf.TableName = "tblOtherData"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "TDWGLevel3"
        sf.FriendlyName = "Botanical Country"
        sf.TableName = "tblOtherData"
        sfs.Add(sf)
        sf = New SearchableField
        sf.FieldName = "TDWGLevel4"
        sf.FriendlyName = "Basic Recording Unit"
        sf.TableName = "tblOtherData"
        sfs.Add(sf)

        Return sfs
    End Function

    Public Shared Function NameSearch(ByVal ss As List(Of SearchSetting), ByVal statusSel As SearchStatusSelection) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim hasDist As Boolean = False
                For Each setting As SearchSetting In ss
                    If setting.SearchField.StartsWith("TDWGLevel") Then
                        hasDist = True
                        Exit For
                    End If
                Next

                Dim sql As String = "select distinct n.nameguid, n.namerankfk, n.namefull, n.namecanonical, n.nameparent, n.nameauthors, n.namepreferredfk," + _
                    " case when n.namepreferredfk is null then 'Unknown' when n.namepreferredfk = n.nameguid then 'Accepted' else n.namepreferred end as NameStatus, " + _
                    " n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied, " + _
                    " n.namepublishedin, n.nameorthography, " + _
                    " n.namebasionymauthors, n.namecombinationauthors, " + _
                    " n.NamePreferred, " + _
                    " dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted, " + _
                    " tblrank.* " + _
                    " from tblName n inner join tblrank on rankpk = n.namerankfk " + _
                    " left join tblname cn on cn.nameparentfk = n.nameguid and cn.namepreferredfk = cn.nameguid " + _
                    " inner join tblProviderName pn on pn.pnnamefk = n.nameguid " + _
                    " inner join tblProviderImport pim on pim.ProviderImportPk = pn.pnproviderimportfk " + _
                    " inner join tblProvider p on p.providerpk = pim.providerimportproviderfk "

                If hasDist Then
                    sql = "set arithabort on; " + sql + " inner join tblOtherData o on n.NameGUID = o.RecordFk "
                End If

                sql += " where ("

                If ss(0).SearchField = "ProviderName" Then
                    sql += "p."
                ElseIf ss(0).SearchField.StartsWith("TDWGLevel") Then
                    'no prefix
                Else
                    sql += "n."
                End If

                For Each setting As SearchSetting In ss
                    If setting.SearchField.StartsWith("TDWGLevel") Then
                        If setting.IsAnd Then sql += ") and ("
                        If setting.IsOr Then sql += " or "

                        'Dim tg As TDWGGeo = Nothing 
                        'If setting.SearchField = "TDWGLevel1" Then
                        '    tg = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG1, setting.SearchText)
                        'ElseIf setting.SearchField = "TDWGLevel2" Then
                        '    tg = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG2, setting.SearchText)
                        'ElseIf setting.SearchField = "TDWGLevel3" Then
                        '    tg = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG3, setting.SearchText)
                        'ElseIf setting.SearchField = "TDWGLevel4" Then
                        '    tg = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG4, setting.SearchText)
                        'End If

                        'sql += " (o.OtherDataXml.exist('/DataSet/Biostat[contains(@region, """ + tg.Code + """)]') = 1 " + _
                        '    " and o.OtherDataXml.exist('/DataSet/Biostat[@Occurrence=""Present""]') = 1) "


                        Dim level As TDWGGeoLevel = TDWGGeoLevel.TDWG4
                        If setting.SearchField = "TDWGLevel1" Then
                            level = TDWGGeoLevel.TDWG1
                        ElseIf setting.SearchField = "TDWGLevel2" Then
                            level = TDWGGeoLevel.TDWG2
                        ElseIf setting.SearchField = "TDWGLevel3" Then
                            level = TDWGGeoLevel.TDWG3
                        End If

                        Dim tgs As List(Of DataAccess.TDWGGeo) = DataAccess.Distribution.Gazetteer.GetGeoRegions(level, setting.SearchText)

                        Dim where As String = "("
                        For Each tg As TDWGGeo In tgs
                            If where.Length > 1 Then where += " or "

                            Dim lvl As String = ""
                            If tg.Level = TDWGGeoLevel.TDWG1 Then lvl = "@L1"
                            If tg.Level = TDWGGeoLevel.TDWG2 Then lvl = "@L2"
                            If tg.Level = TDWGGeoLevel.TDWG3 Then lvl = "@L3"
                            If tg.Level = TDWGGeoLevel.TDWG4 Then lvl = "@L4"

                            where += " o.OtherDataXml.exist('/DataSet/Biostat[contains(" + lvl + ", """ + tg.Code + """)]') = 1 "
                        Next
                        where += ") and o.OtherDataXml.exist('/DataSet/Biostat[@Occurrence=""Present""]') = 1 "

                        sql += where
                    Else
                        Dim tn As String = "n."
                        If setting.SearchField = "ProviderName" Then tn = "p."

                        If setting.IsAnd Then sql += ") and (" + tn
                        If setting.IsOr Then sql += " or " + tn

                        If setting.SearchUpperText IsNot Nothing AndAlso setting.SearchUpperText.Length > 0 Then
                            sql += setting.SearchField + " >= '" + setting.SearchText + "' and "
                            sql += tn + setting.SearchField + " <= '" + setting.SearchUpperText + "'"
                        Else
                            sql += setting.SearchField + " like '"
                            If setting.AnywhereInText Then sql += "%"
                            sql += setting.SearchText
                            If setting.WholeWord Then sql += " "
                            sql += "%'"
                        End If

                    End If

                Next

                Dim origSrch As String = sql
                Dim stSql As String = ""
                If statusSel.IncludeAccepted And Not statusSel.IncludeSynonyms Then
                    stSql += "and (n.namepreferredfk = n.nameguid or cn.nameguid is not null "
                    If statusSel.IncludeUnknown Then stSql += "or n.namepreferredfk is null"
                    stSql += ") "
                End If
                If Not statusSel.IncludeAccepted Then
                    stSql += "and (n.namepreferredfk <> n.nameguid "
                    If statusSel.IncludeUnknown Then stSql += "or n.namepreferredfk is null"
                    stSql += ") "
                End If
                If Not statusSel.IncludeSynonyms Then
                    stSql += "and (n.namepreferredfk = n.nameguid "
                    If statusSel.IncludeUnknown Then stSql += "or n.namepreferredfk is null"
                    stSql += ") "
                End If
                If Not statusSel.IncludeUnknown Then
                    stSql += "and n.namepreferredfk is not null "
                End If
                If Not statusSel.IncludeAccepted AndAlso Not statusSel.IncludeSynonyms AndAlso statusSel.IncludeUnknown Then
                    stSql = "and n.namepreferredfk is null "
                End If
                sql += stSql

                sql += " ) order by RankSort, n.NameFull"
                origSrch += " ) order by RankSort, n.NameFull"


                cmd.CommandText = sql
                cmd.CommandTimeout = 60000
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                'try all names?
                'If ds.Tables(0).Rows.Count = 0 And Not includeInvalidNames Then
                '    cmd.CommandText = origSrch
                '    da = New SqlDataAdapter(cmd)
                '    da.Fill(ds)
                'End If
            End Using
        End Using

        Return ds
    End Function

    Public Shared Function NameSearchVariants(ByVal searchText As String) As DataSet
        'for "did you mean" results section
        'search for names in orthographic variants and provider data
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn
                cmd.CommandTimeout = 100000

                'FREE TEXT
                'Dim sql As String = "select distinct n.nameguid, n.namerankfk, n.namefull, n.namecanonical, n.nameparent, n.nameauthors, tblrank.*, " + _
                '    " nameorthography + ' (Orthographic Variant)' as MatchingText " + _
                '    " from tblName n inner join tblrank on rankpk = n.namerankfk " + _
                '    " left join tblprovidername pn on pn.pnnamefk = n.nameguid " + _
                '    " where contains(NameOrthography, '""" + searchText + "*""') " + _
                '    " and NameFull not like '" + searchText + "%'" + _
                '    " union " + _
                '    " select distinct n.nameguid, n.namerankfk, n.namefull, n.namecanonical, n.nameparent, n.nameauthors, tblrank.*, " + _
                '    " case when pnnamefull like '%" + searchText + "%' then pnnamefull " + _
                '    " when pnnameauthors like '%" + searchText + "%' then pnnameauthors end " + _
                '    " + ' (Provider Data)' collate SQL_Latin1_General_CP1_CI_AI as MatchingText " + _
                '    " from tblName n inner join tblrank on rankpk = n.namerankfk " + _
                '    " left join tblprovidername pn on pn.pnnamefk = n.nameguid " + _
                '    " where contains((PNNameFull, PNNameAuthors), '""" + searchText + "*""') " + _
                '    " and NameFull not like '" + searchText + "%'"


                'Dim sql As String = "select distinct n.nameguid, n.namerankfk, n.namefull, n.namecanonical, n.nameparent, n.nameauthors, tblrank.*, " + _
                '    " case when n.namefull like '%" + searchText + "%' then n.namefull " + _
                '    " when n.nameorthography like '%" + searchText + "%' then n.nameorthography " + _
                '    " when cn.namefull like '%" + searchText + "%' then cn.namefull " + _
                '    " when pn.pnnamefull like '%" + searchText + "%' then pn.pnnamefull " + _
                '    " when pn.pnnameauthors like '%" + searchText + "%' then pn.pnnameauthors " + _
                '    " end collate SQL_Latin1_General_CP1_CI_AI as MatchingText " + _
                '    " from tblName n inner join tblrank on rankpk = n.namerankfk " + _
                '    " left join tblname cn on cn.nameparentfk = n.nameguid " + _
                '    " left join tblprovidername pn on pn.pnnamefk = n.nameguid " + _
                '    " where (n.namefull like '%" + searchText + "%' or n.nameorthography like '%" + _
                '    searchText + "%' or cn.namefull like '%" + _
                '    searchText + "%' or pn.pnnamefull like '%" + _
                '    searchText + "%' or pn.pnnameauthors like '%" + searchText + "%') " + _
                '    " order by RankSort, n.NameFull"

                cmd.CommandText = "sprSelect_FuzzyNameSearch"
                cmd.CommandType = CommandType.StoredProcedure
                cmd.Parameters.Add("@searchText", SqlDbType.NVarChar).Value = searchText

                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

            End Using
        End Using

        Return ds
    End Function

    Public Shared Function NameSearchLevenshtein(ByVal ss As List(Of SearchSetting)) As DataSet
        'for "did you mean" results section
        'search for names using levenshtein

    End Function

    Public Shared Function LiteratureSearch(ByVal ss As List(Of SearchSetting)) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim sql As String = "select * from tblReference where ("
                For Each setting As SearchSetting In ss
                    If setting.IsAnd Then sql += ") and ("
                    If setting.IsOr Then sql += " or "

                    If setting.SearchUpperText IsNot Nothing Then
                        sql += setting.SearchField + " >= '" + setting.SearchText + "' and "
                        sql += setting.SearchField + " <= '" + setting.SearchUpperText + "'"
                    Else
                        sql += setting.SearchField + " like '"
                        If setting.AnywhereInText Then sql += "%"
                        sql += setting.SearchText
                        If setting.WholeWord Then sql += " "
                        sql += "%'"
                    End If

                Next

                sql += ") order by ReferenceCitation"

                cmd.CommandText = sql
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using
        End Using

        Return ds
    End Function

    Public Shared Function AdvancedLiteratureSearch(ByVal ss As List(Of SearchSetting)) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim sql As String = "select r.* from tblReference r inner join tblReferenceRIS ris on ris.RISReferenceFk = r.ReferenceGuid where ("
                For Each setting As SearchSetting In ss
                    If setting.IsAnd Then sql += ") and ("
                    If setting.IsOr Then sql += " or "

                    If setting.SearchUpperText IsNot Nothing Then
                        sql += "cast(ris." + setting.SearchField + " as varchar(1000)) >= '" + setting.SearchText + "' and "
                        sql += "cast(ris." + setting.SearchField + " as varchar(1000)) <= '" + setting.SearchUpperText + "'"
                    Else
                        sql += "ris." + setting.SearchField + " like '"
                        If setting.AnywhereInText Then sql += "%"
                        sql += setting.SearchText
                        If setting.WholeWord Then sql += " "
                        sql += "%'"
                    End If

                Next

                sql += ") order by r.ReferenceCitation"

                cmd.CommandText = sql
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using
        End Using

        Return ds
    End Function

    Public Shared Function DistributionSearch(ByVal searchAreas As List(Of TDWGGeo)) As DataSet
        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim sql As String = "set arithabort on; select distinct n.nameguid, n.namerankfk, n.namefull, n.namecanonical, n.nameparent, n.nameauthors," + _
                    " case when n.namepreferredfk is null then 'Unknown' when n.namepreferredfk = n.nameguid then 'Accepted' else 'Synonym of ' + n.namepreferred end as NameStatus, " + _
                    " dbo.fnGetFullName(n.NameGUID, 1,0,1,0,0) as NameFullFormatted, " + _
                    " n.nameyear, n.nameinvalid, n.nameillegitimate, n.namemisapplied, " + _
                    " n.namepublishedin, n.nameorthography, " + _
                    " n.NamePreferred, " + _
                    " tblrank.* " + _
                    " from tblName n inner join tblrank on rankpk = n.namerankfk " + _
                    " left join tblname cn on cn.nameparentfk = n.nameguid and cn.namepreferredfk = cn.nameguid " + _
                    " inner join tblOtherData on n.NameGUID = RecordFk where "

   
                Dim where As String = "("
                For Each tg As TDWGGeo In searchAreas
                    If where.Length > 1 Then where += " or "

                    Dim lvl As String = ""
                    If tg.Level = TDWGGeoLevel.TDWG1 Then lvl = "@L1"
                    If tg.Level = TDWGGeoLevel.TDWG2 Then lvl = "@L2"
                    If tg.Level = TDWGGeoLevel.TDWG3 Then lvl = "@L3"
                    If tg.Level = TDWGGeoLevel.TDWG4 Then lvl = "@L4"

                    where += " OtherDataXml.exist('/DataSet/Biostat[contains(" + lvl + ", """ + tg.Code + """)]') = 1 "

                    If lvl = "@L2" And tg.Code.Contains(",") Then
                        'add code up to ,
                        where += " or OtherDataXml.exist('/DataSet/Biostat[" + lvl + "=""" + tg.Code.Substring(0, tg.Code.IndexOf(",")) + """]') = 1 "
                    End If
                Next

                where += ") and OtherDataXml.exist('/DataSet/Biostat[@Occurrence=""Present""]') = 1 "

                sql += where
                sql += " order by RankSort, n.NameFull"

                cmd.CommandText = sql
                cmd.CommandTimeout = 60000
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)
            End Using
        End Using

        Return ds
    End Function
End Class
