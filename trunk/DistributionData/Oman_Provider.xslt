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
			<xsl:when test="$pRegion='Oman'">ISO Countries;Oman</xsl:when>
			<xsl:when test="$pRegion='Oman '">ISO Countries;Oman</xsl:when>
			<xsl:when test="$pRegion='Saudi Arabia'">ISO Countries;Saudi Arabia</xsl:when>
			<xsl:when test="$pRegion='Saudi Arabia '">ISO Countries;Saudi Arabia</xsl:when>
			<xsl:when test="$pRegion='UAE'">ISO Countries;United Arab Emirates</xsl:when>
			<xsl:when test="$pRegion='UAE '">ISO Countries;United Arab Emirates</xsl:when>
			<xsl:when test="$pRegion='Yemen'">ISO Countries;Yemen</xsl:when>
			<xsl:when test="$pRegion='Yemen '">ISO Countries;Yemen</xsl:when>
			<xsl:when test="$pRegion='Kuwait'">ISO Countries;Kuwait</xsl:when>
			<xsl:when test="$pRegion='Somalia'">ISO Countries;Somalia</xsl:when>
			<xsl:when test="$pRegion='Somalia '">ISO Countries;Somalia</xsl:when>
			<xsl:when test="$pRegion='Bahrain'">ISO Countries;Bahrain</xsl:when>
			<xsl:when test="$pRegion='Qatar'">ISO Countries;Qatar</xsl:when>
			<xsl:when test="$pRegion='Pakistan'">ISO Countries;Pakistan</xsl:when>
			<xsl:when test="$pRegion='Ethiopia'">ISO Countries;Ethiopia</xsl:when>
			<xsl:when test="$pRegion='Afghanistan'">ISO Countries;Afghanistan</xsl:when>
			<xsl:when test="$pRegion='Azerbaijan'">ISO Countries;Azerbaijan</xsl:when>
			<xsl:when test="$pRegion='Iran'">ISO Countries;Iran</xsl:when>
			<xsl:when test="$pRegion='Eastern Saudi Arabia'">ISO Countries;Saudi Arabia</xsl:when>
			<xsl:when test="$pRegion='Djibouti'">ISO Countries;Djibouti</xsl:when>
			<xsl:when test="$pRegion='Sudan'">ISO Countries;Sudan</xsl:when>
			<xsl:when test="$pRegion='Egypt'">ISO Countries;Egypt</xsl:when>
			<xsl:when test="$pRegion='Sinai'">ISO Countries;Sinai</xsl:when>
			<xsl:when test="$pRegion='Jordan'">ISO Countries;Jordan</xsl:when>
			<xsl:when test="$pRegion='China'">ISO Countries;China</xsl:when>
			<xsl:when test="$pRegion='India'">ISO Countries;India</xsl:when>
			<xsl:when test="$pRegion='Nepal'">ISO Countries;Nepal</xsl:when>
			<xsl:when test="$pRegion='Burma'">ISO Countries;Burma</xsl:when>
			<xsl:when test="$pRegion='Iraq'">ISO Countries;Iraq</xsl:when>
			<xsl:when test="$pRegion='Israel'">ISO Countries;Israel</xsl:when>
			<xsl:when test="$pRegion='Palestine'">ISO Countries;Palestine</xsl:when>
			<xsl:when test="$pRegion='Lebanon'">ISO Countries;Lebanon</xsl:when>
			<xsl:when test="$pRegion='Syria'">ISO Countries;Syria</xsl:when>
			<xsl:when test="$pRegion='Turkey'">ISO Countries;Turkey</xsl:when>
			<xsl:when test="$pRegion='Turkmenistan'">ISO Countries;Turkmenistan</xsl:when>
			<xsl:when test="$pRegion='Eritrea'">ISO Countries;Eritrea</xsl:when>
			<xsl:when test="$pRegion='Morocco'">ISO Countries;Morocco</xsl:when>
			<xsl:when test="$pRegion='Kenya'">ISO Countries;Kenya</xsl:when>
			<xsl:when test="$pRegion='Tanzania'">ISO Countries;Tanzania</xsl:when>
			<xsl:when test="$pRegion='Spain'">ISO Countries;Spain</xsl:when>
			<xsl:when test="$pRegion='Armenia'">ISO Countries;Armenia</xsl:when>
			<xsl:when test="$pRegion='Arabian Peninsula '">Regions;Arabian Peninsula</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
