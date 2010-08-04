<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class OtherDataCtrl
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.grdOtherDataTypes = New System.Windows.Forms.DataGridView
        Me.OthDataIdCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.OthDataNameCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.OthDataConsTransCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.OthDataWebTransCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.OthDataWebSeqCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.OthDataDisplayTabCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.Label10 = New System.Windows.Forms.Label
        Me.grdTransMappings = New System.Windows.Forms.DataGridView
        Me.MappingImportCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.MappingsTypeCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.MappingsUseXmlCol = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.MappingsTransCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.MappingsOutputCol = New System.Windows.Forms.DataGridViewComboBoxColumn
        Me.MappingsAddRootCol = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.Label9 = New System.Windows.Forms.Label
        Me.btnImportTrans = New System.Windows.Forms.Button
        Me.grdTransformations = New System.Windows.Forms.DataGridView
        Me.TransIdCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.TransNameCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.TransDescCol = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.TransXmlCol = New System.Windows.Forms.DataGridViewLinkColumn
        Me.Label7 = New System.Windows.Forms.Label
        Me.llbRefreshOthData = New System.Windows.Forms.LinkLabel
        Me.updateStdDataBtn = New System.Windows.Forms.Button
        Me.updateConsButton = New System.Windows.Forms.Button
        CType(Me.grdOtherDataTypes, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdTransMappings, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.grdTransformations, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'grdOtherDataTypes
        '
        Me.grdOtherDataTypes.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdOtherDataTypes.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.grdOtherDataTypes.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.grdOtherDataTypes.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.OthDataIdCol, Me.OthDataNameCol, Me.OthDataConsTransCol, Me.OthDataWebTransCol, Me.OthDataWebSeqCol, Me.OthDataDisplayTabCol})
        Me.grdOtherDataTypes.Location = New System.Drawing.Point(101, 183)
        Me.grdOtherDataTypes.Name = "grdOtherDataTypes"
        Me.grdOtherDataTypes.Size = New System.Drawing.Size(792, 171)
        Me.grdOtherDataTypes.TabIndex = 2
        '
        'OthDataIdCol
        '
        Me.OthDataIdCol.DataPropertyName = "OtherDataTypePk"
        Me.OthDataIdCol.HeaderText = "Id"
        Me.OthDataIdCol.Name = "OthDataIdCol"
        Me.OthDataIdCol.Visible = False
        '
        'OthDataNameCol
        '
        Me.OthDataNameCol.DataPropertyName = "Name"
        Me.OthDataNameCol.HeaderText = "Name"
        Me.OthDataNameCol.Name = "OthDataNameCol"
        '
        'OthDataConsTransCol
        '
        Me.OthDataConsTransCol.DataPropertyName = "ConsensusTransformationFk"
        Me.OthDataConsTransCol.HeaderText = "Cons. Transformation"
        Me.OthDataConsTransCol.Name = "OthDataConsTransCol"
        '
        'OthDataWebTransCol
        '
        Me.OthDataWebTransCol.DataPropertyName = "WebTransformationFk"
        Me.OthDataWebTransCol.HeaderText = "Web Transformation"
        Me.OthDataWebTransCol.Name = "OthDataWebTransCol"
        '
        'OthDataWebSeqCol
        '
        Me.OthDataWebSeqCol.DataPropertyName = "WebSequence"
        Me.OthDataWebSeqCol.HeaderText = "Web Sequence"
        Me.OthDataWebSeqCol.Name = "OthDataWebSeqCol"
        '
        'OthDataDisplayTabCol
        '
        Me.OthDataDisplayTabCol.DataPropertyName = "DisplayTab"
        Me.OthDataDisplayTabCol.HeaderText = "Web Display Tab"
        Me.OthDataDisplayTabCol.Name = "OthDataDisplayTabCol"
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(6, 183)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(91, 13)
        Me.Label10.TabIndex = 25
        Me.Label10.Text = "Other Data Types"
        '
        'grdTransMappings
        '
        Me.grdTransMappings.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdTransMappings.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.grdTransMappings.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.grdTransMappings.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.MappingImportCol, Me.MappingsTypeCol, Me.MappingsUseXmlCol, Me.MappingsTransCol, Me.MappingsOutputCol, Me.MappingsAddRootCol})
        Me.grdTransMappings.Location = New System.Drawing.Point(101, 360)
        Me.grdTransMappings.Name = "grdTransMappings"
        Me.grdTransMappings.Size = New System.Drawing.Size(792, 190)
        Me.grdTransMappings.TabIndex = 3
        '
        'MappingImportCol
        '
        Me.MappingImportCol.DataPropertyName = "ProviderImportFk"
        Me.MappingImportCol.HeaderText = "Import"
        Me.MappingImportCol.Name = "MappingImportCol"
        '
        'MappingsTypeCol
        '
        Me.MappingsTypeCol.DataPropertyName = "POtherDataType"
        Me.MappingsTypeCol.HeaderText = "Data Type"
        Me.MappingsTypeCol.Name = "MappingsTypeCol"
        '
        'MappingsUseXmlCol
        '
        Me.MappingsUseXmlCol.DataPropertyName = "UseDataXml"
        Me.MappingsUseXmlCol.FillWeight = 60.0!
        Me.MappingsUseXmlCol.HeaderText = "Use Xml"
        Me.MappingsUseXmlCol.Name = "MappingsUseXmlCol"
        '
        'MappingsTransCol
        '
        Me.MappingsTransCol.DataPropertyName = "TransformationFk"
        Me.MappingsTransCol.HeaderText = "Transformation"
        Me.MappingsTransCol.Name = "MappingsTransCol"
        '
        'MappingsOutputCol
        '
        Me.MappingsOutputCol.DataPropertyName = "OutputTypeFk"
        Me.MappingsOutputCol.HeaderText = "Output Type"
        Me.MappingsOutputCol.Name = "MappingsOutputCol"
        '
        'MappingsAddRootCol
        '
        Me.MappingsAddRootCol.DataPropertyName = "AddRoot"
        Me.MappingsAddRootCol.FillWeight = 60.0!
        Me.MappingsAddRootCol.HeaderText = "Add Root"
        Me.MappingsAddRootCol.Name = "MappingsAddRootCol"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(6, 360)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(53, 13)
        Me.Label9.TabIndex = 23
        Me.Label9.Text = "Mappings"
        '
        'btnImportTrans
        '
        Me.btnImportTrans.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnImportTrans.BackColor = System.Drawing.Color.WhiteSmoke
        Me.btnImportTrans.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnImportTrans.Location = New System.Drawing.Point(899, 23)
        Me.btnImportTrans.Name = "btnImportTrans"
        Me.btnImportTrans.Size = New System.Drawing.Size(80, 23)
        Me.btnImportTrans.TabIndex = 1
        Me.btnImportTrans.Text = "Import"
        Me.btnImportTrans.UseVisualStyleBackColor = False
        '
        'grdTransformations
        '
        Me.grdTransformations.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdTransformations.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill
        Me.grdTransformations.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.grdTransformations.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.TransIdCol, Me.TransNameCol, Me.TransDescCol, Me.TransXmlCol})
        Me.grdTransformations.Location = New System.Drawing.Point(101, 18)
        Me.grdTransformations.Name = "grdTransformations"
        Me.grdTransformations.Size = New System.Drawing.Size(792, 159)
        Me.grdTransformations.TabIndex = 0
        '
        'TransIdCol
        '
        Me.TransIdCol.DataPropertyName = "TransformationPk"
        Me.TransIdCol.HeaderText = "Id"
        Me.TransIdCol.Name = "TransIdCol"
        Me.TransIdCol.Visible = False
        '
        'TransNameCol
        '
        Me.TransNameCol.DataPropertyName = "Name"
        Me.TransNameCol.HeaderText = "Name"
        Me.TransNameCol.Name = "TransNameCol"
        '
        'TransDescCol
        '
        Me.TransDescCol.DataPropertyName = "Description"
        Me.TransDescCol.HeaderText = "Description"
        Me.TransDescCol.Name = "TransDescCol"
        '
        'TransXmlCol
        '
        Me.TransXmlCol.DataPropertyName = "Xslt"
        Me.TransXmlCol.HeaderText = "Xslt"
        Me.TransXmlCol.Name = "TransXmlCol"
        Me.TransXmlCol.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.TransXmlCol.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(3, 18)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(82, 13)
        Me.Label7.TabIndex = 20
        Me.Label7.Text = "Transformations"
        '
        'llbRefreshOthData
        '
        Me.llbRefreshOthData.AutoSize = True
        Me.llbRefreshOthData.Location = New System.Drawing.Point(98, 3)
        Me.llbRefreshOthData.Name = "llbRefreshOthData"
        Me.llbRefreshOthData.Size = New System.Drawing.Size(44, 13)
        Me.llbRefreshOthData.TabIndex = 26
        Me.llbRefreshOthData.TabStop = True
        Me.llbRefreshOthData.Text = "Refresh"
        '
        'updateStdDataBtn
        '
        Me.updateStdDataBtn.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.updateStdDataBtn.BackColor = System.Drawing.Color.WhiteSmoke
        Me.updateStdDataBtn.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.updateStdDataBtn.Location = New System.Drawing.Point(571, 556)
        Me.updateStdDataBtn.Name = "updateStdDataBtn"
        Me.updateStdDataBtn.Size = New System.Drawing.Size(158, 23)
        Me.updateStdDataBtn.TabIndex = 27
        Me.updateStdDataBtn.Text = "Update Standard Output"
        Me.updateStdDataBtn.UseVisualStyleBackColor = False
        '
        'updateConsButton
        '
        Me.updateConsButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.updateConsButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.updateConsButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.updateConsButton.Location = New System.Drawing.Point(735, 556)
        Me.updateConsButton.Name = "updateConsButton"
        Me.updateConsButton.Size = New System.Drawing.Size(158, 23)
        Me.updateConsButton.TabIndex = 28
        Me.updateConsButton.Text = "Update Consensus Data"
        Me.updateConsButton.UseVisualStyleBackColor = False
        '
        'OtherDataCtrl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.AutoScroll = True
        Me.Controls.Add(Me.updateConsButton)
        Me.Controls.Add(Me.updateStdDataBtn)
        Me.Controls.Add(Me.llbRefreshOthData)
        Me.Controls.Add(Me.grdOtherDataTypes)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.grdTransMappings)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.btnImportTrans)
        Me.Controls.Add(Me.grdTransformations)
        Me.Controls.Add(Me.Label7)
        Me.Name = "OtherDataCtrl"
        Me.Size = New System.Drawing.Size(986, 586)
        CType(Me.grdOtherDataTypes, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdTransMappings, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.grdTransformations, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents grdOtherDataTypes As System.Windows.Forms.DataGridView
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents grdTransMappings As System.Windows.Forms.DataGridView
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents btnImportTrans As System.Windows.Forms.Button
    Friend WithEvents grdTransformations As System.Windows.Forms.DataGridView
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents MappingImportCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MappingsTypeCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MappingsUseXmlCol As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents MappingsTransCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MappingsOutputCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents MappingsAddRootCol As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents llbRefreshOthData As System.Windows.Forms.LinkLabel
    Friend WithEvents TransIdCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents TransNameCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents TransDescCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents TransXmlCol As System.Windows.Forms.DataGridViewLinkColumn
    Friend WithEvents updateStdDataBtn As System.Windows.Forms.Button
    Friend WithEvents updateConsButton As System.Windows.Forms.Button
    Friend WithEvents OthDataIdCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents OthDataNameCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents OthDataConsTransCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents OthDataWebTransCol As System.Windows.Forms.DataGridViewComboBoxColumn
    Friend WithEvents OthDataWebSeqCol As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents OthDataDisplayTabCol As System.Windows.Forms.DataGridViewComboBoxColumn

End Class
