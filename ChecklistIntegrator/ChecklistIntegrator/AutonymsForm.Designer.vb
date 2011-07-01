<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AutonymsForm
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
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar()
        Me.CncButton = New System.Windows.Forms.Button()
        Me.ProgressText = New System.Windows.Forms.TextBox()
        Me.missingAutonyms = New System.Windows.Forms.CheckBox()
        Me.UnacceptedAutonyms = New System.Windows.Forms.CheckBox()
        Me.NoConceptAutonyms = New System.Windows.Forms.CheckBox()
        Me.SuspendLayout()
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 45)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(394, 23)
        Me.ProgressBar1.TabIndex = 2
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(351, 234)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(55, 22)
        Me.CncButton.TabIndex = 0
        Me.CncButton.Text = "Go"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'ProgressText
        '
        Me.ProgressText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressText.Location = New System.Drawing.Point(12, 74)
        Me.ProgressText.Multiline = True
        Me.ProgressText.Name = "ProgressText"
        Me.ProgressText.ReadOnly = True
        Me.ProgressText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.ProgressText.Size = New System.Drawing.Size(394, 154)
        Me.ProgressText.TabIndex = 3
        '
        'missingAutonyms
        '
        Me.missingAutonyms.AutoSize = True
        Me.missingAutonyms.Checked = True
        Me.missingAutonyms.CheckState = System.Windows.Forms.CheckState.Checked
        Me.missingAutonyms.Location = New System.Drawing.Point(12, 12)
        Me.missingAutonyms.Name = "missingAutonyms"
        Me.missingAutonyms.Size = New System.Drawing.Size(110, 17)
        Me.missingAutonyms.TabIndex = 4
        Me.missingAutonyms.Text = "Missing Autonyms"
        Me.missingAutonyms.UseVisualStyleBackColor = True
        '
        'UnacceptedAutonyms
        '
        Me.UnacceptedAutonyms.AutoSize = True
        Me.UnacceptedAutonyms.Checked = True
        Me.UnacceptedAutonyms.CheckState = System.Windows.Forms.CheckState.Checked
        Me.UnacceptedAutonyms.Location = New System.Drawing.Point(128, 12)
        Me.UnacceptedAutonyms.Name = "UnacceptedAutonyms"
        Me.UnacceptedAutonyms.Size = New System.Drawing.Size(134, 17)
        Me.UnacceptedAutonyms.TabIndex = 5
        Me.UnacceptedAutonyms.Text = "Unaccepted Autonyms"
        Me.UnacceptedAutonyms.UseVisualStyleBackColor = True
        '
        'NoConceptAutonyms
        '
        Me.NoConceptAutonyms.AutoSize = True
        Me.NoConceptAutonyms.Checked = True
        Me.NoConceptAutonyms.CheckState = System.Windows.Forms.CheckState.Checked
        Me.NoConceptAutonyms.Location = New System.Drawing.Point(268, 12)
        Me.NoConceptAutonyms.Name = "NoConceptAutonyms"
        Me.NoConceptAutonyms.Size = New System.Drawing.Size(132, 17)
        Me.NoConceptAutonyms.TabIndex = 6
        Me.NoConceptAutonyms.Text = "No Concept Autonyms"
        Me.NoConceptAutonyms.UseVisualStyleBackColor = True
        '
        'AutonymsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(418, 263)
        Me.Controls.Add(Me.NoConceptAutonyms)
        Me.Controls.Add(Me.UnacceptedAutonyms)
        Me.Controls.Add(Me.missingAutonyms)
        Me.Controls.Add(Me.ProgressText)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.ProgressBar1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "AutonymsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Process Autonyms"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents ProgressText As System.Windows.Forms.TextBox
    Friend WithEvents missingAutonyms As System.Windows.Forms.CheckBox
    Friend WithEvents UnacceptedAutonyms As System.Windows.Forms.CheckBox
    Friend WithEvents NoConceptAutonyms As System.Windows.Forms.CheckBox
End Class
