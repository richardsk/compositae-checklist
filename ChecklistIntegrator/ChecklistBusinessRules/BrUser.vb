Public Class BrUser

    Public Enum ReadWriteMode
        Read
        Edit
        None
        Unknown
    End Enum

    Private Shared providers As ChecklistObjects.UserProvider()

    Private Shared readMode As ReadWriteMode = ReadWriteMode.Unknown

    Public Shared ReadOnly Property UserProviders() As ChecklistObjects.UserProvider()
        Get
            If providers Is Nothing OrElse providers(0).UserPk <> ChecklistObjects.SessionState.CurrentUser.IdAsInt Then
                providers = ChecklistDataAccess.UserData.GetUserProviders(ChecklistObjects.SessionState.CurrentUser.IdAsInt)
            End If
            Return providers
        End Get
    End Property

    Public Shared Function GetSystemProviderImport() As ChecklistObjects.ProviderImport
        Dim pi As ChecklistObjects.ProviderImport

        Try
            'Get latest system ProviderImport for the latest UserProvider
            'UserProviders are ordered from newest to oldest
            'ProviderImports are also ordered from newest to oldest
            For Each up As ChecklistObjects.UserProvider In UserProviders
                If up.Provider.IsEditor Then
                    pi = up.ProviderImports(0)
                    Exit For
                End If
            Next
        Catch ex As Exception
        End Try

        Return pi
    End Function


    Public Shared Function GetReadWriteMode() As ReadWriteMode
        If readMode = ReadWriteMode.Unknown Then
            Dim sysPI As ChecklistObjects.ProviderImport = GetSystemProviderImport()
            If sysPI Is Nothing Then
                readMode = ReadWriteMode.Read
            Else
                readMode = ReadWriteMode.Edit
            End If
        End If
        Return readMode
    End Function

End Class
