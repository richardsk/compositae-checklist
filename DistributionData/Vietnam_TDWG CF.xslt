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
			<xsl:when test="$pRegion='Ấn Độ'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pRegion='Mianma'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pRegion='Nepal'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pRegion='Trung Quốc'">TDWG Level 2;36</xsl:when>
			<xsl:when test="$pRegion='Thài Lan'">TDWG Level 4;THA-OO</xsl:when>
			<xsl:when test="$pRegion='Lào'">TDWG Level 4;LAO-OO</xsl:when>
			<xsl:when test="$pRegion='Campuchia'">TDWG Level 4;CBD-OO</xsl:when>
			<xsl:when test="$pRegion='Malaixia'">TDWG Level 3;MLY</xsl:when>
			<xsl:when test="$pRegion='Indônêxia'">TDWG Level 4;MOL-OO</xsl:when>
			<xsl:when test="$pRegion='Philippin'">TDWG Level 4;PHI-OO</xsl:when>
			<xsl:when test="$pRegion='Nhật Bản'">TDWG Level 3;JAP</xsl:when>
			<xsl:when test="$pRegion='Ôxtrâylia'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pRegion='Xri Lanka'">TDWG Level 4;SRL-OO</xsl:when>
			<xsl:when test="$pRegion='Niu Ghinê'">TDWG Level 3;NWG</xsl:when>
			<xsl:when test="$pRegion='Việt Nam'">TDWG Level 3;VIE</xsl:when>
			<xsl:when test="$pRegion='Ai Cập'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pRegion='châu Âu'">TDWG Level 1;1</xsl:when>
			<xsl:when test="$pRegion='châu Mỹ'">TDWG Level 1;1,2</xsl:when>
			<xsl:when test="$pRegion='châu Phi'">TDWG Level 1;2</xsl:when>
			<xsl:when test="$pRegion='châu Á'">TDWG Level 1;3,4</xsl:when>
			<xsl:when test="$pRegion='Đông Nam Á'">TDWG Level 1;4</xsl:when>
			<xsl:when test="$pRegion='Bắc Mỹ'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pRegion='Nam Mỹ'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pRegion='Đài Loan'">TDWG Level 4;TAI-OO</xsl:when>
			<xsl:when test="$pRegion='Trung Á'">TDWG Level 2;32</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
