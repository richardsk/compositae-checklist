Public Class CancelProgressForm
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        ShowBeat = True
        Timer1.Interval = 1000
        DoProgress = False
    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents txtMessages As System.Windows.Forms.TextBox
    Friend WithEvents Beat1 As Beat
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(CancelProgressForm))
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.Panel1 = New System.Windows.Forms.Panel()
        Me.Beat1 = New Beat()
        Me.txtMessages = New System.Windows.Forms.TextBox()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = ((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right)
        Me.ProgressBar1.Location = New System.Drawing.Point(68, 42)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(178, 23)
        Me.ProgressBar1.TabIndex = 0
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = (System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left)
        Me.cmdCancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.cmdCancel.Location = New System.Drawing.Point(4, 42)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(56, 23)
        Me.cmdCancel.TabIndex = 1
        Me.cmdCancel.Text = "Cancel"
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.Color.LightSkyBlue
        Me.Panel1.Controls.AddRange(New System.Windows.Forms.Control() {Me.Beat1, Me.cmdCancel})
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Left
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(64, 67)
        Me.Panel1.TabIndex = 2
        '
        'Beat1
        '
        Me.Beat1.BackColor = System.Drawing.Color.Black
        Me.Beat1.BeatOn = False
        Me.Beat1.Location = New System.Drawing.Point(4, 4)
        Me.Beat1.Name = "Beat1"
        Me.Beat1.Size = New System.Drawing.Size(56, 32)
        Me.Beat1.TabIndex = 2
        '
        'txtMessages
        '
        Me.txtMessages.Anchor = (((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right)
        Me.txtMessages.BackColor = System.Drawing.Color.WhiteSmoke
        Me.txtMessages.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMessages.Location = New System.Drawing.Point(72, 4)
        Me.txtMessages.Multiline = True
        Me.txtMessages.Name = "txtMessages"
        Me.txtMessages.ReadOnly = True
        Me.txtMessages.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtMessages.Size = New System.Drawing.Size(174, 34)
        Me.txtMessages.TabIndex = 3
        Me.txtMessages.Text = ""
        '
        'Timer1
        '
        '
        'CancelProgressForm
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ClientSize = New System.Drawing.Size(250, 67)
        Me.Controls.AddRange(New System.Windows.Forms.Control() {Me.txtMessages, Me.Panel1, Me.ProgressBar1})
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "CancelProgressForm"
        Me.Text = "Working"
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public CancelRequestSent As Boolean
    Public EndDialog As Boolean

    Public DoProgress As Boolean
    Public ShowBeat As Boolean
    Public Id As Guid

    Public DoNotSendToDB As Boolean = False

    Public Property Interval() As Long
        Get
            Return Timer1.Interval
        End Get
        Set(ByVal Value As Long)
            Timer1.Interval = Value
        End Set
    End Property


    Public Property FormTitle() As String
        Get
            Return Me.Text
        End Get
        Set(ByVal Value As String)
            Me.Text = Value
        End Set
    End Property

    Private Sub CancelProgressForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.Cursor = Cursors.WaitCursor


        Setup()
    End Sub

    Private Sub Setup()
        If ShowBeat Then
            Beat1.Visible = True
            Beat1.BeatOn = True
        Else
            Beat1.Visible = False
            Beat1.BeatOn = False
        End If

        If DoProgress = True Then
            ProgressBar1.Visible = True
        Else
            ProgressBar1.Visible = False
        End If

        Timer1.Enabled = True
    End Sub


    Private Sub PollDatabaseForProgress()
        'TODO check db for progress
        Dim Progress As Double = 0
        Dim Messages As String = ""

        'TODO create code to get progress


        Progress = ProgressBar1.Value + 3
        UpdateMessages(Messages)
        UpdateProgressBar(Progress)

    End Sub

    Private Sub UpdateMessages(ByVal Messages As String)
        txtMessages.Text = Messages
    End Sub

    Private Sub UpdateProgressBar(ByVal Progress As Double)
        If Progress < ProgressBar1.Minimum Or Progress > ProgressBar1.Maximum Then
            Return
        End If

        ProgressBar1.Value = Progress
    End Sub


    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Timer1.Enabled = False
        If EndDialog = True Then
            Me.Close()
        End If
        If DoProgress = True Then
            PollDatabaseForProgress()
        End If
        Application.DoEvents()
        Timer1.Enabled = True
    End Sub

    Private Sub cmdCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdCancel.Click
        SendCancelRequest()
        Close()
    End Sub

    Private Sub SendCancelRequest()
        If DoNotSendToDB = True Then Return

        ChecklistDataAccess.DBData.InsertCancelRequest(Id)

        CancelRequestSent = True
    End Sub

    Private Sub CancelProgressForm_Closing(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles MyBase.Closing
        Me.Cursor = Cursors.Default
    End Sub
End Class
