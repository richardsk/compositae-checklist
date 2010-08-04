<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ReportControl.ascx.vb" Inherits="Controls_ReportControl" %>
<asp:Label ID="Label1" runat="server" CssClass="PageHeading" Text="Report" meta:resourcekey="Label1Resource1"></asp:Label>&nbsp;<br />
<br />
<asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Select Report Options:" meta:resourcekey="Label2Resource1"></asp:Label><br />
<br />
<asp:CheckBox ID="synonymsCheck" runat="server" Checked="True" Text="Include synonyms" meta:resourcekey="synonymsCheckResource1" /><br />
<asp:CheckBox ID="childrenCheck" runat="server" Checked="True" Text="Include child names" meta:resourcekey="childrenCheckResource1" /><br />
<asp:CheckBox ID="conflictCheck" runat="server" Text="Include indication of conflict in taxonomic concepts (slower)" meta:resourcekey="conflictCheckResource1" /><br />
<asp:CheckBox ID="IncludeDistCheck" runat="server" Checked="True" Text="Include distribution" meta:resourcekey="IncludeDistCheckResource1" /><br />
<br />
<asp:Button ID="genRepButton" runat="server" Text="Generate Report" meta:resourcekey="genRepButtonResource1" />
