<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReportsControl
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
        Me.RunReportButton = New System.Windows.Forms.Button
        Me.ReportBrowser = New System.Windows.Forms.WebBrowser
        Me.ReportCombo = New System.Windows.Forms.ComboBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'RunReportButton
        '
        Me.RunReportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RunReportButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RunReportButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RunReportButton.Location = New System.Drawing.Point(755, 3)
        Me.RunReportButton.Name = "RunReportButton"
        Me.RunReportButton.Size = New System.Drawing.Size(65, 23)
        Me.RunReportButton.TabIndex = 5
        Me.RunReportButton.Text = "Run"
        Me.RunReportButton.UseVisualStyleBackColor = False
        '
        'ReportBrowser
        '
        Me.ReportBrowser.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportBrowser.Location = New System.Drawing.Point(3, 52)
        Me.ReportBrowser.MinimumSize = New System.Drawing.Size(20, 20)
        Me.ReportBrowser.Name = "ReportBrowser"
        Me.ReportBrowser.Size = New System.Drawing.Size(817, 205)
        Me.ReportBrowser.TabIndex = 6
        '
        'ReportCombo
        '
        Me.ReportCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ReportCombo.FormattingEnabled = True
        Me.ReportCombo.Location = New System.Drawing.Point(48, 5)
        Me.ReportCombo.Name = "ReportCombo"
        Me.ReportCombo.Size = New System.Drawing.Size(631, 21)
        Me.ReportCombo.TabIndex = 3
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(3, 8)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(39, 13)
        Me.Label7.TabIndex = 4
        Me.Label7.Text = "Report"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(3, 36)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(39, 13)
        Me.Label1.TabIndex = 7
        Me.Label1.Text = "Output"
        '
        'ReportsControl
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.RunReportButton)
        Me.Controls.Add(Me.ReportBrowser)
        Me.Controls.Add(Me.ReportCombo)
        Me.Controls.Add(Me.Label7)
        Me.Name = "ReportsControl"
        Me.Size = New System.Drawing.Size(823, 260)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents RunReportButton As System.Windows.Forms.Button
    Friend WithEvents ReportBrowser As System.Windows.Forms.WebBrowser
    Friend WithEvents ReportCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label

End Class
