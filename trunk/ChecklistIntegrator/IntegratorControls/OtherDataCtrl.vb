Public Class OtherDataCtrl


    Public Event OtherDataEdited()

    Private m_IsDirty As Boolean = False

    Public Property IsDirty() As Boolean
        Get
            Return m_IsDirty
        End Get
        Set(ByVal value As Boolean)
            m_IsDirty = value
            RaiseEvent OtherDataEdited()
        End Set
    End Property

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        OthDataDisplayTabCol.Items.Add("")
        For Each nm As String In [Enum].GetNames(GetType(ChecklistObjects.EDisplayTab))
            OthDataDisplayTabCol.Items.Add(nm)
        Next

    End Sub

    Public Sub Initialise()
        Try
            grdTransformations.AutoGenerateColumns = False
            grdOtherDataTypes.AutoGenerateColumns = False
            grdTransMappings.AutoGenerateColumns = False

            grdTransformations.DataSource = ChecklistDataAccess.OtherData.GetTransformations().Tables(0)
            grdOtherDataTypes.DataSource = ChecklistDataAccess.OtherData.GetOtherDataTypes().Tables(0)
            grdTransMappings.DataSource = ChecklistDataAccess.OtherData.GetOtherDataMappings().Tables(0)

            Dim dsTrans As DataSet = ChecklistDataAccess.OtherData.GetTransformations()
            dsTrans.Tables(0).Rows.Add(New Object() {DBNull.Value, "[none]", DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value})
            Dim othTypeDs As DataSet = ChecklistDataAccess.OtherData.GetOtherDataTypes()
            othTypeDs.Tables(0).Rows.Add(New Object() {DBNull.Value, "[none]", DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value, DBNull.Value})

            TransXmlCol.DefaultCellStyle.NullValue = "Import..."

            OthDataConsTransCol.DataSource = dsTrans.Tables(0)
            OthDataConsTransCol.DisplayMember = "Name"
            OthDataConsTransCol.ValueMember = "TransformationPk"

            OthDataWebTransCol.DataSource = dsTrans.Tables(0)
            OthDataWebTransCol.DisplayMember = "Name"
            OthDataWebTransCol.ValueMember = "TransformationPk"

            MappingsOutputCol.DataSource = othTypeDs.Tables(0)
            MappingsOutputCol.DisplayMember = "Name"
            MappingsOutputCol.ValueMember = "OtherDataTypePk"

            MappingsTransCol.DataSource = dsTrans.Tables(0)
            MappingsTransCol.DisplayMember = "Name"
            MappingsTransCol.ValueMember = "TransformationPk"

            MappingImportCol.DataSource = ChecklistDataAccess.ImportData.GetProviderImports(-1)
            MappingImportCol.DisplayMember = "Text"
            MappingImportCol.ValueMember = "ProviderImportPk"

            Dim types As DataTable = ChecklistDataAccess.OtherData.GetProviderOtherDataTypes
            types.Rows.Add(New Object() {DBNull.Value, DBNull.Value})
            MappingsTypeCol.DataSource = New DataView(types)
            MappingsTypeCol.DisplayMember = "POtherDataType"
            MappingsTypeCol.ValueMember = "POtherDataType"

            IsDirty = False
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub grdTransMappings_CellBeginEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles grdTransMappings.CellBeginEdit
        If grdTransMappings.Columns(e.ColumnIndex).Name = MappingsTypeCol.Name Then
            'update data type col

            grdTransMappings.Rows(e.RowIndex).Cells(MappingsTypeCol.Name).Value = DBNull.Value
            Dim dv As DataView = CType(grdTransMappings.Rows(e.RowIndex).Cells(MappingsTypeCol.Name), DataGridViewComboBoxCell).DataSource
            dv = New DataView(dv.Table)
            dv.RowFilter = "POtherDataProviderImportFk is null"
            If grdTransMappings.Rows(e.RowIndex).Cells(MappingImportCol.Name).Value IsNot DBNull.Value Then
                Dim impPk As Integer = grdTransMappings.Rows(e.RowIndex).Cells(MappingImportCol.Name).Value
                dv.RowFilter = "POtherDataProviderImportFk is null or POtherDataProviderImportFk = " + impPk.ToString
            End If
            CType(grdTransMappings.Rows(e.RowIndex).Cells(MappingsTypeCol.Name), DataGridViewComboBoxCell).DataSource = dv
        End If

        IsDirty = True
    End Sub

    Private Sub grdTransformations_CellContentClick(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles grdTransformations.CellContentClick
        If grdTransformations.Columns(e.ColumnIndex).Name = TransXmlCol.Name Then
            Try
                Dim doc As Xml.XmlDocument = ImportTransformationForm.GetFileXml()
                If doc IsNot Nothing Then
                    grdTransformations.Item(e.ColumnIndex, e.RowIndex).Value = doc.DocumentElement.OuterXml
                    IsDirty = True
                End If
            Catch ex As Exception
                ChecklistObjects.ChecklistException.LogError(ex)
                MsgBox("Error getting xslt")
            End Try
        End If
    End Sub

    Private Sub grdOtherDataTypes_CellEndEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles grdOtherDataTypes.CellEndEdit
        IsDirty = True
    End Sub

    Private Sub grdTransformations_CellEndEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles grdTransformations.CellEndEdit
        IsDirty = True
    End Sub

    Private Sub grdOtherDataTypes_UserAddedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdOtherDataTypes.UserAddedRow
        IsDirty = True
    End Sub

    Private Sub grdOtherDataTypes_UserDeletedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdOtherDataTypes.UserDeletedRow
        IsDirty = True
    End Sub

    Private Sub grdTransformations_UserAddedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdTransformations.UserAddedRow
        IsDirty = True
    End Sub

    Private Sub grdTransformations_UserDeletedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdTransformations.UserDeletedRow
        IsDirty = True
    End Sub

    Private Sub grdTransMappings_UserAddedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdTransMappings.UserAddedRow
        IsDirty = True
    End Sub

    Private Sub grdTransMappings_UserDeletedRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowEventArgs) Handles grdTransMappings.UserDeletedRow
        IsDirty = True
    End Sub

    Private Sub llbRefreshOthData_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles llbRefreshOthData.LinkClicked
        If DoSave(True) Then Initialise()
    End Sub

    Public Function DoSave(ByVal prompt As Boolean) As Boolean
        Dim ok As Boolean = True

        If IsDirty Then
            Dim res As MsgBoxResult = MsgBoxResult.Yes
            If prompt Then
                res = MsgBox("Save changes?", MsgBoxStyle.YesNo, "Save Other Data")
            End If

            If res = MsgBoxResult.Yes Then
                Try

                    Dim dt As DataTable = grdTransMappings.DataSource
                    Dim ch As DataTable = dt.GetChanges
                    Dim i As Integer = 0
                    For Each row As DataRow In dt.Rows
                        If row.RowState <> DataRowState.Deleted Then
                            If row.IsNull("ProviderImportFk") Then
                                MsgBox("An import must be specified for a mapping")
                                grdTransMappings.Focus()
                                grdTransMappings.CurrentCell = grdTransMappings.Item(MappingImportCol.Index, i)
                                Return False
                            End If
                            If row.IsNull("POtherDataType") Then
                                MsgBox("A data type must be specified for a mapping")
                                grdTransMappings.Focus()
                                grdTransMappings.CurrentCell = grdTransMappings.Item(MappingsTypeCol.Index, i)
                                Return False
                            End If
                            i += 1
                        End If
                    Next

                    dt = grdTransformations.DataSource
                    ch = dt.GetChanges
                    If ch IsNot Nothing Then
                        For Each row As DataRow In ch.Rows
                            If row.RowState = DataRowState.Added OrElse row.RowState = DataRowState.Modified Then
                                ChecklistDataAccess.OtherData.InsertUpdateTransformation(row, ChecklistObjects.SessionState.CurrentUser.Login)
                            ElseIf row.RowState = DataRowState.Deleted Then
                                ChecklistDataAccess.OtherData.DeleteTransformation(row("TransformationPk", DataRowVersion.Original))
                            End If
                        Next
                    End If

                    dt = grdOtherDataTypes.DataSource
                    ch = dt.GetChanges
                    If ch IsNot Nothing Then
                        For Each row As DataRow In ch.Rows
                            If row.RowState = DataRowState.Added OrElse row.RowState = DataRowState.Modified Then
                                ChecklistDataAccess.OtherData.InsertUpdateOtherDataType(row, ChecklistObjects.SessionState.CurrentUser.Login)
                            ElseIf row.RowState = DataRowState.Deleted Then
                                ChecklistDataAccess.OtherData.DeleteOtherDataType(row("OtherDataTypePk", DataRowVersion.Original))
                            End If
                        Next
                    End If

                    dt = grdTransMappings.DataSource
                    ch = dt.GetChanges
                    If ch IsNot Nothing Then
                        For Each row As DataRow In ch.Rows
                            If row.RowState = DataRowState.Added OrElse row.RowState = DataRowState.Modified Then
                                ChecklistDataAccess.OtherData.InsertUpdateOtherDataMapping(row, ChecklistObjects.SessionState.CurrentUser.Login)
                            ElseIf row.RowState = DataRowState.Deleted Then
                                Dim outTypeFk As Object = row("OutputTypeFk", DataRowVersion.Original)
                                If outTypeFk Is DBNull.Value Then outTypeFk = -1
                                ChecklistDataAccess.OtherData.DeleteOtherDataMapping(row("ProviderImportFk", DataRowVersion.Original), row("POtherDataType", DataRowVersion.Original), outTypeFk)
                            End If
                        Next
                    End If

                    Initialise() 'reload

                    IsDirty = False
                Catch ex As Exception
                    ChecklistObjects.ChecklistException.LogError(ex)
                    ok = False
                End Try

            End If

        End If

        Return ok
    End Function

    Private Sub btnImportTrans_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImportTrans.Click
        Dim impFm As New ImportTransformationForm
        If impFm.ShowDialog = DialogResult.OK Then
            Dim dt As DataTable = grdTransformations.DataSource

            Dim xslt As Object = DBNull.Value
            If impFm.TransformationXslt IsNot Nothing Then xslt = impFm.TransformationXslt.DocumentElement.OuterXml
            dt.Rows.Add(New Object() {-1, impFm.TransformationName, impFm.TransformationDescription, xslt, DBNull.Value, DBNull.Value})
        End If
    End Sub


    Private Sub updateStdDataBtn_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles updateStdDataBtn.Click
        Dim updFm As New UpdateStdOutputForm
        updFm.ShowDialog()
    End Sub

    Private Sub updateConsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles updateConsButton.Click
        Dim integFm As New IntegrationProcessForm
        integFm.ShowDialog()
    End Sub
End Class
