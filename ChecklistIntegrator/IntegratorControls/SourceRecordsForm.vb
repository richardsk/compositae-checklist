Public Class SourceRecordsForm

    Public NameRecords As DataTable
    Public RefRecords As DataTable
    Public ConceptRecords As DataTable
    Public OtherDataRecords As DataTable

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub SourceRecordsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If NameRecords IsNot Nothing Then SourceCombo.Items.Add("Names")
        If ConceptRecords IsNot Nothing Then SourceCombo.Items.Add("Concepts")
        If RefRecords IsNot Nothing Then SourceCombo.Items.Add("References")
        If OtherDataRecords IsNot Nothing Then SourceCombo.Items.Add("Other Data")
        SourceCombo.SelectedIndex = 0
    End Sub

    Private Sub SourceCombo_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SourceCombo.SelectedIndexChanged
        If SourceCombo.Text = "Names" Then
            DataGridView1.DataSource = NameRecords
        ElseIf SourceCombo.Text = "Concepts" Then
            DataGridView1.DataSource = ConceptRecords
            DataGridView1.Update()
        ElseIf SourceCombo.Text = "References" Then
            DataGridView1.DataSource = RefRecords
        ElseIf SourceCombo.Text = "Other Data" Then
            DataGridView1.DataSource = OtherDataRecords
        End If
    End Sub
End Class