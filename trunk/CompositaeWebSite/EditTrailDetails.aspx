<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditTrailDetails.aspx.vb" Inherits="EditTrailDetails" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label Font-Bold="True" ID="Label1" runat="server" CssClass="PageHeading" Text="Edit Trail for "></asp:Label><br />
        <br />
        <asp:GridView ID="EditDetailsGrid" runat="server" AutoGenerateColumns="False">
            <HeaderStyle BackColor="#DBBC57" />
        </asp:GridView>
        &nbsp;</div>
    </form>
</body>
</html>
