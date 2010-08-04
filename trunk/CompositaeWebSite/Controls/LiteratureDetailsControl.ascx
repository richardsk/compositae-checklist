<%@ Control Language="VB" AutoEventWireup="false" CodeFile="LiteratureDetailsControl.ascx.vb" Inherits="Controls_LiteratureDetailsControl" %>
<p>
    <table border="0" cellpadding="8" cellspacing="0">
        <tr>
            <td nowrap="nowrap" style="width: 517px; height: 41px">
                <span class="PageHeading" style="font-size: 17pt">
                    <asp:Label ID="Label1" runat="server" meta:resourcekey="Label1Resource1" Text="Literature Details"></asp:Label></span></td>
        </tr>
        <tr>
            <td style="width: 517px; height: 41px;">
                <b>
                    <asp:Label ID="Label2" runat="server" meta:resourcekey="Label2Resource1" Text="Citation:"></asp:Label>
                </b><asp:Label ID="CitationLabel" runat="server" Text="Label" meta:resourcekey="CitationLabelResource1"></asp:Label><br /><br />
                <b>
                    <asp:Label ID="Label3" runat="server" meta:resourcekey="Label3Resource1" Text="LSID:"></asp:Label>
                </b><asp:Label ID="LSIDLabel" runat="server" Text="Label" meta:resourcekey="LSIDLabelResource1"></asp:Label></td>
        </tr>
    </table>
</p>
