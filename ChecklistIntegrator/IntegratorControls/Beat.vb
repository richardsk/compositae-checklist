

Public Class Beat
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub
    Friend WithEvents Timer1 As System.Windows.Forms.Timer
    Friend WithEvents Timer2 As System.Windows.Forms.Timer
    Friend WithEvents Timer3 As System.Windows.Forms.Timer
    Private components As System.ComponentModel.IContainer

    'Required by the Windows Form Designer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.Timer1 = New System.Windows.Forms.Timer(Me.components)
        Me.Timer2 = New System.Windows.Forms.Timer(Me.components)
        Me.Timer3 = New System.Windows.Forms.Timer(Me.components)
        '
        'Timer1
        '
        '
        'Timer2
        '
        '
        'Timer3
        '
        '
        'Beat
        '
        Me.BackColor = System.Drawing.Color.Black
        Me.Name = "Beat"

    End Sub

#End Region

    Const NO_POINTS As Long = 150
    Const BEAT_WIDTH As Double = 20
    Dim mrgHeight(NO_POINTS) As Double
    Dim mrgIntensity(NO_POINTS) As Long
    Dim mCurrentLocation As Long
    Dim mBeatLocation As Long
    Dim mBeatOn As Boolean

    Protected Overrides Sub OnPaint(ByVal pe As PaintEventArgs)
        ' This calls the OnPaint method of the base class.
        MyBase.OnPaint(pe)
        If mBeatOn = False Then
            Exit Sub
        End If
        ' Declares and instantiates a drawing pen.
        Dim myColor As ColorConverter


        ' Draws an aqua rectangle in the ClipRectangle.
        'pe.Graphics.DrawLine(myPen, 0, 0, 50, 50)

        Dim medium As Double = CType(Me.Size.Height, Double) / CType(2, Double)
        Dim dblWidth As Double = Me.Size.Width
        Dim dblInc As Double = dblWidth / CType(NO_POINTS, Double)

        Dim index As Long
        For index = 0 To NO_POINTS - 2
            Dim dblIndex As Double = index
            Dim dblNextIndex As Double = CType(index + 1, Double)
            Dim X1 As Double = dblIndex * dblInc
            Dim Y1 As Double = medium + mrgHeight(index) * medium / -2
            Dim X2 As Double = dblNextIndex * dblInc
            Dim Y2 As Double = medium + mrgHeight(index + 1) * medium / -2
            Dim c As ColorConverter = New ColorConverter()
            'Dim customColor As Color = c.ConvertFrom(RGB(0, mrgIntensity(index), 0))
            Dim intColor As Integer = RGB(0, mrgIntensity(index), 0)
            Dim customColor As Color = System.Drawing.ColorTranslator.FromOle(intColor)

            Dim myPen As System.Drawing.Pen = New System.Drawing.Pen(customColor)

            pe.Graphics.DrawLine(myPen, CType(X1, Single), CType(Y1, Single), CType(X2, Single), CType(Y2, Single))
            mrgIntensity(index) -= 5
            If mrgIntensity(index) < 0 Then
                mrgIntensity(index) = 0
            End If

        Next




    End Sub

    Private Sub Timer1_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer1.Tick
        Timer1.Enabled = False
        mBeatLocation = 0

        Timer1.Enabled = True
        'Debug.WriteLine("beat " & Now())
    End Sub

    Private Sub Beat_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        SetState(mBeatOn)

    End Sub

    Sub SetState(ByVal bBeatOn As Boolean)
        If mBeatOn = True Then
            mCurrentLocation = 0
            Timer1.Interval = 968
            Timer1.Enabled = True
            Timer2.Interval = 2
            Timer2.Enabled = True
            mBeatLocation = 500
            Timer3.Interval = 30
            Timer3.Enabled = True
        Else
            Timer1.Enabled = False
            Timer2.Enabled = False
            Timer3.Enabled = False
            Refresh()
        End If
    End Sub

    Private Sub Timer2_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer2.Tick
        Dim y As Double = 0

        If mBeatLocation < BEAT_WIDTH Then
            mBeatLocation += 1

            Dim x As Double = (2 * Math.PI) * (CType(mBeatLocation, Double) / CType(BEAT_WIDTH, Double))
            y = System.Math.Sin(x)

        End If
        mrgHeight(mCurrentLocation + 1) = y
        mrgIntensity(mCurrentLocation) = 255
        mCurrentLocation += 1
        mCurrentLocation = mCurrentLocation Mod (NO_POINTS - 1)
    End Sub

    Private Sub Timer3_Tick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Timer3.Tick
        Timer3.Enabled = False
        Me.Refresh()
        Timer3.Enabled = True
    End Sub

    Property BeatOn() As Boolean
        Get
            Return mBeatOn

        End Get
        Set(ByVal Value As Boolean)
            mBeatOn = Value
            SetState(mBeatOn)
        End Set
    End Property
End Class


