<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ConsensusControl.ascx.vb" Inherits="Controls_ConsensusControl" %>
<%@ Register Src="DistributionControl.ascx" TagName="DistributionControl" TagPrefix="uc1" %>

<script type="text/javascript">
    $(document).ready(function () {
        $.ajax({
            url: 'MapService.asmx/GetDistributionMapUrl?nameGuid=<%=NameID%>',
            method: "GET",
            timeout: 200000,
            success: function (mapUrl) {
                if (mapUrl == '') {
                    $('#ctl03_ConsensusControl1_distMapImage').hide();
                    $('#ctl03_ConsensusControl1_mapLabel').hide();
                    $('#loadingSpan').hide();
                }
                else {
                    $('#ctl03_ConsensusControl1_distMapImage').attr('src', mapUrl);
                    $('#loadingSpan').hide();
                    mapUrl = mapUrl.substring(0, mapUrl.length - 3); // 'change to big image size                     
                    $('#ctl03_ConsensusControl1_mapLink').attr('href', mapUrl + "1000");
                }
            }
        });
    }); 
</script>

<table class="NameDetails" id="detailsTbl" width="100%" style="font-size: smaller">
    <tr >
        <td style="width: 60%" valign="top">
            <asp:Table ID="FieldsTable" runat="server" Font-Bold="True">
            </asp:Table>
        </td>
        <td valign="top">
            &nbsp;<asp:Label ID="mapLabel" runat="server" Font-Bold="True" Font-Size="Larger"
                meta:resourcekey="mapLabelResource1" Text="Standardised Distribution Map"></asp:Label><br />
            <asp:HyperLink ID="mapLink" runat="server" Target="_blank">
                <span id="loadingSpan">Loading...</span>
                <asp:Image ID="distMapImage" runat="server" meta:resourcekey="distMapImageResource1" 
                    Width="340px" />
            </asp:HyperLink>
        </td>
    </tr>
</table>
<table>
    <tr>
        <td>
            <asp:Table runat="server" CssClass="NameDetails" ID="detailsTbl2" Width="100%" Style="font-size: smaller">
                <asp:TableRow>
                    <asp:TableCell ID="cell11" VerticalAlign="top" Width="90px">
                        <br />
                        <asp:Label ID="Label7" runat="server" Font-Bold="True" meta:resourcekey="Label7Resource1"
                            Text="Data Providers:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell runat="server" VerticalAlign="top">
                        <br />
                        <asp:Label ID="dataProvLabel" runat="server" meta:resourcekey="dataProvLabelResource1"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:Label ID="Label8" runat="server" Font-Bold="True" meta:resourcekey="Label8Resource1"
                            Text="LSID:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:Label ID="lsidLabel" runat="server" meta:resourcekey="lsidLabelResource1"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:Label ID="Label9" runat="server" Font-Bold="True" meta:resourcekey="Label9Resource1"
                            Text="Updated:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:Label ID="updatedLabel" runat="server" meta:resourcekey="updatedLabelResource1"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Edit trail:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:HyperLink ID="editDetailsLink" runat="server" Text="Details"></asp:HyperLink>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell ID="TableCell1" VerticalAlign="top" Width="90px">
                        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Credits:"></asp:Label>
                    </asp:TableCell>
                    <asp:TableCell ID="TableCell2" runat="server" VerticalAlign="top">
                        <asp:Label ID="creditsLabel" runat="server"></asp:Label>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>
    
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <br />
            <asp:Label Font-Size="smaller" ID="publicationNote" runat="server" meta:resourcekey="publicationNoteResource1">* Publication abbreviation not confirmed as standard</asp:Label><br />
        </td>
    </tr>
</table>
&nbsp; 