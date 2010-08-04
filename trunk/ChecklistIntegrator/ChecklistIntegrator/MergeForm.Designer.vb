<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MergeForm
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
        Me.MergeDetailsGrid = New C1.Win.C1FlexGrid.C1FlexGrid
        Me.CloseButton = New System.Windows.Forms.Button
        Me.CncButton = New System.Windows.Forms.Button
        CType(Me.MergeDetailsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MergeDetailsGrid
        '
        Me.MergeDetailsGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.MergeDetailsGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.MergeDetailsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MergeDetailsGrid.ColumnInfo = "0,0,0,0,0,85,Columns:"
        Me.MergeDetailsGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.MergeDetailsGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.MergeDetailsGrid.Location = New System.Drawing.Point(12, 12)
        Me.MergeDetailsGrid.Name = "MergeDetailsGrid"
        Me.MergeDetailsGrid.Rows.Count = 1
        Me.MergeDetailsGrid.Rows.DefaultSize = 17
        Me.MergeDetailsGrid.Size = New System.Drawing.Size(912, 506)
        Me.MergeDetailsGrid.TabIndex = 18
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CloseButton.Location = New System.Drawing.Point(856, 524)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(68, 22)
        Me.CloseButton.TabIndex = 20
        Me.CloseButton.Text = "OK"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(787, 524)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(63, 22)
        Me.CncButton.TabIndex = 21
        Me.CncButton.Text = "Close"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'MergeForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(936, 558)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.MergeDetailsGrid)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MergeForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Merge Records"
        CType(Me.MergeDetailsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents MergeDetailsGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents CncButton As System.Windows.Forms.Button
End Class
