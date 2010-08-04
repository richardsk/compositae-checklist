Imports ChecklistObjects

Public Class MergeSelForm

    Public Enum MergeSel
        DontMerge
        AToB
        BToA
        Cancel
    End Enum

    Public ValueA As String
    Public ValueAId As String
    Public ValueB As String
    Public ValueBId As String
    Public PercentMatch As Double = -1
    Public ShowViewButtons As Boolean = False

    Public Event ShowDetailsPopup(ByVal itemId As String)

    Public MergeSelection As MergeSel = MergeSel.DontMerge

    Private Sub MergeSelForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If ValueA IsNot Nothing AndAlso ValueB IsNot Nothing Then
            NameAText.Text = ValueA
            NameBText.Text = ValueB
        End If
        If PercentMatch <> -1 Then Text += " (" + PercentMatch.ToString("00.00") + "%)"

        If Not ShowViewButtons Then
            viewItem1.Visible = False
            viewItem2.Visible = False
        End If
    End Sub

    Private Sub AToBButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AToBButton.Click
        MergeSelection = MergeSel.AToB
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub BToAButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BToAButton.Click
        MergeSelection = MergeSel.BToA
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub DontMergeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DontMergeButton.Click
        MergeSelection = MergeSel.DontMerge
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        MergeSelection = MergeSel.Cancel
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub viewItem1_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles viewItem1.LinkClicked
        If ValueAId IsNot Nothing Then RaiseEvent ShowDetailsPopup(ValueAId)
    End Sub

    Private Sub viewItem2_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles viewItem2.LinkClicked
        If ValueBId IsNot Nothing Then RaiseEvent ShowDetailsPopup(ValueBId)
    End Sub
End Class