Imports ChecklistObjects
Imports ChecklistDataAccess
Imports WebDataAccess

Imports System.Data

Partial Class Controls_OriginalDataControl
    Inherits System.Web.UI.UserControl


    Public Sub Display()
        If provDataTable.Rows.Count > 0 Then Return 'already done

        Dim SelName As Name = NameData.GetName(Nothing, Utility.NameID(Request))

        Dim Fields As New Generic.Dictionary(Of String, String)

        provDataTable.ForeColor = Drawing.Color.Black

        'name
        Dim row As New TableRow
        Dim cell As New TableCell
        cell.VerticalAlign = VerticalAlign.Top
        cell.Text = Global.Resources.Resource.Name
        cell.Font.Bold = True
        cell.Font.Size = New FontUnit(FontSize.Larger)
        cell.ForeColor = Drawing.Color.Black
        cell.Width = New Unit(150)
        row.Cells.Add(cell)

        cell = New TableCell
        'cell.VerticalAlign = VerticalAlign.Top
        cell.Font.Bold = True
        cell.Font.Size = New FontUnit(FontSize.Larger)
        cell.Text = SelName.NameFullFormatted
        row.Cells.Add(cell)

        provDataTable.Rows.Add(row)

        row = New TableRow
        cell = New TableCell
        cell.Text = Global.Resources.Resource.Conflicting_Field_Data
        cell.ColumnSpan = 2
        cell.Font.Size = New FontUnit(FontSize.Small)
        cell.Font.Bold = False
        row.Cells.Add(cell)

        provDataTable.Rows.Add(row)


        'conflicting fields
        Dim provData As DataSet = NameData.GetProviderNameRecords(SelName.Id)

        Dim val As String = Utility.GetProviderFieldData(provData, SelName.NameFull, "PNNameFull")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Full_Name, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameAuthors, "PNNameAuthors")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Name_Authors, val)

        Dim ris As ReferenceRIS = ReferenceData.GetReferenceRISByReference(SelName.NameReferenceFk)
        Dim pubText As String = ""
        Dim fullRef As String = ""

        If SelName.NameReferenceFk IsNot Nothing Then
            Dim ds As DataSet = ReferenceData.GetReferenceDs(SelName.NameReferenceFk)
            fullRef = ds.Tables(0).Rows(0)("ReferenceFullCitation").ToString
            If fullRef.Length = 0 Then fullRef = ds.Tables(0).Rows(0)("ReferenceCitation").ToString
        End If

        If ris IsNot Nothing Then
            pubText = SelName.NameYear
            If pubText.Length > 0 Then pubText += ", "
            pubText += ris.RISStandardAbbreviation
            If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += ", "
            pubText += ris.RISVolume
            If pubText.Length > 0 And Not pubText.EndsWith(", ") Then pubText += " : "
            pubText += SelName.NameMicroReference
        ElseIf SelName.NameReferenceFk IsNot Nothing Then
            pubText = SelName.NameYear
            If pubText.Length > 0 Then pubText += ", "
            pubText += fullRef
            If SelName.NameMicroReference IsNot Nothing Then pubText += " : " + SelName.NameMicroReference
        Else
            pubText = SelName.NamePublishedIn
        End If

        val = Utility.GetProviderFieldData(provData, pubText, "PNPublishedIn")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Published, val)


        'Dim status As String = ""
        'If SelName.NamePreferredFk = SelName.Id Then
        '    Dim concepts As DataSet = ConceptData.GetNameConceptRelationshipRecordsDs(SelName.Id, False)
        '    If concepts.Tables.Count > 0 Then
        '        For Each dr As DataRow In concepts.Tables(0).Rows
        '            If dr("ConceptRelationshipRelationship").ToString = "has preferred name" Then
        '                Dim lnk As String = Utility.GetLiteratureLinkHtml(dr("ConceptAccordingToFk").ToString, dr("ConceptAccordingTo").ToString)
        '                status = "<span style='color:Green'>ACCEPTED</span> (" + lnk + ")"
        '                Exit For
        '            End If
        '        Next
        '    End If
        'ElseIf SelName.NamePreferredFk IsNot Nothing Then
        '    status = "<span style='color:Red'>SYNONYM of </span>" + Utility.GetNameLinkHtml(Request, SelName.NamePreferredFk, SelName.NamePreferred, "0")
        'Else
        '    status = Global.Resources.Resource.Unknown
        'End If

        'val = Utility.GetProviderFieldData(provData, status, "PNNamePreferred")
        'If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Status, val)

        Dim icbnNotes As String = ""
        If SelName.NameNomNotes IsNot Nothing AndAlso SelName.NameNomNotes.Length > 0 Then
            icbnNotes = SelName.NameNomNotes
        End If
        If SelName.NameHomonymOf IsNot Nothing AndAlso SelName.NameHomonymOf.Length > 0 Then
            Dim hom As Name = NameData.GetName(Nothing, SelName.NameHomonymOfFk)
            If icbnNotes.Length > 0 Then icbnNotes += "; "
            icbnNotes += "non " + hom.NameAuthors + " " + hom.NameYear
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

        val = Utility.GetProviderFieldData(provData, icbnNotes, "PNICBNNotes")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.ICBN_Notes, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameOrthography, "PNOrthography")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Name_Orthography, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameBasionym, "PNBasionym")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Name_Basionym, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameTypeName, "PNTypeName")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Name_Type, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameHomonymOf, "PNHomonymOf")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Homonym_Of, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameBasedOn, "PNBasedOn")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Based_On, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameConservedAgainst, "PNConservedAgainst")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Conserved_Against, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameReplacementFor, "PNReplacementFor")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Replacement_For, val)

        val = Utility.GetProviderFieldData(provData, SelName.NameNotes, "PNNotes")
        If val.Length > 0 Then Fields.Add(Global.Resources.Resource.Notes, val)


        For Each key As String In Fields.Keys

            row = New TableRow
            cell = New TableCell
            cell.VerticalAlign = VerticalAlign.Top
            cell.Text = key
            row.Cells.Add(cell)

            provDataTable.Rows.Add(row)

            cell = New TableCell
            cell.VerticalAlign = VerticalAlign.Top
            cell.Text = Fields(key)
            cell.Width = New Unit(640)
            cell.Font.Bold = False
            cell.Font.Size = New FontUnit(FontSize.Small)
            row.Cells.Add(cell)

            provDataTable.Rows.Add(row)
        Next


    End Sub
End Class
