<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml VietnamFlora_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText">
					<xsl:value-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:variable name='vRegion' select="substring-before($pText, ',')"/>
		<xsl:variable name='vRemain' select="normalize-space(substring-after($pText, ','))"/>
		<xsl:if test="$vRegion!=''">
			<xsl:variable name="vTRegion">
				<xsl:call-template name="conRegion">
					<xsl:with-param name="pRegion" select="$vRegion"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="vSchema" select="substring-before($vTRegion,';')"/>
			<xsl:variable name="vReg" select="substring-after($vTRegion,';')"/>
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
				<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
				<xsl:attribute name="origin"></xsl:attribute>
				<xsl:attribute name="occurrence">Present</xsl:attribute>
			</Distribution>
		</xsl:if>
		<xsl:if test="string-length($vRemain)&gt;0">
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="$vRemain"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Việt Nam'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Ai Cập'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Ấn Độ'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Mianma'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Trung Quốc'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Lào'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Campuchia'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Indônêxia'">TDWG Level 3;VIE</xsl:when>
			<xsl:otherwise>TDWG Level 3;VIE</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
