<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class SelectReferenceForm
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
        Me.SetToNoneButton = New System.Windows.Forms.Button
        Me.ClrButton = New System.Windows.Forms.Button
        Me.CncButton = New System.Windows.Forms.Button
        Me.SelectButton = New System.Windows.Forms.Button
        Me.ReferenceSearch1 = New IntegratorControls.ReferenceSearch
        Me.SuspendLayout()
        '
        'SetToNoneButton
        '
        Me.SetToNoneButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SetToNoneButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SetToNoneButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SetToNoneButton.Location = New System.Drawing.Point(355, 403)
        Me.SetToNoneButton.Name = "SetToNoneButton"
        Me.SetToNoneButton.Size = New System.Drawing.Size(80, 23)
        Me.SetToNoneButton.TabIndex = 1
        Me.SetToNoneButton.Text = "Set to none"
        Me.SetToNoneButton.UseVisualStyleBackColor = False
        '
        'ClrButton
        '
        Me.ClrButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ClrButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ClrButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ClrButton.Location = New System.Drawing.Point(441, 403)
        Me.ClrButton.Name = "ClrButton"
        Me.ClrButton.Size = New System.Drawing.Size(80, 23)
        Me.ClrButton.TabIndex = 2
        Me.ClrButton.Text = "Clear"
        Me.ClrButton.UseVisualStyleBackColor = False
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.Location = New System.Drawing.Point(613, 403)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(80, 23)
        Me.CncButton.TabIndex = 4
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'SelectButton
        '
        Me.SelectButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SelectButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SelectButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SelectButton.Location = New System.Drawing.Point(527, 403)
        Me.SelectButton.Name = "SelectButton"
        Me.SelectButton.Size = New System.Drawing.Size(80, 23)
        Me.SelectButton.TabIndex = 3
        Me.SelectButton.Text = "Select"
        Me.SelectButton.UseVisualStyleBackColor = False
        '
        'ReferenceSearch1
        '
        Me.ReferenceSearch1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReferenceSearch1.Location = New System.Drawing.Point(14, 12)
        Me.ReferenceSearch1.Name = "ReferenceSearch1"
        Me.ReferenceSearch1.Size = New System.Drawing.Size(679, 393)
        Me.ReferenceSearch1.TabIndex = 0
        '
        'SelectReferenceForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(705, 438)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.SelectButton)
        Me.Controls.Add(Me.ClrButton)
        Me.Controls.Add(Me.SetToNoneButton)
        Me.Controls.Add(Me.ReferenceSearch1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "SelectReferenceForm"
        Me.Text = "Select Reference"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents SetToNoneButton As System.Windows.Forms.Button
    Friend WithEvents ClrButton As System.Windows.Forms.Button
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents SelectButton As System.Windows.Forms.Button
    Friend WithEvents ReferenceSearch1 As IntegratorControls.ReferenceSearch
End Class
