<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MoveDiffParentsForm
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
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.CncButton = New System.Windows.Forms.Button
        Me.ProgressText = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.parentText = New System.Windows.Forms.TextBox
        Me.browseButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 39)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(420, 23)
        Me.ProgressBar1.TabIndex = 1
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(377, 190)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(55, 22)
        Me.CncButton.TabIndex = 3
        Me.CncButton.Text = "Go"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'ProgressText
        '
        Me.ProgressText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressText.Location = New System.Drawing.Point(12, 68)
        Me.ProgressText.Multiline = True
        Me.ProgressText.Name = "ProgressText"
        Me.ProgressText.ReadOnly = True
        Me.ProgressText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.ProgressText.Size = New System.Drawing.Size(420, 116)
        Me.ProgressText.TabIndex = 2
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 15)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(38, 13)
        Me.Label1.TabIndex = 5
        Me.Label1.Text = "Parent"
        '
        'parentText
        '
        Me.parentText.Location = New System.Drawing.Point(56, 12)
        Me.parentText.Name = "parentText"
        Me.parentText.ReadOnly = True
        Me.parentText.Size = New System.Drawing.Size(287, 20)
        Me.parentText.TabIndex = 6
        '
        'browseButton
        '
        Me.browseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.browseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.browseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.browseButton.Location = New System.Drawing.Point(349, 10)
        Me.browseButton.Name = "browseButton"
        Me.browseButton.Size = New System.Drawing.Size(83, 22)
        Me.browseButton.TabIndex = 0
        Me.browseButton.Text = "Browse"
        Me.browseButton.UseVisualStyleBackColor = False
        '
        'MoveDiffParentsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(444, 219)
        Me.Controls.Add(Me.browseButton)
        Me.Controls.Add(Me.parentText)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.ProgressText)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.ProgressBar1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MoveDiffParentsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Move Names With Diff Preferred Parent"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents ProgressText As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents parentText As System.Windows.Forms.TextBox
    Friend WithEvents browseButton As System.Windows.Forms.Button
End Class
