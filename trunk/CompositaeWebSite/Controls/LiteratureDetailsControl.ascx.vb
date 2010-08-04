Imports System.Data
Imports DataAccess

Imports ChecklistDataAccess

Partial Class Controls_LiteratureDetailsControl
    Inherits System.Web.UI.UserControl

    Private Class RefDetails
        Public Citation As String
        Public LSID As String
    End Class

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim refId As String = Request.QueryString("ReferenceId")

            If refId Is Nothing Then 'browsing the tree?
                'a bit of a jack so we can keep the previous report details on the screen
                Dim ref As RefDetails = Session("RefDetails")
                If ref IsNot Nothing Then
                    CitationLabel.Text = ref.Citation
                    LSIDLabel.Text = ref.LSID
                End If
            Else
                Dim ds As DataSet = ReferenceData.GetReferenceDs(refId)

                Dim ref As New RefDetails
                ref.LSID = ds.Tables(0).Rows(0)("ReferenceLSID").ToString
                Dim cit As String = ds.Tables(0).Rows(0)("ReferenceFullCitation").ToString
                If cit.Length = 0 Then cit = ds.Tables(0).Rows(0)("ReferenceCitation").ToString
                ref.Citation = cit

                Session("RefDetails") = ref

                CitationLabel.Text = cit

                LSIDLabel.Text = ref.LSID
            End If
        Catch ex As Exception
            Utility.LogError(ex)
        End Try
    End Sub
End Class
