<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml PLANTS North America Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="vRegions">
			<xsl:value-of select="substring-before(., '.')"/>
		</xsl:variable>
		<xsl:variable name="vStatus" select="translate(normalize-space((substring-after(., '.'))), '.', '')"/>
		<Distributions>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="$vRegions"/>
				<xsl:with-param name="pStatus" select="$vStatus"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:param name="pStatus"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
					<xsl:with-param name="pStatus" select="$pStatus"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
					<xsl:with-param name="pStatus" select="$pStatus"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:param name="pStatus"/>
		<xsl:variable name="vRegion">
			<xsl:call-template name="conRegion">
				<xsl:with-param name="pRegion" select="normalize-space($pRegion)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="vStatus">
			<xsl:call-template name="conBiostatus">
				<xsl:with-param name="pStatus">
					<xsl:value-of select="$pStatus"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$pRegion!=''">
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="region"><xsl:value-of select="substring-after($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="occurrence"><xsl:value-of select="substring-before($vStatus, ';')"/></xsl:attribute>
				<xsl:attribute name="origin"><xsl:value-of select="substring-after($vStatus,';')"/></xsl:attribute>
			</Distribution>
		</xsl:if>
	</xsl:template>
	<xsl:template name="conBiostatus">
		<xsl:param name="pStatus"/>
		<xsl:choose>
			<xsl:when test="$pStatus='Naturalized'">Present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Present'">Present;</xsl:when>
			<xsl:when test="$pStatus='Native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pStatus='Indigenous'">Present;Indigenous</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pStatus"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Honshu'">TDWG Level 4;JAP-HN</xsl:when>
			<xsl:when test="$pRegion='Hokkaido'">TDWG Level 4;JAP-HK</xsl:when>
			<xsl:when test="$pRegion='Shikoku'">TDWG Level 4;JAP-SH</xsl:when>
			<xsl:when test="$pRegion='Kyushu'">TDWG Level 4;JAP-KY</xsl:when>
			<xsl:when test="$pRegion='Rynkyu'">TDWG Level 4;NNS-OO</xsl:when>
			<xsl:when test="$pRegion='Oki Islands'">TDWG Level 4;JAP-HN</xsl:when>
			<xsl:when test="$pRegion='Hachijo-jima'">TDWG Level 4;JAP-HN</xsl:when>
			<xsl:when test="$pRegion='Amani-Oshima'">TDWG Level 4;NNS-OO</xsl:when>
			<xsl:when test="$pRegion='Kuriles'">TDWG Level 4;KUR-OO</xsl:when>
			<xsl:when test="$pRegion='Ogasawara Islands'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Izu Islands'">TDWG Level 4;JAP-HN</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
