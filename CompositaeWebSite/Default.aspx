<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto"  %>

<%@ Register Src="Controls/TreeControl2.ascx" TagName="TreeControl2" TagPrefix="uc3" %>

<%@ Register Src="Controls/TreeControl.ascx" TagName="TreeControl" TagPrefix="uc2" %>

<%@ Register Src="Controls/HomeControl.ascx" TagName="HomeControl" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Global Compositae Checklist</title>
    <link href="Includes/style.css" type="text/css" rel="stylesheet"/>

<script type="text/javascript">
    function getHeight()
    {
            var myWidth = 0, myHeight = 0;
            if( typeof( window.innerWidth ) == 'number' )
            {
                //Non-IE
                myWidth = window.innerWidth;
                myHeight = window.innerHeight;
            }
            else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) )
            {
                //IE 6+ in 'standards compliant mode'
                myWidth = document.documentElement.clientWidth;
                myHeight = document.documentElement.clientHeight;
            }
            else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) )
            {
                //IE 4 compatible
                myWidth = document.body.clientWidth;
                myHeight = document.body.clientHeight;
            }
            
        return myHeight;
        
    }

    function KeyDownHandler(e, btn)
    {
        if(!e) e=window.event;
        var key = e.keyCode ? e.keyCode : e.which;
    
        // process only the Enter key
        if (key == 13)
        {
            // cancel the default submit
            e.returnValue=false;
            e.cancel = true;
            // submit the form by programmatically clicking the specified button
            btn.click();
        }
    }

</script>
    
</head>

<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-15008713-1");
pageTracker._trackPageview();
} catch(err) {}</script>

<body onload="" >

    <form id="form1" runat="server" >
    
    
<center>
        <table border="0" cellpadding="1" cellspacing="0" width="95%" style="text-align:left">
            <tr>
                <td style="color: white; background-color: #dbbc57; width: 331px; vertical-align:top;padding-top:8px;padding-left:8px" rowspan="2"  >
                    <asp:HyperLink ID="ImageLink" NavigateUrl="~/Default.aspx" runat="server" Height="100px" meta:resourcekey="ImageLinkResource1" Text='&#13;&#10;                        <img alt="Compositae" src="Images/logo small.jpg" height="100x" style="border-style:none;" />&#13;&#10;                    ' ></asp:HyperLink>
                    <asp:HyperLink ID="homeLink" runat="server" meta:resourcekey="Label1Resource1"
                        Text="GLOBAL COMPOSITAE CHECKLIST" NavigateUrl="~/Default.aspx" Font-Underline="False" Font-Size="20pt" Width="192px" ForeColor="White" ></asp:HyperLink></td>
                <td style="color: white; background-color: #dbbc57;" align="right" valign="top">
                    <br />
                    <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/Default.aspx" CssClass="menu" Text="Home" meta:resourcekey="HyperLink2Resource2" ForeColor="White"></asp:HyperLink>&nbsp;&nbsp;&nbsp; | &nbsp;&nbsp;
                    <asp:HyperLink ID="HyperLink3" runat="server" CssClass="menu" meta:resourcekey="HyperLink3Resource1"
                        NavigateUrl="~/Default.aspx?Page=ProviderList" Text="Data Providers" ForeColor="White"></asp:HyperLink>
                    &nbsp; &nbsp; &nbsp;| &nbsp;&nbsp;
                    <asp:HyperLink ID="BibLink" runat="server" CssClass="menu" NavigateUrl="~/Default.aspx?Page=Bibliography" meta:resourcekey="BibLinkResource1" Text="Bibliography" ForeColor="White"></asp:HyperLink>
                    &nbsp;&nbsp; | &nbsp;&nbsp;
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Default.aspx?Page=About" CssClass="menu" meta:resourcekey="HyperLink1Resource1" Text="About" ForeColor="White"></asp:HyperLink>
                    &nbsp;&nbsp; | &nbsp;&nbsp;
                    <asp:HyperLink ID="FeedbackLink" runat="server" CssClass="menu" NavigateUrl="~/Default.aspx?Page=Feedback" meta:resourcekey="FeedbackLinkResource1" Text="Feedback" ForeColor="White"></asp:HyperLink>
                    &nbsp;&nbsp; &nbsp; &nbsp;
                    &nbsp;
                    &nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td align="left" style="color: white; background-color: #dbbc57; height: 39px;" valign="top">
                    <br />
                    </td>
            </tr>
        </table>
        
            <asp:Table ID="detailsTable" runat="server" width="95%">
                <asp:TableRow>
                    <asp:TableCell ID="leftMenuCell" runat="server" style="width: 230px; padding-top:5px;" VerticalAlign="top" HorizontalAlign="left">
                        <asp:Panel ID="searchPanel" runat="server" meta:resourcekey="searchPanelResource2" Width="98%">
                                    <asp:Label ID="Label1" runat="server" Text="Search Names " meta:resourcekey="Label1Resource2" Height="24px" CssClass="BlockHeader"></asp:Label><br />                                    
                                    <asp:DropDownList ID="searchField" runat="server" AutoPostBack="True" Width="225px"></asp:DropDownList><br />
                                    <asp:TextBox ID="SearchText" runat="server" Columns="21" MaxLength="100" meta:resourcekey="SearchTextResource1"></asp:TextBox>
                                    <asp:DropDownList ID="provCombo1" runat="server" Visible="False" Width="225px">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="countryCombo" runat="server" Visible="false" Width="225px" >
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="continentsCombo" runat="server" Visible="false" Width="225px">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="regionsCombo" runat="server" Visible="false" Width="225px" >
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="unitsCombo" runat="server" Visible="false" Width="225px">
                                    </asp:DropDownList>
                            <asp:Button ID="SearchButton" runat="server" meta:resourcekey="SearchButtonResource1" Text="Search" /><br />
                                    <asp:HyperLink ID="searchNamesLink" Font-Size="Smaller" runat="server" NavigateUrl="~/Default.aspx?Page=AdvNameSearch" Text="Advanced search" ForeColor="Black" meta:resourcekey="searchNamesLinkResource1" ></asp:HyperLink>
                                    &nbsp;
                                    <asp:HyperLink ID="HyperLink4" runat="server" ForeColor="Black" Font-Size="smaller"
                                        NavigateUrl="~/default.aspx?Page=About&amp;Tab=SearchHelp" Text="Search Help" meta:resourcekey="HyperLink4Resource2" Target="_blank"></asp:HyperLink>
                                    <br />
                            <br />
                        </asp:Panel>
                        <asp:Label ID="Label2" runat="server" Text="Browse Names" meta:resourcekey="Label2Resource1" Height="24px" CssClass="BlockHeader" Width="98%"></asp:Label>
                        <uc2:TreeControl ID="TreeControl1" runat="server" />

                    </asp:TableCell>
                
                    <asp:TableCell HorizontalAlign="left" VerticalAlign="top" width="100%" >                                   
                                    <asp:Panel ID="DetailsPanel" runat="server" BorderWidth="1px" BorderColor="White" meta:resourcekey="DetailsPanelResource1">
                        &nbsp;</asp:Panel>
                        &nbsp;
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            
            <span style="font-size:smaller">
                Use of this data allowable with&nbsp;
                <a href="Default.aspx?Page=About&Tab=Cite">due attribution</a>.
                
            </span>
        </center>
    </form>

</body>
</html>
        
