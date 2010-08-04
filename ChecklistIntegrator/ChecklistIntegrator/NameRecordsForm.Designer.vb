<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NameRecordsForm
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
        Me.NameRecords1 = New IntegratorControls.NameRecords
        Me.CloseButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'NameRecords1
        '
        Me.NameRecords1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameRecords1.Location = New System.Drawing.Point(12, 12)
        Me.NameRecords1.Name = "NameRecords1"
        Me.NameRecords1.Size = New System.Drawing.Size(731, 541)
        Me.NameRecords1.TabIndex = 0
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(655, 560)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(88, 23)
        Me.CloseButton.TabIndex = 34
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'NameRecordsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(755, 595)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.NameRecords1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "NameRecordsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Name Records"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents NameRecords1 As IntegratorControls.NameRecords
    Public WithEvents CloseButton As System.Windows.Forms.Button
End Class
