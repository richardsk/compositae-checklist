<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProviderNameRecordsForm
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
        Me.ProviderNameRecords1 = New IntegratorControls.ProviderNameRecords
        Me.GotoButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(633, 529)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(88, 23)
        Me.CloseButton.TabIndex = 34
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'ProviderNameRecords1
        '
        Me.ProviderNameRecords1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderNameRecords1.Location = New System.Drawing.Point(12, 11)
        Me.ProviderNameRecords1.Name = "ProviderNameRecords1"
        Me.ProviderNameRecords1.Size = New System.Drawing.Size(709, 512)
        Me.ProviderNameRecords1.TabIndex = 38
        '
        'GotoButton
        '
        Me.GotoButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GotoButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.GotoButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.GotoButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.GotoButton.Location = New System.Drawing.Point(514, 529)
        Me.GotoButton.Name = "GotoButton"
        Me.GotoButton.Size = New System.Drawing.Size(113, 23)
        Me.GotoButton.TabIndex = 39
        Me.GotoButton.Text = "Go to name"
        Me.GotoButton.UseVisualStyleBackColor = False
        '
        'ProviderNameRecordsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(733, 564)
        Me.Controls.Add(Me.GotoButton)
        Me.Controls.Add(Me.ProviderNameRecords1)
        Me.Controls.Add(Me.CloseButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ProviderNameRecordsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Provider Name Records"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents ProviderNameRecords1 As IntegratorControls.ProviderNameRecords
    Friend WithEvents GotoButton As System.Windows.Forms.Button
End Class
