<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class UpdateStdOutputForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
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
        Me.ProgressText = New System.Windows.Forms.TextBox
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.GoButton = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.providerCombo = New System.Windows.Forms.ComboBox
        Me.closeButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'ProgressText
        '
        Me.ProgressText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressText.Location = New System.Drawing.Point(12, 62)
        Me.ProgressText.Multiline = True
        Me.ProgressText.Name = "ProgressText"
        Me.ProgressText.ReadOnly = True
        Me.ProgressText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.ProgressText.Size = New System.Drawing.Size(484, 118)
        Me.ProgressText.TabIndex = 2
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 33)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(484, 23)
        Me.ProgressBar1.TabIndex = 1
        '
        'GoButton
        '
        Me.GoButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GoButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.GoButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.GoButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.GoButton.Location = New System.Drawing.Point(357, 186)
        Me.GoButton.Name = "GoButton"
        Me.GoButton.Size = New System.Drawing.Size(70, 22)
        Me.GoButton.TabIndex = 3
        Me.GoButton.Text = "Go"
        Me.GoButton.UseVisualStyleBackColor = False
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(46, 13)
        Me.Label1.TabIndex = 7
        Me.Label1.Text = "Provider"
        '
        'providerCombo
        '
        Me.providerCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.providerCombo.FormattingEnabled = True
        Me.providerCombo.Location = New System.Drawing.Point(78, 6)
        Me.providerCombo.Name = "providerCombo"
        Me.providerCombo.Size = New System.Drawing.Size(376, 21)
        Me.providerCombo.TabIndex = 0
        '
        'closeButton
        '
        Me.closeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.closeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.closeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.closeButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.closeButton.Location = New System.Drawing.Point(433, 186)
        Me.closeButton.Name = "closeButton"
        Me.closeButton.Size = New System.Drawing.Size(63, 22)
        Me.closeButton.TabIndex = 8
        Me.closeButton.Text = "Close"
        Me.closeButton.UseVisualStyleBackColor = False
        '
        'UpdateStdOutputForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(508, 220)
        Me.Controls.Add(Me.closeButton)
        Me.Controls.Add(Me.providerCombo)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.GoButton)
        Me.Controls.Add(Me.ProgressText)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Name = "UpdateStdOutputForm"
        Me.Text = "Update Standard Output"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ProgressText As System.Windows.Forms.TextBox
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents GoButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents providerCombo As System.Windows.Forms.ComboBox
    Friend WithEvents closeButton As System.Windows.Forms.Button
End Class
