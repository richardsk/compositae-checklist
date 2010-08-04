<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MulitGridControl
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.EditCombo = New System.Windows.Forms.ComboBox
        Me.EditText = New System.Windows.Forms.TextBox
        Me.EditCheckBox = New System.Windows.Forms.CheckBox
        Me.EditDateTimePicker = New System.Windows.Forms.DateTimePicker
        Me.SuspendLayout()
        '
        'EditCombo
        '
        Me.EditCombo.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EditCombo.FormattingEnabled = True
        Me.EditCombo.Location = New System.Drawing.Point(0, 0)
        Me.EditCombo.Name = "EditCombo"
        Me.EditCombo.Size = New System.Drawing.Size(226, 21)
        Me.EditCombo.TabIndex = 0
        '
        'EditText
        '
        Me.EditText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EditText.Location = New System.Drawing.Point(0, 27)
        Me.EditText.Name = "EditText"
        Me.EditText.Size = New System.Drawing.Size(226, 20)
        Me.EditText.TabIndex = 1
        '
        'EditCheckBox
        '
        Me.EditCheckBox.AutoSize = True
        Me.EditCheckBox.Location = New System.Drawing.Point(0, 51)
        Me.EditCheckBox.Name = "EditCheckBox"
        Me.EditCheckBox.Size = New System.Drawing.Size(15, 14)
        Me.EditCheckBox.TabIndex = 2
        Me.EditCheckBox.UseVisualStyleBackColor = True
        '
        'EditDateTimePicker
        '
        Me.EditDateTimePicker.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.EditDateTimePicker.Location = New System.Drawing.Point(0, 70)
        Me.EditDateTimePicker.Name = "EditDateTimePicker"
        Me.EditDateTimePicker.Size = New System.Drawing.Size(226, 20)
        Me.EditDateTimePicker.TabIndex = 3
        '
        'MulitGridControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.EditDateTimePicker)
        Me.Controls.Add(Me.EditCheckBox)
        Me.Controls.Add(Me.EditText)
        Me.Controls.Add(Me.EditCombo)
        Me.Name = "MulitGridControl"
        Me.Size = New System.Drawing.Size(226, 90)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents EditCombo As System.Windows.Forms.ComboBox
    Friend WithEvents EditText As System.Windows.Forms.TextBox
    Friend WithEvents EditCheckBox As System.Windows.Forms.CheckBox
    Friend WithEvents EditDateTimePicker As System.Windows.Forms.DateTimePicker

End Class
