<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml SouthernCone_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:variable name="vBiostatus">
				<xsl:call-template name="conBiostatus">
					<xsl:with-param name="pProv">
						<xsl:value-of select="normalize-space(substring-after(., '.'))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="translate(substring-before(., '.'), '()', ',')"/>
				<xsl:with-param name="pBiostatus" select="$vBiostatus"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:param name="pBiostatus"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:when>
			<!--do we need an otherwise here?-->
			<xsl:otherwise>
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="$pText"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:param name="pBiostatus"/>
		<xsl:if test="$pRegion!=''">
			<xsl:variable name="vRegion">
				<xsl:call-template name="conRegion">
					<xsl:with-param name="pProv" select="normalize-space($pRegion)"/>
				</xsl:call-template>
			</xsl:variable>
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="region">	<xsl:value-of select="substring-after($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="occurrence"><xsl:value-of select="substring-before($pBiostatus, ';')"/></xsl:attribute>
				<xsl:attribute name="origin"><xsl:value-of select="substring-after($pBiostatus, ';')"/></xsl:attribute>
				<!--<xsl:attribute name="isOriginal">true</xsl:attribute>-->
			</Distribution>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="conBiostatus">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Present.'">Present;</xsl:when>
			<xsl:when test="$pProv='Endemic.'">Present;Endemic</xsl:when>
			<xsl:when test="$pProv='Exotic.'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='Cultivated.'">Present;Cultivated</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Abyssinia'">TDWG Level 4;ETH-OO</xsl:when>
			<xsl:when test="$pProv='Afghanistan'">TDWG Level 4;AFG-OO</xsl:when>
			<xsl:when test="$pProv='Africa'">TDWG Level 1;2</xsl:when>
			<xsl:when test="$pProv='Albania'">TDWG Level 4;ALB-OO</xsl:when>
			<xsl:when test="$pProv='Algeria'">TDWG Level 4;ALG-OO</xsl:when>
			<xsl:when test="$pProv='Angola'">TDWG Level 4;ANG-OO</xsl:when>
			<xsl:when test="$pProv='Antigua'">TDWG Level 4;LEE-AB</xsl:when>
			<xsl:when test="$pProv='Antigua and Barbuda'">TDWG Level 4;LEE-AB</xsl:when>
			<xsl:when test="$pProv='Argentina'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pProv='Armenia'">TDWG Level 4;TCS-AR</xsl:when>
			<xsl:when test="$pProv='Australia'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pProv='Austria'">TDWG Level 4;AUT-AU</xsl:when>
			<xsl:when test="$pProv='Azerbaijan'">TDWG Level 4;TCS-AZ</xsl:when>
			<xsl:when test="$pProv='Bahamas'">TDWG Level 4;BAH-OO</xsl:when>
			<xsl:when test="$pProv='Bangladesh'">TDWG Level 4;BAN-OO</xsl:when>
			<xsl:when test="$pProv='Barbados'">TDWG Level 4;WIN-BA</xsl:when>
			<xsl:when test="$pProv='Barbuda'">TDWG Level 4;LEE-AB</xsl:when>
			<xsl:when test="$pProv='Belarus'">TDWG Level 4;BLR-OO</xsl:when>
			<xsl:when test="$pProv='Belgium'">TDWG Level 4;BGM-BE</xsl:when>
			<xsl:when test="$pProv='Belize'">TDWG Level 4;BLZ-OO</xsl:when>
			<xsl:when test="$pProv='Benin'">TDWG Level 4;BEN-OO</xsl:when>
			<xsl:when test="$pProv='Bhutan'">TDWG Level 4;EHM-BH</xsl:when>
			<xsl:when test="$pProv='Bolivia'">TDWG Level 4;BOL-OO</xsl:when>
			<xsl:when test="$pProv='Bolivia'">TDWG Level 4;BOL-OO</xsl:when>
			<xsl:when test="$pProv='Botswana'">TDWG Level 4;BOT-OO</xsl:when>
			<xsl:when test="$pProv='Brazil'">TDWG Level 2;84</xsl:when>
			<xsl:when test="$pProv='Bulgaria'">TDWG Level 4;BUL-OO</xsl:when>
			<xsl:when test="$pProv='Burundi'">TDWG Level 4;BUR-OO</xsl:when>
			<xsl:when test="$pProv='Cambodia'">TDWG Level 4;CBD-OO</xsl:when>
			<xsl:when test="$pProv='Cameroon'">TDWG Level 4;CMN-OO</xsl:when>
			<xsl:when test="$pProv='Canada'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pProv='Canary Islands'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Cape Verde'">TDWG Level 4;CVI-OO</xsl:when>
			<xsl:when test="$pProv='Caribbean'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pProv='Caribbean Islands'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pProv='Cayman Islands'">TDWG Level 4;CAY-OO</xsl:when>
			<xsl:when test="$pProv='Central African Republic'">TDWG Level 4;CAF-OO</xsl:when>
			<xsl:when test="$pProv='Chad'">TDWG Level 4;CHA-OO</xsl:when>
			<xsl:when test="$pProv='Chile'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pProv='China'">TDWG Level 2;36</xsl:when>
			<xsl:when test="$pProv='Colombia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pProv='Congo'">TDWG Level 4;CON-OO</xsl:when>
			<xsl:when test="$pProv='Cook Islands'">TDWG Level 4;COO-OO</xsl:when>
			<xsl:when test="$pProv='Costa Rica'">TDWG Level 4;COS-OO</xsl:when>
			<xsl:when test="$pProv='Ivory Coast'">TDWG Level 4;IVO-OO</xsl:when>
			<xsl:when test="$pProv='Cuba'">TDWG Level 4;CUB-OO</xsl:when>
			<xsl:when test="$pProv='Cyprus'">TDWG Level 4;CYP-OO</xsl:when>
			<xsl:when test="$pProv='Czech Republic'">TDWG Level 4;CZE-CZ</xsl:when>
			<xsl:when test="$pProv='Czechoslovakia'">TDWG Level 3;CZE</xsl:when>
			<xsl:when test="$pProv='Denmark'">TDWG Level 4;DEN-OO</xsl:when>
			<xsl:when test="$pProv='Dominica'">TDWG Level 4;WIN-DO</xsl:when>
			<xsl:when test="$pProv='Dominican Republic'">TDWG Level 4;DOM-OO</xsl:when>
			<xsl:when test="$pProv='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pProv='Egypt'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pProv='El Salvador'">TDWG Level 4;ELS-OO</xsl:when>
			<xsl:when test="$pProv='England'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pProv='Equatorial Guinea'">TDWG Level 4;EQG-OO</xsl:when>
			<xsl:when test="$pProv='Estonia'">TDWG Level 4;BLT-ES</xsl:when>
			<xsl:when test="$pProv='Ethiopia'">TDWG Level 4;ETH-OO</xsl:when>
			<xsl:when test="$pProv='Europe'">TDWG Level 1;1</xsl:when>
			<xsl:when test="$pProv='Faroe Islands'">TDWG Level 4;FOR-OO</xsl:when>
			<xsl:when test="$pProv='Fiji'">TDWG Level 4;FIJ-OO</xsl:when>
			<xsl:when test="$pProv='Fiji Islands'">TDWG Level 4;FIJ-OO</xsl:when>
			<xsl:when test="$pProv='Finland'">TDWG Level 4;FIN-OO</xsl:when>
			<xsl:when test="$pProv='Former Yugoslavia'">TDWG Level 3;YUG</xsl:when>
			<xsl:when test="$pProv='France'">TDWG Level 4;FRA-FR</xsl:when>
			<xsl:when test="$pProv='French Guiana'">TDWG Level 4;FRG-OO</xsl:when>
			<xsl:when test="$pProv='Gabon'">TDWG Level 4;GAB-OO</xsl:when>
			<xsl:when test="$pProv='Gambia'">TDWG Level 4;GAM-OO</xsl:when>
			<xsl:when test="$pProv='Georgia'">TDWG Level 4;TCS-GR</xsl:when>
			<xsl:when test="$pProv='Germany'">TDWG Level 4;GER-OO</xsl:when>
			<xsl:when test="$pProv='Ghana'">TDWG Level 4;GHA-OO</xsl:when>
			<xsl:when test="$pProv='Greece'">TDWG Level 4;GRC-OO</xsl:when>
			<xsl:when test="$pProv='Grenada'">TDWG Level 4;WIN-GR</xsl:when>
			<xsl:when test="$pProv='Guadeloupe'">TDWG Level 4;LEE-GU</xsl:when>
			<xsl:when test="$pProv='Guatemala'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pProv='Guinea'">TDWG Level 4;GUI-OO</xsl:when>
			<xsl:when test="$pProv='Guinea-Bissau'">TDWG Level 4;GNB-OO</xsl:when>
			<xsl:when test="$pProv='Guyana'">TDWG Level 4;GUY-OO</xsl:when>
			<xsl:when test="$pProv='Haiti'">TDWG Level 4;HAI-HA</xsl:when>
			<xsl:when test="$pProv='Hawaii'">TDWG Level 3;HAW</xsl:when>
			<xsl:when test="$pProv='Hawaii Islands'">TDWG Level 4;HAW-HI</xsl:when>
			<xsl:when test="$pProv='Honduras'">TDWG Level 4;HON-OO</xsl:when>
			<xsl:when test="$pProv='Hongkong'">TDWG Level 4;CHS-HK</xsl:when>
			<xsl:when test="$pProv='Hungary'">TDWG Level 4;HUN-OO</xsl:when>
			<xsl:when test="$pProv='Iceland'">TDWG Level 4;ICE-OO</xsl:when>
			<xsl:when test="$pProv='India'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pProv='Indonesia'">TDWG Level 2;42</xsl:when>
			<xsl:when test="$pProv='Iran'">TDWG Level 4;IRN-OO</xsl:when>
			<xsl:when test="$pProv='Iraq'">TDWG Level 4;IRQ-OO</xsl:when>
			<xsl:when test="$pProv='Ireland'">TDWG Level 4;IRE-IR</xsl:when>
			<xsl:when test="$pProv='Israel'">TDWG Level 4;PAL-IS</xsl:when>
			<xsl:when test="$pProv='Italy'">TDWG Level 4;ITA-IT</xsl:when>
			<xsl:when test="$pProv='Jamaica'">TDWG Level 4;JAM-OO</xsl:when>
			<xsl:when test="$pProv='Japan'">TDWG Level 3;JAP</xsl:when>
			<xsl:when test="$pProv='Jordan'">TDWG Level 4;PAL-JO</xsl:when>
			<xsl:when test="$pProv='Kazakhstan'">TDWG Level 4;KAZ-OO</xsl:when>
			<xsl:when test="$pProv='Kenya'">TDWG Level 4;KEN-OO</xsl:when>
			<xsl:when test="$pProv='Korea'">TDWG Level 3;KOR</xsl:when>
			<xsl:when test="$pProv='Kurdistan'">TDWG Level 2;34</xsl:when>
			<xsl:when test="$pProv='Kyrgyzstan'">TDWG Level 4;KGZ-OO</xsl:when>
			<xsl:when test="$pProv='Laos'">TDWG Level 4;LAO-OO</xsl:when>
			<xsl:when test="$pProv='Latvia'">TDWG Level 4;BLT-LA</xsl:when>
			<xsl:when test="$pProv='Lebanon'">TDWG Level 4;LBS-LB</xsl:when>
			<xsl:when test="$pProv='Lesotho'">TDWG Level 4;LES-OO</xsl:when>
			<xsl:when test="$pProv='Liberia'">TDWG Level 4;LBR-OO</xsl:when>
			<xsl:when test="$pProv='Libya'">TDWG Level 4;LBY-OO</xsl:when>
			<xsl:when test="$pProv='Lithuania'">TDWG Level 4;BLT-LI</xsl:when>
			<xsl:when test="$pProv='Madagascar'">TDWG Level 4;MDG-OO</xsl:when>
			<xsl:when test="$pProv='Malawi'">TDWG Level 4;MLW-OO</xsl:when>
			<xsl:when test="$pProv='Malaysia'">TDWG Level 3;MLY</xsl:when>
			<xsl:when test="$pProv='Maldives'">TDWG Level 4;MDV-OO</xsl:when>
			<xsl:when test="$pProv='Mali'">TDWG Level 4;MLI-OO</xsl:when>
			<xsl:when test="$pProv='Malta'">TDWG Level 4;SIC-MA</xsl:when>
			<xsl:when test="$pProv='Marshall Islands'">TDWG Level 4;MRS-OO</xsl:when>
			<xsl:when test="$pProv='Martinique'">TDWG Level 4;WIN-MA</xsl:when>
			<xsl:when test="$pProv='Mauritania'">TDWG Level 4;MTN-OO</xsl:when>
			<xsl:when test="$pProv='Mauritius'">TDWG Level 4;MAU-OO</xsl:when>
			<xsl:when test="$pProv='Mexico'">TDWG Level 2;79</xsl:when>
			<xsl:when test="$pProv='Micronesia'">TDWG Level 2;62</xsl:when>
			<xsl:when test="$pProv='Moldova'">TDWG Level 4;UKR-MO</xsl:when>
			<xsl:when test="$pProv='Mongolia'">TDWG Level 4;MON-OO</xsl:when>
			<xsl:when test="$pProv='Montserrat'">TDWG Level 4;LEE-MO</xsl:when>
			<xsl:when test="$pProv='Morocco'">TDWG Level 4;MOR-MO</xsl:when>
			<xsl:when test="$pProv='Mozambique'">TDWG Level 4;MOZ-OO</xsl:when>
			<xsl:when test="$pProv='Myanmar'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pProv='Namibia'">TDWG Level 4;NAM-OO</xsl:when>
			<xsl:when test="$pProv='Nepal'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pProv='Netherlands'">TDWG Level 4;NET-OO</xsl:when>
			<xsl:when test="$pProv='New Caledonia'">TDWG Level 4;NWC-OO</xsl:when>
			<xsl:when test="$pProv='New Zealand'">TDWG Level 2;51</xsl:when>
			<xsl:when test="$pProv='Nicaragua'">TDWG Level 4;NIC-OO</xsl:when>
			<xsl:when test="$pProv='Niger'">TDWG Level 4;NGR-OO</xsl:when>
			<xsl:when test="$pProv='Nigeria'">TDWG Level 4;NGA-OO</xsl:when>
			<xsl:when test="$pProv='North America'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pProv='Norway'">TDWG Level 4;NOR-OO</xsl:when>
			<xsl:when test="$pProv='Pacific Island'">TDWG Level 1;6</xsl:when>
			<xsl:when test="$pProv='Pacific Islands'">TDWG Level 1;6</xsl:when>
			<xsl:when test="$pProv='Pakistan '">TDWG Level 4;PAK-OO</xsl:when>
			<xsl:when test="$pProv='Panama'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pProv='Papua New Guinea'">TDWG Level 4;NWG-PN</xsl:when>
			<xsl:when test="$pProv='Paraguay'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='Peru'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pProv='Philippines'">TDWG Level 4;PHI-OO</xsl:when>
			<xsl:when test="$pProv='Poland'">TDWG Level 4;POL-OO</xsl:when>
			<xsl:when test="$pProv='Polynesia'">TDWG Level 1;6</xsl:when>
			<xsl:when test="$pProv='Portugal'">TDWG Level 4;POR-OO</xsl:when>
			<xsl:when test="$pProv='Puerto Rico'">TDWG Level 4;PUE-OO</xsl:when>
			<xsl:when test="$pProv='Reunion'">TDWG Level 4;REU-OO</xsl:when>
			<xsl:when test="$pProv='Romania'">TDWG Level 4;ROM-OO</xsl:when>
			<xsl:when test="$pProv='Rwanda'">TDWG Level 4;RWA-OO</xsl:when>
			<xsl:when test="$pProv='Samoa'">TDWG Level 3;SAM</xsl:when>
			<xsl:when test="$pProv='Saudi Arabia'">TDWG Level 4;SAU-OO</xsl:when>
			<xsl:when test="$pProv='Senegal'">TDWG Level 4;SEN-OO</xsl:when>
			<xsl:when test="$pProv='Seychelles'">TDWG Level 4;SEY-OO</xsl:when>
			<xsl:when test="$pProv='Sierra Leone'">TDWG Level 4;SIE-OO</xsl:when>
			<xsl:when test="$pProv='Singapore'">TDWG Level 4;MLY-SI</xsl:when>
			<xsl:when test="$pProv='Slovakia'">TDWG Level 4;CZE-SL</xsl:when>
			<xsl:when test="$pProv='Solomon Islands'">TDWG Level 3;SOL</xsl:when>
			<xsl:when test="$pProv='Somalia'">TDWG Level 4;SOM-OO</xsl:when>
			<xsl:when test="$pProv='South Africa'">TDWG Level 2;27</xsl:when>
			<xsl:when test="$pProv='South America'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pProv='Spain'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pProv='Sri Lanka'">TDWG Level 4;SRL-OO</xsl:when>
			<xsl:when test="$pProv='St. Kitts and Nevis'">TDWG Level 4;LEE-SK</xsl:when>
			<xsl:when test="$pProv='St. Lucia'">TDWG Level 4;WIN-SL</xsl:when>
			<xsl:when test="$pProv='St. Vincent'">TDWG Level 4;WIN-SV</xsl:when>
			<xsl:when test="$pProv='St. Vincent and Grenadines'">TDWG Level 4;WIN-SV</xsl:when>
			<xsl:when test="$pProv='Sudan'">TDWG Level 4;SUD-OO</xsl:when>
			<xsl:when test="$pProv='Suriname'">TDWG Level 4;SUR-OO</xsl:when>
			<xsl:when test="$pProv='Swaziland'">TDWG Level 4;SWZ-OO</xsl:when>
			<xsl:when test="$pProv='Sweden'">TDWG Level 4;SWE-OO</xsl:when>
			<xsl:when test="$pProv='Switzerland'">TDWG Level 4;SWI-OO</xsl:when>
			<xsl:when test="$pProv='Syria'">TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pProv='Tadzhikistan'">TDWG Level 4;TZK-OO</xsl:when>
			<xsl:when test="$pProv='Taiwan '">TDWG Level 4;TAI-OO</xsl:when>
			<xsl:when test="$pProv='Tajikistan'">TDWG Level 4;TZK-OO</xsl:when>
			<xsl:when test="$pProv='Tanzania'">TDWG Level 4;TAN-OO</xsl:when>
			<xsl:when test="$pProv='Thailand'">TDWG Level 4;THA-OO</xsl:when>
			<xsl:when test="$pProv='Tibet'">TDWG Level 4;CHT-OO</xsl:when>
			<xsl:when test="$pProv='Togo'">TDWG Level 4;TOG-OO</xsl:when>
			<xsl:when test="$pProv='Trinidad and Tobago'">TDWG Level 4;TRT-OO</xsl:when>
			<xsl:when test="$pProv='Tunisia'">TDWG Level 4;TUN-OO</xsl:when>
			<xsl:when test="$pProv='Turkestan'">TDWG Level 2;32</xsl:when>
			<xsl:when test="$pProv='Turkey'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pProv='Turkistan'">TDWG Level 2;32</xsl:when>
			<xsl:when test="$pProv='Turkmenistan'">TDWG Level 4;TKM-OO</xsl:when>
			<xsl:when test="$pProv='Uganda'">TDWG Level 4;UGA-OO</xsl:when>
			<xsl:when test="$pProv='Ukraine'">TDWG Level 4;UKR-UK</xsl:when>
			<xsl:when test="$pProv='United Kingdom'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pProv='United States of America'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pProv='Uruguay'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='Uzbekistan'">TDWG Level 4;UZB-OO</xsl:when>
			<xsl:when test="$pProv='Venezuela'">TDWG Level 4;VEN-OO</xsl:when>
			<xsl:when test="$pProv='Vietnam'">TDWG Level 4;VIE-OO</xsl:when>
			<xsl:when test="$pProv='Virgin Islands'">TDWG Level 3;LEE</xsl:when>
			<xsl:when test="$pProv='West Indies'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pProv='Yemen'">TDWG Level 3;YEM</xsl:when>
			<xsl:when test="$pProv='Yugoslavia'">TDWG Level 3;YUG</xsl:when>
			<xsl:when test="$pProv='Zaire'">TDWG Level 4;ZAI-OO</xsl:when>
			<xsl:when test="$pProv='Zambia'">TDWG Level 4;ZAM-OO</xsl:when>
			<xsl:when test="$pProv='Zimbabwe'">TDWG Level 4;ZIM-OO</xsl:when>
			<xsl:when test="$pProv='Andaman'">TDWG Level 4;AND-AN</xsl:when>
			<xsl:when test="$pProv='Andhra Pradesh'">TDWG Level 4;IND-AP</xsl:when>
			<xsl:when test="$pProv='Arunachal Pradesh'">TDWG Level 4;EHM-AP</xsl:when>
			<xsl:when test="$pProv='Assam'">TDWG Level 4;ASS-AS</xsl:when>
			<xsl:when test="$pProv='Bihar'">TDWG Level 4;IND-BI</xsl:when>
			<xsl:when test="$pProv='Chhatisgarh'">TDWG Level 4;IND-CH</xsl:when>
			<xsl:when test="$pProv='Delhi'">TDWG Level 4;IND-DE</xsl:when>
			<xsl:when test="$pProv='Goa'">TDWG Level 4;IND-GO</xsl:when>
			<xsl:when test="$pProv='Gujarat'">TDWG Level 4;IND-GU</xsl:when>
			<xsl:when test="$pProv='Haryana'">TDWG Level 4;IND-HA</xsl:when>
			<xsl:when test="$pProv='Himachal Pradesh'">TDWG Level 4;WHM-HP</xsl:when>
			<xsl:when test="$pProv='Jammu and Kashmir'">TDWG Level 4;WHM-JK</xsl:when>
			<xsl:when test="$pProv='Jharkhand'">TDWG Level 4;IND-JK</xsl:when>
			<xsl:when test="$pProv='Karnataka'">TDWG Level 4;IND-KT</xsl:when>
			<xsl:when test="$pProv='Kerala'">TDWG Level 4;IND-KE</xsl:when>
			<xsl:when test="$pProv='Madhya Pradesh'">TDWG Level 4;IND-MP</xsl:when>
			<xsl:when test="$pProv='Maharashtra'">TDWG Level 4;IND-MR</xsl:when>
			<xsl:when test="$pProv='Manipur'">TDWG Level 4;ASS-MA</xsl:when>
			<xsl:when test="$pProv='Meghalaya'">TDWG Level 4;ASS-ME</xsl:when>
			<xsl:when test="$pProv='Mizoram'">TDWG Level 4;ASS-MI</xsl:when>
			<xsl:when test="$pProv='Nagaland'">TDWG Level 4;ASS-NA</xsl:when>
			<xsl:when test="$pProv='Orissa'">TDWG Level 4;IND-OR</xsl:when>
			<xsl:when test="$pProv='Punjab'">TDWG Level 4;IND-PU</xsl:when>
			<xsl:when test="$pProv='Rajasthan'">TDWG Level 4;IND-RA</xsl:when>
			<xsl:when test="$pProv='Sikkim'">TDWG Level 4;EHM- SI</xsl:when>
			<xsl:when test="$pProv='Tamil Nadu'">TDWG Level 4;IND-TN</xsl:when>
			<xsl:when test="$pProv='Tripura'">TDWG Level 4;ASS-TR</xsl:when>
			<xsl:when test="$pProv='Uttar Pradesh'">TDWG Level 4;IND-UP</xsl:when>
			<xsl:when test="$pProv='Uttarakhand'">TDWG Level 4;WHM-UT</xsl:when>
			<xsl:when test="$pProv='West Bengal'">TDWG Level 4;IND-WB</xsl:when>
			<xsl:when test="$pProv='Dadra and Nagar Haveli'">TDWG Level 4;IND-DD</xsl:when>
			<xsl:when test="$pProv='Daman'">TDWG Level 4;IND-DM</xsl:when>
			<xsl:when test="$pProv='Diu'">TDWG Level 4;IND-DI</xsl:when>
			<xsl:when test="$pProv='Nicobar'">TDWG Level 4;NCB-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>
