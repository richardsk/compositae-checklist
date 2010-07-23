<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Cuba_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Biostatus">
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="Schema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="Region"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="Origin"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="Occurrence"/></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
