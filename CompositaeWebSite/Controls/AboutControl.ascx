<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AboutControl.ascx.vb" Inherits="Controls_AboutControl" %>
<div style="padding-left:8px;">

<table>
    <tr>
    <td valign="top">
        <a href="Default.aspx?Page=About&Tab=About">About</a>
        <br />
        <a href="Default.aspx?Page=About&Tab=Tree">Tree</a>
        <br /> 
        <a href="Default.aspx?Page=About&Tab=Taxonomy">Taxonomy</a>
        <br /> 
        <a href="Default.aspx?Page=About&Tab=Cite">How to cite</a>
        <br /> 
        <a href="Default.aspx?Page=About&Tab=Ack">Acknowledgements</a>
        <br />
        <a href="http://webservices.landcareresearch.co.nz/compositaewebservice/ticachecklistservice.asmx" target="_blank">Web service</a>
        <br />
    </td>
    
    <td valign="top" style="padding-left:15px;">
            <asp:PlaceHolder ID="aboutPlaceHolder" runat="server">
        </asp:PlaceHolder>

    </td>
    </tr>
 </table>

</div>