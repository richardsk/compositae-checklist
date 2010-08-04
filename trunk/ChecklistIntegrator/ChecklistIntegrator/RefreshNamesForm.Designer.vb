<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class RefreshNamesForm
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
        Me.UpdateAllCheck = New System.Windows.Forms.CheckBox
        Me.ProgressText = New System.Windows.Forms.TextBox
        Me.SuspendLayout()
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 12)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(353, 23)
        Me.ProgressBar1.TabIndex = 2
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(310, 95)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(55, 22)
        Me.CncButton.TabIndex = 0
        Me.CncButton.Text = "Go"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'UpdateAllCheck
        '
        Me.UpdateAllCheck.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.UpdateAllCheck.AutoSize = True
        Me.UpdateAllCheck.Location = New System.Drawing.Point(12, 95)
        Me.UpdateAllCheck.Name = "UpdateAllCheck"
        Me.UpdateAllCheck.Size = New System.Drawing.Size(145, 17)
        Me.UpdateAllCheck.TabIndex = 1
        Me.UpdateAllCheck.Text = "Force update ALL names"
        Me.UpdateAllCheck.UseVisualStyleBackColor = True
        '
        'ProgressText
        '
        Me.ProgressText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressText.Location = New System.Drawing.Point(12, 41)
        Me.ProgressText.Multiline = True
        Me.ProgressText.Name = "ProgressText"
        Me.ProgressText.ReadOnly = True
        Me.ProgressText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.ProgressText.Size = New System.Drawing.Size(353, 48)
        Me.ProgressText.TabIndex = 3
        '
        'RefreshNamesForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(377, 124)
        Me.Controls.Add(Me.ProgressText)
        Me.Controls.Add(Me.UpdateAllCheck)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.ProgressBar1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "RefreshNamesForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Refresh Names"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents UpdateAllCheck As System.Windows.Forms.CheckBox
    Friend WithEvents ProgressText As System.Windows.Forms.TextBox
End Class
