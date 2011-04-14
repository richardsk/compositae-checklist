Imports IntegratorControls
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class IntegratorForm
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
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(IntegratorForm))
        Dim DataGridViewCellStyle1 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle2 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle3 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle4 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle5 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle6 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle7 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle8 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle9 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle10 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle11 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle12 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle13 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle14 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Dim DataGridViewCellStyle15 As System.Windows.Forms.DataGridViewCellStyle = New System.Windows.Forms.DataGridViewCellStyle()
        Me.ExitButton = New System.Windows.Forms.Button()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.TabControl1 = New System.Windows.Forms.TabControl()
        Me.TabPageNames = New System.Windows.Forms.TabPage()
        Me.NewNameButton = New System.Windows.Forms.Button()
        Me.MergeMultipleButton = New System.Windows.Forms.Button()
        Me.LinkButton = New System.Windows.Forms.Button()
        Me.MergeButton = New System.Windows.Forms.Button()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.DocumentContainer6 = New TD.SandDock.DocumentContainer()
        Me.SearchDockControl = New TD.SandDock.DockControl()
        Me.RefreshTreeLink = New System.Windows.Forms.LinkLabel()
        Me.NameSelector1 = New IntegratorControls.NameSelector()
        Me.NameDetailsDockControl = New TD.SandDock.DockControl()
        Me.RefreshChildrenLink = New System.Windows.Forms.LinkLabel()
        Me.RefreshNameLink = New System.Windows.Forms.LinkLabel()
        Me.BackButton = New System.Windows.Forms.Button()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.BrowseButton = New System.Windows.Forms.Button()
        Me.EditButton = New System.Windows.Forms.Button()
        Me.NameDetailsGrid = New C1.Win.C1FlexGrid.C1FlexGrid()
        Me.NamesHideBlankFields = New System.Windows.Forms.CheckBox()
        Me.ProvNameDockControl = New TD.SandDock.DockControl()
        Me.ProviderNameGrid = New System.Windows.Forms.DataGridView()
        Me.Split = New System.Windows.Forms.DataGridViewLinkColumn()
        Me.View = New System.Windows.Forms.DataGridViewLinkColumn()
        Me.ConceptsDockControl = New TD.SandDock.DockControl()
        Me.ConceptsGrid = New C1.Win.C1FlexGrid.C1FlexGrid()
        Me.ProvConceptsDockControl = New TD.SandDock.DockControl()
        Me.ProvConceptGrid = New System.Windows.Forms.DataGridView()
        Me.OtherDataDockControl = New TD.SandDock.DockControl()
        Me.OtherDataGrid = New System.Windows.Forms.DataGridView()
        Me.ReportsDockControl = New TD.SandDock.DockControl()
        Me.ReportsControlOnNames = New IntegratorControls.ReportsControl()
        Me.TabPageReferences = New System.Windows.Forms.TabPage()
        Me.NewRefButton = New System.Windows.Forms.Button()
        Me.RefLinkButton = New System.Windows.Forms.Button()
        Me.RefMergeButton = New System.Windows.Forms.Button()
        Me.Panel2 = New System.Windows.Forms.Panel()
        Me.DocumentContainer5 = New TD.SandDock.DocumentContainer()
        Me.SelectorDockControl = New TD.SandDock.DockControl()
        Me.ReferenceSearch1 = New IntegratorControls.ReferenceSearch()
        Me.RefDetailsDockControl = New TD.SandDock.DockControl()
        Me.RefRefLink = New System.Windows.Forms.LinkLabel()
        Me.RefNamesInRefLink = New System.Windows.Forms.LinkLabel()
        Me.FullCitationText = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.RefDetailsGrid = New C1.Win.C1FlexGrid.C1FlexGrid()
        Me.RefLSIDText = New System.Windows.Forms.TextBox()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.RefCitationText = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.RefBrowseButton = New System.Windows.Forms.Button()
        Me.RefEditButton = New System.Windows.Forms.Button()
        Me.RefHideBlankFields = New System.Windows.Forms.CheckBox()
        Me.ProviderRISDockControl = New TD.SandDock.DockControl()
        Me.ProviderRISGrid = New System.Windows.Forms.DataGridView()
        Me.ProviderRefDockControl = New TD.SandDock.DockControl()
        Me.RefProviderGrid = New System.Windows.Forms.DataGridView()
        Me.DataGridViewLinkColumn1 = New System.Windows.Forms.DataGridViewLinkColumn()
        Me.TabPageOtherData = New System.Windows.Forms.TabPage()
        Me.OtherDataCtrl1 = New IntegratorControls.OtherDataCtrl()
        Me.TabPageProviders = New System.Windows.Forms.TabPage()
        Me.ProvRefButton = New System.Windows.Forms.Button()
        Me.ViewProvNamesButton = New System.Windows.Forms.Button()
        Me.EditProviderButton = New System.Windows.Forms.Button()
        Me.AddProviderButton = New System.Windows.Forms.Button()
        Me.ProvidersGrid = New System.Windows.Forms.DataGridView()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.TabPageReports = New System.Windows.Forms.TabPage()
        Me.ReportsControl1 = New IntegratorControls.ReportsControl()
        Me.SaveButton = New System.Windows.Forms.Button()
        Me.SandDockManager1 = New TD.SandDock.SandDockManager()
        Me.MenuStrip1 = New System.Windows.Forms.MenuStrip()
        Me.FileMenuItem1 = New System.Windows.Forms.ToolStripMenuItem()
        Me.SaveEditsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ImportToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ImportMergeFileToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ImportAnnotationsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExportDatabaseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AboutToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ExitToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.EditToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.AuthorsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ViewLogMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RunIntegrationToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ViewLogToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CleanDatabaseToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.RefreshAllNamesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeduplicateChildrenToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.DeduplicateReferencesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MoveChildrenOfSelectedToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MergeUnknownNamesToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.MoveNamesWithDiffPrefParentToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CncButton = New System.Windows.Forms.Button()
        Me.DataGridViewLinkColumn2 = New System.Windows.Forms.DataGridViewLinkColumn()
        Me.saveWithAttButton = New System.Windows.Forms.Button()
        Me.ProcessAutonymsToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.TabControl1.SuspendLayout()
        Me.TabPageNames.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.DocumentContainer6.SuspendLayout()
        Me.SearchDockControl.SuspendLayout()
        Me.NameDetailsDockControl.SuspendLayout()
        CType(Me.NameDetailsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ProvNameDockControl.SuspendLayout()
        CType(Me.ProviderNameGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ConceptsDockControl.SuspendLayout()
        CType(Me.ConceptsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ProvConceptsDockControl.SuspendLayout()
        CType(Me.ProvConceptGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.OtherDataDockControl.SuspendLayout()
        CType(Me.OtherDataGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ReportsDockControl.SuspendLayout()
        Me.TabPageReferences.SuspendLayout()
        Me.Panel2.SuspendLayout()
        Me.DocumentContainer5.SuspendLayout()
        Me.SelectorDockControl.SuspendLayout()
        Me.RefDetailsDockControl.SuspendLayout()
        CType(Me.RefDetailsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ProviderRISDockControl.SuspendLayout()
        CType(Me.ProviderRISGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.ProviderRefDockControl.SuspendLayout()
        CType(Me.RefProviderGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPageOtherData.SuspendLayout()
        Me.TabPageProviders.SuspendLayout()
        CType(Me.ProvidersGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TabPageReports.SuspendLayout()
        Me.MenuStrip1.SuspendLayout()
        Me.SuspendLayout()
        '
        'ExitButton
        '
        Me.ExitButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ExitButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ExitButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ExitButton.Location = New System.Drawing.Point(926, 725)
        Me.ExitButton.Name = "ExitButton"
        Me.ExitButton.Size = New System.Drawing.Size(88, 23)
        Me.ExitButton.TabIndex = 3
        Me.ExitButton.Text = "Exit"
        Me.ExitButton.UseVisualStyleBackColor = False
        '
        'Label3
        '
        Me.Label3.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(307, 1056)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(42, 13)
        Me.Label3.TabIndex = 8
        Me.Label3.Text = "Hybrids"
        '
        'TabControl1
        '
        Me.TabControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TabControl1.Controls.Add(Me.TabPageNames)
        Me.TabControl1.Controls.Add(Me.TabPageReferences)
        Me.TabControl1.Controls.Add(Me.TabPageOtherData)
        Me.TabControl1.Controls.Add(Me.TabPageProviders)
        Me.TabControl1.Controls.Add(Me.TabPageReports)
        Me.TabControl1.Location = New System.Drawing.Point(3, 27)
        Me.TabControl1.Name = "TabControl1"
        Me.TabControl1.SelectedIndex = 0
        Me.TabControl1.Size = New System.Drawing.Size(1011, 691)
        Me.TabControl1.TabIndex = 0
        '
        'TabPageNames
        '
        Me.TabPageNames.Controls.Add(Me.NewNameButton)
        Me.TabPageNames.Controls.Add(Me.MergeMultipleButton)
        Me.TabPageNames.Controls.Add(Me.LinkButton)
        Me.TabPageNames.Controls.Add(Me.MergeButton)
        Me.TabPageNames.Controls.Add(Me.Panel1)
        Me.TabPageNames.Controls.Add(Me.Label3)
        Me.TabPageNames.Location = New System.Drawing.Point(4, 22)
        Me.TabPageNames.Name = "TabPageNames"
        Me.TabPageNames.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPageNames.Size = New System.Drawing.Size(1003, 665)
        Me.TabPageNames.TabIndex = 0
        Me.TabPageNames.Text = "Names"
        Me.TabPageNames.UseVisualStyleBackColor = True
        '
        'NewNameButton
        '
        Me.NewNameButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.NewNameButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.NewNameButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.NewNameButton.Location = New System.Drawing.Point(244, 638)
        Me.NewNameButton.Name = "NewNameButton"
        Me.NewNameButton.Size = New System.Drawing.Size(88, 23)
        Me.NewNameButton.TabIndex = 2
        Me.NewNameButton.Text = "New Name"
        Me.NewNameButton.UseVisualStyleBackColor = False
        '
        'MergeMultipleButton
        '
        Me.MergeMultipleButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.MergeMultipleButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.MergeMultipleButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.MergeMultipleButton.Location = New System.Drawing.Point(99, 638)
        Me.MergeMultipleButton.Name = "MergeMultipleButton"
        Me.MergeMultipleButton.Size = New System.Drawing.Size(139, 23)
        Me.MergeMultipleButton.TabIndex = 1
        Me.MergeMultipleButton.Text = "Merge Multiple Names"
        Me.MergeMultipleButton.UseVisualStyleBackColor = False
        '
        'LinkButton
        '
        Me.LinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.LinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LinkButton.Location = New System.Drawing.Point(383, 638)
        Me.LinkButton.Name = "LinkButton"
        Me.LinkButton.Size = New System.Drawing.Size(179, 23)
        Me.LinkButton.TabIndex = 3
        Me.LinkButton.Text = "Link Other Provider Names"
        Me.LinkButton.UseVisualStyleBackColor = False
        '
        'MergeButton
        '
        Me.MergeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.MergeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.MergeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.MergeButton.Location = New System.Drawing.Point(5, 638)
        Me.MergeButton.Name = "MergeButton"
        Me.MergeButton.Size = New System.Drawing.Size(88, 23)
        Me.MergeButton.TabIndex = 0
        Me.MergeButton.Text = "Merge Name"
        Me.MergeButton.UseVisualStyleBackColor = False
        '
        'Panel1
        '
        Me.Panel1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel1.Controls.Add(Me.DocumentContainer6)
        Me.Panel1.Location = New System.Drawing.Point(1, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(1000, 635)
        Me.Panel1.TabIndex = 25
        '
        'DocumentContainer6
        '
        Me.DocumentContainer6.Controls.Add(Me.SearchDockControl)
        Me.DocumentContainer6.Controls.Add(Me.NameDetailsDockControl)
        Me.DocumentContainer6.Controls.Add(Me.ProvNameDockControl)
        Me.DocumentContainer6.Controls.Add(Me.ConceptsDockControl)
        Me.DocumentContainer6.Controls.Add(Me.ProvConceptsDockControl)
        Me.DocumentContainer6.Controls.Add(Me.OtherDataDockControl)
        Me.DocumentContainer6.Controls.Add(Me.ReportsDockControl)
        Me.DocumentContainer6.DockingManager = TD.SandDock.DockingManager.Whidbey
        Me.DocumentContainer6.Guid = New System.Guid("e50f2267-a98a-4ac3-a70f-8ad9cf166364")
        Me.DocumentContainer6.LayoutSystem = New TD.SandDock.SplitLayoutSystem(250, 400, System.Windows.Forms.Orientation.Horizontal, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.SplitLayoutSystem(998, 633, System.Windows.Forms.Orientation.Vertical, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.DocumentLayoutSystem(265, 633, New TD.SandDock.DockControl() {Me.SearchDockControl}, Me.SearchDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.SplitLayoutSystem(728, 633, System.Windows.Forms.Orientation.Horizontal, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.DocumentLayoutSystem(729, 289, New TD.SandDock.DockControl() {Me.NameDetailsDockControl}, Me.NameDetailsDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.DocumentLayoutSystem(729, 105, New TD.SandDock.DockControl() {Me.ProvNameDockControl}, Me.ProvNameDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.DocumentLayoutSystem(729, 107, New TD.SandDock.DockControl() {Me.ConceptsDockControl}, Me.ConceptsDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.DocumentLayoutSystem(729, 118, New TD.SandDock.DockControl() {Me.ProvConceptsDockControl, Me.OtherDataDockControl, Me.ReportsDockControl}, Me.OtherDataDockControl), TD.SandDock.LayoutSystemBase)}), TD.SandDock.LayoutSystemBase)}), TD.SandDock.LayoutSystemBase)})
        Me.DocumentContainer6.Location = New System.Drawing.Point(0, 0)
        Me.DocumentContainer6.Manager = Nothing
        Me.DocumentContainer6.Name = "DocumentContainer6"
        Me.DocumentContainer6.Size = New System.Drawing.Size(1000, 635)
        Me.DocumentContainer6.TabIndex = 0
        '
        'SearchDockControl
        '
        Me.SearchDockControl.Closable = False
        Me.SearchDockControl.Controls.Add(Me.RefreshTreeLink)
        Me.SearchDockControl.Controls.Add(Me.NameSelector1)
        Me.SearchDockControl.Guid = New System.Guid("b4d23f62-4bc7-4ab3-8db1-a1e3b62dee5e")
        Me.SearchDockControl.Location = New System.Drawing.Point(3, 23)
        Me.SearchDockControl.Name = "SearchDockControl"
        Me.SearchDockControl.Size = New System.Drawing.Size(261, 609)
        Me.SearchDockControl.TabIndex = 0
        Me.SearchDockControl.Text = "Select Name (F3)"
        '
        'RefreshTreeLink
        '
        Me.RefreshTreeLink.AutoSize = True
        Me.RefreshTreeLink.Location = New System.Drawing.Point(0, 0)
        Me.RefreshTreeLink.Name = "RefreshTreeLink"
        Me.RefreshTreeLink.Size = New System.Drawing.Size(65, 13)
        Me.RefreshTreeLink.TabIndex = 17
        Me.RefreshTreeLink.TabStop = True
        Me.RefreshTreeLink.Text = "Refresh tree"
        '
        'NameSelector1
        '
        Me.NameSelector1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameSelector1.DragEnabled = False
        Me.NameSelector1.DropEnable = False
        Me.NameSelector1.HistoryName = Nothing
        Me.NameSelector1.HistoryVisible = False
        Me.NameSelector1.Location = New System.Drawing.Point(0, 16)
        Me.NameSelector1.MergeKey = Nothing
        Me.NameSelector1.Name = "NameSelector1"
        Me.NameSelector1.Size = New System.Drawing.Size(261, 593)
        Me.NameSelector1.TabIndex = 16
        '
        'NameDetailsDockControl
        '
        Me.NameDetailsDockControl.Closable = False
        Me.NameDetailsDockControl.Controls.Add(Me.RefreshChildrenLink)
        Me.NameDetailsDockControl.Controls.Add(Me.RefreshNameLink)
        Me.NameDetailsDockControl.Controls.Add(Me.BackButton)
        Me.NameDetailsDockControl.Controls.Add(Me.Label4)
        Me.NameDetailsDockControl.Controls.Add(Me.BrowseButton)
        Me.NameDetailsDockControl.Controls.Add(Me.EditButton)
        Me.NameDetailsDockControl.Controls.Add(Me.NameDetailsGrid)
        Me.NameDetailsDockControl.Controls.Add(Me.NamesHideBlankFields)
        Me.NameDetailsDockControl.Guid = New System.Guid("9443c40c-a5b0-46ee-befa-ca97d36c88d3")
        Me.NameDetailsDockControl.Location = New System.Drawing.Point(272, 23)
        Me.NameDetailsDockControl.Name = "NameDetailsDockControl"
        Me.NameDetailsDockControl.Size = New System.Drawing.Size(725, 266)
        Me.NameDetailsDockControl.TabIndex = 1
        Me.NameDetailsDockControl.Text = "Name Details (F4)"
        '
        'RefreshChildrenLink
        '
        Me.RefreshChildrenLink.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefreshChildrenLink.AutoSize = True
        Me.RefreshChildrenLink.Location = New System.Drawing.Point(292, 4)
        Me.RefreshChildrenLink.Name = "RefreshChildrenLink"
        Me.RefreshChildrenLink.Size = New System.Drawing.Size(106, 13)
        Me.RefreshChildrenLink.TabIndex = 23
        Me.RefreshChildrenLink.TabStop = True
        Me.RefreshChildrenLink.Text = "Refresh Child Names"
        '
        'RefreshNameLink
        '
        Me.RefreshNameLink.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefreshNameLink.AutoSize = True
        Me.RefreshNameLink.Location = New System.Drawing.Point(413, 4)
        Me.RefreshNameLink.Name = "RefreshNameLink"
        Me.RefreshNameLink.Size = New System.Drawing.Size(75, 13)
        Me.RefreshNameLink.TabIndex = 22
        Me.RefreshNameLink.TabStop = True
        Me.RefreshNameLink.Text = "Refresh Name"
        '
        'BackButton
        '
        Me.BackButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.BackButton.Image = CType(resources.GetObject("BackButton.Image"), System.Drawing.Image)
        Me.BackButton.Location = New System.Drawing.Point(4, 3)
        Me.BackButton.Name = "BackButton"
        Me.BackButton.Size = New System.Drawing.Size(42, 22)
        Me.BackButton.TabIndex = 21
        Me.BackButton.UseVisualStyleBackColor = True
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(55, 8)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(54, 13)
        Me.Label4.TabIndex = 20
        Me.Label4.Text = "Edit mode"
        '
        'BrowseButton
        '
        Me.BrowseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.BrowseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.BrowseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.BrowseButton.Location = New System.Drawing.Point(155, 3)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(55, 22)
        Me.BrowseButton.TabIndex = 19
        Me.BrowseButton.Text = "&Browse"
        Me.BrowseButton.UseVisualStyleBackColor = False
        '
        'EditButton
        '
        Me.EditButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.EditButton.ForeColor = System.Drawing.SystemColors.ControlDark
        Me.EditButton.Location = New System.Drawing.Point(110, 3)
        Me.EditButton.Name = "EditButton"
        Me.EditButton.Size = New System.Drawing.Size(46, 22)
        Me.EditButton.TabIndex = 18
        Me.EditButton.Text = "&Edit"
        Me.EditButton.UseVisualStyleBackColor = True
        '
        'NameDetailsGrid
        '
        Me.NameDetailsGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.NameDetailsGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.NameDetailsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameDetailsGrid.ColumnInfo = "1,1,0,0,0,85,Columns:"
        Me.NameDetailsGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.NameDetailsGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.NameDetailsGrid.Location = New System.Drawing.Point(3, 26)
        Me.NameDetailsGrid.Name = "NameDetailsGrid"
        Me.NameDetailsGrid.Rows.Count = 1
        Me.NameDetailsGrid.Rows.DefaultSize = 17
        Me.NameDetailsGrid.Size = New System.Drawing.Size(719, 239)
        Me.NameDetailsGrid.TabIndex = 17
        '
        'NamesHideBlankFields
        '
        Me.NamesHideBlankFields.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NamesHideBlankFields.AutoSize = True
        Me.NamesHideBlankFields.Location = New System.Drawing.Point(501, 3)
        Me.NamesHideBlankFields.Name = "NamesHideBlankFields"
        Me.NamesHideBlankFields.Size = New System.Drawing.Size(104, 17)
        Me.NamesHideBlankFields.TabIndex = 16
        Me.NamesHideBlankFields.Text = "Hide blank fields"
        Me.NamesHideBlankFields.UseVisualStyleBackColor = True
        '
        'ProvNameDockControl
        '
        Me.ProvNameDockControl.Closable = False
        Me.ProvNameDockControl.Controls.Add(Me.ProviderNameGrid)
        Me.ProvNameDockControl.Guid = New System.Guid("70b9f3a0-2bd3-4cf8-8040-0f5f46244533")
        Me.ProvNameDockControl.Location = New System.Drawing.Point(272, 317)
        Me.ProvNameDockControl.Name = "ProvNameDockControl"
        Me.ProvNameDockControl.Size = New System.Drawing.Size(725, 81)
        Me.ProvNameDockControl.TabIndex = 3
        Me.ProvNameDockControl.Text = "Provider Name Records (F5)"
        '
        'ProviderNameGrid
        '
        Me.ProviderNameGrid.AllowUserToAddRows = False
        Me.ProviderNameGrid.AllowUserToDeleteRows = False
        Me.ProviderNameGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle1.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle1.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle1.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProviderNameGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle1
        Me.ProviderNameGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ProviderNameGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.Split, Me.View})
        DataGridViewCellStyle2.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle2.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle2.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle2.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle2.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle2.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle2.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ProviderNameGrid.DefaultCellStyle = DataGridViewCellStyle2
        Me.ProviderNameGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ProviderNameGrid.Location = New System.Drawing.Point(0, 0)
        Me.ProviderNameGrid.MultiSelect = False
        Me.ProviderNameGrid.Name = "ProviderNameGrid"
        Me.ProviderNameGrid.ReadOnly = True
        DataGridViewCellStyle3.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle3.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle3.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle3.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle3.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle3.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle3.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProviderNameGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle3
        Me.ProviderNameGrid.RowHeadersVisible = False
        Me.ProviderNameGrid.Size = New System.Drawing.Size(725, 81)
        Me.ProviderNameGrid.TabIndex = 20
        '
        'Split
        '
        Me.Split.HeaderText = "Split"
        Me.Split.Name = "Split"
        Me.Split.ReadOnly = True
        Me.Split.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.Split.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.Split.Text = "Split"
        Me.Split.TrackVisitedState = False
        Me.Split.UseColumnTextForLinkValue = True
        '
        'View
        '
        Me.View.HeaderText = "Details"
        Me.View.Name = "View"
        Me.View.ReadOnly = True
        Me.View.Text = "View"
        Me.View.UseColumnTextForLinkValue = True
        '
        'ConceptsDockControl
        '
        Me.ConceptsDockControl.Closable = False
        Me.ConceptsDockControl.Controls.Add(Me.ConceptsGrid)
        Me.ConceptsDockControl.Guid = New System.Guid("1c9bb48a-351a-4341-8fdd-3a6e8c830b9b")
        Me.ConceptsDockControl.Location = New System.Drawing.Point(272, 426)
        Me.ConceptsDockControl.Name = "ConceptsDockControl"
        Me.ConceptsDockControl.Size = New System.Drawing.Size(725, 83)
        Me.ConceptsDockControl.TabIndex = 2
        Me.ConceptsDockControl.Text = "Concepts (F6)"
        '
        'ConceptsGrid
        '
        Me.ConceptsGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.ConceptsGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.ConceptsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ConceptsGrid.ColumnInfo = "1,1,0,0,0,85,Columns:"
        Me.ConceptsGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.ConceptsGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.ConceptsGrid.Location = New System.Drawing.Point(0, 0)
        Me.ConceptsGrid.Name = "ConceptsGrid"
        Me.ConceptsGrid.Rows.Count = 1
        Me.ConceptsGrid.Rows.DefaultSize = 17
        Me.ConceptsGrid.Size = New System.Drawing.Size(727, 83)
        Me.ConceptsGrid.TabIndex = 18
        '
        'ProvConceptsDockControl
        '
        Me.ProvConceptsDockControl.Controls.Add(Me.ProvConceptGrid)
        Me.ProvConceptsDockControl.Guid = New System.Guid("da78eefd-5037-48e1-94d9-78bebbcc05bf")
        Me.ProvConceptsDockControl.Location = New System.Drawing.Point(272, 540)
        Me.ProvConceptsDockControl.Name = "ProvConceptsDockControl"
        Me.ProvConceptsDockControl.Size = New System.Drawing.Size(725, 96)
        Me.ProvConceptsDockControl.TabIndex = 4
        Me.ProvConceptsDockControl.Text = "Provider Concept Records (F7)"
        '
        'ProvConceptGrid
        '
        Me.ProvConceptGrid.AllowUserToAddRows = False
        Me.ProvConceptGrid.AllowUserToDeleteRows = False
        Me.ProvConceptGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle4.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle4.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle4.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle4.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle4.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle4.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle4.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProvConceptGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle4
        Me.ProvConceptGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        DataGridViewCellStyle5.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle5.BackColor = System.Drawing.Color.Gainsboro
        DataGridViewCellStyle5.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle5.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle5.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle5.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle5.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ProvConceptGrid.DefaultCellStyle = DataGridViewCellStyle5
        Me.ProvConceptGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ProvConceptGrid.Location = New System.Drawing.Point(0, 0)
        Me.ProvConceptGrid.MultiSelect = False
        Me.ProvConceptGrid.Name = "ProvConceptGrid"
        Me.ProvConceptGrid.ReadOnly = True
        DataGridViewCellStyle6.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle6.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle6.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle6.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle6.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle6.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle6.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProvConceptGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle6
        Me.ProvConceptGrid.RowHeadersVisible = False
        Me.ProvConceptGrid.Size = New System.Drawing.Size(725, 96)
        Me.ProvConceptGrid.TabIndex = 21
        '
        'OtherDataDockControl
        '
        Me.OtherDataDockControl.Controls.Add(Me.OtherDataGrid)
        Me.OtherDataDockControl.Guid = New System.Guid("adf19f28-caf2-47ba-90c0-5393ef0c847d")
        Me.OtherDataDockControl.Location = New System.Drawing.Point(272, 537)
        Me.OtherDataDockControl.Name = "OtherDataDockControl"
        Me.OtherDataDockControl.Size = New System.Drawing.Size(725, 95)
        Me.OtherDataDockControl.TabIndex = 5
        Me.OtherDataDockControl.Text = "Provider Other Data"
        '
        'OtherDataGrid
        '
        Me.OtherDataGrid.AllowUserToAddRows = False
        Me.OtherDataGrid.AllowUserToDeleteRows = False
        Me.OtherDataGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle7.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle7.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle7.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle7.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.OtherDataGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle7
        Me.OtherDataGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        DataGridViewCellStyle8.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle8.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle8.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle8.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle8.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle8.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle8.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.OtherDataGrid.DefaultCellStyle = DataGridViewCellStyle8
        Me.OtherDataGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.OtherDataGrid.Location = New System.Drawing.Point(0, 0)
        Me.OtherDataGrid.MultiSelect = False
        Me.OtherDataGrid.Name = "OtherDataGrid"
        DataGridViewCellStyle9.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle9.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle9.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle9.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle9.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle9.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle9.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.OtherDataGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle9
        Me.OtherDataGrid.RowHeadersVisible = False
        Me.OtherDataGrid.Size = New System.Drawing.Size(725, 95)
        Me.OtherDataGrid.TabIndex = 21
        '
        'ReportsDockControl
        '
        Me.ReportsDockControl.Controls.Add(Me.ReportsControlOnNames)
        Me.ReportsDockControl.Guid = New System.Guid("afdcee02-0c9c-4026-907c-5bf65d635b97")
        Me.ReportsDockControl.Location = New System.Drawing.Point(272, 540)
        Me.ReportsDockControl.Name = "ReportsDockControl"
        Me.ReportsDockControl.Size = New System.Drawing.Size(725, 96)
        Me.ReportsDockControl.TabIndex = 6
        Me.ReportsDockControl.Text = "Reports"
        '
        'ReportsControlOnNames
        '
        Me.ReportsControlOnNames.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ReportsControlOnNames.Location = New System.Drawing.Point(0, 0)
        Me.ReportsControlOnNames.Name = "ReportsControlOnNames"
        Me.ReportsControlOnNames.Size = New System.Drawing.Size(725, 96)
        Me.ReportsControlOnNames.TabIndex = 23
        '
        'TabPageReferences
        '
        Me.TabPageReferences.Controls.Add(Me.NewRefButton)
        Me.TabPageReferences.Controls.Add(Me.RefLinkButton)
        Me.TabPageReferences.Controls.Add(Me.RefMergeButton)
        Me.TabPageReferences.Controls.Add(Me.Panel2)
        Me.TabPageReferences.Location = New System.Drawing.Point(4, 22)
        Me.TabPageReferences.Name = "TabPageReferences"
        Me.TabPageReferences.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPageReferences.Size = New System.Drawing.Size(1003, 665)
        Me.TabPageReferences.TabIndex = 1
        Me.TabPageReferences.Text = "References"
        Me.TabPageReferences.UseVisualStyleBackColor = True
        '
        'NewRefButton
        '
        Me.NewRefButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.NewRefButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.NewRefButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.NewRefButton.Location = New System.Drawing.Point(119, 643)
        Me.NewRefButton.Name = "NewRefButton"
        Me.NewRefButton.Size = New System.Drawing.Size(108, 23)
        Me.NewRefButton.TabIndex = 34
        Me.NewRefButton.Text = "New Reference"
        Me.NewRefButton.UseVisualStyleBackColor = False
        '
        'RefLinkButton
        '
        Me.RefLinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.RefLinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RefLinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RefLinkButton.Location = New System.Drawing.Point(284, 643)
        Me.RefLinkButton.Name = "RefLinkButton"
        Me.RefLinkButton.Size = New System.Drawing.Size(115, 23)
        Me.RefLinkButton.TabIndex = 33
        Me.RefLinkButton.Text = "Link Other Records"
        Me.RefLinkButton.UseVisualStyleBackColor = False
        '
        'RefMergeButton
        '
        Me.RefMergeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.RefMergeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RefMergeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RefMergeButton.Location = New System.Drawing.Point(5, 643)
        Me.RefMergeButton.Name = "RefMergeButton"
        Me.RefMergeButton.Size = New System.Drawing.Size(108, 23)
        Me.RefMergeButton.TabIndex = 31
        Me.RefMergeButton.Text = "Merge Reference"
        Me.RefMergeButton.UseVisualStyleBackColor = False
        '
        'Panel2
        '
        Me.Panel2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Panel2.Controls.Add(Me.DocumentContainer5)
        Me.Panel2.Location = New System.Drawing.Point(3, 5)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(1000, 635)
        Me.Panel2.TabIndex = 2
        '
        'DocumentContainer5
        '
        Me.DocumentContainer5.Controls.Add(Me.SelectorDockControl)
        Me.DocumentContainer5.Controls.Add(Me.RefDetailsDockControl)
        Me.DocumentContainer5.Controls.Add(Me.ProviderRISDockControl)
        Me.DocumentContainer5.Controls.Add(Me.ProviderRefDockControl)
        Me.DocumentContainer5.DockingManager = TD.SandDock.DockingManager.Whidbey
        Me.DocumentContainer5.Guid = New System.Guid("e50f2267-a98a-4ac3-a70f-8ad9cf166364")
        Me.DocumentContainer5.LayoutSystem = New TD.SandDock.SplitLayoutSystem(250, 400, System.Windows.Forms.Orientation.Horizontal, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.SplitLayoutSystem(998, 633, System.Windows.Forms.Orientation.Vertical, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.DocumentLayoutSystem(265, 633, New TD.SandDock.DockControl() {Me.SelectorDockControl}, Me.SelectorDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.SplitLayoutSystem(728, 633, System.Windows.Forms.Orientation.Horizontal, New TD.SandDock.LayoutSystemBase() {CType(New TD.SandDock.DocumentLayoutSystem(729, 389, New TD.SandDock.DockControl() {Me.RefDetailsDockControl}, Me.RefDetailsDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.DocumentLayoutSystem(729, 128, New TD.SandDock.DockControl() {Me.ProviderRISDockControl}, Me.ProviderRISDockControl), TD.SandDock.LayoutSystemBase), CType(New TD.SandDock.DocumentLayoutSystem(729, 107, New TD.SandDock.DockControl() {Me.ProviderRefDockControl}, Me.ProviderRefDockControl), TD.SandDock.LayoutSystemBase)}), TD.SandDock.LayoutSystemBase)}), TD.SandDock.LayoutSystemBase)})
        Me.DocumentContainer5.Location = New System.Drawing.Point(0, 0)
        Me.DocumentContainer5.Manager = Nothing
        Me.DocumentContainer5.Name = "DocumentContainer5"
        Me.DocumentContainer5.Size = New System.Drawing.Size(1000, 635)
        Me.DocumentContainer5.TabIndex = 2
        '
        'SelectorDockControl
        '
        Me.SelectorDockControl.Closable = False
        Me.SelectorDockControl.Controls.Add(Me.ReferenceSearch1)
        Me.SelectorDockControl.Guid = New System.Guid("b4d23f62-4bc7-4ab3-8db1-a1e3b62dee5e")
        Me.SelectorDockControl.Location = New System.Drawing.Point(3, 23)
        Me.SelectorDockControl.Name = "SelectorDockControl"
        Me.SelectorDockControl.Size = New System.Drawing.Size(261, 609)
        Me.SelectorDockControl.TabIndex = 0
        Me.SelectorDockControl.Text = "Select Reference"
        '
        'ReferenceSearch1
        '
        Me.ReferenceSearch1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ReferenceSearch1.Location = New System.Drawing.Point(0, 0)
        Me.ReferenceSearch1.Name = "ReferenceSearch1"
        Me.ReferenceSearch1.Size = New System.Drawing.Size(261, 609)
        Me.ReferenceSearch1.TabIndex = 0
        '
        'RefDetailsDockControl
        '
        Me.RefDetailsDockControl.Controls.Add(Me.RefRefLink)
        Me.RefDetailsDockControl.Controls.Add(Me.RefNamesInRefLink)
        Me.RefDetailsDockControl.Controls.Add(Me.FullCitationText)
        Me.RefDetailsDockControl.Controls.Add(Me.Label8)
        Me.RefDetailsDockControl.Controls.Add(Me.RefDetailsGrid)
        Me.RefDetailsDockControl.Controls.Add(Me.RefLSIDText)
        Me.RefDetailsDockControl.Controls.Add(Me.Label6)
        Me.RefDetailsDockControl.Controls.Add(Me.RefCitationText)
        Me.RefDetailsDockControl.Controls.Add(Me.Label5)
        Me.RefDetailsDockControl.Controls.Add(Me.Label2)
        Me.RefDetailsDockControl.Controls.Add(Me.RefBrowseButton)
        Me.RefDetailsDockControl.Controls.Add(Me.RefEditButton)
        Me.RefDetailsDockControl.Controls.Add(Me.RefHideBlankFields)
        Me.RefDetailsDockControl.Guid = New System.Guid("9443c40c-a5b0-46ee-befa-ca97d36c88d3")
        Me.RefDetailsDockControl.Location = New System.Drawing.Point(272, 23)
        Me.RefDetailsDockControl.Name = "RefDetailsDockControl"
        Me.RefDetailsDockControl.Size = New System.Drawing.Size(725, 366)
        Me.RefDetailsDockControl.TabIndex = 1
        Me.RefDetailsDockControl.Text = "Reference Details"
        '
        'RefRefLink
        '
        Me.RefRefLink.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefRefLink.AutoSize = True
        Me.RefRefLink.Location = New System.Drawing.Point(291, 8)
        Me.RefRefLink.Name = "RefRefLink"
        Me.RefRefLink.Size = New System.Drawing.Size(97, 13)
        Me.RefRefLink.TabIndex = 34
        Me.RefRefLink.TabStop = True
        Me.RefRefLink.Text = "Refresh Reference"
        '
        'RefNamesInRefLink
        '
        Me.RefNamesInRefLink.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefNamesInRefLink.AutoSize = True
        Me.RefNamesInRefLink.Location = New System.Drawing.Point(412, 8)
        Me.RefNamesInRefLink.Name = "RefNamesInRefLink"
        Me.RefNamesInRefLink.Size = New System.Drawing.Size(163, 13)
        Me.RefNamesInRefLink.TabIndex = 33
        Me.RefNamesInRefLink.TabStop = True
        Me.RefNamesInRefLink.Text = "Refresh Names in this Reference"
        '
        'FullCitationText
        '
        Me.FullCitationText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FullCitationText.Location = New System.Drawing.Point(65, 86)
        Me.FullCitationText.Name = "FullCitationText"
        Me.FullCitationText.ReadOnly = True
        Me.FullCitationText.Size = New System.Drawing.Size(598, 20)
        Me.FullCitationText.TabIndex = 32
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(3, 89)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(61, 13)
        Me.Label8.TabIndex = 31
        Me.Label8.Text = "Full Citation"
        '
        'RefDetailsGrid
        '
        Me.RefDetailsGrid.AllowDragging = C1.Win.C1FlexGrid.AllowDraggingEnum.None
        Me.RefDetailsGrid.AllowSorting = C1.Win.C1FlexGrid.AllowSortingEnum.None
        Me.RefDetailsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefDetailsGrid.ColumnInfo = "0,0,0,0,0,85,Columns:"
        Me.RefDetailsGrid.KeyActionEnter = C1.Win.C1FlexGrid.KeyActionEnum.None
        Me.RefDetailsGrid.KeyActionTab = C1.Win.C1FlexGrid.KeyActionEnum.MoveDown
        Me.RefDetailsGrid.Location = New System.Drawing.Point(3, 112)
        Me.RefDetailsGrid.Name = "RefDetailsGrid"
        Me.RefDetailsGrid.Rows.Count = 1
        Me.RefDetailsGrid.Rows.DefaultSize = 17
        Me.RefDetailsGrid.Size = New System.Drawing.Size(719, 251)
        Me.RefDetailsGrid.TabIndex = 30
        '
        'RefLSIDText
        '
        Me.RefLSIDText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefLSIDText.Location = New System.Drawing.Point(65, 34)
        Me.RefLSIDText.Name = "RefLSIDText"
        Me.RefLSIDText.ReadOnly = True
        Me.RefLSIDText.Size = New System.Drawing.Size(598, 20)
        Me.RefLSIDText.TabIndex = 29
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(3, 37)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(31, 13)
        Me.Label6.TabIndex = 28
        Me.Label6.Text = "LSID"
        '
        'RefCitationText
        '
        Me.RefCitationText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefCitationText.Location = New System.Drawing.Point(65, 60)
        Me.RefCitationText.Name = "RefCitationText"
        Me.RefCitationText.ReadOnly = True
        Me.RefCitationText.Size = New System.Drawing.Size(598, 20)
        Me.RefCitationText.TabIndex = 27
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(3, 63)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(42, 13)
        Me.Label5.TabIndex = 26
        Me.Label5.Text = "Citation"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 8)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(54, 13)
        Me.Label2.TabIndex = 24
        Me.Label2.Text = "Edit mode"
        '
        'RefBrowseButton
        '
        Me.RefBrowseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RefBrowseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RefBrowseButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.RefBrowseButton.Location = New System.Drawing.Point(106, 3)
        Me.RefBrowseButton.Name = "RefBrowseButton"
        Me.RefBrowseButton.Size = New System.Drawing.Size(55, 22)
        Me.RefBrowseButton.TabIndex = 23
        Me.RefBrowseButton.Text = "&Browse"
        Me.RefBrowseButton.UseVisualStyleBackColor = False
        '
        'RefEditButton
        '
        Me.RefEditButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RefEditButton.ForeColor = System.Drawing.SystemColors.ControlDark
        Me.RefEditButton.Location = New System.Drawing.Point(61, 3)
        Me.RefEditButton.Name = "RefEditButton"
        Me.RefEditButton.Size = New System.Drawing.Size(46, 22)
        Me.RefEditButton.TabIndex = 22
        Me.RefEditButton.Text = "&Edit"
        Me.RefEditButton.UseVisualStyleBackColor = True
        '
        'RefHideBlankFields
        '
        Me.RefHideBlankFields.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RefHideBlankFields.AutoSize = True
        Me.RefHideBlankFields.Location = New System.Drawing.Point(600, 6)
        Me.RefHideBlankFields.Name = "RefHideBlankFields"
        Me.RefHideBlankFields.Size = New System.Drawing.Size(104, 17)
        Me.RefHideBlankFields.TabIndex = 16
        Me.RefHideBlankFields.Text = "Hide blank fields"
        Me.RefHideBlankFields.UseVisualStyleBackColor = True
        '
        'ProviderRISDockControl
        '
        Me.ProviderRISDockControl.Controls.Add(Me.ProviderRISGrid)
        Me.ProviderRISDockControl.Guid = New System.Guid("0c4e9eef-c969-4f74-98e7-587ead8231da")
        Me.ProviderRISDockControl.Location = New System.Drawing.Point(272, 417)
        Me.ProviderRISDockControl.Name = "ProviderRISDockControl"
        Me.ProviderRISDockControl.Size = New System.Drawing.Size(725, 104)
        Me.ProviderRISDockControl.TabIndex = 5
        Me.ProviderRISDockControl.Text = "Provider RIS Records"
        '
        'ProviderRISGrid
        '
        Me.ProviderRISGrid.AllowUserToAddRows = False
        Me.ProviderRISGrid.AllowUserToDeleteRows = False
        Me.ProviderRISGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle10.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle10.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle10.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle10.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle10.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle10.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle10.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProviderRISGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle10
        Me.ProviderRISGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        DataGridViewCellStyle11.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle11.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle11.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle11.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle11.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle11.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle11.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.ProviderRISGrid.DefaultCellStyle = DataGridViewCellStyle11
        Me.ProviderRISGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ProviderRISGrid.Location = New System.Drawing.Point(0, 0)
        Me.ProviderRISGrid.MultiSelect = False
        Me.ProviderRISGrid.Name = "ProviderRISGrid"
        Me.ProviderRISGrid.ReadOnly = True
        DataGridViewCellStyle12.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle12.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle12.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle12.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle12.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle12.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle12.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.ProviderRISGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle12
        Me.ProviderRISGrid.RowHeadersVisible = False
        Me.ProviderRISGrid.Size = New System.Drawing.Size(725, 104)
        Me.ProviderRISGrid.TabIndex = 20
        '
        'ProviderRefDockControl
        '
        Me.ProviderRefDockControl.Controls.Add(Me.RefProviderGrid)
        Me.ProviderRefDockControl.Guid = New System.Guid("70b9f3a0-2bd3-4cf8-8040-0f5f46244533")
        Me.ProviderRefDockControl.Location = New System.Drawing.Point(272, 549)
        Me.ProviderRefDockControl.Name = "ProviderRefDockControl"
        Me.ProviderRefDockControl.Size = New System.Drawing.Size(725, 83)
        Me.ProviderRefDockControl.TabIndex = 3
        Me.ProviderRefDockControl.Text = "Provider Reference Records"
        '
        'RefProviderGrid
        '
        Me.RefProviderGrid.AllowUserToAddRows = False
        Me.RefProviderGrid.AllowUserToDeleteRows = False
        Me.RefProviderGrid.AllowUserToResizeRows = False
        DataGridViewCellStyle13.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle13.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle13.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle13.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle13.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle13.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle13.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.RefProviderGrid.ColumnHeadersDefaultCellStyle = DataGridViewCellStyle13
        Me.RefProviderGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.RefProviderGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.DataGridViewLinkColumn1})
        DataGridViewCellStyle14.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle14.BackColor = System.Drawing.SystemColors.Window
        DataGridViewCellStyle14.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle14.ForeColor = System.Drawing.SystemColors.ControlText
        DataGridViewCellStyle14.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle14.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle14.WrapMode = System.Windows.Forms.DataGridViewTriState.[False]
        Me.RefProviderGrid.DefaultCellStyle = DataGridViewCellStyle14
        Me.RefProviderGrid.Dock = System.Windows.Forms.DockStyle.Fill
        Me.RefProviderGrid.Location = New System.Drawing.Point(0, 0)
        Me.RefProviderGrid.MultiSelect = False
        Me.RefProviderGrid.Name = "RefProviderGrid"
        Me.RefProviderGrid.ReadOnly = True
        DataGridViewCellStyle15.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft
        DataGridViewCellStyle15.BackColor = System.Drawing.SystemColors.Control
        DataGridViewCellStyle15.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        DataGridViewCellStyle15.ForeColor = System.Drawing.SystemColors.WindowText
        DataGridViewCellStyle15.SelectionBackColor = System.Drawing.SystemColors.Highlight
        DataGridViewCellStyle15.SelectionForeColor = System.Drawing.SystemColors.HighlightText
        DataGridViewCellStyle15.WrapMode = System.Windows.Forms.DataGridViewTriState.[True]
        Me.RefProviderGrid.RowHeadersDefaultCellStyle = DataGridViewCellStyle15
        Me.RefProviderGrid.RowHeadersVisible = False
        Me.RefProviderGrid.Size = New System.Drawing.Size(725, 83)
        Me.RefProviderGrid.TabIndex = 19
        '
        'DataGridViewLinkColumn1
        '
        Me.DataGridViewLinkColumn1.HeaderText = "Split"
        Me.DataGridViewLinkColumn1.Name = "DataGridViewLinkColumn1"
        Me.DataGridViewLinkColumn1.ReadOnly = True
        Me.DataGridViewLinkColumn1.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.DataGridViewLinkColumn1.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.DataGridViewLinkColumn1.Text = "Split"
        Me.DataGridViewLinkColumn1.TrackVisitedState = False
        Me.DataGridViewLinkColumn1.UseColumnTextForLinkValue = True
        '
        'TabPageOtherData
        '
        Me.TabPageOtherData.Controls.Add(Me.OtherDataCtrl1)
        Me.TabPageOtherData.Location = New System.Drawing.Point(4, 22)
        Me.TabPageOtherData.Name = "TabPageOtherData"
        Me.TabPageOtherData.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPageOtherData.Size = New System.Drawing.Size(1003, 665)
        Me.TabPageOtherData.TabIndex = 5
        Me.TabPageOtherData.Text = "Other Data"
        Me.TabPageOtherData.UseVisualStyleBackColor = True
        '
        'OtherDataCtrl1
        '
        Me.OtherDataCtrl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OtherDataCtrl1.AutoScroll = True
        Me.OtherDataCtrl1.IsDirty = False
        Me.OtherDataCtrl1.Location = New System.Drawing.Point(6, 6)
        Me.OtherDataCtrl1.Name = "OtherDataCtrl1"
        Me.OtherDataCtrl1.Size = New System.Drawing.Size(986, 630)
        Me.OtherDataCtrl1.TabIndex = 0
        '
        'TabPageProviders
        '
        Me.TabPageProviders.Controls.Add(Me.ProvRefButton)
        Me.TabPageProviders.Controls.Add(Me.ViewProvNamesButton)
        Me.TabPageProviders.Controls.Add(Me.EditProviderButton)
        Me.TabPageProviders.Controls.Add(Me.AddProviderButton)
        Me.TabPageProviders.Controls.Add(Me.ProvidersGrid)
        Me.TabPageProviders.Controls.Add(Me.Label1)
        Me.TabPageProviders.Location = New System.Drawing.Point(4, 22)
        Me.TabPageProviders.Name = "TabPageProviders"
        Me.TabPageProviders.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPageProviders.Size = New System.Drawing.Size(1003, 665)
        Me.TabPageProviders.TabIndex = 2
        Me.TabPageProviders.Text = "Providers"
        Me.TabPageProviders.UseVisualStyleBackColor = True
        '
        'ProvRefButton
        '
        Me.ProvRefButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ProvRefButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ProvRefButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ProvRefButton.Location = New System.Drawing.Point(359, 586)
        Me.ProvRefButton.Name = "ProvRefButton"
        Me.ProvRefButton.Size = New System.Drawing.Size(148, 23)
        Me.ProvRefButton.TabIndex = 33
        Me.ProvRefButton.Text = "View Provider References"
        Me.ProvRefButton.UseVisualStyleBackColor = False
        '
        'ViewProvNamesButton
        '
        Me.ViewProvNamesButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ViewProvNamesButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ViewProvNamesButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ViewProvNamesButton.Location = New System.Drawing.Point(219, 586)
        Me.ViewProvNamesButton.Name = "ViewProvNamesButton"
        Me.ViewProvNamesButton.Size = New System.Drawing.Size(134, 23)
        Me.ViewProvNamesButton.TabIndex = 32
        Me.ViewProvNamesButton.Text = "View Provider Names"
        Me.ViewProvNamesButton.UseVisualStyleBackColor = False
        '
        'EditProviderButton
        '
        Me.EditProviderButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.EditProviderButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.EditProviderButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.EditProviderButton.Location = New System.Drawing.Point(114, 586)
        Me.EditProviderButton.Name = "EditProviderButton"
        Me.EditProviderButton.Size = New System.Drawing.Size(99, 23)
        Me.EditProviderButton.TabIndex = 31
        Me.EditProviderButton.Text = "Edit Provider"
        Me.EditProviderButton.UseVisualStyleBackColor = False
        '
        'AddProviderButton
        '
        Me.AddProviderButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.AddProviderButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.AddProviderButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.AddProviderButton.Location = New System.Drawing.Point(9, 586)
        Me.AddProviderButton.Name = "AddProviderButton"
        Me.AddProviderButton.Size = New System.Drawing.Size(99, 23)
        Me.AddProviderButton.TabIndex = 30
        Me.AddProviderButton.Text = "Add Provider"
        Me.AddProviderButton.UseVisualStyleBackColor = False
        '
        'ProvidersGrid
        '
        Me.ProvidersGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProvidersGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ProvidersGrid.Location = New System.Drawing.Point(3, 19)
        Me.ProvidersGrid.Name = "ProvidersGrid"
        Me.ProvidersGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ProvidersGrid.Size = New System.Drawing.Size(767, 561)
        Me.ProvidersGrid.TabIndex = 1
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 3)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(51, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Providers"
        '
        'TabPageReports
        '
        Me.TabPageReports.Controls.Add(Me.ReportsControl1)
        Me.TabPageReports.Location = New System.Drawing.Point(4, 22)
        Me.TabPageReports.Name = "TabPageReports"
        Me.TabPageReports.Padding = New System.Windows.Forms.Padding(3)
        Me.TabPageReports.Size = New System.Drawing.Size(1003, 665)
        Me.TabPageReports.TabIndex = 4
        Me.TabPageReports.Text = "Reports"
        Me.TabPageReports.UseVisualStyleBackColor = True
        '
        'ReportsControl1
        '
        Me.ReportsControl1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReportsControl1.Location = New System.Drawing.Point(0, 0)
        Me.ReportsControl1.Name = "ReportsControl1"
        Me.ReportsControl1.Size = New System.Drawing.Size(1003, 669)
        Me.ReportsControl1.TabIndex = 0
        '
        'SaveButton
        '
        Me.SaveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SaveButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SaveButton.Enabled = False
        Me.SaveButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SaveButton.Location = New System.Drawing.Point(840, 725)
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(80, 23)
        Me.SaveButton.TabIndex = 2
        Me.SaveButton.Text = "Save"
        Me.SaveButton.UseVisualStyleBackColor = False
        '
        'SandDockManager1
        '
        Me.SandDockManager1.OwnerForm = Me
        '
        'MenuStrip1
        '
        Me.MenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.FileMenuItem1, Me.EditToolStripMenuItem, Me.ViewLogMenuItem})
        Me.MenuStrip1.Location = New System.Drawing.Point(0, 0)
        Me.MenuStrip1.Name = "MenuStrip1"
        Me.MenuStrip1.Size = New System.Drawing.Size(1016, 24)
        Me.MenuStrip1.TabIndex = 14
        Me.MenuStrip1.Text = "MenuStrip1"
        '
        'FileMenuItem1
        '
        Me.FileMenuItem1.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.SaveEditsToolStripMenuItem, Me.ImportToolStripMenuItem, Me.ImportMergeFileToolStripMenuItem, Me.ImportAnnotationsToolStripMenuItem, Me.ExportDatabaseToolStripMenuItem, Me.AboutToolStripMenuItem, Me.ExitToolStripMenuItem})
        Me.FileMenuItem1.Name = "FileMenuItem1"
        Me.FileMenuItem1.Size = New System.Drawing.Size(35, 20)
        Me.FileMenuItem1.Text = "File"
        '
        'SaveEditsToolStripMenuItem
        '
        Me.SaveEditsToolStripMenuItem.Enabled = False
        Me.SaveEditsToolStripMenuItem.Name = "SaveEditsToolStripMenuItem"
        Me.SaveEditsToolStripMenuItem.ShortcutKeys = CType((System.Windows.Forms.Keys.Control Or System.Windows.Forms.Keys.S), System.Windows.Forms.Keys)
        Me.SaveEditsToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.SaveEditsToolStripMenuItem.Text = "Save Edits"
        '
        'ImportToolStripMenuItem
        '
        Me.ImportToolStripMenuItem.Name = "ImportToolStripMenuItem"
        Me.ImportToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.ImportToolStripMenuItem.Text = "Import Data..."
        '
        'ImportMergeFileToolStripMenuItem
        '
        Me.ImportMergeFileToolStripMenuItem.Name = "ImportMergeFileToolStripMenuItem"
        Me.ImportMergeFileToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.ImportMergeFileToolStripMenuItem.Text = "Import Merge File ..."
        '
        'ImportAnnotationsToolStripMenuItem
        '
        Me.ImportAnnotationsToolStripMenuItem.Name = "ImportAnnotationsToolStripMenuItem"
        Me.ImportAnnotationsToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.ImportAnnotationsToolStripMenuItem.Text = "Import Annotations ..."
        '
        'ExportDatabaseToolStripMenuItem
        '
        Me.ExportDatabaseToolStripMenuItem.Name = "ExportDatabaseToolStripMenuItem"
        Me.ExportDatabaseToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.ExportDatabaseToolStripMenuItem.Text = "Data Transfer..."
        '
        'AboutToolStripMenuItem
        '
        Me.AboutToolStripMenuItem.Name = "AboutToolStripMenuItem"
        Me.AboutToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.AboutToolStripMenuItem.Text = "About..."
        '
        'ExitToolStripMenuItem
        '
        Me.ExitToolStripMenuItem.Name = "ExitToolStripMenuItem"
        Me.ExitToolStripMenuItem.Size = New System.Drawing.Size(193, 22)
        Me.ExitToolStripMenuItem.Text = "Exit"
        '
        'EditToolStripMenuItem
        '
        Me.EditToolStripMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.AuthorsToolStripMenuItem})
        Me.EditToolStripMenuItem.Name = "EditToolStripMenuItem"
        Me.EditToolStripMenuItem.Size = New System.Drawing.Size(37, 20)
        Me.EditToolStripMenuItem.Text = "Edit"
        '
        'AuthorsToolStripMenuItem
        '
        Me.AuthorsToolStripMenuItem.Name = "AuthorsToolStripMenuItem"
        Me.AuthorsToolStripMenuItem.Size = New System.Drawing.Size(135, 22)
        Me.AuthorsToolStripMenuItem.Text = "Authors..."
        '
        'ViewLogMenuItem
        '
        Me.ViewLogMenuItem.DropDownItems.AddRange(New System.Windows.Forms.ToolStripItem() {Me.RunIntegrationToolStripMenuItem, Me.ViewLogToolStripMenuItem, Me.CleanDatabaseToolStripMenuItem, Me.RefreshAllNamesToolStripMenuItem, Me.DeduplicateChildrenToolStripMenuItem, Me.DeduplicateReferencesToolStripMenuItem, Me.MoveChildrenOfSelectedToolStripMenuItem, Me.MergeUnknownNamesToolStripMenuItem, Me.MoveNamesWithDiffPrefParentToolStripMenuItem, Me.ProcessAutonymsToolStripMenuItem})
        Me.ViewLogMenuItem.Name = "ViewLogMenuItem"
        Me.ViewLogMenuItem.Size = New System.Drawing.Size(44, 20)
        Me.ViewLogMenuItem.Text = "Tools"
        '
        'RunIntegrationToolStripMenuItem
        '
        Me.RunIntegrationToolStripMenuItem.Name = "RunIntegrationToolStripMenuItem"
        Me.RunIntegrationToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.RunIntegrationToolStripMenuItem.Text = "Run Integration..."
        '
        'ViewLogToolStripMenuItem
        '
        Me.ViewLogToolStripMenuItem.Name = "ViewLogToolStripMenuItem"
        Me.ViewLogToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.ViewLogToolStripMenuItem.Text = "View Error Log..."
        '
        'CleanDatabaseToolStripMenuItem
        '
        Me.CleanDatabaseToolStripMenuItem.Name = "CleanDatabaseToolStripMenuItem"
        Me.CleanDatabaseToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.CleanDatabaseToolStripMenuItem.Text = "Clean Database"
        '
        'RefreshAllNamesToolStripMenuItem
        '
        Me.RefreshAllNamesToolStripMenuItem.Name = "RefreshAllNamesToolStripMenuItem"
        Me.RefreshAllNamesToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.RefreshAllNamesToolStripMenuItem.Text = "Refresh All Names"
        '
        'DeduplicateChildrenToolStripMenuItem
        '
        Me.DeduplicateChildrenToolStripMenuItem.Name = "DeduplicateChildrenToolStripMenuItem"
        Me.DeduplicateChildrenToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.DeduplicateChildrenToolStripMenuItem.Text = "Deduplicate Child Names..."
        '
        'DeduplicateReferencesToolStripMenuItem
        '
        Me.DeduplicateReferencesToolStripMenuItem.Name = "DeduplicateReferencesToolStripMenuItem"
        Me.DeduplicateReferencesToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.DeduplicateReferencesToolStripMenuItem.Text = "Deduplicate References..."
        '
        'MoveChildrenOfSelectedToolStripMenuItem
        '
        Me.MoveChildrenOfSelectedToolStripMenuItem.Name = "MoveChildrenOfSelectedToolStripMenuItem"
        Me.MoveChildrenOfSelectedToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.MoveChildrenOfSelectedToolStripMenuItem.Text = "Move Children of Current Name..."
        '
        'MergeUnknownNamesToolStripMenuItem
        '
        Me.MergeUnknownNamesToolStripMenuItem.Name = "MergeUnknownNamesToolStripMenuItem"
        Me.MergeUnknownNamesToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.MergeUnknownNamesToolStripMenuItem.Text = "Merge unknown names ..."
        '
        'MoveNamesWithDiffPrefParentToolStripMenuItem
        '
        Me.MoveNamesWithDiffPrefParentToolStripMenuItem.Name = "MoveNamesWithDiffPrefParentToolStripMenuItem"
        Me.MoveNamesWithDiffPrefParentToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.MoveNamesWithDiffPrefParentToolStripMenuItem.Text = "Move Names With Diff Pref Parent..."
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.Enabled = False
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.Location = New System.Drawing.Point(575, 725)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(80, 23)
        Me.CncButton.TabIndex = 1
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'DataGridViewLinkColumn2
        '
        Me.DataGridViewLinkColumn2.HeaderText = "Split"
        Me.DataGridViewLinkColumn2.Name = "DataGridViewLinkColumn2"
        Me.DataGridViewLinkColumn2.ReadOnly = True
        Me.DataGridViewLinkColumn2.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.DataGridViewLinkColumn2.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic
        Me.DataGridViewLinkColumn2.Text = "Split"
        Me.DataGridViewLinkColumn2.TrackVisitedState = False
        Me.DataGridViewLinkColumn2.UseColumnTextForLinkValue = True
        '
        'saveWithAttButton
        '
        Me.saveWithAttButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.saveWithAttButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.saveWithAttButton.Enabled = False
        Me.saveWithAttButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.saveWithAttButton.Location = New System.Drawing.Point(667, 725)
        Me.saveWithAttButton.Name = "saveWithAttButton"
        Me.saveWithAttButton.Size = New System.Drawing.Size(134, 23)
        Me.saveWithAttButton.TabIndex = 15
        Me.saveWithAttButton.Text = "Save With Attribution"
        Me.saveWithAttButton.UseVisualStyleBackColor = False
        '
        'ProcessAutonymsToolStripMenuItem
        '
        Me.ProcessAutonymsToolStripMenuItem.Name = "ProcessAutonymsToolStripMenuItem"
        Me.ProcessAutonymsToolStripMenuItem.Size = New System.Drawing.Size(261, 22)
        Me.ProcessAutonymsToolStripMenuItem.Text = "Process Autonyms"
        '
        'IntegratorForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1016, 753)
        Me.Controls.Add(Me.saveWithAttButton)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.TabControl1)
        Me.Controls.Add(Me.ExitButton)
        Me.Controls.Add(Me.SaveButton)
        Me.Controls.Add(Me.MenuStrip1)
        Me.MainMenuStrip = Me.MenuStrip1
        Me.Name = "IntegratorForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Checklist Integrator"
        Me.TabControl1.ResumeLayout(False)
        Me.TabPageNames.ResumeLayout(False)
        Me.TabPageNames.PerformLayout()
        Me.Panel1.ResumeLayout(False)
        Me.DocumentContainer6.ResumeLayout(False)
        Me.SearchDockControl.ResumeLayout(False)
        Me.SearchDockControl.PerformLayout()
        Me.NameDetailsDockControl.ResumeLayout(False)
        Me.NameDetailsDockControl.PerformLayout()
        CType(Me.NameDetailsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ProvNameDockControl.ResumeLayout(False)
        CType(Me.ProviderNameGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ConceptsDockControl.ResumeLayout(False)
        CType(Me.ConceptsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ProvConceptsDockControl.ResumeLayout(False)
        CType(Me.ProvConceptGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.OtherDataDockControl.ResumeLayout(False)
        CType(Me.OtherDataGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ReportsDockControl.ResumeLayout(False)
        Me.TabPageReferences.ResumeLayout(False)
        Me.Panel2.ResumeLayout(False)
        Me.DocumentContainer5.ResumeLayout(False)
        Me.SelectorDockControl.ResumeLayout(False)
        Me.RefDetailsDockControl.ResumeLayout(False)
        Me.RefDetailsDockControl.PerformLayout()
        CType(Me.RefDetailsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ProviderRISDockControl.ResumeLayout(False)
        CType(Me.ProviderRISGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ProviderRefDockControl.ResumeLayout(False)
        CType(Me.RefProviderGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPageOtherData.ResumeLayout(False)
        Me.TabPageProviders.ResumeLayout(False)
        Me.TabPageProviders.PerformLayout()
        CType(Me.ProvidersGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TabPageReports.ResumeLayout(False)
        Me.MenuStrip1.ResumeLayout(False)
        Me.MenuStrip1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ExitButton As System.Windows.Forms.Button
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents TabControl1 As System.Windows.Forms.TabControl
    Friend WithEvents TabPageNames As System.Windows.Forms.TabPage
    Friend WithEvents TabPageReferences As System.Windows.Forms.TabPage
    Friend WithEvents TabPageProviders As System.Windows.Forms.TabPage
    Friend WithEvents SaveButton As System.Windows.Forms.Button
    Friend WithEvents TabPageReports As System.Windows.Forms.TabPage
    Friend WithEvents SandDockManager1 As TD.SandDock.SandDockManager
    Friend WithEvents LinkButton As System.Windows.Forms.Button
    Friend WithEvents MergeButton As System.Windows.Forms.Button
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents DocumentContainer5 As TD.SandDock.DocumentContainer
    Friend WithEvents SelectorDockControl As TD.SandDock.DockControl
    Friend WithEvents RefDetailsDockControl As TD.SandDock.DockControl
    Friend WithEvents RefHideBlankFields As System.Windows.Forms.CheckBox
    Friend WithEvents ProviderRefDockControl As TD.SandDock.DockControl
    Friend WithEvents RefProviderGrid As System.Windows.Forms.DataGridView
    Friend WithEvents DataGridViewLinkColumn1 As System.Windows.Forms.DataGridViewLinkColumn
    Friend WithEvents RefLinkButton As System.Windows.Forms.Button
    Friend WithEvents RefMergeButton As System.Windows.Forms.Button
    Friend WithEvents ReferenceSearch1 As IntegratorControls.ReferenceSearch
    Friend WithEvents MenuStrip1 As System.Windows.Forms.MenuStrip
    Friend WithEvents FileMenuItem1 As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ImportToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ExitToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ViewLogMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RunIntegrationToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ViewLogToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ProvRefButton As System.Windows.Forms.Button
    Friend WithEvents ViewProvNamesButton As System.Windows.Forms.Button
    Friend WithEvents EditProviderButton As System.Windows.Forms.Button
    Friend WithEvents AddProviderButton As System.Windows.Forms.Button
    Friend WithEvents ProvidersGrid As System.Windows.Forms.DataGridView
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents SaveEditsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DocumentContainer6 As TD.SandDock.DocumentContainer
    Friend WithEvents SearchDockControl As TD.SandDock.DockControl
    Friend WithEvents NameSelector1 As NameSelector
    Friend WithEvents ConceptsDockControl As TD.SandDock.DockControl
    Friend WithEvents ProvNameDockControl As TD.SandDock.DockControl
    Friend WithEvents DataGridViewLinkColumn2 As System.Windows.Forms.DataGridViewLinkColumn
    Friend WithEvents ProviderNameGrid As System.Windows.Forms.DataGridView
    Friend WithEvents NameDetailsDockControl As TD.SandDock.DockControl
    Friend WithEvents BackButton As System.Windows.Forms.Button
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents EditButton As System.Windows.Forms.Button
    Friend WithEvents NameDetailsGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents NamesHideBlankFields As System.Windows.Forms.CheckBox
    Friend WithEvents ProvConceptsDockControl As TD.SandDock.DockControl
    Friend WithEvents ProvConceptGrid As System.Windows.Forms.DataGridView
    Friend WithEvents ConceptsGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents RefBrowseButton As System.Windows.Forms.Button
    Friend WithEvents RefEditButton As System.Windows.Forms.Button
    Friend WithEvents RefCitationText As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents RefLSIDText As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents RefDetailsGrid As C1.Win.C1FlexGrid.C1FlexGrid
    Friend WithEvents ProviderRISDockControl As TD.SandDock.DockControl
    Friend WithEvents ProviderRISGrid As System.Windows.Forms.DataGridView
    Friend WithEvents OtherDataDockControl As TD.SandDock.DockControl
    Friend WithEvents OtherDataGrid As System.Windows.Forms.DataGridView
    Friend WithEvents FullCitationText As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents ReportsControl1 As IntegratorControls.ReportsControl
    Friend WithEvents ReportsDockControl As TD.SandDock.DockControl
    Friend WithEvents ReportsControlOnNames As IntegratorControls.ReportsControl
    Friend WithEvents Split As System.Windows.Forms.DataGridViewLinkColumn
    Friend WithEvents View As System.Windows.Forms.DataGridViewLinkColumn
    Friend WithEvents RefreshTreeLink As System.Windows.Forms.LinkLabel
    Friend WithEvents MergeMultipleButton As System.Windows.Forms.Button
    Friend WithEvents NewNameButton As System.Windows.Forms.Button
    Friend WithEvents NewRefButton As System.Windows.Forms.Button
    Friend WithEvents RefreshNameLink As System.Windows.Forms.LinkLabel
    Friend WithEvents ExportDatabaseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents CleanDatabaseToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RefreshAllNamesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RefreshChildrenLink As System.Windows.Forms.LinkLabel
    Friend WithEvents DeduplicateChildrenToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveChildrenOfSelectedToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DeduplicateReferencesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents EditToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AuthorsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents AboutToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents RefRefLink As System.Windows.Forms.LinkLabel
    Friend WithEvents RefNamesInRefLink As System.Windows.Forms.LinkLabel
    Friend WithEvents TabPageOtherData As System.Windows.Forms.TabPage
    Friend WithEvents OtherDataCtrl1 As IntegratorControls.OtherDataCtrl
    Friend WithEvents MergeUnknownNamesToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MoveNamesWithDiffPrefParentToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ImportMergeFileToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents saveWithAttButton As System.Windows.Forms.Button
    Friend WithEvents ImportAnnotationsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents ProcessAutonymsToolStripMenuItem As System.Windows.Forms.ToolStripMenuItem

End Class
