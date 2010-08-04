Imports ChecklistDataAccess
Imports System.Data.SqlClient
Imports System.Text

Public Class Report

    Private Shared NameIds As List(Of String)
    Private Shared ProviderIds As List(Of String)

    Private Shared ReadOnly Property ConnectionString() As String
        Get
            Return System.Configuration.ConfigurationManager.AppSettings("ConnectionString")
        End Get
    End Property

    Public Shared Function GenerateRTFReport(ByVal ds As DataSet, ByVal showConflicts As Boolean, ByVal includeDist As Boolean) As String
        NameIds = New List(Of String)
        ProviderIds = New List(Of String)

        Dim doc As New StringBuilder
        doc.Append("{\rtf\ansi\deff0")

        doc.Append("{\colortbl;\red0\green0\blue0;\red255\green0\blue0;}")

        If showConflicts Then
            doc.Append("*indicates conflict in preferred concepts\line")
            doc.Append("\cf2 red \cf1 indicates logical inconsistency in preferred concepts\line")
        End If

        doc.Append("\line")

        'do accepted names, and their synonyms
        GetRTFReportDetailsForNames(doc, ds, showConflicts, 1, 2, includeDist)

        'add unknown status names to the bottom

        doc.Append("\line ")

        GetRTFReportDetailsUnknownStatus(doc, ds, showConflicts)

        Dim provs As String = "\line Data Providers : "
        For Each ps As String In ProviderIds
            provs += ps + ","
        Next
        provs = provs.TrimEnd(",")

        doc.Append(provs)
        doc.Append("\line ")

        doc.Append("}")

        Dim docStr = doc.ToString

        docStr = ConvertUnicodeChars(docStr)

        Return docStr
    End Function

    Private Shared Function ConvertUnicodeChars(ByVal doc As String) As String
        Dim newDoc As New Text.StringBuilder
        For Each c As Char In doc
            If AscW(c) > 127 Then
                newDoc.Append("\u" + Str(AscW(c)).Trim())
            Else
                newDoc.Append(c)
            End If
        Next

        Return newDoc.ToString
    End Function

    Private Shared Sub GetRTFReportDetailsUnknownStatus(ByRef doc As StringBuilder, ByVal ds As DataSet, ByVal showConflicts As Boolean)
        Dim ukn As String = ""

        For Each dr As DataRow In ds.Tables(0).Rows

            If NameIds.Contains(dr("NameGuid").ToString) Then Continue For

            If dr.IsNull("NamePreferredFk") Then
                Dim fullname As String = ""
                fullname = dr("NameFullFormatted").ToString.Replace("<I>", "\i ")
                fullname = fullname.Replace("</I>", "\i0 ")

                If showConflicts Then
                    If dr("hasConf").ToString = "1" Then
                        fullname = "*" + fullname
                    End If

                    If dr("hasPrefNameIncons").ToString = "1" OrElse dr("hasSynonymIncons").ToString = "1" Then
                        fullname += "\cf2 " + fullname + "\cf1 "
                    End If
                End If

                ukn += fullname

                'ukn += "{\v " + dr("NameGuid").ToString + "}"
                ukn += " \line "

                Dim provs As String() = dr("DataProviders").ToString.Substring(17).Split(",")
                'Dim first As Boolean = True
                For Each ps As String In provs
                    If Not ProviderIds.Contains(ps) And ps <> "Editor" Then
                        ProviderIds.Add(ps)
                    End If
                Next
            End If

            NameIds.Add(dr("NameGuid").ToString)
        Next

        If ukn.Length > 0 Then
            doc.Append("\b Names with unknown status \b0 \line")
            doc.Append(ukn)
        End If
    End Sub

    Private Shared Sub GetRTFReportDetailsForNames(ByRef doc As StringBuilder, ByVal ds As DataSet, ByVal showConflicts As Boolean, ByVal depth As Integer, ByVal maxDepth As Integer, ByVal includeDist As Boolean)

        Dim first As Boolean = True

        For Each dr As DataRowView In ds.Tables(0).DefaultView

            If depth = 1 And dr("NamePreferredFk").ToString <> dr("NameGuid").ToString And Not first Then
                Continue For
            End If

            first = False

            If depth > 1 And dr("NamePreferredFk").ToString = dr("NameGuid").ToString Then Continue For

            If NameIds.Contains(dr("NameGuid").ToString) Then Continue For

            Dim fullname As String = ""
            fullname = dr("NameFullFormatted").ToString.Replace("<I>", "\i ")
            fullname = fullname.Replace("</I>", "\i0 ")

            If showConflicts Then
                If dr("hasConf").ToString = "1" Then
                    fullname = "*" + fullname
                End If

                If dr("hasPrefNameIncons").ToString = "1" OrElse dr("hasSynonymIncons").ToString = "1" Then
                    fullname += "\cf2 " + fullname + "\cf1 "
                End If
            End If

            If depth = 1 Then
                doc.Append("\b " + fullname + " \b0 ")
            Else
                For i As Integer = 1 To depth - 1
                    doc.Append("\tab ")
                Next
                doc.Append(fullname)
            End If

            'doc.Append("{\v " + dr("NameGuid").ToString + "}")
            doc.Append(" \line ")

            NameIds.Add(dr("NameGuid").ToString)

            Dim provs As String() = dr("DataProviders").ToString.Substring(17).Split(",")
            'Dim first As Boolean = True
            For Each ps As String In provs
                If Not ProviderIds.Contains(ps) And ps <> "Editor" Then
                    ProviderIds.Add(ps)
                End If
            Next

            If depth < maxDepth And dr("NameGuid").ToString = dr("NamePreferredFk").ToString Then
                Dim syns As DataSet = ChecklistDataAccess.NameData.GetNameSynonymsDs(dr("NameGuid").ToString)
                For Each synDr As DataRow In syns.Tables(0).Rows
                    If synDr("NameGuid").ToString = dr("NameGuid").ToString Then
                        synDr.Delete()
                        syns.AcceptChanges()
                        Exit For
                    End If
                Next
                Dim synRepDs As DataSet = syns
                synRepDs = GetNameReportDs(syns, showConflicts)

                If synRepDs.Tables.Count > 0 Then
                    GetRTFReportDetailsForNames(doc, synRepDs, showConflicts, depth + 1, maxDepth, includeDist)
                End If

                doc.Append("\line ")
            End If

            If includeDist Then
                Dim d As New DataAccess.Distribution
                Dim dist As List(Of TDWGGeo) = d.GetNameDistribution(dr("NameGuid").ToString)
                If dist.Count > 0 Then
                    Dim distStr As String = "\tab Distribution: "
                    Dim geosDone As String = ","
                    For Each tg As TDWGGeo In dist
                        If geosDone.IndexOf("," + tg.Name + ",") = -1 Then
                            distStr += tg.Name + ", "
                            geosDone += tg.Name + ","
                        End If
                    Next
                    distStr = distStr.Trim(" ")
                    distStr = distStr.Trim(",")

                    doc.Append(distStr)
                    doc.Append(" \line \line ")
                End If
            End If

        Next

    End Sub

    Public Shared Function GetNamesReport(ByVal namesDs As DataSet, ByVal showConflicts As Boolean, ByVal includeDist As Boolean) As String
        Dim report As String = ""
        Dim repDs As DataSet '= namesDs

        repDs = GetNameReportDs(namesDs, showConflicts)

        repDs.Tables(0).DefaultView.Sort = "RankSort, NameFull"

        report = GenerateRTFReport(repDs, showConflicts, includeDist)

        Return report
    End Function

    Public Shared Function GetNamesReportCSV(ByVal namesDs As DataSet, ByVal showConflicts As Boolean, ByVal includeDist As Boolean) As String
        Dim report As String = ""
        Dim repDs As DataSet = namesDs

        If showConflicts Then repDs = GetNameReportDs(namesDs, showConflicts)

        report = GenerateCSVReport(repDs, showConflicts, includeDist)

        Return report
    End Function

    Public Shared Function GenerateCSVReport(ByVal ds As DataSet, ByVal showConflicts As Boolean, ByVal includeDist As Boolean) As String
        Dim doc As New StringBuilder

        Dim sep As String = Chr(9)

        doc.Append("NeedsUpdating" + sep + "NameGuid" + sep + "NameFull" + sep + "NameRank" + sep + "NameBasionymAuthors" + sep + "NameCombinationAuthors" + sep + "NameYear" + sep + "NameParent" + sep + "NamePreferred" + sep + "NamePublishedIn" + sep + "NameInvalid" + sep + "NameIllegitimate" + sep + "NameMisapplied" + sep + "NameOrthography" + sep + "NameDistribution")
        doc.Append(Environment.NewLine)

        For Each dr As DataRow In ds.Tables(0).Rows
            doc.Append(sep) 'needs updating col

            doc.Append(dr("NameGuid").ToString)
            doc.Append(sep)

            doc.Append(dr("NameFull").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("RankName").ToString)
            doc.Append(sep)

            doc.Append(dr("NameBasionymAuthors").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NameCombinationAuthors").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NameYear").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NameParent").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NamePreferred").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NamePublishedIn").ToString) '.Replace(",", ";"))
            doc.Append(sep)

            doc.Append(dr("NameInvalid").ToString)
            doc.Append(sep)

            doc.Append(dr("NameIllegitimate").ToString)
            doc.Append(sep)

            doc.Append(dr("NameMisapplied").ToString)
            doc.Append(sep)

            doc.Append(dr("NameOrthography").ToString) '.Replace(",", ";"))
            doc.Append(sep)


            If includeDist Then
                Dim d As New DataAccess.Distribution
                Dim dist As List(Of TDWGGeo) = d.GetNameDistribution(dr("NameGuid").ToString)
                If dist.Count > 0 Then
                    Dim distStr As String = ""
                    Dim geosDone As String = ";"
                    For Each tg As TDWGGeo In dist
                        If geosDone.IndexOf(";" + tg.Name + ";") = -1 Then
                            distStr += tg.Name + ";"
                            geosDone += tg.Name + ";"
                        End If
                    Next
                    distStr = distStr.Trim(" ")
                    distStr = distStr.Trim(";")

                    doc.Append(distStr)

                End If
            End If

            doc.Append(sep)

            doc.Append(Environment.NewLine)
        Next

        Return doc.ToString
    End Function

    Private Shared Function GetNameReportDs(ByVal namesDs As DataSet, ByVal showConflicts As Boolean) As DataSet
        Dim repDs As New DataSet

        If namesDs.Tables.Count > 0 AndAlso namesDs.Tables(0).Rows.Count > 0 Then
            Dim ids As String = ""
            For Each dr As DataRow In namesDs.Tables(0).Rows
                ids += "," + dr("NameGuid").ToString
            Next
            ids = ids.TrimStart(",")

            Using cnn As New SqlConnection(ConnectionString)
                cnn.Open()

                Using cmd As New SqlCommand
                    cmd.Connection = cnn
                    cmd.CommandText = "sprSelect_ReportNamesList"
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.Add("@nameIds", SqlDbType.NVarChar).Value = ids
                    cmd.Parameters.Add("@showConflicts", SqlDbType.Bit).Value = showConflicts
                    cmd.CommandTimeout = 180000
                    Dim da As New SqlDataAdapter(cmd)
                    da.Fill(repDs)
                End Using
            End Using
        End If

        Return repDs
    End Function
End Class
