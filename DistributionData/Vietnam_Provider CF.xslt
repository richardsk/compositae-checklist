<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml PLANTS North America Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="vRegions">
			<xsl:value-of select="substring-before(., '.')"/>
		</xsl:variable>
		<xsl:variable name="vStatus" select="translate(normalize-space((substring-after(., '.'))), '.', '')"/>
		<Distributions>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="$vRegions"/>
				<xsl:with-param name="pStatus" select="$vStatus"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:param name="pStatus"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
					<xsl:with-param name="pStatus" select="$pStatus"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
					<xsl:with-param name="pStatus" select="$pStatus"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:param name="pStatus"/>
		<xsl:variable name="vRegion">
			<xsl:call-template name="conRegion">
				<xsl:with-param name="pRegion" select="normalize-space($pRegion)"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="vStatus">
			<xsl:call-template name="conBiostatus">
				<xsl:with-param name="pStatus">
					<xsl:value-of select="$pStatus"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$pRegion!=''">
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="region"><xsl:value-of select="substring-after($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="occurrence"><xsl:value-of select="substring-before($vStatus, ';')"/></xsl:attribute>
				<xsl:attribute name="origin"><xsl:value-of select="substring-after($vStatus,';')"/></xsl:attribute>
				<xsl:attribute name="isOriginal">true</xsl:attribute>
			</Distribution>
		</xsl:if>
	</xsl:template>
	<xsl:template name="conBiostatus">
		<xsl:param name="pStatus"/>
		<xsl:choose>
			<xsl:when test="$pStatus='Endemic'">Present;Endemic</xsl:when>
			<xsl:otherwise>Present;Unknown</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Ấn Độ'">ISO Countries;India</xsl:when>
			<xsl:when test="$pRegion='Mianma'">ISO Countries;Myanmar</xsl:when>
			<xsl:when test="$pRegion='Nepal'">ISO Countries;Nepal</xsl:when>
			<xsl:when test="$pRegion='Trung Quốc'">ISO Countries;China</xsl:when>
			<xsl:when test="$pRegion='Thài Lan'">ISO Countries;Thailand</xsl:when>
			<xsl:when test="$pRegion='Lào'">ISO Countries;Laos</xsl:when>
			<xsl:when test="$pRegion='Campuchia'">ISO Countries;Cambodia</xsl:when>
			<xsl:when test="$pRegion='Malaixia'">ISO Countries;Malaysia</xsl:when>
			<xsl:when test="$pRegion='Indônêxia'">ISO Countries;Indonesia</xsl:when>
			<xsl:when test="$pRegion='Philippin'">ISO Countries;Philipines</xsl:when>
			<xsl:when test="$pRegion='Nhật Bản'">ISO Countries;Japan</xsl:when>
			<xsl:when test="$pRegion='Ôxtrâylia'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pRegion='Xri Lanka'">ISO Countries;Sri Lanka</xsl:when>
			<xsl:when test="$pRegion='Niu Ghinê'">ISO Countries;New Guinea</xsl:when>
			<xsl:when test="$pRegion='Việt Nam'">ISO Countries;Vietnam</xsl:when>
			<xsl:when test="$pRegion='Ai Cập'">ISO Countries;Egypt</xsl:when>
			<xsl:when test="$pRegion='châu Âu'">Region;Europe</xsl:when>
			<xsl:when test="$pRegion='châu Mỹ'">Region;America</xsl:when>
			<xsl:when test="$pRegion='châu Phi'">Region;Africa</xsl:when>
			<xsl:when test="$pRegion='châu Á'">Region;Asia</xsl:when>
			<xsl:when test="$pRegion='Đông Nam Á'">Region;South east Asia</xsl:when>
			<xsl:when test="$pRegion='Bắc Mỹ'">Region;North America</xsl:when>
			<xsl:when test="$pRegion='Nam Mỹ'">Region;South America</xsl:when>
			<xsl:when test="$pRegion='Đài Loan'">ISO Countries;Taiwan</xsl:when>
			<xsl:when test="$pRegion='Trung Á'">Region;Central Asia</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
