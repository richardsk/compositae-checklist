Imports ChecklistObjects

Public Class ProviderForm

    Public TheProvider As Provider
    Public AllProviders As DataSet

    Private Sub ProviderForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim maxRank As Integer = 0

        If AllProviders IsNot Nothing Then
            For Each p As DataRow In AllProviders.Tables(0).Rows
                If Not p.IsNull("ProviderPreferredConceptRanking") AndAlso p("ProviderPreferredConceptRanking") > maxRank Then maxRank = p("ProviderPreferredConceptRanking")
            Next
        End If

        prefConcRanking.Minimum = 0
        prefConcRanking.Maximum = 99999

        prefConcRanking.Value = maxRank + 1

        If Not TheProvider Is Nothing Then
            ProviderNameText.Text = TheProvider.Name
            FullNameText.Text = TheProvider.FullName
            UrlText.Text = TheProvider.Url
            ProjectUrlText.Text = TheProvider.ProjectUrl
            ContactNameText.Text = TheProvider.ContactName
            ContactPhoneText.Text = TheProvider.ContactPhone
            ContactEmailText.Text = TheProvider.ContactEmail
            ContactAddressText.Text = TheProvider.ContactAddress
            StatementText.Text = TheProvider.Statement
            UseForParentageCheck.Checked = TheProvider.UseForParentage
            If TheProvider.PreferredConceptRanking > 0 Then prefConcRanking.Value = TheProvider.PreferredConceptRanking

        End If
    End Sub

    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        If TheProvider Is Nothing Then
            TheProvider = New Provider
        End If

        TheProvider.Name = ProviderNameText.Text
        TheProvider.FullName = FullNameText.Text
        TheProvider.Url = UrlText.Text
        TheProvider.ProjectUrl = ProjectUrlText.Text
        TheProvider.ContactName = ContactNameText.Text
        TheProvider.ContactPhone = ContactPhoneText.Text
        TheProvider.ContactEmail = ContactEmailText.Text
        TheProvider.ContactAddress = ContactAddressText.Text
        TheProvider.Statement = StatementText.Text
        TheProvider.UseForParentage = UseForParentageCheck.Checked
        If prefConcRanking.Value = 0 Then
            TheProvider.PreferredConceptRanking = -1
        Else
            TheProvider.PreferredConceptRanking = prefConcRanking.Value
        End If

        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CnclButton.Click
        Me.Close()
    End Sub
End Class