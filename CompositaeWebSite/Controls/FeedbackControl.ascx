<%@ Control Language="VB" AutoEventWireup="false" CodeFile="FeedbackControl.ascx.vb" Inherits="Controls_FeedbackControl" %>

<div style="padding-top:1px; padding-left:3px">

<asp:Panel ID="MsgPanel" runat="server" meta:resourcekey="MsgPanelResource1" >
</asp:Panel>

<asp:Panel ID="fPanel" runat="server" meta:resourcekey="fPanelResource1" >

    <table cellpadding="2" border="0" cellspacing="0" >
	    <tr>
		    <td  colspan="2">
                <asp:Label ID="Label5" runat="server" CssClass="BlockHeader" Height="24px" 
                    Text="Feedback" Width="100%" meta:resourcekey="Label5Resource2"></asp:Label></td>
	    </tr>
   		<tr >
			<td align="left" colspan="2" class="small" >
			    <p>
                    <asp:Label ID="Label6" runat="server" Text="Please give feedback in English if possible.  If you would like to send us a file with extended feedback (e.g. an annotated report from the website) please fill in the feedback form and then attach the file in a reply to the automated email response you receive. " meta:resourcekey="Label6Resource2"></asp:Label><br />
                    <br />
                    <asp:Label ID="Label2" runat="server" Text="By sending this feedback form to us you agree to have any new data made freely available on the website and also to GBIF and Species2000. " meta:resourcekey="Label2Resource1"></asp:Label>
                   
                    </p>
                    
				</td>				
		</tr>
		<tr >
			<td align="left" class="smaller" height="4" ><strong>
                <asp:Label ID="Label4" runat="server" Text="Name" meta:resourcekey="Label4Resource1"></asp:Label>
            </strong></td>
			<td align="left" height="4" >
                <asp:TextBox ID="nameText" runat="server" Columns="50" MaxLength="50" meta:resourcekey="nameTextResource1"></asp:TextBox></td>
			
		</tr>
		<tr >
			<td align="left" class="smaller" height="11" ><strong>&nbsp;<asp:Label ID="Label7" runat="server" meta:resourcekey="Label7Resource1"
                    Text="Email"></asp:Label></strong></td>
			<td align="left" height="11" >
                <asp:TextBox ID="emailText" runat="server" Columns="50" MaxLength="250" meta:resourcekey="emailTextResource1" AutoCompleteType="Disabled"></asp:TextBox></td>
			
		</tr>
		<tr >
			<td align="left" class="smaller" height="2" ><strong>&nbsp;<asp:Label ID="Label1" runat="server" 
                    Width="145px" Text="Confirm email" meta:resourcekey="Label1Resource1"></asp:Label></strong></td>
			<td align="left" height="2" >
                <asp:TextBox ID="confirmEmailText" runat="server" Columns="50" MaxLength="250" meta:resourcekey="confirmEmailTextResource1" AutoCompleteType="Disabled"></asp:TextBox></td>
			
		</tr>
        <tr>
            <td align="left" class="smaller" height="2" >
            </td>
            <td align="left" height="2">
                <asp:CheckBox ID="ticaCheck" runat="server" Text="TICA member" meta:resourcekey="ticaCheckResource1" /></td>
            
        </tr>
		<tr >
			<td align="left" class="smaller" ><strong>
                <asp:Label runat="server" ID="Label8" Text="Feedback details" meta:resourcekey="Label8Resource1"></asp:Label>
            </strong></td>
			<td align="left" >
                <asp:TextBox ID="feedbackText" runat="server" Columns="50" MaxLength="500" Rows="12"
                    TextMode="MultiLine" meta:resourcekey="feedbackTextResource1"></asp:TextBox></td>
			
		</tr>
		<tr >
			<td align="left" class="smaller" ></td>
			<td align="left" >
				<asp:button id="submit" text="Submit feedback" runat="server" width="132px" font-bold="True" meta:resourcekey="submitResource1"></asp:button></td>
			
		</tr>
	</table>
</asp:Panel>

</div>
