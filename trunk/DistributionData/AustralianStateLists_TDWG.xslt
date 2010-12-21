<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Australian Capitol Territory.xml?>
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
				<xsl:variable name="vOrigin">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Uncertain</xsl:when>
						<xsl:when test="Occurrence='Exotic'">Exotic</xsl:when>
						<xsl:when test="Occurrence='Indigenous'">Indigenous</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
						<xsl:when test="Occurrence='Exotic'">Present</xsl:when>
						<xsl:when test="Occurrence='Indigenous'">Present</xsl:when>
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
		</Distributions>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Australia'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pRegion='Australian Capitol Territory'">TDWG Level 4;NSW-CT</xsl:when>
			<xsl:when test="$pRegion='Australian Capital Territory'">TDWG Level 4;NSW-CT</xsl:when>
			<xsl:when test="$pRegion='New South Wales'">TDWG Level 4;NSW-NS</xsl:when>
			<xsl:when test="$pRegion='Queensland'">TDWG Level 3;QLD</xsl:when>
			<xsl:when test="$pRegion='Western Australia'">TDWG Level 3;WAU</xsl:when>
			<xsl:when test="$pRegion='Northern Territory'">TDWG Level 3;NTA</xsl:when>
			<xsl:when test="$pRegion='Victoria'">TDWG Level 3;VIC</xsl:when>
			<xsl:when test="$pRegion='South Australia'">TDWG Level 3;SOA</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
