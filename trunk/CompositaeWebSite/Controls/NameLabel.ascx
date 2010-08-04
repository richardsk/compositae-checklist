<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NameLabel.ascx.vb" Inherits="Controls_NameLabel" %>

<link rel="stylesheet" type="text/css" href="../Includes/style.css" />

<table width="100%">
<tr>
<td>
    <asp:Label ID="Label1" runat="server" CssClass="nameLabel" Font-Bold="False" Text="Name:"></asp:Label></td>
<td>
    <asp:Label ID="canonicalLabel" runat="server" CssClass="canonicalLabel" Text="Label"></asp:Label>
    <asp:Label ID="authorsLabel" runat="server" CssClass="authorsLabel" Text="Label"></asp:Label></td>
</tr>
</table>
