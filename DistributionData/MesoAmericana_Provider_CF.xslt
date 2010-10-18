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
				<xsl:attribute name="origin">Unknown</xsl:attribute>
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
			<xsl:when test="$pIn='Angola'">ISO Countries; Angola</xsl:when>
			<xsl:when test="$pIn='Algeria'">ISO Countries; Algeria</xsl:when>
			<xsl:when test="$pIn='American Samoa'">ISO Countries; American Samoa</xsl:when>
			<xsl:when test="$pIn='Argentina'">ISO Countries; Argentina</xsl:when>
			<xsl:when test="$pIn='Australia'">ISO Countries; Australia</xsl:when>
			<xsl:when test="$pIn='Belize'">ISO Countries; Belize</xsl:when>
			<xsl:when test="$pIn='Bhutan'">ISO Countries; Bhutan</xsl:when>
			<xsl:when test="$pIn='Bioko'">Islands; Bioko</xsl:when>
			<xsl:when test="$pIn='Bolivia'">ISO Countries; Bolivia</xsl:when>
			<xsl:when test="$pIn='Botswana'">ISO Countries; Botswana</xsl:when>
			<xsl:when test="$pIn='Brazil'">ISO Countries; Brazil</xsl:when>
			<xsl:when test="$pIn='Burma'">ISO Countries; Burma</xsl:when>
			<xsl:when test="$pIn='Burundi'">ISO Countries; Burundi</xsl:when>
			<xsl:when test="$pIn='Cabinda'">Province of Angola; Cabinda</xsl:when>
			<xsl:when test="$pIn='Cameroon'">ISO Countries; Cameroon</xsl:when>
			<xsl:when test="$pIn='Canada'">ISO Countries; Canada</xsl:when>
			<xsl:when test="$pIn='Canary Islands'">Islands; Canary Islands</xsl:when>
			<xsl:when test="$pIn='Cape Verde'">ISO Countries; Cape Verde</xsl:when>
			<xsl:when test="$pIn='Caribbean'">Region; Caribbean</xsl:when>
			<xsl:when test="$pIn='Central African Republic'">ISO Countries; Central African Republic</xsl:when>
			<xsl:when test="$pIn='Chile'">ISO Countries; Chile</xsl:when>
			<xsl:when test="$pIn='China'">ISO Countries; China</xsl:when>
			<xsl:when test="$pIn='Colombia'">ISO Countries; Colombia</xsl:when>
			<xsl:when test="$pIn='Comoros'">ISO Countries; Comoros</xsl:when>
			<xsl:when test="$pIn='Congo'">ISO Countries; Congo</xsl:when>
			<xsl:when test="$pIn='Cook Isl'">Islands; Cook Isl</xsl:when>
			<xsl:when test="$pIn='Corsica'">Islands; Corsica</xsl:when>
			<xsl:when test="$pIn='Costa Rica'">ISO Countries; Costa Rica</xsl:when>
			<xsl:when test="$pIn='Ecuador'">ISO Countries; Ecuador</xsl:when>
			<xsl:when test="$pIn='El Salvador'">ISO Countries; El Salvador</xsl:when>
			<xsl:when test="$pIn='Ethiopia'">ISO Countries; Ethiopia</xsl:when>
			<xsl:when test="$pIn='Fiji'">ISO Countries; Fiji</xsl:when>
			<xsl:when test="$pIn='France'">ISO Countries; France</xsl:when>
			<xsl:when test="$pIn='French Guiana'">ISO Countries; French Guiana</xsl:when>
			<xsl:when test="$pIn='Gabon'">ISO Countries; Gabon</xsl:when>
			<xsl:when test="$pIn='Gambia'">ISO Countries; Gambia</xsl:when>
			<xsl:when test="$pIn='Ghana'">ISO Countries; Ghana</xsl:when>
			<xsl:when test="$pIn='Great Britain'">ISO Countries; Great Britain</xsl:when>
			<xsl:when test="$pIn='Greece'">ISO Countries; Greece</xsl:when>
			<xsl:when test="$pIn='Greenland'">ISO Countries; Greenland</xsl:when>
			<xsl:when test="$pIn='Guam'">ISO Countries; Guam</xsl:when>
			<xsl:when test="$pIn='Guatemala'">ISO Countries; Guatemala</xsl:when>
			<xsl:when test="$pIn='Guinea'">ISO Countries; Guinea</xsl:when>
			<xsl:when test="$pIn='Guinea-Bissau'">ISO Countries; Guinea-Bissau</xsl:when>
			<xsl:when test="$pIn='Guyana'">ISO Countries; Guyana</xsl:when>
			<xsl:when test="$pIn='Hawaiian Isl'">Islands; Hawaiian Isl</xsl:when>
			<xsl:when test="$pIn='Honduras'">ISO Countries; Honduras</xsl:when>
			<xsl:when test="$pIn='India'">ISO Countries; India</xsl:when>
			<xsl:when test="$pIn='Indonesia'">ISO Countries; Indonesia</xsl:when>
			<xsl:when test="$pIn='Ivory Coast'">ISO Countries; Ivory Coast</xsl:when>
			<xsl:when test="$pIn='Japan'">ISO Countries; Japan</xsl:when>
			<xsl:when test="$pIn='Java'">ISO Countries; Java</xsl:when>
			<xsl:when test="$pIn='Kenya'">ISO Countries; Kenya</xsl:when>
			<xsl:when test="$pIn='Liberia'">ISO Countries; Liberia</xsl:when>
			<xsl:when test="$pIn='Madagascar'">ISO Countries; Madagascar</xsl:when>
			<xsl:when test="$pIn='Malawi'">ISO Countries; Malawi</xsl:when>
			<xsl:when test="$pIn='Malaysia'">ISO Countries; Malaysia</xsl:when>
			<xsl:when test="$pIn='Marquesas'">Islands; Marquesas</xsl:when>
			<xsl:when test="$pIn='Marshall Isl'">Islands; Marshall Isl</xsl:when>
			<xsl:when test="$pIn='Mexico'">ISO Countries; Mexico</xsl:when>
			<xsl:when test="$pIn='Micronesia Federated States'">Islands; Micronesia Federated States</xsl:when>
			<xsl:when test="$pIn='Mozambique'">ISO Countries; Mozambique</xsl:when>
			<xsl:when test="$pIn='Namibia'">ISO Countries; Namibia</xsl:when>
			<xsl:when test="$pIn='Nepal'">ISO Countries; Nepal</xsl:when>
			<xsl:when test="$pIn='New Guinea'">ISO Countries; New Guinea</xsl:when>
			<xsl:when test="$pIn='New Zealand'">ISO Countries; New Zealand</xsl:when>
			<xsl:when test="$pIn='Nicaragua'">ISO Countries; Nicaragua</xsl:when>
			<xsl:when test="$pIn='Niger'">ISO Countries; Niger</xsl:when>
			<xsl:when test="$pIn='Nigeria'">ISO Countries; Nigeria</xsl:when>
			<xsl:when test="$pIn='Northern Marianas'">Islands; Northern Marianas</xsl:when>
			<xsl:when test="$pIn='Panama'">ISO Countries; Panama</xsl:when>
			<xsl:when test="$pIn='Papua New Guinea'">ISO Countries; Papua New Guinea</xsl:when>
			<xsl:when test="$pIn='Paraguay'">ISO Countries; Paraguay</xsl:when>
			<xsl:when test="$pIn='Peru'">ISO Countries; Peru</xsl:when>
			<xsl:when test="$pIn='Philippines'">ISO Countries; Philippines</xsl:when>
			<xsl:when test="$pIn='Rwanda'">ISO Countries; Rwanda</xsl:when>
			<xsl:when test="$pIn='Saudi Arabia'">ISO Countries; Saudi Arabia</xsl:when>
			<xsl:when test="$pIn='Senegal'">ISO Countries; Senegal</xsl:when>
			<xsl:when test="$pIn='Seychelles'">ISO Countries; Seychelles</xsl:when>
			<xsl:when test="$pIn='Sierra Leone'">ISO Countries; Sierra Leone</xsl:when>
			<xsl:when test="$pIn='Society Isl'">Islands; Society Isl</xsl:when>
			<xsl:when test="$pIn='Solomon Isl'">Islands; Solomon Isl</xsl:when>
			<xsl:when test="$pIn='Somalia'">ISO Countries; Somalia</xsl:when>
			<xsl:when test="$pIn='South Africa'">ISO Countries; South Africa</xsl:when>
			<xsl:when test="$pIn='Spain'">ISO Countries; Spain</xsl:when>
			<xsl:when test="$pIn='Sri Lanka'">ISO Countries; Sri Lanka</xsl:when>
			<xsl:when test="$pIn='Sudan'">ISO Countries; Sudan</xsl:when>
			<xsl:when test="$pIn='Sulawesi'">Islands; Sulawesi</xsl:when>
			<xsl:when test="$pIn='Sumatra'">Islands; Sumatra</xsl:when>
			<xsl:when test="$pIn='Suriname'">ISO Countries; Suriname</xsl:when>
			<xsl:when test="$pIn='Taiwan'">ISO Countries; Taiwan</xsl:when>
			<xsl:when test="$pIn='Tanzania'">ISO Countries; Tanzania</xsl:when>
			<xsl:when test="$pIn='Thailand'">ISO Countries; Thailand</xsl:when>
			<xsl:when test="$pIn='Togo'">ISO Countries; Togo</xsl:when>
			<xsl:when test="$pIn='Tokelau Isl'">Islands; Tokelau Isl</xsl:when>
			<xsl:when test="$pIn='Tonga'">ISO Countries; Tonga</xsl:when>
			<xsl:when test="$pIn='Tuamotu Isl'">Islands; Tuamotu Isl</xsl:when>
			<xsl:when test="$pIn='Uganda'">ISO Countries; Uganda</xsl:when>
			<xsl:when test="$pIn='United States'">ISO Countries; United States</xsl:when>
			<xsl:when test="$pIn='Uruguay'">ISO Countries; Uruguay</xsl:when>
			<xsl:when test="$pIn='Vanuatu'">ISO Countries; Vanuatu</xsl:when>
			<xsl:when test="$pIn='Venezuela'">ISO Countries; Venezuela</xsl:when>
			<xsl:when test="$pIn='Western Samoa'">Islands; Western Samoa</xsl:when>
			<xsl:when test="$pIn='Zaire'">ISO Countries; Zaire</xsl:when>
			<xsl:when test="$pIn='Zambia'">ISO Countries; Zambia</xsl:when>
			<xsl:when test="$pIn='Zimbabwe'">ISO Countries; Zimbabwe</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
