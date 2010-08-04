Imports ChecklistDataAccess
Imports ChecklistObjects
Imports IntegratorControls

Public Class DefParentsForm

    Public Import As ProviderImport

    Private Sub DefParentsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        DefParNameType.SelectedIndex = 0
        DefGenParNameType.SelectedIndex = 0

        Try
            Dim nm As Name = NameData.GetName(Nothing, Configuration.ConfigurationManager.AppSettings.Get("DefaultHigherParentNameId"))
            nameLink.Text = nm.NameFull

            If Import IsNot Nothing Then
                Import.ProviderImportHigherNameId = nm.Id
                Import.ProviderImportHigherPNId = ""
            End If

            nm = NameData.GetName(Nothing, Configuration.ConfigurationManager.AppSettings.Get("DefaultGenusParentNameId"))
            genNameLink.Text = nm.NameFull

            If Import IsNot Nothing Then
                Import.ProviderImportGenusNameId = nm.Id
                Import.ProviderImportGenusPNId = ""
            End If

        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to load import")
        End Try

    End Sub

    Private Sub nameLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles nameLink.LinkClicked
        If DefParNameType.SelectedIndex = 0 Then
            Dim selFm As New SelectNameForm
            selFm.InitialNameId = Import.ProviderImportHigherNameId
            If selFm.ShowDialog = Windows.Forms.DialogResult.OK Then
                Import.ProviderImportHigherNameId = selFm.SelectedNameId
                Import.ProviderImportHigherPNId = ""
                nameLink.Text = selFm.SelectedNameText
            End If
        Else
            'select prov name
            Dim selPN As New ProviderNameRecordsForm
            selPN.SelectMode = RecordSelectMode.SelectRecord
            If selPN.ShowDialog = Windows.Forms.DialogResult.OK Then
                Import.ProviderImportHigherPNId = selPN.SelectedRecord.PNNameId
                Import.ProviderImportHigherNameId = ""
                nameLink.Text = selPN.SelectedRecord.PNNameFull
            End If
        End If
    End Sub

    Private Sub genNameLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles genNameLink.LinkClicked
        If DefGenParNameType.SelectedIndex = 0 Then
            Dim selFm As New SelectNameForm
            selFm.InitialNameId = Import.ProviderImportGenusNameId
            If selFm.ShowDialog = Windows.Forms.DialogResult.OK Then
                Import.ProviderImportGenusNameId = selFm.SelectedNameId
                Import.ProviderImportGenusPNId = ""
                genNameLink.Text = selFm.SelectedNameText
            End If
        Else
            'select prov name
            Dim selPN As New ProviderNameRecordsForm
            selPN.SelectMode = RecordSelectMode.SelectRecord
            If selPN.ShowDialog = Windows.Forms.DialogResult.OK Then
                Import.ProviderImportGenusPNId = selPN.SelectedRecord.PNNameId
                Import.ProviderImportGenusNameId = ""
                nameLink.Text = selPN.SelectedRecord.PNNameFull
            End If
        End If
    End Sub

    Private Sub OkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OkButton.Click
        'save
        Try
            ImportData.InsertUpdateProviderImport(Import, SessionState.CurrentUser.Login)
            DialogResult = Windows.Forms.DialogResult.OK
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to save import")
        End Try
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Me.Close()
    End Sub

End Class