<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<body>
				<h2>Names</h2>
				<xsl:apply-templates select="NewDataSet/Table[recordType='Name']"/>

			</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table[recordType='Name']">
		<b>ID: </b> <xsl:value-of select="recordId"/>&#160;&#160;
		<b>Name: </b> <xsl:value-of select="recordDetails"/>&#160;&#160;
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=linkParent'))"/>
			</xsl:attribute>Link Parent Name
		</a>&#160;
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=ignore'))"/>
			</xsl:attribute>Ignore error
		</a><br/>
	</xsl:template>

	
</xsl:stylesheet>
