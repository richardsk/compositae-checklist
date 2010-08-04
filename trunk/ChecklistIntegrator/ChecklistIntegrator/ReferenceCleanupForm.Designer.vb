<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReferenceCleanupForm
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
        Me.Label1 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.AutoThresholdText = New System.Windows.Forms.TextBox
        Me.DontMergeText = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.Label4 = New System.Windows.Forms.Label
        Me.NameText = New System.Windows.Forms.TextBox
        Me.GoButton = New System.Windows.Forms.Button
        Me.LevenWordPercText = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CloseButton.Location = New System.Drawing.Point(327, 251)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(63, 22)
        Me.CloseButton.TabIndex = 6
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(9, 110)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(62, 13)
        Me.Label1.TabIndex = 27
        Me.Label1.Text = "Thresholds:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(9, 132)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(206, 13)
        Me.Label2.TabIndex = 28
        Me.Label2.Text = "Auto merge refernces with match % above"
        '
        'AutoThresholdText
        '
        Me.AutoThresholdText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AutoThresholdText.Location = New System.Drawing.Point(276, 129)
        Me.AutoThresholdText.Name = "AutoThresholdText"
        Me.AutoThresholdText.Size = New System.Drawing.Size(111, 20)
        Me.AutoThresholdText.TabIndex = 2
        Me.AutoThresholdText.Text = "90"
        '
        'DontMergeText
        '
        Me.DontMergeText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DontMergeText.Location = New System.Drawing.Point(276, 155)
        Me.DontMergeText.Name = "DontMergeText"
        Me.DontMergeText.Size = New System.Drawing.Size(111, 20)
        Me.DontMergeText.TabIndex = 3
        Me.DontMergeText.Text = "45"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(9, 158)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(158, 13)
        Me.Label3.TabIndex = 30
        Me.Label3.Text = "Dont merge with match % below"
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 214)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(378, 23)
        Me.ProgressBar1.TabIndex = 5
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 9)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(154, 13)
        Me.Label4.TabIndex = 33
        Me.Label4.Text = "Check references below name:"
        '
        'NameText
        '
        Me.NameText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameText.Location = New System.Drawing.Point(12, 25)
        Me.NameText.Multiline = True
        Me.NameText.Name = "NameText"
        Me.NameText.ReadOnly = True
        Me.NameText.Size = New System.Drawing.Size(378, 34)
        Me.NameText.TabIndex = 0
        Me.NameText.TabStop = False
        '
        'GoButton
        '
        Me.GoButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GoButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.GoButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.GoButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.GoButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.GoButton.Location = New System.Drawing.Point(15, 186)
        Me.GoButton.Name = "GoButton"
        Me.GoButton.Size = New System.Drawing.Size(63, 22)
        Me.GoButton.TabIndex = 4
        Me.GoButton.Text = "Go"
        Me.GoButton.UseVisualStyleBackColor = False
        '
        'LevenWordPercText
        '
        Me.LevenWordPercText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LevenWordPercText.Location = New System.Drawing.Point(276, 75)
        Me.LevenWordPercText.Name = "LevenWordPercText"
        Me.LevenWordPercText.Size = New System.Drawing.Size(111, 20)
        Me.LevenWordPercText.TabIndex = 1
        Me.LevenWordPercText.Text = "80"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(9, 78)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(162, 13)
        Me.Label5.TabIndex = 35
        Me.Label5.Text = "Levenshtein word match percent"
        '
        'ReferenceCleanupForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(402, 285)
        Me.Controls.Add(Me.LevenWordPercText)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.GoButton)
        Me.Controls.Add(Me.NameText)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Controls.Add(Me.DontMergeText)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.AutoThresholdText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.CloseButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ReferenceCleanupForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Reference Deduplication"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents AutoThresholdText As System.Windows.Forms.TextBox
    Friend WithEvents DontMergeText As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents NameText As System.Windows.Forms.TextBox
    Friend WithEvents GoButton As System.Windows.Forms.Button
    Friend WithEvents LevenWordPercText As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
End Class
