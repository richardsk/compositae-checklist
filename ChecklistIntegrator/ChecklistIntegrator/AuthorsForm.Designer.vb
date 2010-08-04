<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AuthorsForm
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
        Me.SaveButton = New System.Windows.Forms.Button
        Me.CloseButton = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.searchText = New System.Windows.Forms.TextBox
        Me.SearchButton = New System.Windows.Forms.Button
        Me.ResultsGrid = New System.Windows.Forms.DataGridView
        Me.AuthorPk = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Abbreviation = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Forename = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Surname = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CorrectAuthor = New System.Windows.Forms.DataGridViewButtonColumn
        Me.CorrectAuthorFk = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Label2 = New System.Windows.Forms.Label
        Me.AnywhereCheck = New System.Windows.Forms.CheckBox
        Me.ImportButton = New System.Windows.Forms.Button
        Me.saveRefreshButton = New System.Windows.Forms.Button
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'SaveButton
        '
        Me.SaveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SaveButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SaveButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SaveButton.Location = New System.Drawing.Point(474, 572)
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(80, 23)
        Me.SaveButton.TabIndex = 15
        Me.SaveButton.Text = "Save Only"
        Me.SaveButton.UseVisualStyleBackColor = False
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(560, 572)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(80, 23)
        Me.CloseButton.TabIndex = 16
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(27, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Find"
        '
        'searchText
        '
        Me.searchText.Location = New System.Drawing.Point(59, 6)
        Me.searchText.Name = "searchText"
        Me.searchText.Size = New System.Drawing.Size(362, 20)
        Me.searchText.TabIndex = 1
        '
        'SearchButton
        '
        Me.SearchButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SearchButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SearchButton.Location = New System.Drawing.Point(427, 4)
        Me.SearchButton.Name = "SearchButton"
        Me.SearchButton.Size = New System.Drawing.Size(80, 23)
        Me.SearchButton.TabIndex = 13
        Me.SearchButton.Text = "Search"
        Me.SearchButton.UseVisualStyleBackColor = False
        '
        'ResultsGrid
        '
        Me.ResultsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ResultsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.AuthorPk, Me.Abbreviation, Me.Forename, Me.Surname, Me.CorrectAuthor, Me.CorrectAuthorFk})
        Me.ResultsGrid.Location = New System.Drawing.Point(12, 73)
        Me.ResultsGrid.MultiSelect = False
        Me.ResultsGrid.Name = "ResultsGrid"
        Me.ResultsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.CellSelect
        Me.ResultsGrid.Size = New System.Drawing.Size(628, 479)
        Me.ResultsGrid.TabIndex = 14
        '
        'AuthorPk
        '
        Me.AuthorPk.DataPropertyName = "AuthorPk"
        Me.AuthorPk.HeaderText = "Id"
        Me.AuthorPk.Name = "AuthorPk"
        Me.AuthorPk.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        '
        'Abbreviation
        '
        Me.Abbreviation.DataPropertyName = "Abbreviation"
        Me.Abbreviation.HeaderText = "Abbreviation"
        Me.Abbreviation.Name = "Abbreviation"
        '
        'Forename
        '
        Me.Forename.DataPropertyName = "Forename"
        Me.Forename.HeaderText = "Forename"
        Me.Forename.Name = "Forename"
        '
        'Surname
        '
        Me.Surname.DataPropertyName = "Surname"
        Me.Surname.HeaderText = "Surname"
        Me.Surname.Name = "Surname"
        '
        'CorrectAuthor
        '
        Me.CorrectAuthor.DataPropertyName = "CorrectAuthor"
        Me.CorrectAuthor.HeaderText = "Correct Author"
        Me.CorrectAuthor.Name = "CorrectAuthor"
        Me.CorrectAuthor.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        '
        'CorrectAuthorFk
        '
        Me.CorrectAuthorFk.DataPropertyName = "CorrectAuthorFk"
        Me.CorrectAuthorFk.HeaderText = "CorrectAuthorFk"
        Me.CorrectAuthorFk.Name = "CorrectAuthorFk"
        Me.CorrectAuthorFk.Visible = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 57)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(42, 13)
        Me.Label2.TabIndex = 17
        Me.Label2.Text = "Results"
        '
        'AnywhereCheck
        '
        Me.AnywhereCheck.AutoSize = True
        Me.AnywhereCheck.Location = New System.Drawing.Point(59, 32)
        Me.AnywhereCheck.Name = "AnywhereCheck"
        Me.AnywhereCheck.Size = New System.Drawing.Size(104, 17)
        Me.AnywhereCheck.TabIndex = 18
        Me.AnywhereCheck.Text = "Anywhere in text"
        Me.AnywhereCheck.UseVisualStyleBackColor = True
        '
        'ImportButton
        '
        Me.ImportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ImportButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ImportButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ImportButton.Location = New System.Drawing.Point(15, 572)
        Me.ImportButton.Name = "ImportButton"
        Me.ImportButton.Size = New System.Drawing.Size(80, 23)
        Me.ImportButton.TabIndex = 19
        Me.ImportButton.Text = "Import..."
        Me.ImportButton.UseVisualStyleBackColor = False
        '
        'saveRefreshButton
        '
        Me.saveRefreshButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.saveRefreshButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.saveRefreshButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.saveRefreshButton.Location = New System.Drawing.Point(351, 572)
        Me.saveRefreshButton.Name = "saveRefreshButton"
        Me.saveRefreshButton.Size = New System.Drawing.Size(117, 23)
        Me.saveRefreshButton.TabIndex = 20
        Me.saveRefreshButton.Text = "Save and Refresh"
        Me.saveRefreshButton.UseVisualStyleBackColor = False
        '
        'AuthorsForm
        '
        Me.AcceptButton = Me.SearchButton
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(652, 607)
        Me.Controls.Add(Me.saveRefreshButton)
        Me.Controls.Add(Me.ImportButton)
        Me.Controls.Add(Me.AnywhereCheck)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.SaveButton)
        Me.Controls.Add(Me.ResultsGrid)
        Me.Controls.Add(Me.SearchButton)
        Me.Controls.Add(Me.searchText)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "AuthorsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Authors"
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents SaveButton As System.Windows.Forms.Button
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents searchText As System.Windows.Forms.TextBox
    Friend WithEvents SearchButton As System.Windows.Forms.Button
    Friend WithEvents ResultsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents AuthorPk As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Abbreviation As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Forename As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Surname As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CorrectAuthor As System.Windows.Forms.DataGridViewButtonColumn
    Friend WithEvents CorrectAuthorFk As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents AnywhereCheck As System.Windows.Forms.CheckBox
    Friend WithEvents ImportButton As System.Windows.Forms.Button
    Friend WithEvents saveRefreshButton As System.Windows.Forms.Button
End Class
