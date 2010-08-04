Imports System.Threading
Imports System.Security.Cryptography
Imports System.Text
Imports System.IO

Imports Diagnostics.Log

Public Class LcUtility

    Public Const MESSAGES_FILENAME_TAG As String = "Messages.html"
    Public Const ERROR_FILENAME As String = "Errors.html"
    Public Const ERROR_XML_FILENAME As String = "Errors.xml"

    Public Const HISTORY_FILENAME As String = "History.html"
    Public Const HISTORY_XML_FILENAME As String = "History.xml"

    Public Const ERROR_XSLT_FILENAME_TAG As String = "ErrorsXsltFilePath"
    Public Const HISTORY_XSLT_FILENAME_TAG As String = "HistoryXsltFilePath"

    Public Const HYBRID_FILENAME As String = "Hybrids.html"
    Public Const HYBRID_XSLT_FILENAME_TAG As String = "HybridXsltFilePath"
    Public Const HYBRID_XML_FILENAME As String = "Hybrids.xml"

    Public Const NOT_SET As String = "<Not Set>"

    Private Const PUBLIC_KEY_PATH As String = "ServerPublicKeyPath"

    Private Const IMAGES_TAG As String = "Images"

    Private Shared CancelForm As CancelProgressForm

#Region "Enums"

    Private Enum II
        blank = 0
        k
        k_m
        p_p
        p
        p_m
        c_p
        c
        c_m
        o_p
        o
        o_m
        f_p
        f
        f_m
        t_p
        t
        t_m
        a
        g
        g_m
        s
        s_m
        v
        cv
        h
        Tree
        x
        Root
        forma
    End Enum

    Private Enum enumTagState
        Text = 0
        Tag
    End Enum

#End Region


#Region "Public Functions and Subs"

    Public Shared Function GetTable(ByVal ds As DataSet, ByVal TableName As String) As DataTable
        Dim table As DataTable
        Try
            table = ds.Tables(TableName)
        Catch ex As Exception
            table = Nothing
        End Try

        Return table
    End Function



    'Public Shared Function GetServerPublicKey() As String
    '    Dim KeyFilePath As String = GetAppConfigValue(PUBLIC_KEY_PATH)
    '    If KeyFilePath = "" Then Return ""

    '    Dim Key As String = ""

    '    Dim fs As IO.FileStream
    '    Try
    '        fs = IO.File.Open(KeyFilePath, IO.FileMode.Open, IO.FileAccess.Read)
    '        Dim fr As New IO.StreamReader(fs)
    '        Key = fr.ReadToEnd
    '    Catch ex As Exception
    '        Debug.WriteLine(ex.Message)

    '        Key = ""
    '    Finally
    '        If Not fs Is Nothing Then fs.Close()
    '    End Try

    '    Return Key
    'End Function


    'Public Shared Function GetAppConfigValue(ByVal Key As String) As String
    '    Dim value As String = ""
    '    If Key Is Nothing Then Return value
    '    If Key = "" Then Return value

    '    Try
    '        value = Configuration.ConfigurationSettings.AppSettings.Get(Key)
    '    Catch ex As Exception
    '        Debug.WriteLine(ex.Message)
    '        ChecklistObjects.ChecklistException.LogError(ex)
    '        value = ""
    '    End Try

    '    If value Is Nothing Then Return ""
    '    Return value
    'End Function


    Public Shared Sub StartCancelDialog(ByVal Id As Guid, ByVal DoProgress As Boolean, ByVal ShowBeat As Boolean, ByVal TitleText As String, Optional ByVal DoNotSendToDB As Boolean = False)
        If Not CancelForm Is Nothing Then
            Try
                CancelForm.Close()
            Catch

            End Try
        End If



        CancelForm = New CancelProgressForm
        CancelForm.DoNotSendToDB = DoNotSendToDB
        CancelForm.Id = Id
        CancelForm.DoProgress = DoProgress
        CancelForm.ShowBeat = True
        CancelForm.FormTitle = TitleText

        Dim CancelThreadStart As New ThreadStart(AddressOf ShowCancelDialog)
        ' Create a Thread object. 
        Dim CancelThread As New Thread(CancelThreadStart)
        ' Starting the thread invokes the ThreadStart delegate.
        CancelThread.Start()

    End Sub

    Private Shared Sub ShowCancelDialog()
        CancelForm.ShowDialog()
    End Sub

    Public Shared Sub EndCancelForm()
        CancelForm.EndDialog = True
    End Sub

    Public Shared ReadOnly Property CancelRequested()
        Get
            If CancelForm Is Nothing Then
                Return False
            End If
            Return CancelForm.CancelRequestSent
        End Get
    End Property


    Public Shared Function StripTags(ByVal Text As String) As String
        Dim strOutput As String = ""

        Dim length As Long = Text.Length
        Dim StartIndex As Long = 0
        Dim EndIndex As Long = 0
        Dim index As Long
        Dim TagState As enumTagState = enumTagState.Text
        For index = 0 To length - 1
            Dim c As Char = Text.Chars(index)
            If TagState = enumTagState.Text And c = "<" Then
                TagState = enumTagState.Tag
                EndIndex = index
                strOutput &= Text.Substring(StartIndex, EndIndex - StartIndex)
            End If
            If TagState = enumTagState.Tag And c = ">" Then
                TagState = enumTagState.Text
                StartIndex = index + 1
            End If
        Next
        If TagState = enumTagState.Text Then
            strOutput &= Text.Substring(StartIndex, length - StartIndex)
        End If

        Return strOutput
    End Function

    'for Default user id, use id less than one 

    'Public Shared Function GetUserSetting(ByVal Form As String, ByVal Control As String, ByVal Parameter As String) As String
    '    If LcNameLiteratureInterface.NameLiteratureSessionState Is Nothing Then
    '        Return ""
    '    End If
    '    Return GetUserSetting(LcNameLiteratureInterface.NameLiteratureSessionState.UserKey, Form, Control, Parameter)
    'End Function

    'Public Shared Function GetUserSetting(ByVal UserKey As Long, ByVal Form As String, ByVal Control As String, ByVal Parameter As String) As String
    '    Dim Value As String = ""

    '    Dim marshall As LcNameLiteratureInterface = New LcNameLiteratureInterface
    '    Value = marshall.WebGetUserSetting(UserKey, Form, Control, Parameter)

    '    Return Value
    'End Function

    'Public Shared Sub UpdateUserSetting(ByVal Form As String, ByVal Control As String, ByVal Parameter As String, ByVal Value As String)
    '    If LcNameLiteratureInterface.NameLiteratureSessionState Is Nothing Then
    '        Return
    '    End If
    '    UpdateUserSetting(LcNameLiteratureInterface.NameLiteratureSessionState.UserKey, Form, Control, Parameter, Value)
    'End Sub

    'Public Shared Function UpdateUserSetting(ByVal UserKey As Long, ByVal Form As String, ByVal Control As String, ByVal Parameter As String, ByVal Value As String) As Date
    '    Dim DateLastChanged As Date

    '    Dim marshall As LcNameLiteratureInterface = New LcNameLiteratureInterface
    '    DateLastChanged = marshall.WebUpdateUserSetting(UserKey, Form, Control, Parameter, Value)

    '    Return DateLastChanged
    'End Function

    'Public Shared Sub DeleteUserSetting(ByVal userKey As Long, ByVal form As String, ByVal control As String, ByVal parameter As String)
    '    Dim marshall As LcNameLiteratureInterface = New LcNameLiteratureInterface
    '    marshall.WebDeleteUserSetting(userKey, form, control, parameter)
    'End Sub

    Public Shared Function GetImageIndex_x(ByVal RankName As String) As Long
        Select Case RankName
            Case "none" '2
                Return II.blank
            Case "kingdom" '4
                Return II.k
            Case "subkingdom" '6
                Return II.k_m
            Case "superphylum" '7
                Return II.p_p
            Case "phylum" '8
                Return II.p
            Case "subphylum" '10
                Return II.p_m
            Case "superclass" '11
                Return II.c_p
            Case "class" '12
                Return II.c
            Case "subclass" '13
                Return II.c_m
            Case "infraclass" '14
                Return II.c_m
            Case "superorder" '15
                Return II.o_p
            Case "order" '16
                Return II.o
            Case "suborder" '18
                Return II.o_m
            Case "infraorder" '19
                Return II.o_m
            Case "superfamily" '20
                Return II.f_p
            Case "family" '22
                Return II.f
            Case "subfamily" '23
                Return II.f_m
            Case "tribe" '24
                Return II.t
            Case "subtribe" '26
                Return II.t_m
            Case "anamorph" '28
                Return II.a
            Case "genus" '30
                Return II.g
            Case "subgenus" '32
                Return II.g_m
            Case "section" '34
                Return II.blank
            Case "subsection" '36
                Return II.blank
            Case "series" '38
                Return II.blank
            Case "subseries" '40
                Return II.blank
            Case "species" '42
                Return II.s
            Case "subsp." '44
                Return II.s_m
            Case "var." '46
                Return II.v
            Case "subvar." '48
                Return II.v
            Case "f." '50
                Return II.blank
            Case "subforma" '52
                Return II.blank
            Case "serovar" '54
                Return II.blank
            Case "phagovar" '54
                Return II.blank
            Case "pv." '54
                Return II.blank
            Case "f.sp." '54
                Return II.blank
            Case "biovar" '54
                Return II.blank
            Case "ß" '56
                Return II.blank
            Case "a" '56
                Return II.blank
            Case "?" '56
                Return II.blank
            Case "d" '56
                Return II.blank
            Case "" '57
                Return II.blank
            Case "cv" '58
                Return II.cv
            Case "graft hybrid" '58
                Return II.h
            Case "hybrid formula" '58
                Return II.h
            Case "intergen hybrid" '58
                Return II.h
            Case "intragen hybrid" '58
                Return II.h

            Case Else
                Return 0
        End Select
    End Function

    'order in imagelist critical
    Public Shared Function GetImageIndex(ByVal RankKey As Long) As Long
        Select Case RankKey
            Case 16
                Return II.blank
            Case 15
                Return II.k
            Case 30
                Return II.k_m
            Case 41
                Return II.p_p
            Case 19
                Return II.p
            Case 48 'division
                Return II.p
            Case 32
                Return II.p_m
            Case 38
                Return II.c_p
            Case 3
                Return II.c
            Case 26
                Return II.c_m
            Case 11
                Return II.c_m
            Case 40
                Return II.o_p
            Case 17
                Return II.o
            Case 31
                Return II.o_m
            Case 12
                Return II.o_m
            Case 39
                Return II.f_p
            Case 7
                Return II.f
            Case 27
                Return II.f_m
            Case 42
                Return II.t_p
            Case 43
                Return II.t
            Case 36
                Return II.t_m
            Case 1
                Return II.a
            Case 8
                Return II.g
            Case 29
                Return II.g_m

            Case 24
                Return II.s
            Case 35
                Return II.s_m
            Case 44
                Return II.v
            Case 37 'subvar
                Return II.v

            Case 5
                Return II.forma

            Case 4
                Return II.cv

            Case Else
                Return II.blank

        End Select
    End Function

    Public Shared Function GetMessagesFileName() As String
        Return GetNonVersionedAppDataPath() & "\" & MESSAGES_FILENAME_TAG
    End Function

    'Private Shared Sub CopyImages()
    '    Dim destination_path As String = GetNonVersionedAppDataPath() & "\" & IMAGES_TAG

    '    Try
    '        IO.Directory.CreateDirectory(destination_path)
    '    Catch ex As Exception
    '        ChecklistObjects.ChecklistException.LogError(ex)
    '        Return
    '    End Try

    '    'Dim source_path As String = ""
    '    'Try
    '    '    Dim exe_info As IO.DirectoryInfo = IO.Directory.GetParent(Application.ExecutablePath)
    '    '    Dim source_info As IO.DirectoryInfo = exe_info.Parent
    '    '    source_path = source_info.FullName()
    '    'Catch ex As Exception
    '    '    LogEvent(ex.Message, EventLogEntryType.Error)
    '    '    source_path = ""
    '    'End Try

    '    'If source_path = "" OrElse IO.Directory.Exists(source_path & "\" & IMAGES_TAG) = false Then
    '    '    source_path = LcUtility.GetAppConfigValue("Images")
    '    'End If

    '    Dim source_path As String = LcUtility.GetAppConfigValue("Images")
    '    If source_path = "" OrElse IO.Directory.Exists(source_path) = False Then Return

    '    Dim files As String() = IO.Directory.GetFiles(source_path)
    '    If files Is Nothing OrElse files.Length = 0 Then Return

    '    Dim filename As String
    '    For Each filename In files
    '        Dim fi As New IO.FileInfo(filename)
    '        Dim destination As String = destination_path & "\" & fi.Name
    '        Try
    '            IO.File.Copy(filename, destination, True)
    '        Catch ex As Exception
    '            Debug.WriteLine(ex.Message)
    '        End Try

    '    Next


    'End Sub

    'Public Shared Sub CreateMessageFile()
    '    Dim MessagesFilePath As String = GetMessagesFileName()

    '    If File.Exists(MessagesFilePath) Then
    '        Return
    '    End If

    '    CopyImages()

    '    Dim html As String = "<html><body>"

    '    Dim fs As IO.FileStream
    '    Dim sw As IO.StreamWriter
    '    Try
    '        fs = IO.File.Create(MessagesFilePath)
    '        sw = New IO.StreamWriter(fs, System.Text.Encoding.Unicode)
    '        sw.Write(html)
    '    Catch ex As Exception
    '        LogEvent(ex.Message, EventLogEntryType.Error)
    '    Finally
    '        If Not sw Is Nothing Then sw.Close()
    '        If Not fs Is Nothing Then fs.Close()
    '    End Try

    'End Sub

    'Public Shared Sub AddMessage(ByVal Message As String, Optional ByVal ImagePath As String = "")
    '    CreateMessageFile()

    '    Dim MessagesFilePath As String = GetMessagesFileName()
    '    If MessagesFilePath = "" Then Return

    '    Dim HtmlMessage = "<BR> <img src=""" & ImagePath & """ > <span class=""DateClass"">" & Now() & "</span>: " & "<span class=""MessageClass"">" & Message & "</span>"

    '    Dim fs As IO.FileStream
    '    Dim sw As IO.StreamWriter
    '    Try
    '        fs = IO.File.Open(MessagesFilePath, IO.FileMode.Append)
    '        sw = New IO.StreamWriter(fs, System.Text.Encoding.Unicode)
    '        sw.Write(HtmlMessage)
    '    Catch ex As Exception
    '        LogEvent(ex.Message, EventLogEntryType.Error)
    '    Finally
    '        If Not sw Is Nothing Then sw.Close()
    '        If Not fs Is Nothing Then fs.Close()
    '    End Try

    'End Sub

    Public Shared Function IsByteArrayEqual(ByVal b1 As Byte(), ByVal b2 As Byte()) As Boolean
        If b1.Length <> b2.Length Then Return False

        Dim index As Long
        For index = 0 To b1.Length - 1
            If b1(index) <> b2(index) Then Return False
        Next

        Return True
    End Function

    Public Shared Function AToB(ByVal szString As String) As Byte()
        If szString.Length = 0 Then Return Nothing
        Dim i As Integer
        Dim btRet(szString.Length - 1) As Byte
        For i = 0 To szString.Length - 1
            btRet(i) = Asc(szString.Chars(i))
        Next
        Return btRet
    End Function

    Public Shared Function BToA(ByVal btBytes() As Byte) As String
        Dim szRet As String
        Dim i As Integer
        For i = LBound(btBytes) To UBound(btBytes)
            szRet = szRet & Chr(btBytes(i))
        Next
        Return szRet
    End Function

    Public Sub BtoDebug(ByVal b As Byte())
        If b Is Nothing Then Return

        Dim i As Integer
        For i = 0 To b.Length - 1
            Debug.Write(b(i).ToString & " ")
        Next
        Debug.WriteLine("")
    End Sub

    Public Shared Function CopyBytes(ByVal source As Byte()) As Byte()
        If source Is Nothing Then Return Nothing

        Dim dest(source.Length) As Byte
        Array.Copy(source, dest, source.Length)

        Return dest
    End Function

    Public Shared Function StringsEqual_ci(ByVal s1 As String, ByVal s2 As String) As Boolean
        Return (String.Compare(s1, s2, True) = 0)
    End Function

    Public Shared Function StringsEqual_ci(ByVal s1 As String, ByVal s2 As String, ByVal Length As Integer) As Boolean
        Return (String.Compare(s1, 0, s2, 0, Length, True) = 0)
    End Function

    Public Shared Function GetHashString(ByVal RawHashText As String) As String
        Return Convert.ToBase64String(GetHash(RawHashText))
    End Function

    Public Shared Function GetHash(ByVal data As String) As Byte()

        Dim HashValue() As Byte

        'Create a new instance of UnicodeEncoding to 
        'convert the string into an array of Unicode bytes.
        Dim UE As New UnicodeEncoding

        'Convert the string into an array of bytes.
        Dim MessageBytes As Byte() = UE.GetBytes(data)

        'Create a new instance of SHA1Managed to create 
        'the hash value.
        Dim SHhash As New SHA1Managed

        'Create the hash value from the array of bytes.
        HashValue = SHhash.ComputeHash(MessageBytes)

        Return HashValue

        'Return UE.GetString(HashValue)
    End Function

    Public Shared Function EncryptString(ByVal PublicKey As String, ByVal Data As String) As Byte()
        If PublicKey = "" Then Return Nothing

        Dim byteData As Byte() = LcUtility.AToB(Data)


        Dim cspParam As CspParameters = New CspParameters
        cspParam.Flags = CspProviderFlags.UseMachineKeyStore
        Dim RSA As RSACryptoServiceProvider = New RSACryptoServiceProvider(cspParam)
        'Dim RSA As New RSACryptoServiceProvider

        Try
            RSA.FromXmlString(PublicKey)
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
            Return Nothing
        End Try

        Dim EncryptedData As Byte() = Nothing

        If byteData Is Nothing Then
            Return Nothing
        Else
            Try
                EncryptedData = RSA.Encrypt(byteData, False)
            Catch ex As Exception
                Debug.WriteLine(ex.Message)
                Return Nothing
            End Try
        End If

        Return EncryptedData
    End Function

#End Region

    'Public Shared Function GetStringKeyFromLong(ByVal Key As Long) As String
    '    Dim marshall As New LcNameLiteratureInterface()
    '    Dim ds As DsName = Nothing
    '    Try
    '        ds = marshall.WebSelectNameDetails(Key)
    '    Catch ex As Exception
    '        ds = Nothing
    '    End Try

    '    If ds Is Nothing Then Return ""

    '    If ds.tblName.Count < 1 Then Return ""



    '    Return ds.tblName(0).NameGuid

    'End Function





    Public Shared Function ToIntOrNegOne(ByVal strValue As String) As Integer
        If IsNumeric(strValue) Then
            Dim Value As Integer = Val(strValue)
            If Value < 0 Then
                Value = -1
            End If
            Return Value
        Else
            Return -1
        End If
    End Function

    Public Shared Sub SetIntLongDblProperty(ByRef TheProperty As Object, ByVal Value As String)
        If Not (TheProperty.GetType Is GetType(Integer) Or TheProperty.GetType Is GetType(Long) Or TheProperty.GetType Is GetType(Double)) Then
            Return
        End If
        If Value Is Nothing Then
            Return
        End If
        If IsNumeric(Value) = False Then
            Return
        End If

        TheProperty = Value
    End Sub

    Public Shared Sub SetXPointDblProperty(ByRef p As Point, ByVal Value As String)

        If Value Is Nothing Then
            Return
        End If
        If IsNumeric(Value) = False Then
            Return
        End If

        Dim x As Integer = Val(Value)

        Dim p2 As New Point(x, p.Y)

        p = p2
    End Sub

    Public Shared Sub SetYPointDblProperty(ByRef p As Point, ByVal Value As String)

        If Value Is Nothing Then
            Return
        End If
        If IsNumeric(Value) = False Then
            Return
        End If

        Dim y As Integer = Val(Value)

        Dim p2 As New Point(p.X, y)

        p = p2
    End Sub





    Public Shared Function StripSpaces(ByVal InText As String) As String
        Dim OutText As String = ""
        If InText Is Nothing Then
            InText = ""
        End If
        OutText = Replace(InText, " ", "")
        Return OutText
    End Function

    Public Shared Function GetKeyFromRow(ByVal row As DataRow, ByVal ColumnName As String) As Long
        If row Is Nothing Then Return -1
        Dim UniqueKey As String = -1
        Try
            Dim objKey As Object = row.Item(ColumnName)
            UniqueKey = objKey
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
            Return -1
        End Try
        Return UniqueKey
    End Function

    Public Shared Function GetStringKeyFromRow(ByVal row As DataRow, ByVal ColumnName As String) As String
        Dim Key As String = ""

        If row Is Nothing Then Return Key

        Try
            Dim objKey As Object = row.Item(ColumnName)
            Key = objKey
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
            Return Key
        End Try
        Return Key
    End Function

    Public Shared Sub SetKeyInRow(ByVal row As DataRow, ByVal ColumnName As String, ByVal UniqueKey As String)
        If row Is Nothing Then Return

        Try
            If LcUtility.KeyNotSet(UniqueKey) Then
                row.Item(ColumnName) = DBNull.Value
            Else
                row.Item(ColumnName) = UniqueKey
            End If
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
        End Try
    End Sub

    Public Shared Sub SetStringKeyInRow(ByVal row As DataRow, ByVal ColumnName As String, ByVal Key As String)
        If row Is Nothing Then Return

        Try
            If Key = "" Then
                row.Item(ColumnName) = DBNull.Value
            Else
                row.Item(ColumnName) = Key
            End If
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
        End Try
    End Sub

    Public Shared Sub SetTextInRow(ByVal row As DataRow, ByVal ColumnName As String, ByVal Text As String)
        If row Is Nothing Then Return

        Try
            row.Item(ColumnName) = Text
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
        End Try
    End Sub


    Public Shared Function EqualAndGreaterThan15(ByVal x As Integer, ByVal y As Integer) As Boolean
        If x < 16 Or y < 16 Then Return False

        Return (x And 112) = (y And 112)
    End Function

    'Public Shared Sub ShowMsg(ByVal MessageText As String, ByVal Style As MsgBoxStyle, ByVal Title As String, Optional ByVal PreserveMessage As Boolean = False)

    '    If PreserveMessage Then
    '        Const PATH As String = "Images/"
    '        Dim ImagePath As String = ""
    '        Dim EventType As EventLogEntryType = EventLogEntryType.Information

    '        If EqualAndGreaterThan15(Style, MsgBoxStyle.Critical) Then
    '            ImagePath = PATH & "Critical.gif"
    '            EventType = EventLogEntryType.Error
    '        ElseIf EqualAndGreaterThan15(Style, MsgBoxStyle.Information) Then
    '            ImagePath = PATH & "Info.gif"
    '            EventType = EventLogEntryType.Information
    '        ElseIf EqualAndGreaterThan15(Style, MsgBoxStyle.Exclamation) Then
    '            ImagePath = PATH & "Exclamation.gif"
    '            EventType = EventLogEntryType.Warning
    '        Else
    '            ImagePath = PATH & "Info.gif"
    '            EventType = EventLogEntryType.Information
    '        End If

    '        LogEvent(MessageText, EventType)
    '        AddMessage(MessageText, ImagePath)
    '    End If


    '    MsgBox(MessageText, Style, Title)

    'End Sub

    Public Shared Function KeyNotSet(ByVal objUniqueKey As Object) As Boolean
        If objUniqueKey Is Nothing Then Return True
        If objUniqueKey Is DBNull.Value Then Return True
        Dim UniqueKey As String = ""
        Try
            UniqueKey = objUniqueKey
        Catch ex As Exception
            Return True
        End Try

        Return KeyNotSet(UniqueKey)
    End Function

    Public Shared Function KeyNotSet(ByVal UniqueKey As String) As Boolean
        If Trim(UniqueKey) = "" Then Return True
        If Trim(UniqueKey) = "-1" Then Return True
        If Trim(UniqueKey) = "0" Then Return True
        Return False
    End Function

    'Public Shared Function GetRankKeyByRankText(ByVal RankText As String) As Long
    '    Dim RankKey As Long = -1

    '    Dim marshall As New LcNameLiteratureInterface

    '    Dim objDsRanks As DsRanks = marshall.WebFillRanks()
    '    Dim table As DsRanks.tblTaxonRankDataTable = objDsRanks.tblTaxonRank
    '    Dim row As DsRanks.tblTaxonRankRow

    '    For Each row In table
    '        If row.TaxonRankName = RankText Then
    '            Return row.TaxonRankPk
    '        End If
    '    Next

    '    Return RankKey
    'End Function


    Private Shared Function GetIV() As Byte()
        Return New Byte() {&H12, &H34, &H56, &H78, &H90, &HAB, &HCD, &HEF}
    End Function

    Private Shared Function GetKey(ByVal strKey As String) As Byte()
        Dim Key() As Byte = AToB(strKey)
        Dim length As Integer = strKey.Length

        If length > 24 Then
            Key = AToB(strKey.Substring(0, 24))
        ElseIf length < 24 Then
            Key = AToB(strKey)
            ReDim Preserve Key(23)
        Else
            Key = AToB(strKey)
        End If

        Return Key
    End Function

    Public Shared Function SymetricEncrypt(ByVal RawText As String, ByVal strKey As String) As String

        Dim Key As Byte() = GetKey(strKey)
        Dim IV As Byte() = GetIV()

        Dim strinput As [String] = RawText
        Dim bytearrayinput As [Byte]() = ConvertStringToByteArray(strinput)

        Dim ms As New MemoryStream
        'DES instance with random key
        Dim des As New TripleDESCryptoServiceProvider
        'create DES Encryptor from this instance
        Dim desencrypt As ICryptoTransform = des.CreateEncryptor(Key, IV)
        'Create Crypto Stream that transforms file stream using des encryption
        Dim cryptostream As New CryptoStream(ms, desencrypt, CryptoStreamMode.Write)
        'write out DES encrypted file
        cryptostream.Write(bytearrayinput, 0, bytearrayinput.Length)

        cryptostream.Close()

        Return Convert.ToBase64String(ms.ToArray())
    End Function

    Public Shared Function SymetricDecrypt(ByVal EncryptedText As String, ByVal strKey As String) As String
        Dim EncryptedData As Byte() = Convert.FromBase64String(EncryptedText)

        Dim Key() As Byte = GetKey(strKey)
        Dim IV As Byte() = GetIV()

        Dim ms As New MemoryStream
        'DES instance with random key
        Dim des As New TripleDESCryptoServiceProvider
        'create DES Encryptor from this instance
        Dim desencrypt As ICryptoTransform = des.CreateDecryptor(Key, IV)

        Dim dncStream As New CryptoStream(ms, desencrypt, CryptoStreamMode.Read)

        ms.Write(EncryptedData, 0, EncryptedData.Length)
        ms.Position = 0

        'Read the stream.
        Dim SReader As New StreamReader(dncStream, System.Text.Encoding.Unicode)
        Dim strOut As String = SReader.ReadToEnd()
        dncStream.Close()

        Return strOut
    End Function

    Public Shared Function ConvertStringToByteArray(ByVal s As [String]) As [Byte]()
        Return (New UnicodeEncoding).GetBytes(s)
    End Function 'ConvertStringToByteArray

    Public Shared Function GetObjectFromRow(ByVal Row As DataRow, ByVal Field As String)
        If Row Is Nothing Then Return Nothing
        If Row.ItemArray.Length = 0 Then Return Nothing

        Dim obj As Object = Nothing

        Try
            obj = Row.Item(Field)
        Catch ex As Exception
            obj = Nothing
        End Try

        Return obj
    End Function

    Public Shared Sub MergeTable(ByVal DestTable As DataTable, ByVal SourceDataset As DataSet)
        If DestTable Is Nothing Then Return
        If SourceDataset Is Nothing Then Return

        Dim SourceTable As DataTable = GetTable(SourceDataset, DestTable.TableName)
        If SourceTable Is Nothing Then Return

        Dim SourceRow As DataRow
        For Each SourceRow In SourceTable.Rows
            Dim DestRow As DataRow = DestTable.NewRow()


            Dim column As DataColumn
            For Each column In DestTable.Columns
                Dim SourceObject As Object = GetObjectFromRow(SourceRow, column.ColumnName)
                DestRow(column.ColumnName) = SourceObject
            Next

            DestTable.Rows.Add(DestRow)
        Next

    End Sub

    Private Enum BlockState
        PreBlockState
        InBlockState
        PostBlockState
    End Enum

    'correct selection of text within string for html tagging
    'leading and trailing spaces are put outside blocks
    Public Shared Function BlockText(ByVal StartBlock As String, ByVal RawText As String, ByVal EndBlock As String) As String

        If RawText.Length = 0 Then
            Return ""
        End If

        Dim PreBlock As String = ""
        Dim MidBlock As String = ""
        Dim PostBlock As String = ""

        Dim index As Integer

        Dim EndIndex As Integer = 0
        For index = RawText.Length - 1 To 0 Step -1
            Dim c As Char = RawText.Chars(index)
            If Not Char.IsWhiteSpace(c) Then
                EndIndex = index
                Exit For
            End If
        Next

        Dim state As BlockState = BlockState.PreBlockState

        For index = 0 To RawText.Length - 1
            Dim c As Char = RawText.Chars(index)

            If index > EndIndex Then
                state = BlockState.PostBlockState
            End If

            If state = BlockState.PreBlockState Then
                If Char.IsWhiteSpace(c) Then
                    PreBlock &= c
                Else
                    MidBlock &= c
                    state = BlockState.InBlockState
                End If

            ElseIf state = BlockState.InBlockState Then
                MidBlock &= c

            ElseIf state = BlockState.PostBlockState Then
                PostBlock &= c
            End If

        Next

        Return (PreBlock & StartBlock & MidBlock & EndBlock & PostBlock)
    End Function

    Public Shared Function GetAuthorText(ByVal InText As String) As String
        If InText Is Nothing Then Return Nothing

        Dim WorkingText As String = ""

        Dim c As Char
        For Each c In InText
            Dim c2 As Char = c
            If Not Char.IsLetterOrDigit(c) Then
                c2 = " "
            End If
            WorkingText &= c2
        Next

        Dim part As String() = WorkingText.Split(" ")
        Dim str As String

        Dim OutText As String = ""
        For Each str In part
            If str <> "" Then
                If str.Length > 2 Then
                    OutText &= " " & str
                End If
            End If
        Next


        Return Trim(OutText)
    End Function

    Public Shared Function GetNonVersionedAppDataPath() As String
        Dim info As IO.DirectoryInfo = IO.Directory.GetParent(Application.UserAppDataPath)
        Dim FullName As String = info.FullName

        If Not IO.Directory.Exists(FullName) Then
            IO.Directory.CreateDirectory(FullName)
        End If

        Return FullName
    End Function

#Region "row helpers"

    Private Function GetFirstRowOfFirstTable(ByVal ds As DataSet) As DataRow
        Dim table As DataTable = GetFirstTable(ds)
        If table.Rows.Count = 0 Then Return Nothing

        Return table.Rows(0)
    End Function

    Private Function GetFirstTable(ByVal ds As DataSet) As DataTable
        If ds Is Nothing Then Return Nothing
        If ds.Tables.Count = 0 Then Return Nothing

        Return ds.Tables(0)
    End Function

    Public Shared Function GetStringFromRow(ByVal row As DataRow, ByVal FieldName As String) As String

        Dim obj As Object
        Try
            obj = row.Item(FieldName)
        Catch ex As System.ArgumentException
            Return ""
        End Try

        If obj Is System.DBNull.Value Then
            Return ""
        End If

        Return CType(obj, String)

    End Function



    Public Shared Function GetNumber(ByVal row As DataRow, ByVal FieldName As String) As Long

        Dim obj As Object
        Try
            obj = row.Item(FieldName)
        Catch ex As System.ArgumentException
            Return 0
        End Try

        If obj Is System.DBNull.Value Then
            Return 0
        End If

        Return CType(obj, Long)

    End Function

    Public Shared Function GetBoolean(ByVal row As DataRow, ByVal FieldName As String) As Boolean

        Dim obj As Object
        Try
            obj = row.Item(FieldName)
        Catch ex As System.ArgumentException
            Return False
        End Try

        If obj Is System.DBNull.Value Then
            Return False
        End If

        Return CType(obj, Boolean)

    End Function

    Public Shared Function GetGuid_NullToEmpty(ByVal row As DataRow, ByVal FieldName As String) As Guid

        Dim obj As Object
        Try
            obj = row.Item(FieldName)
        Catch ex As System.ArgumentException
            Return Guid.Empty
        End Try

        If obj Is System.DBNull.Value Then
            Return Guid.Empty
        End If

        Return CType(obj, Guid)
    End Function



#End Region

End Class
