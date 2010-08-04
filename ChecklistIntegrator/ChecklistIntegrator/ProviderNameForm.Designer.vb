<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProviderNameForm
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
        Me.CloseButton = New System.Windows.Forms.Button
        Me.LinkButton = New System.Windows.Forms.Button
        Me.ProviderNameGrid = New C1.Win.C1FlexGrid.C1FlexGrid
        Me.NewNameButton = New System.Windows.Forms.Button
        CType(Me.ProviderNameGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CloseButton.Location = New System.Drawing.Point(649, 512)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(55, 22)
        Me.CloseButton.TabIndex = 23
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'LinkButton
        '
        Me.LinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LinkButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LinkButton.Location = New System.Drawing.Point(410, 512)
        Me.LinkButton.Name = "LinkButton"
        Me.LinkButton.Size = New System.Drawing.Size(97, 22)
        Me.LinkButton.TabIndex = 24
        Me.LinkButton.Text = "Link To Name"
        Me.LinkButton.UseVisualStyleBackColor = False
        '
        'ProviderNameGrid
        '
        Me.ProviderNameGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.ProviderNameGrid.AllowEditing = False
        Me.ProviderNameGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.ProviderNameGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderNameGrid.ColumnInfo = "0,0,0,0,0,85,Columns:"
        Me.ProviderNameGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.ProviderNameGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.ProviderNameGrid.Location = New System.Drawing.Point(12, 12)
        Me.ProviderNameGrid.Name = "ProviderNameGrid"
        Me.ProviderNameGrid.Rows.Count = 1
        Me.ProviderNameGrid.Rows.DefaultSize = 17
        Me.ProviderNameGrid.Size = New System.Drawing.Size(692, 494)
        Me.ProviderNameGrid.TabIndex = 25
        '
        'NewNameButton
        '
        Me.NewNameButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NewNameButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.NewNameButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.NewNameButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.NewNameButton.Location = New System.Drawing.Point(513, 512)
        Me.NewNameButton.Name = "NewNameButton"
        Me.NewNameButton.Size = New System.Drawing.Size(130, 22)
        Me.NewNameButton.TabIndex = 26
        Me.NewNameButton.Text = "Link To New Name"
        Me.NewNameButton.UseVisualStyleBackColor = False
        '
        'ProviderNameForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(716, 546)
        Me.Controls.Add(Me.NewNameButton)
        Me.Controls.Add(Me.ProviderNameGrid)
        Me.Controls.Add(Me.LinkButton)
        Me.Controls.Add(Me.CloseButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ProviderNameForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Provider Name"
        CType(Me.ProviderNameGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents LinkButton As System.Windows.Forms.Button
    Friend WithEvents ProviderNameGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents NewNameButton As System.Windows.Forms.Button
End Class
