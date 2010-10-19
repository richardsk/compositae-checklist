<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml FloraOfChina_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Province">
				<Distribution>
					<xsl:attribute name="schema">Provinces of China</xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="."/></xsl:attribute>
					<xsl:attribute name="occurrence">present</xsl:attribute>
					<xsl:attribute name="origin"/>
				</Distribution>
			</xsl:for-each>
			<xsl:for-each select="//Country">
				<Distribution>
					<xsl:attribute name="schema">Country</xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="."/></xsl:attribute>
					<xsl:attribute name="occurrence">present</xsl:attribute>
					<xsl:attribute name="origin"/>
				</Distribution>
			</xsl:for-each>
			<xsl:for-each select="//Region">
				<Distribution>
					<xsl:attribute name="schema">Regions</xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="."/></xsl:attribute>
					<xsl:attribute name="occurrence">present</xsl:attribute>
					<xsl:attribute name="origin"/>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
