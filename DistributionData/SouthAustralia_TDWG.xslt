<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml South Australia.xml?>
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
				<xsl:variable name="vStatus">
					<xsl:choose>
						<xsl:when test="Status='*'">Exotic</xsl:when>
						<xsl:when test="Status='?e'">Exotic</xsl:when>
						<xsl:when test="Status='?n'">Indigenous</xsl:when>
						<xsl:when test="Status='Critically Endangered'">Indigenous</xsl:when>
						<xsl:when test="Status='Endangered'">Indigenous</xsl:when>
						<xsl:when test="Status='Endangered*'">Indigenous</xsl:when>
						<xsl:when test="Status='Extinct*'">Uncertain</xsl:when>
						<xsl:when test="Status='Rare'">Indigenous</xsl:when>
						<xsl:when test="Status='Vulnerable'">Indigenous</xsl:when>
						<xsl:otherwise>Indigenous</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
						<xsl:otherwise>Present</xsl:otherwise>
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
						<xsl:value-of select="$vStatus"/>
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
			<xsl:when test="$pRegion='South Australia'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='NSW'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pRegion='NW'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='LE'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='NU'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='GT'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='FR'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='EA'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='EP'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='NL'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='MU'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='YP'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='SL'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='KI'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='SE'">TDWG Level 4;SOA-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
