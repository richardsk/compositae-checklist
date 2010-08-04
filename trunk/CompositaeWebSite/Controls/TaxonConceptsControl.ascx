<%@ Control Language="VB" AutoEventWireup="false" CodeFile="TaxonConceptsControl.ascx.vb" Inherits="Controls_TaxonConceptsControl" %>
<table width="100%" style="font-weight: normal; color: black">
    <tr>
        <td style="width:155px" >
            <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="medium" meta:resourcekey="Label1Resource1"
                Text="Name:"></asp:Label>
        </td>
        <td align="left" > 
            <asp:Label ID="nameLabel" runat="server" meta:resourcekey="nameLabelResource1" Text="Label" Font-Bold="True"></asp:Label></td>
    </tr>
</table>
<table width="100%" style="font-weight: normal; color: black; ">
    <tr>
        <td colspan="2">
            &nbsp;<asp:GridView ID="conceptsGrid" runat="server" meta:resourcekey="conceptsGridResource2" BorderStyle="None" CaptionAlign="Left" CellPadding="2" GridLines="None" HorizontalAlign="Left" >
                <HeaderStyle HorizontalAlign="Left" />
                <RowStyle HorizontalAlign="Left" />
            </asp:GridView>
            <asp:Label ID="errLabel" runat="server" meta:resourcekey="errLabelResource1" Text="No concepts"
                Visible="False"></asp:Label>
        </td>
    </tr>
</table>
