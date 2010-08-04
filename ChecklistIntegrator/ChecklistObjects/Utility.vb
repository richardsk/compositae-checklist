Imports System.Xml
Imports System.Xml.Xsl

Public Class Utility

#Region "DB functions"
    Public Shared Function GetDBGuid(ByVal val As String) As Object
        Dim g As Object = DBNull.Value

        If Not val Is Nothing AndAlso val.Length > 0 Then
            g = New Guid(val)
        End If

        Return g
    End Function

    Public Shared Function GetDBInt(ByVal val As Integer) As Object
        Dim i As Object = DBNull.Value

        If val >= 0 Then
            i = val
        End If

        Return i
    End Function

    Public Shared Function GetDBString(ByVal val As String) As Object
        Dim s As Object = DBNull.Value

        If Not val Is Nothing Then
            s = val
        End If

        Return s
    End Function

    Public Shared Function GetDBStringNonEmpty(ByVal val As String) As Object
        Dim s As Object = DBNull.Value

        If Not val Is Nothing AndAlso val.Length > 0 Then
            s = val
        End If

        Return s
    End Function

    Public Shared Function GetDBDate(ByVal val As DateTime) As Object
        Dim d As Object = DBNull.Value

        If val <> DateTime.MinValue Then
            d = val
        End If

        Return d
    End Function

    Public Shared Function LongSPTimeout() As Integer
        'timeout in seconds for long SP calls
        Dim timeout As Integer = 180
        Try
            Dim tos As String = Configuration.ConfigurationManager.AppSettings.Get("LongSPCallSeconds")
            timeout = Integer.Parse(tos)
        Catch ex As Exception
        End Try
        Return timeout
    End Function

#End Region

#Region "Levenshtein"
    '*******************************
    '*** Get minimum of three values
    '*******************************

    Private Shared Function Minimum(ByVal a As Integer, _
                             ByVal b As Integer, _
                             ByVal c As Integer) As Integer
        Dim mi As Integer

        mi = a
        If b < mi Then
            mi = b
        End If
        If c < mi Then
            mi = c
        End If

        Return mi
    End Function

    '********************************
    '*** Compute Levenshtein Distance
    '********************************

    Public Shared Function LevenshteinPercent(ByVal s As String, ByVal t As String) As Double
        Dim maxLen As Integer = Math.Max(s.Length, t.Length)
        Dim ld As Integer = LevenshteinDistance(s, t)
        Return (CType((maxLen - ld) * 100, Double) / CType(maxLen, Double))
    End Function

    Public Shared Function LevenshteinDistance(ByVal s As String, ByVal t As String) As Integer

        Dim m As Integer ' length of t
        Dim n As Integer ' length of s
        Dim i As Integer ' iterates through s
        Dim j As Integer ' iterates through t
        Dim s_i As String ' ith character of s
        Dim t_j As String ' jth character of t
        Dim cost As Integer ' cost

        ' Step 1
        n = Len(s)
        m = Len(t)
        If n = 0 Then
            Return m
        End If
        If m = 0 Then
            Return n
        End If

        Dim d(0 To n, 0 To m) As Integer ' matrix

        ' Step 2
        For i = 0 To n
            d(i, 0) = i
        Next i

        For j = 0 To m
            d(0, j) = j
        Next j

        ' Step 3
        For i = 1 To n
            s_i = Mid$(s, i, 1)

            ' Step 4
            For j = 1 To m
                t_j = Mid$(t, j, 1)

                ' Step 5
                If s_i = t_j Then
                    cost = 0
                Else
                    cost = 1
                End If

                ' Step 6
                d(i, j) = Minimum(d(i - 1, j) + 1, d(i, j - 1) + 1, d(i - 1, j - 1) + cost)
            Next j
        Next i

        ' Step 7
        Return d(n, m)
    End Function

#End Region

#Region "Conversion"
    Public Shared Function ConvertToRomanNumerals(ByVal lngNumber As Long) As String
        Dim roman As String = ""

        lngNumber = Math.Abs(lngNumber)

        Dim lngThousands As Long
        Dim lngFiveHundreds As Long
        Dim lngHundreds As Long
        Dim lngFifties As Long
        Dim lngTens As Long
        Dim lngFives As Long
        Dim lngOnes As Long

        lngOnes = lngNumber
        lngThousands = lngOnes \ 1000
        lngOnes = lngOnes - lngThousands * 1000
        lngFiveHundreds = lngOnes \ 500
        lngOnes = lngOnes - lngFiveHundreds * 500
        lngHundreds = lngOnes \ 100
        lngOnes = lngOnes - lngHundreds * 100
        lngFifties = lngOnes \ 50
        lngOnes = lngOnes - lngFifties * 50
        lngTens = lngOnes \ 10
        lngOnes = lngOnes - lngTens * 10
        lngFives = lngOnes \ 5
        lngOnes = lngOnes - lngFives * 5

        roman = New String("M", lngThousands)

        If lngHundreds = 4 Then
            If lngFiveHundreds = 1 Then
                roman = roman & "CM"
            Else
                roman = roman & "CD"
            End If
        Else
            roman = roman & New String("D", lngFiveHundreds) & New String("C", lngHundreds)
        End If

        If lngTens = 4 Then
            If lngFifties = 1 Then
                roman = roman & "XC"
            Else
                roman = roman & "XL"
            End If
        Else
            roman = roman & New String("L", lngFifties) & New String("X", lngTens)
        End If

        If lngOnes = 4 Then
            If lngFives = 1 Then
                roman = roman & "IX"
            Else
                roman = roman & "IV"
            End If
        Else
            roman = roman & New String("V", lngFives) & New String("I", lngOnes)
        End If

        Return roman
    End Function
#End Region

#Region "Xslt"

    Public Shared Function XsltTranslate(ByVal xml As String, ByVal xslt As String) As String
        Dim transform As New XslCompiledTransform
        transform.Load(New XmlTextReader(New IO.StringReader(xslt)))

        Dim ms As New IO.MemoryStream()
        Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
        transform.Transform(New XmlTextReader(New IO.StringReader(xml)), writer)
        writer.Flush()

        ms.Position = 0
        Dim transXml As String = New IO.StreamReader(ms).ReadToEnd()

        writer.Close()

        Return transXml
    End Function

#End Region
End Class
