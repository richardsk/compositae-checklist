<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NameRecords
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.Label3 = New System.Windows.Forms.Label
        Me.FilterText = New System.Windows.Forms.TextBox
        Me.ListButton = New System.Windows.Forms.Button
        Me.Label4 = New System.Windows.Forms.Label
        Me.ResultsGrid = New System.Windows.Forms.DataGridView
        Me.MaxCombo = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.LinkButton = New System.Windows.Forms.Button
        Me.MergeButton = New System.Windows.Forms.Button
        Me.ProvNamesGrid = New System.Windows.Forms.DataGridView
        Me.Selected = New System.Windows.Forms.DataGridViewCheckBoxColumn
        Me.PNSelected = New System.Windows.Forms.DataGridViewCheckBoxColumn
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.ProvNamesGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(3, 6)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(50, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Text filter"
        '
        'FilterText
        '
        Me.FilterText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterText.Location = New System.Drawing.Point(77, 3)
        Me.FilterText.Name = "FilterText"
        Me.FilterText.Size = New System.Drawing.Size(469, 20)
        Me.FilterText.TabIndex = 5
        '
        'ListButton
        '
        Me.ListButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ListButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ListButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ListButton.Location = New System.Drawing.Point(458, 50)
        Me.ListButton.Name = "ListButton"
        Me.ListButton.Size = New System.Drawing.Size(88, 23)
        Me.ListButton.TabIndex = 33
        Me.ListButton.Text = "List Records"
        Me.ListButton.UseVisualStyleBackColor = False
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(3, 89)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(50, 13)
        Me.Label4.TabIndex = 34
        Me.Label4.Text = "Records:"
        '
        'ResultsGrid
        '
        Me.ResultsGrid.AllowUserToAddRows = False
        Me.ResultsGrid.AllowUserToDeleteRows = False
        Me.ResultsGrid.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ResultsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.Selected})
        Me.ResultsGrid.Location = New System.Drawing.Point(3, 105)
        Me.ResultsGrid.MultiSelect = False
        Me.ResultsGrid.Name = "ResultsGrid"
        Me.ResultsGrid.RowHeadersVisible = False
        Me.ResultsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect
        Me.ResultsGrid.Size = New System.Drawing.Size(626, 170)
        Me.ResultsGrid.TabIndex = 35
        '
        'MaxCombo
        '
        Me.MaxCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MaxCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.MaxCombo.FormattingEnabled = True
        Me.MaxCombo.Location = New System.Drawing.Point(77, 29)
        Me.MaxCombo.Name = "MaxCombo"
        Me.MaxCombo.Size = New System.Drawing.Size(274, 21)
        Me.MaxCombo.TabIndex = 37
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(3, 32)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(65, 13)
        Me.Label5.TabIndex = 36
        Me.Label5.Text = "Max records"
        '
        'LinkButton
        '
        Me.LinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LinkButton.Location = New System.Drawing.Point(489, 463)
        Me.LinkButton.Name = "LinkButton"
        Me.LinkButton.Size = New System.Drawing.Size(143, 22)
        Me.LinkButton.TabIndex = 39
        Me.LinkButton.Text = "Link Selected Records"
        Me.LinkButton.UseVisualStyleBackColor = False
        '
        'MergeButton
        '
        Me.MergeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MergeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.MergeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.MergeButton.Location = New System.Drawing.Point(489, 281)
        Me.MergeButton.Name = "MergeButton"
        Me.MergeButton.Size = New System.Drawing.Size(143, 22)
        Me.MergeButton.TabIndex = 40
        Me.MergeButton.Text = "Merge Selected Records"
        Me.MergeButton.UseVisualStyleBackColor = False
        '
        'ProvNamesGrid
        '
        Me.ProvNamesGrid.AllowUserToAddRows = False
        Me.ProvNamesGrid.AllowUserToDeleteRows = False
        Me.ProvNamesGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProvNamesGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ProvNamesGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.PNSelected})
        Me.ProvNamesGrid.Location = New System.Drawing.Point(9, 309)
        Me.ProvNamesGrid.MultiSelect = False
        Me.ProvNamesGrid.Name = "ProvNamesGrid"
        Me.ProvNamesGrid.RowHeadersVisible = False
        Me.ProvNamesGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect
        Me.ProvNamesGrid.Size = New System.Drawing.Size(626, 148)
        Me.ProvNamesGrid.TabIndex = 41
        '
        'Selected
        '
        Me.Selected.FalseValue = "False"
        Me.Selected.FillWeight = 60.0!
        Me.Selected.HeaderText = "Select"
        Me.Selected.Name = "Selected"
        Me.Selected.TrueValue = "True"
        Me.Selected.Width = 60
        '
        'PNSelected
        '
        Me.PNSelected.DataPropertyName = "Selected"
        Me.PNSelected.FalseValue = "False"
        Me.PNSelected.FillWeight = 60.0!
        Me.PNSelected.HeaderText = "Select"
        Me.PNSelected.Name = "PNSelected"
        Me.PNSelected.TrueValue = "True"
        Me.PNSelected.Width = 60
        '
        'NameRecords
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.ProvNamesGrid)
        Me.Controls.Add(Me.MergeButton)
        Me.Controls.Add(Me.LinkButton)
        Me.Controls.Add(Me.MaxCombo)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.ResultsGrid)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ListButton)
        Me.Controls.Add(Me.FilterText)
        Me.Controls.Add(Me.Label3)
        Me.Name = "NameRecords"
        Me.Size = New System.Drawing.Size(635, 489)
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.ProvNamesGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents FilterText As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents ResultsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents MaxCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents LinkButton As System.Windows.Forms.Button
    Friend WithEvents MergeButton As System.Windows.Forms.Button
    Friend WithEvents ProvNamesGrid As System.Windows.Forms.DataGridView
    Public WithEvents ListButton As System.Windows.Forms.Button
    Friend WithEvents Selected As System.Windows.Forms.DataGridViewCheckBoxColumn
    Friend WithEvents PNSelected As System.Windows.Forms.DataGridViewCheckBoxColumn

End Class
