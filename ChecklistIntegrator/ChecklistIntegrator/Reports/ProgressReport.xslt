<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<body>
				<h2>Progress Statistics</h2>
				<xsl:apply-templates />

			</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table">
		<xsl:value-of select="recordDetails"/>&#160;&#160;<br/>
		
	</xsl:template>
	
</xsl:stylesheet>
