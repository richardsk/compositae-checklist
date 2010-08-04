<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProviderReferenceForm
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
        Me.ProviderRefGrid = New C1.Win.C1FlexGrid.C1FlexGrid
        Me.LinkButton = New System.Windows.Forms.Button
        Me.CloseButton = New System.Windows.Forms.Button
        CType(Me.ProviderRefGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ProviderRefGrid
        '
        Me.ProviderRefGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.ProviderRefGrid.AllowEditing = False
        Me.ProviderRefGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.ProviderRefGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderRefGrid.ColumnInfo = "0,0,0,0,0,85,Columns:"
        Me.ProviderRefGrid.Cursor = System.Windows.Forms.Cursors.Default
        Me.ProviderRefGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.ProviderRefGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.ProviderRefGrid.Location = New System.Drawing.Point(12, 12)
        Me.ProviderRefGrid.Name = "ProviderRefGrid"
        Me.ProviderRefGrid.Rows.Count = 1
        Me.ProviderRefGrid.Rows.DefaultSize = 17
        Me.ProviderRefGrid.Size = New System.Drawing.Size(677, 476)
        Me.ProviderRefGrid.TabIndex = 28
        '
        'LinkButton
        '
        Me.LinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LinkButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LinkButton.Location = New System.Drawing.Point(508, 494)
        Me.LinkButton.Name = "LinkButton"
        Me.LinkButton.Size = New System.Drawing.Size(120, 22)
        Me.LinkButton.TabIndex = 27
        Me.LinkButton.Text = "Link To Reference"
        Me.LinkButton.UseVisualStyleBackColor = False
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CloseButton.Location = New System.Drawing.Point(634, 494)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(55, 22)
        Me.CloseButton.TabIndex = 26
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'ProviderReferenceForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(701, 528)
        Me.Controls.Add(Me.ProviderRefGrid)
        Me.Controls.Add(Me.LinkButton)
        Me.Controls.Add(Me.CloseButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ProviderReferenceForm"
        Me.Text = "Provider Reference"
        CType(Me.ProviderRefGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents ProviderRefGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents LinkButton As System.Windows.Forms.Button
    Friend WithEvents CloseButton As System.Windows.Forms.Button
End Class
