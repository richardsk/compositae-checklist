<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Dolomite_Sample2.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="Region"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<Distribution>
					<xsl:attribute name="schema">
						<xsl:value-of select="$vSchema"/>
					</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:value-of select="$vReg"/>
					</xsl:attribute>
					<xsl:attribute name="origin">Indigenous</xsl:attribute>
					<xsl:attribute name="occurrence">Present</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Alpujarrean-Gadorensean'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Guadician-Bacensean'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Malacitan-Almijarensean'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Rondean'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Subbaetic'">TDWG Level 4;SPA-SP</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
