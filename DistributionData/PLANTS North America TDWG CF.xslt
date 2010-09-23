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
			<xsl:when test="$pStatus='Introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Present'">Present;</xsl:when>
			<xsl:when test="$pStatus='Waif - an ephemeral introduction, not persistently naturalized'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pStatus='Probably Native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pStatus='Probably Introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Native and Introduced - some infra-taxa are native and others are introduced'">Present;</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pStatus"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='CAN - Alberta'">TDWG Level 4;ABT-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Manitoba'">TDWG Level 4;MAN-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Newfoundland'">TDWG Level 4;NFL-NE</xsl:when>
			<xsl:when test="$pRegion='CAN - Northwest Territory'">TDWG Level 4;NWT-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Nova Scotia'">TDWG Level 4;NSC-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Nunavut'">TDWG Level 4;NUN-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Ontario'">TDWG Level 4;ONT-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Prince Edward Island'">TDWG Level 4;PEI-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Quebec'">TDWG Level 4;QUE-OO</xsl:when>
			<xsl:when test="$pRegion='PR - Puerto Rico'">TDWG Level 4;PUE-OO</xsl:when>
			<xsl:when test="$pRegion='US - Arizona'">TDWG Level 4;ARI-OO</xsl:when>
			<xsl:when test="$pRegion='US - Arkansas'">TDWG Level 4;ARK-OO</xsl:when>
			<xsl:when test="$pRegion='US - California'">TDWG Level 4;CAL-OO</xsl:when>
			<xsl:when test="$pRegion='US - Delaware'">TDWG Level 4;DEL-OO</xsl:when>
			<xsl:when test="$pRegion='US - Georgia'">TDWG Level 4;GEO-OO</xsl:when>
			<xsl:when test="$pRegion='US - Hawaii'">TDWG Level 3;HAW</xsl:when>
			<xsl:when test="$pRegion='US - Kansas'">TDWG Level 4;KAN-OO</xsl:when>
			<xsl:when test="$pRegion='US - Louisiana'">TDWG Level 4;LOU-OO</xsl:when>
			<xsl:when test="$pRegion='US - Michigan'">TDWG Level 4;MIC-OO</xsl:when>
			<xsl:when test="$pRegion='US - Mississippi'">TDWG Level 4;MSI-OO</xsl:when>
			<xsl:when test="$pRegion='US - Missouri'">TDWG Level 4;MSO-OO</xsl:when>
			<xsl:when test="$pRegion='US - New Jersey'">TDWG Level 4;NWJ-OO</xsl:when>
			<xsl:when test="$pRegion='US - North Carolina'">TDWG Level 4;NCA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Ohio'">TDWG Level 4;OHI-OO</xsl:when>
			<xsl:when test="$pRegion='US - Oregon'">TDWG Level 4;ORE-OO</xsl:when>
			<xsl:when test="$pRegion='US - Pennsylvania'">TDWG Level 4;PEN-OO</xsl:when>
			<xsl:when test="$pRegion='US - South Dakota'">TDWG Level 4;SDA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Vermont'">TDWG Level 4;VER-OO</xsl:when>
			<xsl:when test="$pRegion='US - Virginia'">TDWG Level 4;VRG-OO</xsl:when>
			<xsl:when test="$pRegion='US - West Virginia'">TDWG Level 4;WVA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Wisconsin'">TDWG Level 4;WIS-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - British Columbia'">TDWG Level 4;BRC-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Labrador'">TDWG Level 4;LAB-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - New Brunswick'">TDWG Level 4;NBR-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Saskatchewan'">TDWG Level 4;SAS-OO</xsl:when>
			<xsl:when test="$pRegion='CAN - Yukon Territory'">TDWG Level 4;YUK-OO</xsl:when>
			<xsl:when test="$pRegion='GR - Greenland'">TDWG Level 4;GNL-OO</xsl:when>
			<xsl:when test="$pRegion='SPM - Saint Pierre and Miquelon'">TDWG Level 4;NFL-SP</xsl:when>
			<xsl:when test="$pRegion='US - Alabama'">TDWG Level 4;ALA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Alaska'">TDWG Level 4;ASK-OO</xsl:when>
			<xsl:when test="$pRegion='US - Colorado'">TDWG Level 4;COL-OO</xsl:when>
			<xsl:when test="$pRegion='US - Connecticut'">TDWG Level 4;CNT-OO</xsl:when>
			<xsl:when test="$pRegion='US - District of Columbia'">TDWG Level 4;WDC-OO</xsl:when>
			<xsl:when test="$pRegion='US - Florida'">TDWG Level 4;FLA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Idaho'">TDWG Level 4;IDA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Illinois'">TDWG Level 4;ILL-OO</xsl:when>
			<xsl:when test="$pRegion='US - Indiana'">TDWG Level 4;INI-OO</xsl:when>
			<xsl:when test="$pRegion='US - Iowa'">TDWG Level 4;IOW-OO</xsl:when>
			<xsl:when test="$pRegion='US - Kentucky'">TDWG Level 4;KTY-OO</xsl:when>
			<xsl:when test="$pRegion='US - Maine'">TDWG Level 4;MAI-OO</xsl:when>
			<xsl:when test="$pRegion='US - Maryland'">TDWG Level 4;MRY-OO</xsl:when>
			<xsl:when test="$pRegion='US - Massachusetts'">TDWG Level 4;MAS-OO</xsl:when>
			<xsl:when test="$pRegion='US - Minnesota'">TDWG Level 4;MIN-OO</xsl:when>
			<xsl:when test="$pRegion='US - Montana'">TDWG Level 4;MNT-OO</xsl:when>
			<xsl:when test="$pRegion='US - Nebraska'">TDWG Level 4;NEB-OO</xsl:when>
			<xsl:when test="$pRegion='US - Nevada'">TDWG Level 4;NEV-OO</xsl:when>
			<xsl:when test="$pRegion='US - New Hampshire'">TDWG Level 4;NWH-OO</xsl:when>
			<xsl:when test="$pRegion='US - New Mexico'">TDWG Level 4;NWM-OO</xsl:when>
			<xsl:when test="$pRegion='US - New York'">TDWG Level 4;NWY-OO</xsl:when>
			<xsl:when test="$pRegion='US - North Dakota'">TDWG Level 4;NDA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Oklahoma'">TDWG Level 4;OKL-OO</xsl:when>
			<xsl:when test="$pRegion='US - Rhode Island'">TDWG Level 4;RHO-OO</xsl:when>
			<xsl:when test="$pRegion='US - South Carolina'">TDWG Level 4;SCA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Tennessee'">TDWG Level 4;TEN-OO</xsl:when>
			<xsl:when test="$pRegion='US - Texas'">TDWG Level 4;TEX-OO</xsl:when>
			<xsl:when test="$pRegion='US - Utah'">TDWG Level 4;UTA-OO</xsl:when>
			<xsl:when test="$pRegion='US - Washington'">TDWG Level 4;WAS-OO</xsl:when>
			<xsl:when test="$pRegion='US - Wyoming'">TDWG Level 4;WYO-OO</xsl:when>
			<xsl:when test="$pRegion='VI - Virgin Islands'">TDWG Level 4;LEE-VI</xsl:when>
			<xsl:otherwise>?????;<xsl:value-of select="$pRegion"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
