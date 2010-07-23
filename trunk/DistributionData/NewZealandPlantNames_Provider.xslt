<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Biostatus">
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="RegionSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="Region"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:call-template name="conOccurrence"><xsl:with-param name="pOcc" select="Occurrence"/></xsl:call-template></xsl:attribute>
					<xsl:attribute name="origin"><xsl:call-template name="conOrigin"><xsl:with-param name="pOrig" select="Origin"/></xsl:call-template></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="conOccurrence">
		<xsl:param name="pOcc"/>
		<xsl:choose>
			<xsl:when test="$pOcc='Wild'">Present in wild</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$pOcc"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conOrigin">
		<xsl:param name="pOrig"/>
		<xsl:choose>
			<xsl:when test="$pOrig='Non-endemic'">Non-Endemic</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$pOrig"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
