<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class NameDetailsForm
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
        Me.DetailsGrid = New C1.Win.C1FlexGrid.C1FlexGrid
        Me.CncButton = New System.Windows.Forms.Button
        CType(Me.DetailsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'DetailsGrid
        '
        Me.DetailsGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.DetailsGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.DetailsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DetailsGrid.ColumnInfo = "0,0,0,0,0,85,Columns:"
        Me.DetailsGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.DetailsGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.DetailsGrid.Location = New System.Drawing.Point(12, 12)
        Me.DetailsGrid.Name = "DetailsGrid"
        Me.DetailsGrid.Rows.Count = 1
        Me.DetailsGrid.Rows.DefaultSize = 17
        Me.DetailsGrid.Size = New System.Drawing.Size(473, 537)
        Me.DetailsGrid.TabIndex = 18
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(422, 555)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(63, 22)
        Me.CncButton.TabIndex = 21
        Me.CncButton.Text = "Close"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'NameDetailsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(497, 589)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.DetailsGrid)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "NameDetailsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Name Details"
        CType(Me.DetailsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents DetailsGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents CncButton As System.Windows.Forms.Button
End Class
