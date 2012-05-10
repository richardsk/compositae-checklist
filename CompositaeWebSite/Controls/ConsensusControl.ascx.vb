Imports ChecklistObjects
Imports ChecklistDataAccess
Imports WebDataAccess

Imports System.Collections.Generic
Imports System.Data

Partial Class Controls_ConsensusControl
    Inherits System.Web.UI.UserControl

    Public NameID As String = ""

    Public Sub SetPublicationStandardised(ByVal standard As Boolean)
        publicationNote.Visible = Not standard
    End Sub


    Public Sub Display()
        NameID = WebDataAccess.Utility.NameID(Request)
        Dim SelName As Name = NameData.GetName(Nothing, NameID)

            'map
            'Dim d As New Distribution
            'Dim geoList As List(Of TDWGGeo) = d.GetNameDistributionDescendents(SelName.Id)
            'If geoList.Count > 0 Then
            '    Dim url As String = d.GetMapUrl(geoList)
            '    distMapImage.ImageUrl = url

            '    url = url.Substring(0, url.Length - 3) 'change to big image size
            '    mapLink.NavigateUrl = url + "1000"
            'Else
            '    distMapImage.Visible = False
            '    mapLabel.Visible = False
            'End If

            Dim pn As ProviderName = NameData.GetSystemProviderNameForName(SelName.Id)

            Dim Fields As New Generic.Dictionary(Of String, String)
            Dim validation As New Generic.Dictionary(Of String, String)

            Fields.Add(Global.Resources.Resource.Name, SelName.NameFullFormatted)
            validation.Add(Global.Resources.Resource.Name, WebDataAccess.Utility.GetValidationImage(pn, "PNNameFull"))

            Dim ris As ReferenceRIS = ReferenceData.GetReferenceRISByReference(SelName.NameReferenceFk)
            Dim pubText As String = ""
            Dim fullRef As String = ""

            If SelName.NameReferenceFk IsNot Nothing Then
                Dim ds As DataSet = ReferenceData.GetReferenceDs(SelName.NameReferenceFk)
                fullRef = ds.Tables(0).Rows(0)("ReferenceFullCitation").ToString
                If fullRef.Length = 0 Then fullRef = ds.Tables(0).Rows(0)("ReferenceCitation").ToString
            End If

            Dim std As Boolean = True

            If ris IsNot Nothing Then
                pubText = SelName.NameYear
                If pubText.Length > 0 Then pubText += ", "
                pubText += ris.RISStandardAbbreviation
                If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += ", "
                pubText += ris.RISVolume
                If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += " : "
                pubText += SelName.NameMicroReference
            ElseIf SelName.NameReferenceFk IsNot Nothing Then
                If SelName.NameYear IsNot Nothing Then pubText = SelName.NameYear
                If pubText.Length > 0 Then pubText += ", "
                pubText += fullRef
                If SelName.NameMicroReference IsNot Nothing Then pubText += " : " + SelName.NameMicroReference
            ElseIf SelName.NamePublishedIn IsNot Nothing AndAlso SelName.NamePublishedIn.Length > 0 Then
                std = False
                pubText = SelName.NamePublishedIn
            End If

            SetPublicationStandardised(std)

            If pubText IsNot Nothing AndAlso pubText.Length > 0 Then
                If std Then
                    Fields.Add(Global.Resources.Resource.Published, pubText)
                    validation.Add(Global.Resources.Resource.Published, WebDataAccess.Utility.GetValidationImage(pn, "PNPublishedIn"))
                Else
                    Fields.Add(Global.Resources.Resource.PublishedNonStandard, pubText)
                    validation.Add(Global.Resources.Resource.PublishedNonStandard, WebDataAccess.Utility.GetValidationImage(pn, "PNPublishedIn"))
                End If
            End If

            If SelName.NamePreferredFk = SelName.Id Then
                '           Dim concepts As DataSet = ConceptData.GetNameConceptRelationshipRecordsDs(SelName.Id, False)
                '          If concepts.Tables.Count > 0 Then
                'For Each row As DataRow In concepts.Tables(0).Rows
                'If row("ConceptRelationshipRelationship").ToString = "has preferred name" Then
                'Dim lnk As String = WebDataAccess.Utility.GetLiteratureLinkHtml(row("ConceptAccordingToFk").ToString, Global.Resources.Resource.Concept_According_To) ' row("ConceptAccordingTo").ToString)
                Dim lnk As String = "<a style='color:Black' href='" + WebDataAccess.Utility.GetDefaultPageUrl(Request, "2") + "&nameId=" + SelName.Id + "'>" + Global.Resources.Resource.Concept_According_To + "</a>"
                Fields.Add(Global.Resources.Resource.Status, "<span style='color:green'>ACCEPTED </span>(" + lnk + ")")
                'Exit For
                'End If
                '    Next
                'End If
            ElseIf SelName.NamePreferredFk IsNot Nothing Then
                Fields.Add(Global.Resources.Resource.Status, "<span style='color:Red'>SYNONYM</span> of " + WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NamePreferredFk, SelName.NamePreferredFormatted, "0"))
            Else
                Fields.Add(Global.Resources.Resource.Status, "[No Concept]")
            End If

            Dim icbnNotes As String = ""
            If SelName.NameNomNotes IsNot Nothing AndAlso SelName.NameNomNotes.Length > 0 Then
                icbnNotes = SelName.NameNomNotes
            End If
            If SelName.NameHomonymOf IsNot Nothing AndAlso SelName.NameHomonymOf.Length > 0 Then
                If SelName.NameHomonymOfFk IsNot Nothing Then
                    Dim hom As Name = NameData.GetName(Nothing, SelName.NameHomonymOfFk)
                    If hom IsNot Nothing Then
                        If icbnNotes.Length > 0 Then icbnNotes += "; "
                        icbnNotes += "non " + hom.NameAuthors + " " + hom.NameYear
                    End If
                End If
            End If
            If SelName.NameStatusNotes IsNot Nothing AndAlso SelName.NameStatusNotes.Length > 0 Then
                If icbnNotes.Length > 0 Then icbnNotes += "; "
                icbnNotes += SelName.NameStatusNotes
            End If
            If SelName.NameIllegitimate AndAlso icbnNotes.IndexOf("illeg.") = -1 Then
                If icbnNotes.Length > 0 Then icbnNotes += "; "
                icbnNotes += "nom. illeg."
            End If
            If SelName.NameInvalid AndAlso icbnNotes.IndexOf("inval.") = -1 Then
                If icbnNotes.Length > 0 Then icbnNotes += "; "
                icbnNotes += "nom. inval."
            End If
            If icbnNotes.Length > 0 Then
                Fields.Add(Global.Resources.Resource.ICBN_Notes, icbnNotes)
            End If

            If SelName.NameOrthography IsNot Nothing AndAlso SelName.NameOrthography.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Name_Orthography, SelName.NameOrthography)
                validation.Add(Global.Resources.Resource.Name_Orthography, WebDataAccess.Utility.GetValidationImage(pn, "PNOrthography"))
            End If

            If SelName.NameBasionym IsNot Nothing AndAlso SelName.NameBasionym.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Name_Basionym, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameBasionymFk, SelName.NameBasionymFormatted, "0"))
                validation.Add(Global.Resources.Resource.Name_Basionym, WebDataAccess.Utility.GetValidationImage(pn, "PNBasionym"))
            End If

            If SelName.Id = SelName.NamePreferredFk Then
                Dim tmp As Integer = 1
                Dim syns As List(Of Name) = NameData.GetNameSynonyms(SelName.Id)
                Dim expand As Boolean = False
                If Request.QueryString("syn") IsNot Nothing AndAlso Request.QueryString("syn") = "expand" Then
                    expand = True
                End If

                For Each sn As Name In syns
                    'If tmp > 3 And expand = False Then
                    '    'show Expand to see all synonyms
                    '    Fields.Add("SYN_EXPAND", "")
                    '    Exit For
                    'End If
                    If sn.Id <> SelName.Id And sn.Id <> SelName.NameBasionymFk Then
                        Dim txt As String = WebDataAccess.Utility.GetNameLinkHtml(Request, sn.Id, sn.NameFullFormatted, "0")
                        If tmp = 1 Then
                            Fields.Add(Global.Resources.Resource.Synonyms, txt)
                        Else
                            Fields.Add("_" + tmp.ToString, txt)
                        End If
                        tmp += 1
                    End If
                Next
            End If

            If SelName.NameTypeName IsNot Nothing AndAlso SelName.NameTypeName.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Name_Type, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameTypeNameFk, SelName.NameTypeNameFormatted, "0"))
                validation.Add(Global.Resources.Resource.Name_Type, WebDataAccess.Utility.GetValidationImage(pn, "PNTypeName"))
            End If

            If SelName.NameHomonymOf IsNot Nothing AndAlso SelName.NameHomonymOf.Length > 0 Then
                If SelName.NameHomonymOfFk IsNot Nothing Then
                    Fields.Add(Global.Resources.Resource.Homonym_Of, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameHomonymOfFk, SelName.NameHomonymOfFormatted, "0"))
                Else
                    Fields.Add(Global.Resources.Resource.Homonym_Of, SelName.NameHomonymOf)
                End If
                validation.Add(Global.Resources.Resource.Homonym_Of, WebDataAccess.Utility.GetValidationImage(pn, "PNHomonymOf"))
            End If

            If SelName.NameBasedOn IsNot Nothing AndAlso SelName.NameBasedOn.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Based_On, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameBasedOnFk, SelName.NameBasedOnFormatted, "0"))
                validation.Add(Global.Resources.Resource.Based_On, WebDataAccess.Utility.GetValidationImage(pn, "PNBasedOn"))
            End If

            If SelName.NameConservedAgainst IsNot Nothing AndAlso SelName.NameConservedAgainst.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Conserved_Against, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameConservedAgainstFk, SelName.NameConservedAgainstFormatted, "0"))
                validation.Add(Global.Resources.Resource.Conserved_Against, WebDataAccess.Utility.GetValidationImage(pn, "PNConservedAgainst"))
            End If

            If SelName.NameReplacementFor IsNot Nothing AndAlso SelName.NameReplacementFor.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Replacement_For, WebDataAccess.Utility.GetNameLinkHtml(Request, SelName.NameReplacementForFk, SelName.NameReplacementForFormatted, "0"))
                validation.Add(Global.Resources.Resource.Replacement_For, WebDataAccess.Utility.GetValidationImage(pn, "PNReplacementFor"))
            End If

            If ris IsNot Nothing And pubText <> fullRef And fullRef.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Full_Ref, WebDataAccess.Utility.GetLiteratureLinkHtml(SelName.NameReferenceFk, fullRef))
            End If

            If SelName.NameNotes IsNot Nothing AndAlso SelName.NameNotes.Length > 0 Then
                Fields.Add(Global.Resources.Resource.Notes, SelName.NameNotes)
                validation.Add(Global.Resources.Resource.Notes, WebDataAccess.Utility.GetValidationImage(pn, "PNNotes"))
            End If

            FieldsTable.Rows.Clear()

            Dim x As Integer = 1

            For Each key As String In Fields.Keys

                Dim row As New TableRow
                Dim cell As New TableCell

                If x = 1 Then
                    cell.Width = New Unit("90px")
                    cell.ID = "cell1_1"
                    x += 1
                End If

                If Not key.StartsWith("_") And key <> "SYN_EXPAND" Then cell.Text = key

                row.Cells.Add(cell)

                cell = New TableCell
                cell.Text = Fields(key)
                'cell.Width = New Unit(640)
                If key = Global.Resources.Resource.Name Then
                    cell.Font.Bold = True
                    cell.Font.Size = New FontUnit(FontSize.Medium)
                    row.Cells(0).Font.Bold = True
                    row.Cells(0).Font.Size = New FontUnit(FontSize.Medium)
                ElseIf key = "SYN_EXPAND" Then
                    cell.Text = "<a style='color:Gray' href='" + Request.RawUrl + "&syn=expand'>" + Global.Resources.Resource.Show_All_Synonyms + "...</a><br/><br/>"
                Else
                    cell.Font.Bold = False
                    'cell.Font.Size = New FontUnit(FontSize.Smaller)
                End If
                row.Cells.Add(cell)

                If validation.ContainsKey(key) Then
                    cell = New TableCell
                    cell.Text = validation(key)
                    cell.HorizontalAlign = HorizontalAlign.Left
                    row.Cells.Add(cell)
                End If

                FieldsTable.Rows.Add(row)
            Next

            lsidLabel.Text = SelName.NameLSID

            Dim provData As DataSet = NameData.GetProviderNameRecords(SelName.Id)
            dataProvLabel.Text = WebDataAccess.Utility.GetProvidersHtml(provData, WebDataAccess.Utility.ProviderDataType.Names)

            Dim contrData As DataSet = NameData.GetNameContributors(SelName.Id)
            Dim contrHtml As String = ""
            For Each row As DataRow In contrData.Tables(0).Rows
                If contrHtml.Length > 0 Then contrHtml += ", "
                contrHtml += row("UserFullName").ToString
            Next
            creditsLabel.Text = contrHtml

            updatedLabel.Text = SelName.UpdatedDate.ToString + " " + SelName.UpdatedBy

            editDetailsLink.NavigateUrl = "~/EditTrailDetails.aspx?nameId=" + SelName.Id
            editDetailsLink.Target = "_blank"

            'Page.ClientScript.RegisterStartupScript(Me.GetType(), "image_size", "javascript:document.getElementById('ctl03_ConsensusControl1_cell11').setAttribute('style', 'width:' + document.getElementById('ctl03_ConsensusControl1_cell1_1').width.toString());", True)
    End Sub

End Class
