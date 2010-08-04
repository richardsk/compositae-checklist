Imports System.Windows.Forms
Imports System.Drawing

<Serializable()> _
Public Class FormState
    Private mstrFormName As String
    Private mintWindowState As FormWindowState
    Private mobjLocation As Point
    Private mobjSize As Size

#Region "Constructors"
    Public Sub New()
        InternalConstructor(String.Empty, FormWindowState.Normal, New Point, New Size)
    End Sub

    Public Sub New(ByVal strFormName As String, ByVal enuWindowState As FormWindowState, ByVal objLocation As Point, ByVal objSize As Size)
        InternalConstructor(strFormName, enuWindowState, objLocation, objSize)
    End Sub

    Private Sub InternalConstructor(ByVal strFormName As String, ByVal enuWindowState As FormWindowState, ByVal objLocation As Point, ByVal objSize As Size)
        mstrFormName = strFormName
        mintWindowState = enuWindowState
        mobjLocation = objLocation
        mobjSize = objSize

    End Sub
#End Region

#Region "Properties"
    Public Property FormName() As String
        Get
            Return mstrFormName
        End Get
        Set(ByVal Value As String)
            mstrFormName = Value
        End Set
    End Property

    Public Property WindowState() As FormWindowState
        Get
            Return mintWindowState
        End Get
        Set(ByVal Value As FormWindowState)
            mintWindowState = Value
        End Set
    End Property

    Public Property Location() As Point
        Get
            Return mobjLocation
        End Get
        Set(ByVal Value As Point)
            mobjLocation = Value
        End Set
    End Property

    Public Property Size() As Size
        Get
            Return mobjSize
        End Get
        Set(ByVal Value As Size)
            mobjSize = Value
        End Set
    End Property

#End Region


End Class
