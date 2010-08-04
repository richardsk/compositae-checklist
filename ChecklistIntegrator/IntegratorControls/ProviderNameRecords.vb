Imports ChecklistDataAccess
Imports ChecklistObjects


Public Class ProviderNameRecords


    Public SelectMode As RecordSelectMode = RecordSelectMode.EditRecords

    Public Event LinkName(ByVal PNPk As Integer)
    Public Event IntegrateName(ByVal PNPk As Integer)

    Public ProviderPk As Integer = -1

    Public ReadOnly Property SelectedRecord() As DataRow
        Get
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            Return r.Row
        End Get
    End Property

    Private Sub ProviderNameRecords_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
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
            FilterCombo.Items.Add("Unknown provider names")
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
            If FilterCombo.Text = "Unknown provider names" Then lt = LinkType.Unknown

            Dim names As DataSet = NameData.ListProviderNameRecords(prov, lt, FilterText.Text.Trim, MaxCombo.SelectedItem)

            ResultsGrid.DataSource = names.Tables(0)

        Catch ex As Exception
            MsgBox("Failed to get provider records")
            ChecklistException.LogError(ex)
        End Try
        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub ListButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListButton.Click
        DoSearch()
        Dim idx As Integer = -1
        If ResultsGrid.CurrentRow IsNot Nothing Then idx = ResultsGrid.CurrentRow.Index
        UpdateLinkButton(idx)
    End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        Try
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            RaiseEvent LinkName(r.Row("PNPk"))
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub ResultsGrid_RowEnter(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ResultsGrid.RowEnter
        UpdateLinkButton(e.RowIndex)
    End Sub

    Private Sub UpdateLinkButton(ByVal rowIndex As Integer)
        Dim link As Boolean = False
        If LinkButton.Text = "Select" Then
            link = True
        Else
            Try
                Dim r As DataRowView = ResultsGrid.Rows(rowIndex).DataBoundItem
                If r.Row("PNNameFk").ToString = "" Then
                    link = True
                End If
            Catch ex As Exception
            End Try
        End If
        LinkButton.Enabled = link
        integrateButton.Enabled = link
    End Sub

    Private Sub integrateButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles integrateButton.Click
        Cursor.Current = Cursors.WaitCursor
        Try
            Dim r As DataRowView = ResultsGrid.CurrentRow.DataBoundItem
            RaiseEvent IntegrateName(r.Row("PNPk"))
        Catch ex As Exception
            MsgBox("Failed to integrate : " + ex.Message)
            ChecklistException.LogError(ex)
        End Try
        Cursor.Current = Cursors.Default
    End Sub
End Class
