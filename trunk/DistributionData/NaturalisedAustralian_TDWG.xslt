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
						<xsl:when test="Origin='Exotic'">Exotic</xsl:when>
						<xsl:when test="Origin='Native'">Indigenous</xsl:when>
						<xsl:otherwise>Uncertain</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
						<xsl:when test="Occurrence='Exotic'">Present</xsl:when>
						<xsl:when test="Occurrence='Indigenous'">Present</xsl:when>
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
			<xsl:when test="$pRegion='Australia'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pRegion='Australian Capitol Territory'">TDWG Level 4;NSW-CT</xsl:when>
			<xsl:when test="$pRegion='New South Wales'">TDWG Level 4;NSW-NS</xsl:when>
			<xsl:when test="$pRegion='Queensland'">TDWG Level 4;QLD-QU</xsl:when>
			<xsl:when test="$pRegion='Western Australia'">TDWG Level 4;WAU-WA</xsl:when>
			<xsl:when test="$pRegion='Northern Territory'">TDWG Level 4;NTA-OO</xsl:when>
			<xsl:when test="$pRegion='Victoria'">TDWG Level 4;VIC-OO</xsl:when>
			<xsl:when test="$pRegion='South Australia'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pRegion='Tasmania'">TDWG Level 4;TAS-OO</xsl:when>
			<xsl:when test="$pRegion='Afghanistan'">TDWG Level 4;AFG-OO</xsl:when>
			<xsl:when test="$pRegion='Albania'">TDWG Level 4;ALB-OO</xsl:when>
			<xsl:when test="$pRegion='Algeria'">TDWG Level 4;ALG-OO</xsl:when>
			<xsl:when test="$pRegion='Angola'">TDWG Level 4;ANG-OO</xsl:when>
			<xsl:when test="$pRegion='Arabia'">TDWG Level 2;35</xsl:when>
			<xsl:when test="$pRegion='Argentina'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pRegion='Armenia'">TDWG Level 4;TCS-AR</xsl:when>
			<xsl:when test="$pRegion='Austria'">TDWG Level 4;AUT-AU</xsl:when>
			<xsl:when test="$pRegion='Azerbaijan'">TDWG Level 4;TCS-AZ</xsl:when>
			<xsl:when test="$pRegion='Bangladesh'">TDWG Level 4;BAN-OO</xsl:when>
			<xsl:when test="$pRegion='Belgium'">TDWG Level 4;BGM-BE</xsl:when>
			<xsl:when test="$pRegion='Bolivia'">TDWG Level 4;BOL-OO</xsl:when>
			<xsl:when test="$pRegion='Botswana'">TDWG Level 4;BOT-OO</xsl:when>
			<xsl:when test="$pRegion='Brazil'">TDWG Level 2;84</xsl:when>
			<xsl:when test="$pRegion='Bulgaria'">TDWG Level 4;BUL-OO</xsl:when>
			<xsl:when test="$pRegion='Burma'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pRegion='Canada'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pRegion='Chile'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pRegion='China'">TDWG Level 2;36</xsl:when>
			<xsl:when test="$pRegion='Colombia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Crete'">TDWG Level 4;KRI-OO</xsl:when>
			<xsl:when test="$pRegion='Cuba'">TDWG Level 4;CUB-OO</xsl:when>
			<xsl:when test="$pRegion='Cyprus'">TDWG Level 4;CYP-OO</xsl:when>
			<xsl:when test="$pRegion='Czechoslovakia'">TDWG Level 4;CZECZ</xsl:when>
			<xsl:when test="$pRegion='Dagestan'">TDWG Level 4;NCS-DA</xsl:when>
			<xsl:when test="$pRegion='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pRegion='Egypt'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pRegion='El Salvador'">TDWG Level 4;ELS-OO</xsl:when>
			<xsl:when test="$pRegion='Ethiopia'">TDWG Level 4;ETH-OO</xsl:when>
			<xsl:when test="$pRegion='Fiji'">TDWG Level 4;FIJ-OO</xsl:when>
			<xsl:when test="$pRegion='France'">TDWG Level 4;FRA-FR</xsl:when>
			<xsl:when test="$pRegion='Georgia'">TDWG Level 4;TCS-GR</xsl:when>
			<xsl:when test="$pRegion='Germany'">TDWG Level 4;GER-OO</xsl:when>
			<xsl:when test="$pRegion='Greece'">TDWG Level 4;GRC-OO</xsl:when>
			<xsl:when test="$pRegion='Gualtemala'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pRegion='Guatamala'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pRegion='Guatemala'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pRegion='Hispaniola'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pRegion='Honduras'">TDWG Level 4;HON-OO</xsl:when>
			<xsl:when test="$pRegion='India'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pRegion='Indonesia'">TDWG Level 2;42</xsl:when>
			<xsl:when test="$pRegion='Iran'">TDWG Level 4;IRN-OO</xsl:when>
			<xsl:when test="$pRegion='Iraq'">TDWG Level 4;IRQ-OO</xsl:when>
			<xsl:when test="$pRegion='Ireland'">TDWG Level 4;IRE-IR</xsl:when>
			<xsl:when test="$pRegion='Israel'">TDWG Level 4;PAL-IS</xsl:when>
			<xsl:when test="$pRegion='Italy'">TDWG Level 4;ITA-IT</xsl:when>
			<xsl:when test="$pRegion='Japan'">TDWG Level 3;JAP</xsl:when>
			<xsl:when test="$pRegion='Kazakhstan'">TDWG Level 4;KAZ-OO</xsl:when>
			<xsl:when test="$pRegion='Korea'">TDWG Level 3;KOR</xsl:when>
			<xsl:when test="$pRegion='Kyrgystan'">TDWG Level 4;KGZ-OO</xsl:when>
			<xsl:when test="$pRegion='Lebanon'">TDWG Level 3;LBS</xsl:when>
			<xsl:when test="$pRegion='Lesotho'">TDWG Level 4;LES-OO</xsl:when>
			<xsl:when test="$pRegion='Libya'">TDWG Level 4;LBY-OO</xsl:when>
			<xsl:when test="$pRegion='Madagascar'">TDWG Level 4;MDG-OO</xsl:when>
			<xsl:when test="$pRegion='Malta'">TDWG Level 4;SIC-MA</xsl:when>
			<xsl:when test="$pRegion='Mexico'">TDWG Level 2;79</xsl:when>
			<xsl:when test="$pRegion='Mongolia'">TDWG Level 4;MON-OO</xsl:when>
			<xsl:when test="$pRegion='Morocco'">TDWG Level 4;MOR-MO</xsl:when>
			<xsl:when test="$pRegion='Mozambique'">TDWG Level 4;MOZ-OO</xsl:when>
			<xsl:when test="$pRegion='Namibia'">TDWG Level 4;NAM-OO</xsl:when>
			<xsl:when test="$pRegion='Nepal'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pRegion='New Guinea'">TDWG Level 3;NWG</xsl:when>
			<xsl:when test="$pRegion='New Zealand'">TDWG Level 2;51</xsl:when>
			<xsl:when test="$pRegion='Nicaragua'">TDWG Level 4;NIC-OO</xsl:when>
			<xsl:when test="$pRegion='Pakistan'">TDWG Level 4;PAK-OO</xsl:when>
			<xsl:when test="$pRegion='Palestine'">TDWG Level 3;PAL</xsl:when>
			<xsl:when test="$pRegion='Panama'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pRegion='Paraguay'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pRegion='Peru'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pRegion='Philippines'">TDWG Level 4;PHI-OO</xsl:when>
			<xsl:when test="$pRegion='Portugal'">TDWG Level 4;POR-OO</xsl:when>
			<xsl:when test="$pRegion='Romania'">TDWG Level 4;ROM-OO</xsl:when>
			<xsl:when test="$pRegion='Russia'">TDWG Level 1;3</xsl:when>
			<xsl:when test="$pRegion='Samoa'">TDWG Level 3;SAM</xsl:when>
			<xsl:when test="$pRegion='Senegal'">TDWG Level 4;SEN-OO</xsl:when>
			<xsl:when test="$pRegion='Siberia'">TDWG Level 2;30</xsl:when>
			<xsl:when test="$pRegion='South Africa'">TDWG Level 2;27</xsl:when>
			<xsl:when test="$pRegion='Spain'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pRegion='Sri Lanka'">TDWG Level 4;SRL-OO</xsl:when>
			<xsl:when test="$pRegion='Sudan'">TDWG Level 4;SUD-OO</xsl:when>
			<xsl:when test="$pRegion='Swaziland'">TDWG Level 4;SWZ-OO</xsl:when>
			<xsl:when test="$pRegion='Switzerland'">TDWG Level 4;SWI-OO</xsl:when>
			<xsl:when test="$pRegion='Syria'">TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pRegion='Taiwan'">TDWG Level 4;TAI-OO</xsl:when>
			<xsl:when test="$pRegion='Tunisia'">TDWG Level 4;TUN-OO</xsl:when>
			<xsl:when test="$pRegion='Turkey'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pRegion='UK'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pRegion='Ukraine'">TDWG Level 4;UKR-UK</xsl:when>
			<xsl:when test="$pRegion='Uruguay'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pRegion='USA'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pRegion='Alabama'">TDWG Level 4;ALA-OO</xsl:when>
			<xsl:when test="$pRegion='Arizona'">TDWG Level 4;ARI-OO</xsl:when>
			<xsl:when test="$pRegion='California'">TDWG Level 4;CAL-OO</xsl:when>
			<xsl:when test="$pRegion='Florida'">TDWG Level 4;FLA-OO</xsl:when>
			<xsl:when test="$pRegion='Lousiana'">TDWG Level 4;LOU-OO</xsl:when>
			<xsl:when test="$pRegion='New Mexico'">TDWG Level 4;NWM-OO</xsl:when>
			<xsl:when test="$pRegion='Oregon'">TDWG Level 4;ORE-OO</xsl:when>
			<xsl:when test="$pRegion='Texas'">TDWG Level 4;TEX-OO</xsl:when>
			<xsl:when test="$pRegion='Africa'">TDWG Level 1;2</xsl:when>
			<xsl:when test="$pRegion='Asia'">TDWG Level 1;3</xsl:when>
			<xsl:when test="$pRegion='Europe'">TDWG Level 1;1</xsl:when>
			<xsl:when test="$pRegion='North America'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pRegion='South America'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pRegion='Canary'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pRegion='Madeira'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pRegion='Caribbean'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pRegion='Azores'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pRegion='Canary Islands'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pRegion='Crete'">TDWG Level 4;KRI-OO</xsl:when>
			<xsl:when test="$pRegion='Galapagos'">TDWG Level 4;GAL-OO</xsl:when>
			<xsl:when test="$pRegion='Madiera'">TDWG Level 4;MDR-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
