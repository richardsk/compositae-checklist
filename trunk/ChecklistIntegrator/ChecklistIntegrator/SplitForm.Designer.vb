<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SplitForm
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
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.DiscardRadio = New System.Windows.Forms.RadioButton
        Me.UnlinkRadio = New System.Windows.Forms.RadioButton
        Me.SelectRadio = New System.Windows.Forms.RadioButton
        Me.CreateRadio = New System.Windows.Forms.RadioButton
        Me.CncButton = New System.Windows.Forms.Button
        Me.OkButton = New System.Windows.Forms.Button
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.DiscardRadio)
        Me.GroupBox1.Controls.Add(Me.UnlinkRadio)
        Me.GroupBox1.Controls.Add(Me.SelectRadio)
        Me.GroupBox1.Controls.Add(Me.CreateRadio)
        Me.GroupBox1.Location = New System.Drawing.Point(12, 12)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(268, 131)
        Me.GroupBox1.TabIndex = 0
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Split by"
        '
        'DiscardRadio
        '
        Me.DiscardRadio.AutoSize = True
        Me.DiscardRadio.Location = New System.Drawing.Point(16, 88)
        Me.DiscardRadio.Name = "DiscardRadio"
        Me.DiscardRadio.Size = New System.Drawing.Size(135, 17)
        Me.DiscardRadio.TabIndex = 3
        Me.DiscardRadio.TabStop = True
        Me.DiscardRadio.Text = "Discard provider record"
        Me.DiscardRadio.UseVisualStyleBackColor = True
        '
        'UnlinkRadio
        '
        Me.UnlinkRadio.AutoSize = True
        Me.UnlinkRadio.Location = New System.Drawing.Point(16, 65)
        Me.UnlinkRadio.Name = "UnlinkRadio"
        Me.UnlinkRadio.Size = New System.Drawing.Size(132, 17)
        Me.UnlinkRadio.TabIndex = 2
        Me.UnlinkRadio.TabStop = True
        Me.UnlinkRadio.Text = "Un-link provider record"
        Me.UnlinkRadio.UseVisualStyleBackColor = True
        '
        'SelectRadio
        '
        Me.SelectRadio.AutoSize = True
        Me.SelectRadio.Location = New System.Drawing.Point(16, 42)
        Me.SelectRadio.Name = "SelectRadio"
        Me.SelectRadio.Size = New System.Drawing.Size(143, 17)
        Me.SelectRadio.TabIndex = 1
        Me.SelectRadio.TabStop = True
        Me.SelectRadio.Text = "Link to an existing record"
        Me.SelectRadio.UseVisualStyleBackColor = True
        '
        'CreateRadio
        '
        Me.CreateRadio.AutoSize = True
        Me.CreateRadio.Location = New System.Drawing.Point(16, 19)
        Me.CreateRadio.Name = "CreateRadio"
        Me.CreateRadio.Size = New System.Drawing.Size(121, 17)
        Me.CreateRadio.TabIndex = 0
        Me.CreateRadio.TabStop = True
        Me.CreateRadio.Text = "Create a new record"
        Me.CreateRadio.UseVisualStyleBackColor = True
        '
        'CncButton
        '
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.Location = New System.Drawing.Point(192, 157)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(88, 23)
        Me.CncButton.TabIndex = 2
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'OkButton
        '
        Me.OkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.OkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.OkButton.Location = New System.Drawing.Point(98, 157)
        Me.OkButton.Name = "OkButton"
        Me.OkButton.Size = New System.Drawing.Size(88, 23)
        Me.OkButton.TabIndex = 1
        Me.OkButton.Text = "OK"
        Me.OkButton.UseVisualStyleBackColor = False
        '
        'SplitForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(292, 192)
        Me.Controls.Add(Me.OkButton)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.GroupBox1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "SplitForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Split Record"
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents CreateRadio As System.Windows.Forms.RadioButton
    Friend WithEvents UnlinkRadio As System.Windows.Forms.RadioButton
    Friend WithEvents SelectRadio As System.Windows.Forms.RadioButton
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents OkButton As System.Windows.Forms.Button
    Friend WithEvents DiscardRadio As System.Windows.Forms.RadioButton
End Class
