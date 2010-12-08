<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">

			<xsl:for-each select="Region">

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
					<xsl:attribute name="occurrence"><xsl:value-of select="../Occurrence"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="../Origin"/></xsl:attribute>
				</Distribution>

			</xsl:for-each>


			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Oman'">TDWG Level 4;OMA-OO</xsl:when>
			<xsl:when test="$pRegion='Oman '">TDWG Level 4;OMA-OO</xsl:when>
			<xsl:when test="$pRegion='Saudi Arabia'">TDWG Level 4;SAU-OO</xsl:when>
			<xsl:when test="$pRegion='Saudi Arabia '">TDWG Level 4;SAU-OO</xsl:when>
			<xsl:when test="$pRegion='UAE'">TDWG Level 4;GST-UA</xsl:when>
			<xsl:when test="$pRegion='UAE '">TDWG Level 4;GST-UA</xsl:when>
			<xsl:when test="$pRegion='Yemen'">TDWG Level 3;YEM</xsl:when>
			<xsl:when test="$pRegion='Yemen '">TDWG Level 3;YEM</xsl:when>
			<xsl:when test="$pRegion='Kuwait'">TDWG Level 4;KUW-OO</xsl:when>
			<xsl:when test="$pRegion='Somalia'">TDWG Level 4;SOM-OO</xsl:when>
			<xsl:when test="$pRegion='Somalia '">TDWG Level 4;SOM-OO</xsl:when>
			<xsl:when test="$pRegion='Bahrain'">TDWG Level 4;GST-BA</xsl:when>
			<xsl:when test="$pRegion='Qatar'">TDWG Level 4;GST-QA</xsl:when>
			<xsl:when test="$pRegion='Pakistan'">TDWG Level 4;PAK-OO</xsl:when>
			<xsl:when test="$pRegion='Ethiopia'">TDWG Level 4;ETH-OO</xsl:when>
			<xsl:when test="$pRegion='Afghanistan'">TDWG Level 4;AFG-OO</xsl:when>
			<xsl:when test="$pRegion='Azerbaijan'">TDWG Level 4;TCS-AZ</xsl:when>
			<xsl:when test="$pRegion='Iran'">TDWG Level 4;IRN-OO</xsl:when>
			<xsl:when test="$pRegion='Eastern Saudi Arabia'">TDWG Level 4;SAU-OO</xsl:when>
			<xsl:when test="$pRegion='Djibouti'">TDWG Level 4;DJI-OO</xsl:when>
			<xsl:when test="$pRegion='Sudan'">TDWG Level 4;SUD-OO</xsl:when>
			<xsl:when test="$pRegion='Egypt'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pRegion='Sinai'">TDWG Level 4;SIN-OO</xsl:when>
			<xsl:when test="$pRegion='Jordan'">TDWG Level 4;PAL-JO</xsl:when>
			<xsl:when test="$pRegion='China'">TDWG Level 2;36</xsl:when>
			<xsl:when test="$pRegion='India'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pRegion='Nepal'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pRegion='Burma'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pRegion='Iraq'">TDWG Level 4;IRQ-OO</xsl:when>
			<xsl:when test="$pRegion='Israel'">TDWG Level 4;PAL-IS</xsl:when>
			<xsl:when test="$pRegion='Palestine'">TDWG Level 3;PAL</xsl:when>
			<xsl:when test="$pRegion='Lebanon'">TDWG Level 4;LBS-LB</xsl:when>
			<xsl:when test="$pRegion='Syria'">TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pRegion='Turkey'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pRegion='Turkmenistan'">TDWG Level 4;TKM-OO</xsl:when>
			<xsl:when test="$pRegion='Eritrea'">TDWG Level 4;ERI-OO</xsl:when>
			<xsl:when test="$pRegion='Morocco'">TDWG Level 4;MOR-MO</xsl:when>
			<xsl:when test="$pRegion='Kenya'">TDWG Level 4;KEN-OO</xsl:when>
			<xsl:when test="$pRegion='Tanzania'">TDWG Level 4;TAN-OO</xsl:when>
			<xsl:when test="$pRegion='Spain'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Armenia'">TDWG Level 4;TCS-AR</xsl:when>
			<xsl:when test="$pRegion='Arabian Peninsula '">TDWG Level 2;35</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
