<?xml version="1.0" encoding="UTF-8"?>
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
			<xsl:when test="$pRegion='Peru'">TDWG Level 4;PER-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conOccurrence">
		<xsl:param name="pOcc"/>
		<xsl:choose>
			<xsl:when test="$pOcc='Present'">Present</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pOcc"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conOrigin">
		<xsl:param name="pOrig"/>
		<xsl:choose>
			<xsl:when test="$pOrig='Unknown'">Unknown</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pOrig"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>