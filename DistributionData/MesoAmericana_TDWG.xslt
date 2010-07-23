<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml MesoAmericana_sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="translate(., '.', ',')"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:variable name="vTDWG">
					<xsl:call-template name="conTDWG">
						<xsl:with-param name="pIn" select="normalize-space(substring-before($pText, ','))"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pSchema" select="substring-before($vTDWG, ';')"/>
					<xsl:with-param name="pRegion" select="substring-after($vTDWG, '; ')"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="vTDWG">
					<xsl:call-template name="conTDWG">
						<xsl:with-param name="pIn" select="substring-before($pText, ',')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pSchema" select="substring-before($vTDWG, ';')"/>
					<xsl:with-param name="pRegion" select="substring-after($vTDWG, '; ')"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="writeValue">
		<xsl:param name="pSchema"/>
		<xsl:param name="pRegion"/>
		<xsl:if test="$pSchema!=''">
			<xsl:variable name="vRegion">
				<xsl:choose>
					<xsl:when test="contains($pRegion, ',')">
						<xsl:value-of select="substring-before($pRegion, ',')"/>
						
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="$pRegion"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="$pSchema"/></xsl:attribute>
				<xsl:attribute name="region"><xsl:value-of select="normalize-space($vRegion)"/></xsl:attribute>
				<xsl:attribute name="occurrence">Present</xsl:attribute>
				<xsl:attribute name="origin"/>
				<xsl:attribute name="isOriginal">true</xsl:attribute>
			</Distribution>
			<xsl:if test="contains($pRegion, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pSchema" select="$pSchema"/>
					<xsl:with-param name="pRegion" select="substring-after($pRegion, ', ')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="conTDWG">
		<xsl:param name="pIn"/>
		<xsl:choose>
			<xsl:when test="$pIn='Angola'">TDWG Level 4; ANG-OO</xsl:when>
			<xsl:when test="$pIn='Argentina'">TDWG Level 3; AGE, AGS, AGW</xsl:when>
			<xsl:when test="$pIn='Belize'">TDWG Level 4; BLZ-OO</xsl:when>
			<xsl:when test="$pIn='Bolivia'">TDWG Level 4; BOL-OO</xsl:when>
			<xsl:when test="$pIn='Brazil'">TDWG Level 2; 84</xsl:when>
			<xsl:when test="$pIn='Cameroon'">TDWG Level 4; CMN-OO</xsl:when>
			<xsl:when test="$pIn='Canada'">TDWG Level 3; 71, 72</xsl:when>
			<xsl:when test="$pIn='Caribbean'">TDWG Level 3; 81</xsl:when>
			<xsl:when test="$pIn='Central African Republic'">TDWG Level 4; CAF-OO</xsl:when>
			<xsl:when test="$pIn='Chile'">TDWG Level 2; CLC, CLN, CLS</xsl:when>
			<xsl:when test="$pIn='China'">TDWG Level 2; 36</xsl:when>
			<xsl:when test="$pIn='Colombia'">TDWG Level 4; CLM-00</xsl:when>
			<xsl:when test="$pIn='Comoros'">TDWG Level 3; COM</xsl:when>
			<xsl:when test="$pIn='Costa Rica'">TDWG Level 4; COS-OO</xsl:when>
			<xsl:when test="$pIn='Ecuador'">TDWG Level 4; ECU-OO</xsl:when>
			<xsl:when test="$pIn='El Salvador'">TDWG Level 4; ELS-OO</xsl:when>
			<xsl:when test="$pIn='Gabon'">TDWG Level 4; GAB-OO</xsl:when>
			<xsl:when test="$pIn='Gambia'">TDWG Level 4; GAM-OO</xsl:when>
			<xsl:when test="$pIn='Ghana'">TDWG Level 4; GHA-OO</xsl:when>
			<xsl:when test="$pIn='Greenland'">TDWG Level 4; GNL-OO</xsl:when>
			<xsl:when test="$pIn='Guatemala'">TDWG Level 4; GUA-OO</xsl:when>
			<xsl:when test="$pIn='Guyana'">TDWG Level 4; GUY-OO</xsl:when>
			<xsl:when test="$pIn='Honduras'">TDWG Level 4; HON-OO</xsl:when>
			<xsl:when test="$pIn='India'">TDWG Level 3; IND</xsl:when>
			<xsl:when test="$pIn='Ivory Coast'">TDWG Level 4; IVO-00</xsl:when>
			<xsl:when test="$pIn='Kenya'">TDWG Level 4; KEN-OO</xsl:when>
			<xsl:when test="$pIn='Liberia'">TDWG Level 4; LBR-OO</xsl:when>
			<xsl:when test="$pIn='Madagascar'">TDWG Level 4; MDG-OO</xsl:when>
			<xsl:when test="$pIn='Malawi'">TDWG Level 4; MLW-OO</xsl:when>
			<xsl:when test="$pIn='Mexico'">TDWG Level 2; 79</xsl:when>
			<xsl:when test="$pIn='Mozambique'">TDWG Level 4; MOZ-OO</xsl:when>
			<xsl:when test="$pIn='New Zealand'">TDWG Level 2; 51</xsl:when>
			<xsl:when test="$pIn='Nicaragua'">TDWG Level 4; NIC-00</xsl:when>
			<xsl:when test="$pIn='Panama'">TDWG Level 4; PAN-OO</xsl:when>
			<xsl:when test="$pIn='Paraguay'">TDWG Level 4; PAR-OO</xsl:when>
			<xsl:when test="$pIn='Peru'">TDWG Level 4; PER-OO</xsl:when>
			<xsl:when test="$pIn='Rwanda'">TDWG Level 4; RWA-OO</xsl:when>
			<xsl:when test="$pIn='Senegal'">TDWG Level 4; SEN-OO</xsl:when>
			<xsl:when test="$pIn='Sierra Leone'">TDWG Level 4; SIE-OO</xsl:when>
			<xsl:when test="$pIn='South Africa'">TDWG Level 2; 27</xsl:when>
			<xsl:when test="$pIn='Sri Lanka'">TDWG Level 4; SRL-OO</xsl:when>
			<xsl:when test="$pIn='Sudan'">TDWG Level 4; SUD-OO</xsl:when>
			<xsl:when test="$pIn='Tanzania'">TDWG Level 4; TAN-OO</xsl:when>
			<xsl:when test="$pIn='Togo'">TDWG Level 4; TOG-OO</xsl:when>
			<xsl:when test="$pIn='Uganda'">TDWG Level 4; UGA-OO</xsl:when>
			<xsl:when test="$pIn='United States'">TDWG Level 2; 75, 76, 77, 78</xsl:when>
			<xsl:when test="$pIn='Venezuela'">TDWG Level 4; VEN-OO</xsl:when>
			<xsl:when test="$pIn='Zaire'">TDWG Level 4; ZAI-OO</xsl:when>
			<xsl:when test="$pIn='Zambia'">TDWG Level 4; ZAM-OO</xsl:when>
			<xsl:when test="$pIn='Zimbabwe'">TDWG Level 4; ZIM-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
