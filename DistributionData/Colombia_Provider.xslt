<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Region">
				<Distribution>
					<xsl:attribute name="schema">Districts of Colombia</xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="."/></xsl:attribute>
					<xsl:attribute name="origin"/>
					<xsl:attribute name="occurrence">Present</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
