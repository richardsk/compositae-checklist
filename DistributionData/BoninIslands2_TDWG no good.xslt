<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Australian Capitol Territory.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
			
			<xsl:for-each select="//Region">
			
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="Region"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<xsl:variable name="vOrigin">
					<xsl:choose>
						<xsl:when test="Origin='Alien'">Exotic</xsl:when>
						<xsl:when test="Origin='Native'">Indigenous</xsl:when>
						<xsl:when test="Origin='Endemic'">Endemic</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<Distribution>
					<xsl:attribute name="schema">
						<xsl:value-of select="$vSchema"/>
					</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:value-of select="$vReg"/>
					</xsl:attribute>
					<xsl:attribute name="origin">
						<xsl:value-of select="$vOrigin"/>
					</xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="$vOccurrence"/></xsl:attribute>
				</Distribution>
			</xsl:for-each>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Bonin Islands'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Chichi-Jima'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Haha-jima'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Mukou-jima'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Otouto-jima'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pRegion='Ani-jima'">TDWG Level 4;OGA-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
