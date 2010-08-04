Imports System.Windows.Forms

Public Class SearchResultCompare
    Implements IComparer

    Private mColumnIndex As enumColumn
    Private mAscending As Boolean
    Private mSortingOn As Boolean

    Enum enumColumn
        FullName = 0
        Parent
        CanonicalName
        YearOf
        YearOn
        Author
        Basionym
        'BasionymDate
        RankName
        RankSort
        Key
        LSID
    End Enum

    Public Property ColumnIndex() As Long
        Get
            Return mColumnIndex
        End Get
        Set(ByVal Value As Long)
            mColumnIndex = Value
        End Set
    End Property

    Public Property SortingOn() As Boolean
        Get
            Return mSortingOn
        End Get
        Set(ByVal Value As Boolean)
            mSortingOn = Value
        End Set
    End Property

    Public Property Ascending() As Boolean
        Get
            Return mAscending
        End Get
        Set(ByVal Value As Boolean)
            mAscending = Value
        End Set
    End Property

    Public Sub New(Optional ByVal Ascending As Boolean = True)
        mAscending = Ascending
    End Sub


    Public Function Compare(ByVal x As Object, ByVal y As Object) As Integer Implements IComparer.Compare

        If mSortingOn = False Then
            Return 0
        End If

        Select Case mColumnIndex
            Case enumColumn.Key
                Return NumberCompare(x, y)
            Case enumColumn.RankSort
                Return NumberCompare(x, y)
            Case Else
                Return DefaultCompare(x, y)

        End Select

    End Function


    Private Function NumberCompare(ByVal item1 As ListViewItem, ByVal item2 As ListViewItem) As Long
        Dim Number1 As Double = 0
        Dim Number2 As Double = 0
        If mColumnIndex >= item1.SubItems.Count Then
            Dim i As Integer = 0
        End If
        If mColumnIndex >= item2.SubItems.Count Then
            Dim i As Integer = 0
        End If
        Dim strNumber1 As String = item1.SubItems(mColumnIndex).Text
        Dim strNumber2 As String = item2.SubItems(mColumnIndex).Text
        If IsNumeric(strNumber1) Then
            Number1 = strNumber1
        End If

        If IsNumeric(strNumber2) Then
            Number2 = strNumber2
        End If

        If Number1 > Number2 Xor mAscending Then
            Return -1
        End If
        If Number1 < Number2 Xor mAscending Then
            Return 1
        End If
        Return 0

    End Function

    Private Function DefaultCompare(ByVal item1 As ListViewItem, ByVal item2 As ListViewItem) As Long

        If item1.SubItems(mColumnIndex).Text > item2.SubItems(mColumnIndex).Text Xor mAscending Then
            Return -1
        End If
        If item1.SubItems(mColumnIndex).Text < item2.SubItems(mColumnIndex).Text Xor mAscending Then
            Return 1
        End If
        Return 0

    End Function


End Class
