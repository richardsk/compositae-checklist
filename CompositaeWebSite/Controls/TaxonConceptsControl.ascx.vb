Imports ChecklistObjects
Imports ChecklistDataAccess
Imports WebDataAccess

Imports System.Data

Partial Class Controls_TaxonConceptsControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Public Sub Display()

        Dim SelName As Name = NameData.GetName(Nothing, WebDataAccess.Utility.NameID(Request))

        nameLabel.Text = SelName.NameFullFormatted

        Dim conceptsDt As New DataTable
        'Dim col As New DataColumn("Name")
        'conceptsDt.Columns.Add(col)

        Dim col As New DataColumn("Status")
        conceptsDt.Columns.Add(col)

        col = New DataColumn("AccordingTo")
        conceptsDt.Columns.Add(col)

        col = New DataColumn("DataProvider")
        conceptsDt.Columns.Add(col)


        Dim concepts As DataSet = ConceptData.GetNameConceptRelationshipRecordsDs(SelName.Id, False)
        If concepts.Tables.Count > 0 Then
            For Each dr As DataRow In concepts.Tables(0).Rows

                If dr("ConceptRelationshipRelationship").ToString = "has preferred name" Then
                    Dim status As String = ""

                    If dr("ConceptName1Fk").ToString = dr("ConceptToName1Fk").ToString Then
                        status = "ACCEPTED"
                    Else
                        status = dr("ConceptToName1").ToString
                    End If

                    Dim ds As DataSet = ConceptData.GetProviderConceptRelationshipsForCR(dr("ConceptRelationshipGuid").ToString)
                    'Dim nameStr As String = ""
                    'If ds.Tables(0).Rows.Count > 0 Then nameStr = ds.Tables(0).Rows(0)("PCName2").ToString

                    Dim prov As String = ""
                    prov += WebDataAccess.Utility.GetProvidersHtml(ds, WebDataAccess.Utility.ProviderDataType.Concepts)

                    conceptsDt.Rows.Add(New Object() {status, dr("ConceptAccordingTo").ToString, prov})
                End If

            Next
        End If

        conceptsGrid.RowStyle.HorizontalAlign = HorizontalAlign.Left

        conceptsGrid.Font.Size = New FontUnit(FontSize.Small)
        conceptsGrid.DataSource = conceptsDt
        conceptsGrid.DataBind()

        If conceptsGrid.HeaderRow IsNot Nothing Then
            conceptsGrid.HeaderRow.Cells(0).HorizontalAlign = HorizontalAlign.Left
            conceptsGrid.HeaderRow.Cells(1).HorizontalAlign = HorizontalAlign.Left
            conceptsGrid.HeaderRow.Cells(2).HorizontalAlign = HorizontalAlign.Left
            
            'conceptsGrid.HeaderRow.Cells(0).Text = Global.Resources.Resource.Concept_Name
            conceptsGrid.HeaderRow.Cells(0).Text = Global.Resources.Resource.Concept_Status
            conceptsGrid.HeaderRow.Cells(1).Text = Global.Resources.Resource.Concept_According_To
            conceptsGrid.HeaderRow.Cells(2).Text = Global.Resources.Resource.Concept_Providers
        Else
            errLabel.Visible = True
        End If

        'set font colors
        For Each gvr As GridViewRow In conceptsGrid.Rows
            If gvr.Cells(0).Text = "ACCEPTED" Then
                gvr.Cells(0).ForeColor = Drawing.Color.Green
            Else
                gvr.Cells(0).Text = "<span style='color:Red'>SYNONYM</span> of " + gvr.Cells(0).Text
            End If
            gvr.Cells(2).Text = HttpUtility.HtmlDecode(gvr.Cells(2).Text)

            gvr.Cells(0).Width = New Unit(150)
            gvr.Cells(1).ControlStyle.BorderWidth = 4
            gvr.Cells(1).ControlStyle.BorderColor = Drawing.Color.White
        Next


    End Sub

End Class
