Imports ChecklistDataAccess
Imports ChecklistBusinessRules
Imports ChecklistObjects
Imports IntegratorControls

Imports C1.Win.C1FlexGrid

Imports System.Collections.Specialized

Public Class ProviderNameForm

    Public PNPk As Integer = -1
    Public NameFk As String
    Private provName As DataRow
    Private FieldStatusDs As DataSet

    Private Sub ProviderNameForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        LoadProviderName()

        If provName IsNot Nothing Then
            If provName("PNNameFk").ToString.Length > 0 Then
                LinkButton.Text = "Go to Name"
            End If
        End If
    End Sub

    Private Sub LoadProviderName()
        If PNPk <> -1 Then
            FieldStatusDs = ChecklistDataAccess.FieldStatusData.LoadStatus(PNPk.ToString, "tblProviderName")

            Dim ds As DataSet = NameData.GetProviderNameDs(PNPk)

            provName = ds.Tables(0).Rows(0)

            If provName("PNNameFk").ToString.Length > 0 Then
                NameFk = provName("PNNameFk").ToString
            End If

            Dim dt As New DataTable
            dt.Columns.Add("Field")
            dt.Columns.Add("Value", GetType(Object))
            dt.Columns.Add("Status", GetType(Integer))

            For Each col As DataColumn In ds.Tables(0).Columns
                Dim sr As DataRow
                If FieldStatusDs IsNot Nothing Then sr = FieldStatusData.GetProviderNameFieldStatus(FieldStatusDs, col.ColumnName)
                Dim stat As Integer = -1
                If sr IsNot Nothing AndAlso Not sr.IsNull("FieldStatusLevelFk") Then stat = sr("FieldStatusLevelFk")

                dt.Rows.Add(New Object() {col.ColumnName, ds.Tables(0).Rows(0)(col.ColumnName), stat})
            Next

            ProviderNameGrid.DataSource = dt

            Dim statStyle As CellStyle = ProviderNameGrid.Styles("StatusStyle")
            If statStyle Is Nothing Then
                statStyle = ProviderNameGrid.Styles.Add("StatusStyle", "Normal")
                Dim sdt As New ListDictionary
                sdt.Add(-1, "")
                For Each s As DataRow In FieldStatusData.AuxFieldStatusData.Tables("tblFieldStatusLevel").Rows
                    sdt.Add(s("FieldStatusLevelCounterPk"), s("FieldStatusLevelText"))
                Next
                statStyle.DataMap = sdt
            End If
            ProviderNameGrid.Cols(2).Style = statStyle

            ProviderNameGrid.Cols(0).Width = 190
            ProviderNameGrid.Cols(1).Width = 300
            ProviderNameGrid.Cols(2).Width = 150
        End If
    End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        Try
            If provName IsNot Nothing Then
                If provName("PNNameFk").ToString.Length > 0 Then
                    DialogResult = Windows.Forms.DialogResult.Yes
                    Me.Close()
                Else
                    If PNPk <> -1 Then
                        Dim selForm As New SelectNameForm

                        If provName("PNNameFk").ToString <> "" Then
                            selForm.InitialNameId = provName("PNNameFk").ToString
                        End If

                        If selForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                            Windows.Forms.Cursor.Current = Cursors.WaitCursor

                            Try
                                BrProviderNames.UpdateProviderNameLink(New ProviderName(provName, PNPk.ToString, True), selForm.SelectedNameId)
                            Catch ex As Exception
                                MsgBox("Failed to relink name")
                                ChecklistException.LogError(ex)
                            End Try

                            LoadProviderName()

                            Windows.Forms.Cursor.Current = Cursors.WaitCursor
                        End If
                    End If
                End If
            End If
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub MergeSelectedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub NewNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewNameButton.Click
        Try
            Dim pn As New ChecklistObjects.ProviderName(provName, provName("PNPk").ToString, True)

            Dim n As New Name
            n.Id = Guid.NewGuid.ToString
            n.NameLSID = ChecklistObjects.Name.CreateLSID(n.Id)
            n.NameCanonical = pn.PNNameCanonical
            n.NameRank = pn.PNNameRank
            n.NameRankFk = pn.PNNameRankFk

            'parent
            Dim selForm As New SelectNameForm
            selForm.Title = "Select parent name for the new name"
            If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                n.NameParentFk = selForm.SelectedNameId
                n.NameParent = selForm.SelectedNameText
            Else
                Exit Sub
            End If

            'rank
            If n.NameRankFk = -1 Then
                Dim rnkForm As New SelectRankForm
                If rnkForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                    n.NameRankFk = rnkForm.SelectedRank.IdAsInt
                    n.NameRank = rnkForm.SelectedRank.Name
                Else
                    Exit Sub
                End If
            End If

            'canonical
            If n.NameCanonical Is Nothing OrElse n.NameCanonical.Length = 0 Then
                Dim grab As New GrabTextForm
                grab.Title = "Enter canonical for new name"
                If grab.ShowDialog = Windows.Forms.DialogResult.OK Then
                    n.NameCanonical = grab.TextValue
                Else
                    Exit Sub
                End If
            End If

            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            n = NameData.InsertName(n, SessionState.CurrentUser.Login)

            ChecklistBusinessRules.BrProviderNames.UpdateProviderNameLink(pn, n.Id)

            ChecklistBusinessRules.BrNames.RefreshNameData(n.Id, True)

            LoadProviderName()

            Windows.Forms.Cursor.Current = Cursors.Default

        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            ChecklistException.LogError(ex)
            MsgBox("Failed to create name")
        End Try
    End Sub
End Class