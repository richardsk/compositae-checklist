<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MultipleMatchesForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Me.Label1 = New System.Windows.Forms.Label
        Me.RecordDataGrid = New System.Windows.Forms.DataGridView
        Me.MatchesDataGrid = New System.Windows.Forms.DataGridView
        Me.Label2 = New System.Windows.Forms.Label
        Me.CloseButton = New System.Windows.Forms.Button
        Me.SelectButton = New System.Windows.Forms.Button
        Me.NewNameButton = New System.Windows.Forms.Button
        CType(Me.RecordDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MatchesDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(86, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Record to match"
        '
        'RecordDataGrid
        '
        Me.RecordDataGrid.AllowUserToAddRows = False
        Me.RecordDataGrid.AllowUserToDeleteRows = False
        Me.RecordDataGrid.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RecordDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.RecordDataGrid.Location = New System.Drawing.Point(12, 25)
        Me.RecordDataGrid.Name = "RecordDataGrid"
        Me.RecordDataGrid.ReadOnly = True
        Me.RecordDataGrid.Size = New System.Drawing.Size(631, 82)
        Me.RecordDataGrid.TabIndex = 1
        '
        'MatchesDataGrid
        '
        Me.MatchesDataGrid.AllowUserToAddRows = False
        Me.MatchesDataGrid.AllowUserToDeleteRows = False
        Me.MatchesDataGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MatchesDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.MatchesDataGrid.Location = New System.Drawing.Point(12, 135)
        Me.MatchesDataGrid.Name = "MatchesDataGrid"
        Me.MatchesDataGrid.ReadOnly = True
        Me.MatchesDataGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.MatchesDataGrid.Size = New System.Drawing.Size(631, 175)
        Me.MatchesDataGrid.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 119)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(89, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Possible matches"
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(566, 316)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(77, 23)
        Me.CloseButton.TabIndex = 33
        Me.CloseButton.Text = "Cancel"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'SelectButton
        '
        Me.SelectButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SelectButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SelectButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SelectButton.Location = New System.Drawing.Point(462, 316)
        Me.SelectButton.Name = "SelectButton"
        Me.SelectButton.Size = New System.Drawing.Size(98, 23)
        Me.SelectButton.TabIndex = 34
        Me.SelectButton.Text = "Select Record"
        Me.SelectButton.UseVisualStyleBackColor = False
        '
        'NewNameButton
        '
        Me.NewNameButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NewNameButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.NewNameButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.NewNameButton.Location = New System.Drawing.Point(369, 316)
        Me.NewNameButton.Name = "NewNameButton"
        Me.NewNameButton.Size = New System.Drawing.Size(87, 23)
        Me.NewNameButton.TabIndex = 35
        Me.NewNameButton.Text = "New Name"
        Me.NewNameButton.UseVisualStyleBackColor = False
        '
        'MultipleMatchesForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.CloseButton
        Me.ClientSize = New System.Drawing.Size(655, 351)
        Me.Controls.Add(Me.NewNameButton)
        Me.Controls.Add(Me.SelectButton)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.MatchesDataGrid)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.RecordDataGrid)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MultipleMatchesForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Resolve Multiple Matches"
        CType(Me.RecordDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MatchesDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents RecordDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents MatchesDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents SelectButton As System.Windows.Forms.Button
    Friend WithEvents NewNameButton As System.Windows.Forms.Button
End Class
