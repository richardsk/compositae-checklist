<%@ Control Language="VB" AutoEventWireup="false" CodeFile="TreeControl2.ascx.vb" Inherits="Controls_TreeControl2" %>

    <asp:CheckBox ID="CheckBox1" runat="server" ForeColor="black" Text="Show Synonyms" />
    <asp:Panel ID="treepanel" runat="server" ScrollBars="Auto" Width="240px" Height="450px" >
    <asp:TreeView ID="TreeView1" runat="server" CssClass="tree" NodeStyle-HorizontalPadding="3" >
 
    </asp:TreeView>
    </asp:Panel>
