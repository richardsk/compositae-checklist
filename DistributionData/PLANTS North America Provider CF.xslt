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
			<xsl:when test="$pStatus='Introduced'">Present;Introduced</xsl:when>
			<xsl:when test="$pStatus='Present'">Present;</xsl:when>
			<xsl:when test="$pStatus='Waif - an ephemeral introduction, not persistently naturalized'">Waif;Exotic</xsl:when>
			<xsl:when test="$pStatus='Native'">Present;Native</xsl:when>
			<xsl:when test="$pStatus='Probably Native'">Present;Probably Native</xsl:when>
			<xsl:when test="$pStatus='Probably Introduced'">Present;Probably Exotic</xsl:when>
			<xsl:when test="$pStatus='Native and Introduced - some infra-taxa are native and others are introduced'">Present;</xsl:when>
			<xsl:otherwise><xsl:value-of select="$pStatus"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='CAN - Alberta'">Canadian States;CAN - Alberta</xsl:when>
			<xsl:when test="$pRegion='CAN - Manitoba'">Canadian States;CAN - Manitoba</xsl:when>
			<xsl:when test="$pRegion='CAN - Newfoundland'">Canadian States;CAN - Newfoundland</xsl:when>
			<xsl:when test="$pRegion='CAN - Northwest Territory'">Canadian States;CAN - Northwest Territory</xsl:when>
			<xsl:when test="$pRegion='CAN - Nova Scotia'">Canadian States;CAN - Nova Scotia</xsl:when>
			<xsl:when test="$pRegion='CAN - Nunavut'">Canadian States;CAN - Nunavut</xsl:when>
			<xsl:when test="$pRegion='CAN - Ontario'">Canadian States;CAN - Ontario</xsl:when>
			<xsl:when test="$pRegion='CAN - Prince Edward Island'">Canadian States;CAN - Prince Edward Island</xsl:when>
			<xsl:when test="$pRegion='CAN - Quebec'">Canadian States;CAN - Quebec</xsl:when>
			<xsl:when test="$pRegion='PR - Puerto Rico'">ISO Countries;PR - Puerto Rico</xsl:when>
			<xsl:when test="$pRegion='US - Arizona'">US States;US - Arizona</xsl:when>
			<xsl:when test="$pRegion='US - Arkansas'">US States;US - Arkansas</xsl:when>
			<xsl:when test="$pRegion='US - California'">US States;US - California</xsl:when>
			<xsl:when test="$pRegion='US - Delaware'">US States;US - Delaware</xsl:when>
			<xsl:when test="$pRegion='US - Georgia'">US States;US - Georgia</xsl:when>
			<xsl:when test="$pRegion='US - Hawaii'">US States;US - Hawaii</xsl:when>
			<xsl:when test="$pRegion='US - Kansas'">US States;US - Kansas</xsl:when>
			<xsl:when test="$pRegion='US - Louisiana'">US States;US - Louisiana</xsl:when>
			<xsl:when test="$pRegion='US - Michigan'">US States;US - Michigan</xsl:when>
			<xsl:when test="$pRegion='US - Mississippi'">US States;US - Mississippi</xsl:when>
			<xsl:when test="$pRegion='US - Missouri'">US States;US - Missouri</xsl:when>
			<xsl:when test="$pRegion='US - New Jersey'">US States;US - New Jersey</xsl:when>
			<xsl:when test="$pRegion='US - North Carolina'">US States;US - North Carolina</xsl:when>
			<xsl:when test="$pRegion='US - Ohio'">US States;US - Ohio</xsl:when>
			<xsl:when test="$pRegion='US - Oregon'">US States;US - Oregon</xsl:when>
			<xsl:when test="$pRegion='US - Pennsylvania'">US States;US - Pennsylvania</xsl:when>
			<xsl:when test="$pRegion='US - South Dakota'">US States;US - South Dakota</xsl:when>
			<xsl:when test="$pRegion='US - Vermont'">US States;US - Vermont</xsl:when>
			<xsl:when test="$pRegion='US - Virginia'">US States;US - Virginia</xsl:when>
			<xsl:when test="$pRegion='US - West Virginia'">US States;US - West Virginia</xsl:when>
			<xsl:when test="$pRegion='US - Wisconsin'">US States;US - Wisconsin</xsl:when>
			<xsl:when test="$pRegion='CAN - Alberta'">Canadian States;CAN - Alberta</xsl:when>
			<xsl:when test="$pRegion='CAN - British Columbia'">Canadian States;CAN - British Columbia</xsl:when>
			<xsl:when test="$pRegion='CAN - Labrador'">Canadian States;CAN - Labrador</xsl:when>
			<xsl:when test="$pRegion='CAN - New Brunswick'">Canadian States;CAN - New Brunswick</xsl:when>
			<xsl:when test="$pRegion='CAN - Saskatchewan'">Canadian States;CAN - Saskatchewan</xsl:when>
			<xsl:when test="$pRegion='CAN - Yukon Territory'">Canadian States;CAN - Yukon Territory</xsl:when>
			<xsl:when test="$pRegion='GR - Greenland'">ISO Countries;GR - Greenland</xsl:when>
			<xsl:when test="$pRegion='SPM - Saint Pierre and Miquelon'">Islands;SPM - Saint Pierre and Miquelon</xsl:when>
			<xsl:when test="$pRegion='US - Alabama'">US States;US - Alabama</xsl:when>
			<xsl:when test="$pRegion='US - Alaska'">US States;US - Alaska</xsl:when>
			<xsl:when test="$pRegion='US - Colorado'">US States;US - Colorado</xsl:when>
			<xsl:when test="$pRegion='US - Connecticut'">US States;US - Connecticut</xsl:when>
			<xsl:when test="$pRegion='US - District of Columbia'">US States;US - District of Columbia</xsl:when>
			<xsl:when test="$pRegion='US - Florida'">US States;US - Florida</xsl:when>
			<xsl:when test="$pRegion='US - Idaho'">US States;US - Idaho</xsl:when>
			<xsl:when test="$pRegion='US - Illinois'">US States;US - Illinois</xsl:when>
			<xsl:when test="$pRegion='US - Indiana'">US States;US - Indiana</xsl:when>
			<xsl:when test="$pRegion='US - Iowa'">US States;US - Iowa</xsl:when>
			<xsl:when test="$pRegion='US - Kentucky'">US States;US - Kentucky</xsl:when>
			<xsl:when test="$pRegion='US - Maine'">US States;US - Maine</xsl:when>
			<xsl:when test="$pRegion='US - Maryland'">US States;US - Maryland</xsl:when>
			<xsl:when test="$pRegion='US - Massachusetts'">US States;US - Massachusetts</xsl:when>
			<xsl:when test="$pRegion='US - Minnesota'">US States;US - Minnesota</xsl:when>
			<xsl:when test="$pRegion='US - Montana'">US States;US - Montana</xsl:when>
			<xsl:when test="$pRegion='US - Nebraska'">US States;US - Nebraska</xsl:when>
			<xsl:when test="$pRegion='US - Nevada'">US States;US - Nevada</xsl:when>
			<xsl:when test="$pRegion='US - New Hampshire'">US States;US - New Hampshire</xsl:when>
			<xsl:when test="$pRegion='US - New Mexico'">US States;US - New Mexico</xsl:when>
			<xsl:when test="$pRegion='US - New York'">US States;US - New York</xsl:when>
			<xsl:when test="$pRegion='US - North Dakota'">US States;US - North Dakota</xsl:when>
			<xsl:when test="$pRegion='US - Oklahoma'">US States;US - Oklahoma</xsl:when>
			<xsl:when test="$pRegion='US - Rhode Island'">US States;US - Rhode Island</xsl:when>
			<xsl:when test="$pRegion='US - South Carolina'">US States;US - South Carolina</xsl:when>
			<xsl:when test="$pRegion='US - Tennessee'">US States;US - Tennessee</xsl:when>
			<xsl:when test="$pRegion='US - Texas'">US States;US - Texas</xsl:when>
			<xsl:when test="$pRegion='US - Utah'">US States;US - Utah</xsl:when>
			<xsl:when test="$pRegion='US - Washington'">US States;US - Washington</xsl:when>
			<xsl:when test="$pRegion='US - Wyoming'">US States;US - Wyoming</xsl:when>
			<xsl:when test="$pRegion='VI - Virgin Islands'">Islands;VI - Virgin Islands</xsl:when>
			<xsl:otherwise>US States?;<xsl:value-of select="$pRegion"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
