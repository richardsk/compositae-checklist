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
			<xsl:when test="$pRegion='Australia'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pRegion='Australian Capitol Territory'">Australian States;Australian Capitol Territory</xsl:when>
			<xsl:when test="$pRegion='New South Wales'">Australian States;New South Wales</xsl:when>
			<xsl:when test="$pRegion='Queensland'">Australian States;Queensland</xsl:when>
			<xsl:when test="$pRegion='Western Australia'">Australian States;Western Australia</xsl:when>
			<xsl:when test="$pRegion='Northern Territory'">Australian States;Northern Territory</xsl:when>
			<xsl:when test="$pRegion='Victoria'">Australian States;Victoria</xsl:when>
			<xsl:when test="$pRegion='South Australia'">Australian States;South Australia</xsl:when>
			<xsl:when test="$pRegion='Tasmania'">Australian States;Tasmania</xsl:when>
			<xsl:when test="$pRegion='Afghanistan'">ISO Countries;Afghanistan</xsl:when>
			<xsl:when test="$pRegion='Albania'">ISO Countries;Albania</xsl:when>
			<xsl:when test="$pRegion='Algeria'">ISO Countries;Algeria</xsl:when>
			<xsl:when test="$pRegion='Angola'">ISO Countries;Angola</xsl:when>
			<xsl:when test="$pRegion='Arabia'">ISO Countries;Arabia</xsl:when>
			<xsl:when test="$pRegion='Argentina'">ISO Countries;Argentina</xsl:when>
			<xsl:when test="$pRegion='Armenia'">ISO Countries;Armenia</xsl:when>
			<xsl:when test="$pRegion='Austria'">ISO Countries;Austria</xsl:when>
			<xsl:when test="$pRegion='Azerbaijan'">ISO Countries;Azerbaijan</xsl:when>
			<xsl:when test="$pRegion='Bangladesh'">ISO Countries;Bangladesh</xsl:when>
			<xsl:when test="$pRegion='Belgium'">ISO Countries;Belgium</xsl:when>
			<xsl:when test="$pRegion='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pRegion='Botswana'">ISO Countries;Botswana</xsl:when>
			<xsl:when test="$pRegion='Brazil'">ISO Countries;Brazil</xsl:when>
			<xsl:when test="$pRegion='Bulgaria'">ISO Countries;Bulgaria</xsl:when>
			<xsl:when test="$pRegion='Burma'">ISO Countries;Burma</xsl:when>
			<xsl:when test="$pRegion='Canada'">ISO Countries;Canada</xsl:when>
			<xsl:when test="$pRegion='Chile'">ISO Countries;Chile</xsl:when>
			<xsl:when test="$pRegion='China'">ISO Countries;China</xsl:when>
			<xsl:when test="$pRegion='Colombia'">ISO Countries;Colombia</xsl:when>
			<xsl:when test="$pRegion='Crete'">ISO Countries;Crete</xsl:when>
			<xsl:when test="$pRegion='Cuba'">ISO Countries;Cuba</xsl:when>
			<xsl:when test="$pRegion='Cyprus'">ISO Countries;Cyprus</xsl:when>
			<xsl:when test="$pRegion='Czechoslovakia'">ISO Countries;Czechoslovakia</xsl:when>
			<xsl:when test="$pRegion='Dagestan'">ISO Countries;Dagestan</xsl:when>
			<xsl:when test="$pRegion='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pRegion='Egypt'">ISO Countries;Egypt</xsl:when>
			<xsl:when test="$pRegion='El Salvador'">ISO Countries;El Salvador</xsl:when>
			<xsl:when test="$pRegion='Ethiopia'">ISO Countries;Ethiopia</xsl:when>
			<xsl:when test="$pRegion='Fiji'">ISO Countries;Fiji</xsl:when>
			<xsl:when test="$pRegion='France'">ISO Countries;France</xsl:when>
			<xsl:when test="$pRegion='Georgia'">ISO Countries;Georgia</xsl:when>
			<xsl:when test="$pRegion='Germany'">ISO Countries;Germany</xsl:when>
			<xsl:when test="$pRegion='Greece'">ISO Countries;Greece</xsl:when>
			<xsl:when test="$pRegion='Gualtemala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pRegion='Guatamala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pRegion='Guatemala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pRegion='Hispaniola'">ISO Countries;Hispaniola</xsl:when>
			<xsl:when test="$pRegion='Honduras'">ISO Countries;Honduras</xsl:when>
			<xsl:when test="$pRegion='India'">ISO Countries;India</xsl:when>
			<xsl:when test="$pRegion='Indonesia'">ISO Countries;Indonesia</xsl:when>
			<xsl:when test="$pRegion='Iran'">ISO Countries;Iran</xsl:when>
			<xsl:when test="$pRegion='Iraq'">ISO Countries;Iraq</xsl:when>
			<xsl:when test="$pRegion='Ireland'">ISO Countries;Ireland</xsl:when>
			<xsl:when test="$pRegion='Israel'">ISO Countries;Israel</xsl:when>
			<xsl:when test="$pRegion='Italy'">ISO Countries;Italy</xsl:when>
			<xsl:when test="$pRegion='Japan'">ISO Countries;Japan</xsl:when>
			<xsl:when test="$pRegion='Kazakhstan'">ISO Countries;Kazakhstan</xsl:when>
			<xsl:when test="$pRegion='Korea'">ISO Countries;Korea</xsl:when>
			<xsl:when test="$pRegion='Kyrgystan'">ISO Countries;Kyrgystan</xsl:when>
			<xsl:when test="$pRegion='Lebanon'">ISO Countries;Lebanon</xsl:when>
			<xsl:when test="$pRegion='Lesotho'">ISO Countries;Lesotho</xsl:when>
			<xsl:when test="$pRegion='Libya'">ISO Countries;Libya</xsl:when>
			<xsl:when test="$pRegion='Madagascar'">ISO Countries;Madagascar</xsl:when>
			<xsl:when test="$pRegion='Malta'">ISO Countries;Malta</xsl:when>
			<xsl:when test="$pRegion='Mexico'">ISO Countries;Mexico</xsl:when>
			<xsl:when test="$pRegion='Mongolia'">ISO Countries;Mongolia</xsl:when>
			<xsl:when test="$pRegion='Morocco'">ISO Countries;Morocco</xsl:when>
			<xsl:when test="$pRegion='Mozambique'">ISO Countries;Mozambique</xsl:when>
			<xsl:when test="$pRegion='Namibia'">ISO Countries;Namibia</xsl:when>
			<xsl:when test="$pRegion='Nepal'">ISO Countries;Nepal</xsl:when>
			<xsl:when test="$pRegion='New Guinea'">ISO Countries;New Guinea</xsl:when>
			<xsl:when test="$pRegion='New Zealand'">ISO Countries;New Zealand</xsl:when>
			<xsl:when test="$pRegion='Nicaragua'">ISO Countries;Nicaragua</xsl:when>
			<xsl:when test="$pRegion='Pakistan'">ISO Countries;Pakistan</xsl:when>
			<xsl:when test="$pRegion='Palestine'">ISO Countries;Palestine</xsl:when>
			<xsl:when test="$pRegion='Panama'">ISO Countries;Panama</xsl:when>
			<xsl:when test="$pRegion='Paraguay'">ISO Countries;Paraguay</xsl:when>
			<xsl:when test="$pRegion='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pRegion='Philippines'">ISO Countries;Philippines</xsl:when>
			<xsl:when test="$pRegion='Portugal'">ISO Countries;Portugal</xsl:when>
			<xsl:when test="$pRegion='Romania'">ISO Countries;Romania</xsl:when>
			<xsl:when test="$pRegion='Russia'">ISO Countries;Russia</xsl:when>
			<xsl:when test="$pRegion='Samoa'">ISO Countries;Samoa</xsl:when>
			<xsl:when test="$pRegion='Senegal'">ISO Countries;Senegal</xsl:when>
			<xsl:when test="$pRegion='Siberia'">ISO Countries;Siberia</xsl:when>
			<xsl:when test="$pRegion='South Africa'">ISO Countries;South Africa</xsl:when>
			<xsl:when test="$pRegion='Spain'">ISO Countries;Spain</xsl:when>
			<xsl:when test="$pRegion='Sri Lanka'">ISO Countries;Sri Lanka</xsl:when>
			<xsl:when test="$pRegion='Sudan'">ISO Countries;Sudan</xsl:when>
			<xsl:when test="$pRegion='Swaziland'">ISO Countries;Swaziland</xsl:when>
			<xsl:when test="$pRegion='Switzerland'">ISO Countries;Switzerland</xsl:when>
			<xsl:when test="$pRegion='Syria'">ISO Countries;Syria</xsl:when>
			<xsl:when test="$pRegion='Taiwan'">ISO Countries;Taiwan</xsl:when>
			<xsl:when test="$pRegion='Tunisia'">ISO Countries;Tunisia</xsl:when>
			<xsl:when test="$pRegion='Turkey'">ISO Countries;Turkey</xsl:when>
			<xsl:when test="$pRegion='UK'">ISO Countries;UK</xsl:when>
			<xsl:when test="$pRegion='Ukraine'">ISO Countries;Ukraine</xsl:when>
			<xsl:when test="$pRegion='Uruguay'">ISO Countries;Uruguay</xsl:when>
			<xsl:when test="$pRegion='USA'">ISO Countries;USA</xsl:when>
			<xsl:when test="$pRegion='Alabama'">US States;Alabama</xsl:when>
			<xsl:when test="$pRegion='Arizona'">US States;Arizona</xsl:when>
			<xsl:when test="$pRegion='California'">US States;California</xsl:when>
			<xsl:when test="$pRegion='Florida'">US States;Florida</xsl:when>
			<xsl:when test="$pRegion='Lousiana'">US States;Lousiana</xsl:when>
			<xsl:when test="$pRegion='New Mexico'">US States;New Mexico</xsl:when>
			<xsl:when test="$pRegion='Oregon'">US States;Oregon</xsl:when>
			<xsl:when test="$pRegion='Texas'">US States;Texas</xsl:when>
			<xsl:when test="$pRegion='Africa'">Continents;Africa</xsl:when>
			<xsl:when test="$pRegion='Asia'">Continents;Asia</xsl:when>
			<xsl:when test="$pRegion='Europe'">Continents;Europe</xsl:when>
			<xsl:when test="$pRegion='North America'">Continents;North America</xsl:when>
			<xsl:when test="$pRegion='South America'">Continents;South America</xsl:when>
			<xsl:when test="$pRegion='Canary'">Islands;Canary</xsl:when>
			<xsl:when test="$pRegion='Madeira'">Islands;Madeira</xsl:when>
			<xsl:when test="$pRegion='Caribbean'">Islands;Caribbean</xsl:when>
			<xsl:when test="$pRegion='Azores'">Islands;Azores</xsl:when>
			<xsl:when test="$pRegion='Canary Islands'">Islands;Canary Islands</xsl:when>
			<xsl:when test="$pRegion='Crete'">Islands;Crete</xsl:when>
			<xsl:when test="$pRegion='Galapagos'">Islands;Galapagos</xsl:when>
			<xsl:when test="$pRegion='Madiera'">Islands;Madiera</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
