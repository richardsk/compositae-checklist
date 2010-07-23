<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml New Zealand Plant Names.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
				<xsl:for-each select="//Biostatus">
					<xsl:variable name="vRegion">
						<xsl:call-template name="conRegion">
							<xsl:with-param name="pRegion" select="Region"/>
						</xsl:call-template>
					</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
					<xsl:attribute name="occurrence">
						<xsl:call-template name="conOccurrence">
							<xsl:with-param name="pOcc" select="Occurrence"/>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="origin">
						<xsl:call-template name="conOrigin">
							<xsl:with-param name="pOrig" select="Origin"/>
						</xsl:call-template>
					</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Australia'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pRegion='Chile South'">TDWG Level 3;CLS</xsl:when>
			<xsl:when test="$pRegion='Cook Is.'">TDWG Level 3;COO</xsl:when>
			<xsl:when test="$pRegion='Madagascar'">TDWG Level 3;MDG</xsl:when>
			<xsl:when test="$pRegion='New Zealand'">TDWG Level 2;51</xsl:when>
			<xsl:when test="$pRegion='Papua New Guinea'">TDWG Level 4;NWG-PN</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conOccurrence">
		<xsl:param name="pOcc"/>
		<xsl:choose>
			<xsl:when test="$pOcc='Wild'">Present in wild</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pOcc"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conOrigin">
		<xsl:param name="pOrig"/>
		<xsl:choose>
			<xsl:when test="$pOrig='Non-endemic'">Non-Endemic</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pOrig"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
