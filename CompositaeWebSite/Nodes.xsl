<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output  method="html" />

  <xsl:param name="selectedNode"/>
   
	<xsl:template match="/">
		<!--<HTML>
			<head>
				<META HTTP-EQUIV="Expire" CONTENT="13 Apr 1997 00:00 GMT" />
			</head>
			<BODY>-->
		<!--<h1>Tax Tree</h1>-->
    <table border="0">
			<xsl:apply-templates select="Node" />
		</table>
		<!--</BODY>
		</HTML>-->
	</xsl:template>
	<xsl:template match="Nodes">
		<table border="0" class="nodeTable" cellpadding="1" cellspacing="0">      
			<xsl:apply-templates select="Node" />
		</table>
	</xsl:template>
	<xsl:template match="Node">
		<tr>
      <td align="left"  valign="top" WIDTH="8" nowrap="nowrap"></td>
      <td align="left" valign="bottom" nowrap="nowrap" >
        
			  <xsl:apply-templates select="@State" />
			  <xsl:apply-templates select="@Rank" />
			  <a>
				  <xsl:attribute name="name">
					  <xsl:value-of select="@NodeId" />
				  </xsl:attribute>
			  </a>
			  <!-- <xsl:text>&#160;</xsl:text> -->
                 
        
        <a>
				  <xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
				  <xsl:attribute name="target">_parent</xsl:attribute>
          <xsl:attribute name="Name">Node_<xsl:value-of select="@NodeId" /></xsl:attribute>
          <xsl:attribute name="ID">Node_<xsl:value-of select="@NodeId" /></xsl:attribute>
          <xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
          <xsl:attribute name="style">
            <xsl:value-of select="@style"/>
          </xsl:attribute>
				  <xsl:value-of select="TaxName" />
			  </a>
        
				
			  <!-- <xsl:text>&#160;</xsl:text> -->
        
				<xsl:apply-templates select="Nodes" />
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="Node/@State[.='+']">

  	<a>
			<xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="href">TreeForm.aspx?Action=Expand&amp;NodeId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/Plus.gif" border="0" />
		</a>
	</xsl:template>
	<xsl:template match="Node/@State[.='-']">
    
		<!--	<xsl:copy-of select="../NodeId" /> -->
		<!-- The element's parent's ID is <xsl:value-of select="../@NodeIdA" />. -->
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="href">TreeForm.aspx?Action=Collapse&amp;NodeId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/minus.gif" border="0" />
		</a>
	</xsl:template>
	<xsl:template match="Node/@State[.='x']">
		<a>
      
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="href">TreeForm.aspx?Action=Display&amp;NodeId=<xsl:value-of select="../@NodeId" />&amp;NodeId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/empty.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 1-->
	<xsl:template match="Node/@Rank[.='1']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/matter.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 2-->
	<xsl:template match="Node/@Rank[.='200']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 4-->
	<xsl:template match="Node/@Rank[.='15']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/k.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 6-->
	<xsl:template match="Node/@Rank[.='30']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/k-.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 7-->
	<xsl:template match="Node/@Rank[.='41']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/p+.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 8-->
	<xsl:template match="Node/@Rank[.='19']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/p.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 9-->
	<xsl:template match="Node/@Rank[.='32']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/p-.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 10-->
	<xsl:template match="Node/@Rank[.='48']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/d.gif" border="0" />
		</a>
	</xsl:template>	
	
	<!--Case 11-->
	<xsl:template match="Node/@Rank[.='38']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/c+.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 12-->
	<xsl:template match="Node/@Rank[.='3']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/c.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 13-->
	<xsl:template match="Node/@Rank[.='26']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/c-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 14-->
	<xsl:template match="Node/@Rank[.='11']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/c-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 15-->
	<xsl:template match="Node/@Rank[.='40']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/o+.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 16-->
	<xsl:template match="Node/@Rank[.='17']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/o.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 18-->
	<xsl:template match="Node/@Rank[.='31']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/o-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 19-->
	<xsl:template match="Node/@Rank[.='39']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/f+.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 20-->
	<xsl:template match="Node/@Rank[.='7']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/f.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 22-->
	<xsl:template match="Node/@Rank[.='27']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/f-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 23-->
	<xsl:template match="Node/@Rank[.='42']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/t+.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 24-->
	<xsl:template match="Node/@Rank[.='43']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/t.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 26-->
	<xsl:template match="Node/@Rank[.='36']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/t-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 28-->
	<xsl:template match="Node/@Rank[.='1']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/a.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 30-->
	<xsl:template match="Node/@Rank[.='8']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/g.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 32-->
	<xsl:template match="Node/@Rank[.='29']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/g-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 34-->
	<xsl:template match="Node/@Rank[.='3400']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 36-->
	<xsl:template match="Node/@Rank[.='3600']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 38-->
	<xsl:template match="Node/@Rank[.='3800']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 40-->
	<xsl:template match="Node/@Rank[.='4000']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 42-->
	<xsl:template match="Node/@Rank[.='24']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/s.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 44-->
	<xsl:template match="Node/@Rank[.='35']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/s-.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 46-->
	<xsl:template match="Node/@Rank[.='44']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/v.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 48-->
	<xsl:template match="Node/@Rank[.='4']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/cv.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 50-->
	<xsl:template match="Node/@Rank[.='5000']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/forma.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 52-->
	<xsl:template match="Node/@Rank[.='5200']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 54-->
	<xsl:template match="Node/@Rank[.='5400']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
	
	<!--Case 56-->
	<xsl:template match="Node/@Rank[.='5600']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 57-->
	<xsl:template match="Node/@Rank[.='5700']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case 58-->
	<xsl:template match="Node/@Rank[.='5800']" priority="3">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>

	<!--Case Else-->
	<xsl:template match="Node/@Rank" priority="1">
		<a>
      <xsl:attribute name="style">
        <xsl:value-of select="@style"/>
      </xsl:attribute>
			<xsl:attribute name="title"><xsl:value-of select="NameFull" /></xsl:attribute>
			<xsl:attribute name="target">_parent</xsl:attribute>
			<xsl:attribute name="href">default.aspx?Page=NameDetails&amp;TabNum=0&amp;Action=Display&amp;NameId=<xsl:value-of select="../@NodeId" />&amp;StateId=<xsl:value-of select="//Node/@StateId" /></xsl:attribute>
			<img align="top" src="images/blank1.gif" border="0" />
		</a>
	</xsl:template>
</xsl:stylesheet>
