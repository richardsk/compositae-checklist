<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ProviderFieldDetails.aspx.vb" Inherits="ProviderFieldDetails" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Label Font-Bold="true" ID="Label1" runat="server" CssClass="PageHeading" Text="Provider Details for "></asp:Label><br />
        <br />
        <asp:GridView ID="DetailsGrid" runat="server" AutoGenerateColumns="False">
        </asp:GridView>
        &nbsp;</div>
    </form>
</body>
</html>
