Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class ProviderRefRecords

    Public Event LinkReference(ByVal PRPk As Integer)

    Public ProviderPk As Integer = -1
    Public SelectMode As RecordSelectMode = RecordSelectMode.EditRecords

    Public ReadOnly Property SelectedRecord() As DataRow
        Get
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            Return r.Row
        End Get
    End Property

    Private Sub ProviderRefRecords_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim anyProv As New Provider()
            anyProv.Name = "Any"
            ProviderCombo.Items.Add(anyProv)

            Dim provs As Provider() = ProviderData.GetProviders()
            Dim selProv As Provider
            For Each p As Provider In provs
                ProviderCombo.Items.Add(p)
                If ProviderPk <> -1 AndAlso p.IdAsInt = ProviderPk Then
                    selProv = p
                End If
            Next

            If selProv IsNot Nothing Then
                ProviderCombo.SelectedItem = selProv
            Else
                ProviderCombo.SelectedIndex = 0
            End If

            FilterCombo.Items.Add("No filter")
            FilterCombo.Items.Add("Un-linked records")
            FilterCombo.SelectedIndex = 1
            If ProviderPk <> -1 Then FilterCombo.SelectedIndex = 0

            MaxCombo.Items.Add(10)
            MaxCombo.Items.Add(50)
            MaxCombo.Items.Add(100)
            MaxCombo.Items.Add(200)
            MaxCombo.Items.Add(500)
            MaxCombo.SelectedIndex = 2

            If SelectMode = RecordSelectMode.SelectRecord Then
                LinkButton.Text = "Select"
            End If

            If ProviderPk <> -1 Then
                DoSearch()
            End If
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub


    Private Sub DoSearch()
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Try
            Dim p As Provider = ProviderCombo.SelectedItem
            Dim prov As Integer = -1
            If p.Name <> "Any" Then prov = p.IdAsInt

            Dim lt As LinkType = LinkType.Any
            If FilterCombo.Text = "Un-linked records" Then lt = LinkType.Unlinked

            Dim refs As DataSet = ReferenceData.ListProviderReferenceRecords(prov, lt, FilterText.Text.Trim, MaxCombo.SelectedItem)
            ResultsGrid.DataSource = refs
            ResultsGrid.DataMember = refs.Tables(0).TableName

        Catch ex As Exception
            MsgBox("Failed to get provider records")
            ChecklistException.LogError(ex)
        End Try
        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub ListButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListButton.Click
        DoSearch()
        UpdateLinkButton()
    End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        Try
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            RaiseEvent LinkReference(r.Row("PRPk"))
        Catch ex As Exception
        End Try
    End Sub

    Private Sub ResultsGrid_RowEnter(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ResultsGrid.RowEnter
        UpdateLinkButton()
    End Sub

    Private Sub UpdateLinkButton()
        Dim link As Boolean
        Try
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            If r.Row("PRReferenceFk").ToString = "" Then
                link = True
            End If
        Catch ex As Exception
        End Try
        LinkButton.Enabled = link
    End Sub


End Class
