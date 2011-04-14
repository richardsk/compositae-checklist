Module Module1

    Sub Main()

        Dim a As New CompositaeLSID.CompositaeLSIDAuthority
        Dim ctx As New LSIDFramework.LSIDRequestContext
        ctx.Lsid = New LSIDClient.LSID("urn:lsid:compositae.org:names:C9A677BD-2A67-4E9C-BC68-00005D792229")
        Dim mr As LSIDClient.MetadataResponse = a.doGetMetadata(ctx, New String() {"XML"})

        Dim rdr As New IO.StreamReader(mr.getMetadata())
        Dim res As String = rdr.ReadToEnd()
        rdr.Close()

        Console.WriteLine(res)

        Console.WriteLine("Press a key to exit")
        Console.ReadKey()
    End Sub

End Module
