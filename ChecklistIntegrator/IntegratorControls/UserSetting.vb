Imports System.Xml
Imports System.Xml.Serialization
Imports System.Windows.Forms

''' <summary>
''' Allows the application to persist various options and settings.
''' </summary>
''' <remarks></remarks>
<Serializable()> _
Public NotInheritable Class UserSetting

    Public FormStateList As List(Of FormState)
    Public LastTransferDate As DateTime = DateTime.MinValue


#Region "Constructors"
    ''' <summary>
    ''' Setup default values for the user settings.
    ''' </summary>
    Public Sub New()
        FormStateList = New List(Of FormState)
    End Sub
#End Region


#Region "Methods"

    ''' <summary>
    ''' Load form position and size from user settings.
    ''' </summary>
    Public Sub LoadFormState(ByRef frm As Windows.Forms.Form)
        Dim objFormState As FormState = Nothing

        For Each objFormStateIterator As FormState In FormStateList
            If objFormStateIterator.FormName = frm.GetType.Name Then
                objFormState = objFormStateIterator
                Exit For
            End If
        Next objFormStateIterator

        If objFormState Is Nothing Then

            objFormState = New FormState(frm.GetType.Name, frm.WindowState, frm.Location, frm.Size)

            FormStateList.Add(objFormState)
        End If

        frm.WindowState = objFormState.WindowState
        frm.Size = objFormState.Size
        frm.Location = objFormState.Location
    End Sub

    ''' <summary>
    ''' Save the current form size and position to user settings.
    ''' </summary>
    Public Sub SaveFormState(ByRef frm As Windows.Forms.Form)
        Dim objFormState As FormState = Nothing

        For Each objFormStateIterator As FormState In FormStateList
            If objFormStateIterator.FormName = frm.GetType.Name Then
                objFormState = objFormStateIterator
                Exit For
            End If
        Next objFormStateIterator

        If objFormState Is Nothing Then
            objFormState = New FormState(frm.GetType.Name, frm.WindowState, frm.Location, frm.Size)

            FormStateList.Add(objFormState)
        End If

        If objFormState IsNot Nothing Then
            objFormState.WindowState = frm.WindowState

            If frm.WindowState = FormWindowState.Normal Then
                objFormState.Size = frm.Size
                objFormState.Location = frm.Location
            End If
        End If
    End Sub
#End Region

    Public Sub SaveSettings()
        Try
            ' Serialize the user settings into an XML file.
            Dim objSerializer As New Xml.Serialization.XmlSerializer(GetType(UserSetting))
            Dim dir As String = AppDomain.CurrentDomain.BaseDirectory + "\" + System.Configuration.ConfigurationManager.AppSettings.Get("UserSettingsLocation")
            Dim fname As String = dir + "\User.xml"

            If Not IO.Directory.Exists(dir) Then
                IO.Directory.CreateDirectory(dir)
            End If

            Using objWriter As New IO.StreamWriter(fname)
                objSerializer.Serialize(objWriter, Me)
                objWriter.Close()
            End Using
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try
    End Sub

    Public Function LoadSettings() As UserSetting
        Dim us As UserSetting
        Try
            Dim objSerializer As New Xml.Serialization.XmlSerializer(GetType(UserSetting))
            Dim fname As String = AppDomain.CurrentDomain.BaseDirectory + "\" + System.Configuration.ConfigurationManager.AppSettings.Get("UserSettingsLocation") + "\User.xml"

            Using objReader As New IO.StreamReader(fname)
                us = DirectCast(objSerializer.Deserialize(objReader), UserSetting)
                objReader.Close()
            End Using
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try

        Return us
    End Function
End Class
