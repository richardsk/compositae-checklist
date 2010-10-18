<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Australian Capitol Territory.xml?>
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
				<xsl:variable name="vOrigin">
					<xsl:choose>
						<xsl:when test="Origin='Doubtfully Naturalised'">Doubtfully Naturalised</xsl:when>
						<xsl:when test="Origin='Doubtfully Cultivated'">Doubtfully Cultivated</xsl:when>
						<xsl:when test="Origin='Naturalised'">Naturalised</xsl:when>
						<xsl:when test="Origin='Endemic'">Endemic</xsl:when>
						<xsl:when test="Origin='Exotic'">Exotic</xsl:when>
						<xsl:when test="Origin='Cultivated'">Cultivated</xsl:when>
						<xsl:when test="Origin='Indigenous'">Indigenous</xsl:when>
						<xsl:when test="Origin='Unknown'">Unknown</xsl:when>
						<xsl:when test="Origin='Doubtful'">Doubtful</xsl:when>
						<xsl:when test="Occurrence='Cultivated'">Cultivated</xsl:when>
						<xsl:when test="Occurrence='Adventive'">Adventive</xsl:when>
						<xsl:when test="Occurrence='Endemic'">Endemic</xsl:when>
						<xsl:when test="Occurrence='Exotic'">Exotic</xsl:when>
						<xsl:when test="Occurrence='Naturalised'">Naturalised</xsl:when>
						<xsl:when test="Occurrence='Indigenous'">Indigenous</xsl:when>
						<xsl:otherwise>Uncertain</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Adventive'">Present</xsl:when>
						<xsl:when test="Occurrence='Endemic'">Present</xsl:when>
						<xsl:when test="Occurrence='Cultivated'">Present</xsl:when>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
						<xsl:when test="Occurrence='Exotic'">Present</xsl:when>
						<xsl:when test="Occurrence='Indigenous'">Present</xsl:when>
						<xsl:when test="Occurrence='Naturalised'">Present</xsl:when>
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
			<xsl:when test="$pRegion='Cook Islands'">Islands;Cook Islands</xsl:when>
			<xsl:when test="$pRegion='Easter Island'">Islands;Easter Island</xsl:when>
			<xsl:when test="$pRegion='Fiji'">Islands;Fiji</xsl:when>
			<xsl:when test="$pRegion='Hawaii'">Islands;Hawaii</xsl:when>
			<xsl:when test="$pRegion='Marquesas'">Islands;Marquesas</xsl:when>
			<xsl:when test="$pRegion='Moorea'">ISlands;Moorea</xsl:when>
			<xsl:when test="$pRegion='Niue'">Islands;Niue</xsl:when>
			<xsl:when test="$pRegion='Pitcairn Island'">Islands;Pitcairn Island</xsl:when>
			<xsl:when test="$pRegion='Samoa'">Islands;Samoa</xsl:when>
			<xsl:when test="$pRegion='Tokelau'">Islands;Tokelau</xsl:when>
			<xsl:when test="$pRegion='Tonga'">Islands;Tonga</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
