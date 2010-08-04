Imports Microsoft.VisualBasic
Imports System.Data

Imports ChecklistObjects
Imports ChecklistDataAccess

Public Class Utility

    Public Shared Validation As DataSet

    Public Enum ProviderDataType
        Names
        Concepts
        Refereneces
        OtherData
    End Enum

    Public Shared Function GetNamePageUrl(ByVal request As HttpRequest, ByVal tab As String, ByVal nameId As String) As String
        Dim url As String = "Default.aspx?Page=NameDetails"
        If tab Is Nothing OrElse tab.Length = 0 Then
            If request.QueryString("TabNum") IsNot Nothing Then url += "&TabNum=" + request.QueryString("TabNum")
        Else
            url += "&TabNum=" + tab
        End If
        If nameId IsNot Nothing Then
            url += "&nameId=" + nameId
        End If

        Return url
    End Function

    Public Shared Function GetDefaultPageUrl(ByVal request As HttpRequest, ByVal tab As String) As String
        Dim url As String = "Default.aspx?Page="
        If request.QueryString("Page") IsNot Nothing Then url += request.QueryString("Page")
        If tab Is Nothing OrElse tab.Length = 0 Then
            If request.QueryString("TabNum") IsNot Nothing Then url += "&TabNum=" + request.QueryString("TabNum")
        Else
            url += "&TabNum=" + tab
        End If
        If request.QueryString("ReportId") IsNot Nothing Then url += "&ReportId=" + request.QueryString("ReportId")
        Return url
    End Function

    Public Shared Function NameID(ByVal request As HttpRequest) As String
        Dim id As String = request.QueryString("NameId")
        If id Is Nothing Then id = request.QueryString("NodeId")
        Return id
    End Function

    Public Shared Function AltBGColor() As String
        Return ConfigurationManager.AppSettings("AltBGcolor")
    End Function


    Public Shared Function GetProvidersHtml(ByVal ProvData As DataSet, ByVal type As ProviderDataType) As String
        Dim provs As New ArrayList

        Dim provHtml As String = ""

        If type = ProviderDataType.Names Then
            For Each pn As DataRow In ProvData.Tables(0).Rows
                If Not provs.Contains(pn("ProviderPk").ToString) Then
                    provs.Add(pn("ProviderPk").ToString)

                    provHtml += ", <a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a>"
                End If
            Next
        End If

        If type = ProviderDataType.Concepts Then
            For Each pn As DataRow In ProvData.Tables(0).Rows
                If Not provs.Contains(pn("ProviderPk").ToString) Then
                    provs.Add(pn("ProviderPk").ToString)

                    provHtml += ", <a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a>"
                End If
            Next
        End If

        If type = ProviderDataType.Refereneces Then
            For Each pr As DataRow In ProvData.Tables(1).Rows
                If Not provs.Contains(pr("ProviderPk").ToString) Then
                    provs.Add(pr("ProviderPk").ToString)

                    provHtml += ", <a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pr("ProviderPk").ToString + "'>" + pr("ProviderName").ToString + "</a>"
                End If
            Next
        End If

        If type = ProviderDataType.OtherData Then
            For Each r As DataRow In ProvData.Tables(1).Rows
                If Not provs.Contains(r("ProviderPk").ToString) Then
                    provs.Add(r("ProviderPk").ToString)

                    provHtml += ", <a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + r("ProviderPk").ToString + "'>" + r("ProviderName").ToString + "</a>"
                End If
            Next
        End If

        If provHtml.StartsWith(", ") Then provHtml = provHtml.Substring(2)

        Return provHtml
    End Function

    Public Shared Function GetProviderICBNNotes(ByVal provData As DataRow) As String
        Dim icbnNotes As String = ""

        If provData("PNNonNotes") IsNot DBNull.Value AndAlso provData("PNNonNotes").ToString.Length > 0 Then
            icbnNotes = provData("PNNonNotes").ToString
        End If
        If provData("PNHomonymOf") IsNot DBNull.Value AndAlso provData("PNHomonymOf").ToString.Length > 0 Then
            Dim hom As ProviderName = NameData.GetProviderName(provData("ProviderPk"), provData("PNHomonymOfId"))
            If icbnNotes.Length > 0 Then icbnNotes += "; "
            icbnNotes += "non " + hom.PNNameAuthors + " " + hom.PNYear
        End If
        If provData("PNStatusNotes") IsNot DBNull.Value AndAlso provData("PNStatusNotes").ToString.Length > 0 Then
            If icbnNotes.Length > 0 Then icbnNotes += "; "
            icbnNotes += provData("PNStatusNotes").ToString
        End If
        If provData("PNIllegitimate") IsNot DBNull.Value AndAlso provData("PNIllegitimate") AndAlso icbnNotes.IndexOf("illeg.") = -1 Then
            If icbnNotes.Length > 0 Then icbnNotes += "; "
            icbnNotes += "nom. illeg."
        End If
        If provData("PNInvalid") IsNot DBNull.Value AndAlso provData("PNInvalid") AndAlso icbnNotes.IndexOf("inval.") = -1 Then
            If icbnNotes.Length > 0 Then icbnNotes += "; "
            icbnNotes += "nom. inval."
        End If

        Return icbnNotes
    End Function


    Public Shared Function GetValidationImage(ByVal sysPn As ProviderName, ByVal provNameField As String) As String
        Dim link As String = ""

        If sysPn Is Nothing Then Return ""

        If Validation Is Nothing OrElse Validation.Tables(0).Rows.Count = 0 OrElse Validation.Tables(0).Rows(0)("fieldstatusrecordfk").ToString <> sysPn.Id Then
            Validation = FieldStatusData.LoadStatus(sysPn.Id, "tblProviderName")
        End If

        Dim valRow As DataRow = FieldStatusData.GetProviderNameFieldStatus(Validation, provNameField)

        If valRow IsNot Nothing AndAlso Not valRow.IsNull("FieldStatusLevelFk") Then
            Try
                Dim val As Integer = Integer.Parse(valRow("FieldStatusLevelFk").ToString)
                link = "<a href='default.aspx?Page=DetailsHelp&Section=FieldStatus'><img style='border-style:none' src='images/val" + val.ToString + ".gif'/></a>"
            Catch ex As Exception
            End Try
        End If

        Return link
    End Function

    Public Shared Function GetProviderFieldData(ByVal ProvData As DataSet, ByVal nameVal As String, ByVal provNameField As String) As String
        'Dim provUsed As Boolean = False
        Dim provField As String = ""

        If nameVal IsNot Nothing AndAlso nameVal.Length > 0 Then

            Dim provs As String = ""
            Dim hasConf As Boolean = False
            'check for conflicting data
            For Each pn As DataRow In ProvData.Tables(0).Rows
                If provNameField = "PNPublishedIn" Then
                    Dim pnref As String = GetProviderNamePublication(pn)
                    If pnref.Length > 0 AndAlso pnref <> nameVal Then provField += pnref + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                ElseIf provNameField = "PNNamePreferred" Then
                    Dim pnst As String = GetProviderNameStatus(pn)
                    If pnst.Length > 0 AndAlso pnst <> nameVal Then provField += pnst + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                ElseIf provNameField = "PNICBNNotes" Then
                    Dim notes As String = GetProviderICBNNotes(pn)
                    If notes.Length > 0 AndAlso notes <> nameVal Then provField += notes + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                Else
                    If pn(provNameField).ToString.Length > 0 AndAlso pn(provNameField).ToString <> nameVal Then
                        provField += pn(provNameField).ToString + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                    End If
                End If
            Next
        Else
            'get provider values
            Dim isFirst As Boolean = True
            For Each pn As DataRow In ProvData.Tables(0).Rows

                If provNameField = "PNPublishedIn" Then
                    Dim pnref As String = GetProviderNamePublication(pn)
                    If pnref.Length > 0 Then
                        provField += pnref + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                    End If
                ElseIf provNameField = "PNNamePreferred" Then
                    Dim pnst As String = GetProviderNameStatus(pn)
                    If pnst.Length > 0 Then
                        provField += pnst + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                    End If
                ElseIf provNameField = "PNICBNNotes" Then
                    Dim notes As String = GetProviderICBNNotes(pn)
                    If notes.Length > 0 Then
                        provField += notes + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                    End If
                ElseIf pn(provNameField).ToString.Length > 0 Then
                    provField += pn(provNameField).ToString + " [<b><a style='color:black' href='default.aspx?Page=Provider&ProviderId=" + pn("ProviderPk").ToString + "'>" + pn("ProviderName").ToString + "</a></b>]<br/>"
                End If

            Next
        End If

        Return provField
    End Function

    Public Shared Function GetProviderNameStatus(ByVal provData As DataRow) As String
        Dim status As String = ""

        Dim conc As DataSet = ConceptData.GetProviderConceptRelationshipRecords(provData("PNNameFk").ToString, False)

        For Each row As DataRow In conc.Tables(0).Rows
            If row("PCName1Id").ToString = provData("PNNameId").ToString AndAlso row("PCRRelationship").ToString = "has preferred name" Then
                Dim pnDs As DataSet = NameData.GetProviderNameDs(row("ProviderPk"), row("PCName2Id"))
                Dim pr As ProviderReference = Nothing
                If row("PCAccordingtoId") IsNot DBNull.Value Then pr = ReferenceData.GetProviderReference(row("ProviderPk"), row("PCAccordingToId"))
                If pnDs.Tables(0).Rows(0)("PNNameFk").ToString = provData("PNNameFk").ToString Then
                    If pr IsNot Nothing Then
                        Dim lnk As String = Utility.GetLiteratureLinkHtml(pr.PRReferenceFk, row("PCAccordingTo").ToString)
                        status = "<span style='color:Green'>ACCEPTED</span> (" + lnk + ")"
                    Else
                        status = "<span style='color:Green'>ACCEPTED</span>"
                    End If
                ElseIf pnDs.Tables(0).Rows(0)("PNNameFk") IsNot DBNull.Value Then
                    status = "<span style='color:Red'>SYNONYM</span> of " + Utility.GetNameLinkHtml(HttpContext.Current.Request, pnDs.Tables(0).Rows(0)("PNNameFk").ToString, pnDs.Tables(0).Rows(0)("PNNameFull"), "0")
                Else
                    status = "[No Concept]"
                End If
            End If
        Next

        Return status
    End Function

    Public Shared Function GetProviderNamePublication(ByVal provData As DataRow) As String
        Dim pubText As String = ""
        Dim fullRef As String = ""

        Dim ris As ProviderRIS = Nothing

        If provData("PNReferenceId") IsNot DBNull.Value Then
            Dim ds As DataSet = ReferenceData.GetProviderReferenceDs(provData("ProviderPk"), provData("PNReferenceId"))
            ris = ReferenceData.GetProviderRISByReference(ds.Tables(0).Rows(0)("PRPk"))
            fullRef = ds.Tables(0).Rows(0)("PRFullCitation").ToString
            If fullRef.Length = 0 Then fullRef = ds.Tables(0).Rows(0)("PRCitation").ToString
        End If

        If ris IsNot Nothing Then
            pubText = provData("PNYear").ToString
            If pubText.Length > 0 Then pubText += ", "
            pubText += ris.PRISStandardAbbreviation
            If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += ", "
            pubText += ris.PRISVolume
            If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += " : "
            pubText += provData("PNMicroReference").ToString
        ElseIf provData("PNReferenceId") IsNot DBNull.Value Then
            pubText = provData("PNYear").ToString
            If pubText.Length > 0 Then pubText += ", "
            pubText += fullRef
            If provData("PNMicroReference") IsNot Nothing Then pubText += " : " + provData("PNMicroReference").ToString
        Else
            pubText = provData("PNPublishedIn").ToString
        End If

        Return pubText
    End Function


    Public Shared Function GetStateIdUrl(ByVal request As HttpRequest) As String
        Dim url As String = ""
        If request.QueryString("StateId") IsNot Nothing Then
            url = "&action=Display&StateId=" + request.QueryString("StateId")
        End If
        Return url
    End Function

    Public Shared Function GetNameLinkHtml(ByVal request As HttpRequest, ByVal nameId As String, ByVal nameText As String, ByVal tab As String) As String
        Return "<a style='color:black' href='default.aspx?Page=NameDetails&TabNum=" & tab & "&NameId=" & nameId & GetStateIdUrl(request) & "'>" & nameText & "</a>"
    End Function

    Public Shared Function GetLiteratureLinkHtml(ByVal refId As String, ByVal citation As String) As String
        Return "<a style='color:black' href='default.aspx?Page=LitDetails&ReferenceId=" + refId + "'>" + citation + "</a>"
    End Function


    Public Shared Function GetImageIndex(ByVal RankKey As Long) As String
        Select Case RankKey
            Case 16
                Return "blank1.gif"
            Case 15
                Return "k.gif"
            Case 30
                Return "k-.gif"
            Case 41
                Return "p+.gif"
            Case 19
                Return "p.gif"
            Case 48 'division
                Return "d.gif"
            Case 32
                Return "p-.gif"
            Case 38
                Return "c+.gif"
            Case 3
                Return "c.gif"
            Case 26
                Return "c-.gif"
            Case 11
                Return "c-.gif"
            Case 40
                Return "o+.gif"
            Case 17
                Return "o.gif"
            Case 31
                Return "o-.gif"
            Case 12
                Return "o-.gif"
            Case 39
                Return "f+.gif"
            Case 7
                Return "f.gif"
            Case 27
                Return "f-.gif"
            Case 42
                Return "t+.gif"
            Case 43
                Return "t.gif"
            Case 36
                Return "t-.gif"
            Case 1
                Return "a.gif"
            Case 8
                Return "g.gif"
            Case 29
                Return "g-.gif"
            Case 24
                Return "s.gif"
            Case 35
                Return "s-.gif"
            Case 44
                Return "v.gif"
            Case 37 'subvar
                Return "v-.gif"
            Case 5
                Return "forma.gif"
            Case 4
                Return "cv.gif"
            Case Else
                Return "blank1.gif"
        End Select
    End Function

    Public Shared Sub LogError(ByVal ex As Exception)
        Try
            Dim msg As String = ex.Message + " : " + ex.StackTrace
            Diagnostics.EventLog.WriteEntry("CompositaeWebStie", msg)
        Catch e As Exception
        End Try
        Try
            Dim lmsg As String = ex.Message + " : " + ex.StackTrace
            System.Web.HttpContext.Current.Response.Write(lmsg)
            ''Dim f As String = HttpContext.Current.Request.PhysicalApplicationPath + "\bin\log.txt"
            'Dim f As String = ConfigurationManager.AppSettings.Get("TempDir") + "\log.txt"
            'IO.File.WriteAllText(f, lmsg)
        Catch e As Exception
        End Try
    End Sub
End Class
