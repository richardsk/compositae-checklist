<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Paramo_sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion">
						<xsl:call-template name="conRegion">
							<xsl:with-param name="pRegion" select="."/>
						</xsl:call-template>
					</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
					<xsl:attribute name="occurrence">
						<xsl:choose>
							<xsl:when test="contains(., '?')='true'">Uncertain</xsl:when>
							<xsl:otherwise>Present</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="origin"></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Columbia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Costa Rica'">TDWG Level 4;COS-OO</xsl:when>
			<xsl:when test="$pRegion='Ecuador?'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pRegion='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pRegion='Panama'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pRegion='Peru'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pRegion='Venezuela'">TDWG Level 4;VEN-OO</xsl:when>
		</xsl:choose>
	</xsl:template>	
	
</xsl:stylesheet>
