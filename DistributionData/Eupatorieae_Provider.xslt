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
			<xsl:otherwise>Present;</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Africa'">Continents;Africa</xsl:when>
			<xsl:when test="$pRegion='Am Bor'">Regions;Am Bor</xsl:when>
			<xsl:when test="$pRegion='Amazonian Peru'">Regions;Amazonian Peru</xsl:when>
			<xsl:when test="$pRegion='Andes from Venezuela to Bolivia '">Regions;Andes from Venezuela to Bolivia </xsl:when>
			<xsl:when test="$pRegion='Andes S to Bolivia'">Regions;Andes S to Bolivia</xsl:when>
			<xsl:when test="$pRegion='Angola'">ISO Countries;Angola</xsl:when>
			<xsl:when test="$pRegion='Argentina'">ISO Countries;Argentina</xsl:when>
			<xsl:when test="$pRegion='Arizona'">US States;Arizona</xsl:when>
			<xsl:when test="$pRegion='Asia Minor'">Regions;Asia Minor</xsl:when>
			<xsl:when test="$pRegion='Australia'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pRegion='Australia (Queensland)'">Australian States;Australia (Queensland)</xsl:when>
			<xsl:when test="$pRegion='Bahamas'">ISO Countries;Bahamas</xsl:when>
			<xsl:when test="$pRegion='Baja California'">Mexican States;Baja California</xsl:when>
			<xsl:when test="$pRegion='Belize'">ISO Countries;Belize</xsl:when>
			<xsl:when test="$pRegion='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pRegion='Borneo'">ISO Countries;Borneo</xsl:when>
			<xsl:when test="$pRegion='Botswana'">ISO Countries;Botswana</xsl:when>
			<xsl:when test="$pRegion='Brazil'">ISO Countries;Brazil</xsl:when>
			<xsl:when test="$pRegion='Brazil (Bahia)'">Brazilian States;Brazil (Bahia)</xsl:when>
			<xsl:when test="$pRegion='British Columbia'">Canadian States;British Columbia</xsl:when>
			<xsl:when test="$pRegion='Burundi'">ISO Countries;Burundi</xsl:when>
			<xsl:when test="$pRegion='California'">US States;California</xsl:when>
			<xsl:when test="$pRegion='Cameroon'">ISO Countries;Cameroon</xsl:when>
			<xsl:when test="$pRegion='Cañar'">Provinces of Ecuador;Cañar</xsl:when>
			<xsl:when test="$pRegion='Cape of Good Hope'">Regions;Cape of Good Hope</xsl:when>
			<xsl:when test="$pRegion='central and S Africa'">Regions;central and S Africa</xsl:when>
			<xsl:when test="$pRegion='central and SW United States'">Regions;central and SW United States</xsl:when>
			<xsl:when test="$pRegion='Central and W United States'">Regions;Central and W United States</xsl:when>
			<xsl:when test="$pRegion='Central America'">Regions;Central America</xsl:when>
			<xsl:when test="$pRegion='Central America to Panama'">Regions;Central America to Panama</xsl:when>
			<xsl:when test="$pRegion='central Ecuador '">ISO Countries;central Ecuador </xsl:when>
			<xsl:when test="$pRegion='Central Mexico'">ISO Countries;Central Mexico</xsl:when>
			<xsl:when test="$pRegion='central United States'">ISO Countries;central United States</xsl:when>
			<xsl:when test="$pRegion='Ceylon'">ISO Countries;Ceylon</xsl:when>
			<xsl:when test="$pRegion='Chile'">ISO Countries;Chile</xsl:when>
			<xsl:when test="$pRegion='China'">ISO Countries;China</xsl:when>
			<xsl:when test="$pRegion='Colombia'">ISO Countries;Colombia</xsl:when>
			<xsl:when test="$pRegion='Colombia (Antioquia)'">Colombian Departments;Colombia (Antioquia)</xsl:when>
			<xsl:when test="$pRegion='Colombia (Cundinamarca: Páramo de Palacio)'">Colombian Departments;Colombia (Cundinamarca: Páramo de Palacio)</xsl:when>
			<xsl:when test="$pRegion='Colombia (Nariño)'">Colombian Departments;Colombia (Nariño)</xsl:when>
			<xsl:when test="$pRegion='Costa Rica'">ISO Countries;Costa Rica</xsl:when>
			<xsl:when test="$pRegion='Costa Rica?'">ISO Countries;Costa Rica?</xsl:when>
			<xsl:when test="$pRegion='Cuba'">ISO Countries;Cuba</xsl:when>
			<xsl:when test="$pRegion='Cuba and the Isla de Pinos'">ISO Countries;Cuba and the Isla de Pinos</xsl:when>
			<xsl:when test="$pRegion='Dominica'">ISO Countries;Dominica</xsl:when>
			<xsl:when test="$pRegion='Dominican Republic'">ISO Countries;Dominican Republic</xsl:when>
			<xsl:when test="$pRegion='E and central North America'">Regions;E and central North America</xsl:when>
			<xsl:when test="$pRegion='E and Central United States'">Regions;E and Central United States</xsl:when>
			<xsl:when test="$pRegion='E Africa'">Regions;E Africa</xsl:when>
			<xsl:when test="$pRegion='E Asia'">Regions;E Asia</xsl:when>
			<xsl:when test="$pRegion='E Canada'">Regions;E Canada</xsl:when>
			<xsl:when test="$pRegion='E North America'">Regions;E North America</xsl:when>
			<xsl:when test="$pRegion='E United States'">Regions;E United States</xsl:when>
			<xsl:when test="$pRegion='E United States to Wyoming'">Regions;E United States to Wyoming</xsl:when>
			<xsl:when test="$pRegion='East Africa'">Regions;East Africa</xsl:when>
			<xsl:when test="$pRegion='East Indies'">Regions;East Indies</xsl:when>
			<xsl:when test="$pRegion='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pRegion='Ecuador '">ISO Countries;Ecuador </xsl:when>
			<xsl:when test="$pRegion='Ecuador (Azuay'">Ecuadorian Provinces;Ecuador (Azuay</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Azuay)'">Ecuadorian Provinces;Ecuador (Azuay)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Azuay/Morona-Santiago border)'">Ecuadorian Provinces;Ecuador (Azuay/Morona-Santiago border)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Carchi)'">Ecuadorian Provinces;Ecuador (Carchi)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Chimborazo)'">Ecuadorian Provinces;Ecuador (Chimborazo)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Loja)'">Ecuadorian Provinces;Ecuador (Loja)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Napo)'">Ecuadorian Provinces;Ecuador (Napo)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (northwestern lowlands)'">Ecuadorian Provinces;Ecuador (northwestern lowlands)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Peru?)'">Ecuadorian Provinces;Ecuador (Peru?)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Pichincha)'">Ecuadorian Provinces;Ecuador (Pichincha)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Quito and Tungurahua)'">Ecuadorian Provinces;Ecuador (Quito and Tungurahua)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Zamora-Chinchipe and Loja)'">Ecuadorian Provinces;Ecuador (Zamora-Chinchipe and Loja)</xsl:when>
			<xsl:when test="$pRegion='Ecuador (Zamora-Chinchipe)'">Ecuadorian Provinces;Ecuador (Zamora-Chinchipe)</xsl:when>
			<xsl:when test="$pRegion='El Salvador'">ISO Countries;El Salvador</xsl:when>
			<xsl:when test="$pRegion='England'">ISO Countries;England</xsl:when>
			<xsl:when test="$pRegion='Ethiopia'">ISO Countries;Ethiopia</xsl:when>
			<xsl:when test="$pRegion='Eucador'">ISO Countries;Eucador</xsl:when>
			<xsl:when test="$pRegion='Europe'">Continents;Europe</xsl:when>
			<xsl:when test="$pRegion='Fernando Po'">Islands;Fernando Po</xsl:when>
			<xsl:when test="$pRegion='Fiji'">ISO Countries;Fiji</xsl:when>
			<xsl:when test="$pRegion='Florida'">US States;Florida</xsl:when>
			<xsl:when test="$pRegion='French Guiana'">ISO Countries;French Guiana</xsl:when>
			<xsl:when test="$pRegion='Galapagos'">Islands;Galapagos</xsl:when>
			<xsl:when test="$pRegion='Georgia'">US States;Georgia</xsl:when>
			<xsl:when test="$pRegion='Greater Antilles'">Regions;Greater Antilles</xsl:when>
			<xsl:when test="$pRegion='Grenada'">ISO Countries;Grenada</xsl:when>
			<xsl:when test="$pRegion='Guadeloupe'">Islands;Guadeloupe</xsl:when>
			<xsl:when test="$pRegion='Guatemala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pRegion='Guatemala to Panama'">Regions;Guatemala to Panama</xsl:when>
			<xsl:when test="$pRegion='Guayana'">ISO Countries;Guayana</xsl:when>
			<xsl:when test="$pRegion='Guerrero'">Mexican States;Guerrero</xsl:when>
			<xsl:when test="$pRegion='Guyana'">ISO Countries;Guyana</xsl:when>
			<xsl:when test="$pRegion='Hainan'">Chinese Provinces;Hainan</xsl:when>
			<xsl:when test="$pRegion='Haiti'">ISO Countries;Haiti</xsl:when>
			<xsl:when test="$pRegion='Hispaniola'">Islands;Hispaniola</xsl:when>
			<xsl:when test="$pRegion='Honduras'">ISO Countries;Honduras</xsl:when>
			<xsl:when test="$pRegion='Hong Kong'">ISO Countries;Hong Kong</xsl:when>
			<xsl:when test="$pRegion='Illinois'">US States;Illinois</xsl:when>
			<xsl:when test="$pRegion='India'">ISO Countries;India</xsl:when>
			<xsl:when test="$pRegion='Indian Ocean'">Oceans;Indian Ocean</xsl:when>
			<xsl:when test="$pRegion='Indiana'">US States;Indiana</xsl:when>
			<xsl:when test="$pRegion='Indo-China'">Regions;Indo-China</xsl:when>
			<xsl:when test="$pRegion='Indonesia'">ISO Countries;Indonesia</xsl:when>
			<xsl:when test="$pRegion='Jamaica'">ISO Countries;Jamaica</xsl:when>
			<xsl:when test="$pRegion='Jamaica?'">ISO Countries;Jamaica?</xsl:when>
			<xsl:when test="$pRegion='Japan'">ISO Countries;Japan</xsl:when>
			<xsl:when test="$pRegion='Kentucky'">US States;Kentucky</xsl:when>
			<xsl:when test="$pRegion='Lesser Antilles'">Regions;Lesser Antilles</xsl:when>
			<xsl:when test="$pRegion='Lesser Antilles (Dominica)'">Regions;Lesser Antilles (Dominica)</xsl:when>
			<xsl:when test="$pRegion='Malagasy Republic'">ISO Countries;Malagasy Republic</xsl:when>
			<xsl:when test="$pRegion='Malawi'">ISO Countries;Malawi</xsl:when>
			<xsl:when test="$pRegion='Martinique'">Islands;Martinique</xsl:when>
			<xsl:when test="$pRegion='Mexico'">ISO Countries;Mexico</xsl:when>
			<xsl:when test="$pRegion='Mexico (Chiapas'">Mexican States;Mexico (Chiapas</xsl:when>
			<xsl:when test="$pRegion='Mexico (Chiapas)'">Mexican States;Mexico (Chiapas)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Guerrero)'">Mexican States;Mexico (Guerrero)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Mexico state)'">Mexican States;Mexico (Mexico state)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Michoacán)'">Mexican States;Mexico (Michoacán)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Nayarit)'">Mexican States;Mexico (Nayarit)</xsl:when>
			<xsl:when test="$pRegion='Mexico (northwestern Jalisco)'">Mexican States;Mexico (northwestern Jalisco)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Nuevo León)'">Mexican States;Mexico (Nuevo León)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Oaxaca and Puebla)'">Mexican States;Mexico (Oaxaca and Puebla)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Oaxaca)'">Mexican States;Mexico (Oaxaca)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Quintana Roo)'">Mexican States;Mexico (Quintana Roo)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sierra Madre Occidental'">Mexican States;Mexico (Sierra Madre Occidental</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sierra Madre Occidentale'">Mexican States;Mexico (Sierra Madre Occidentale</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sinaloa and Durango)'">Mexican States;Mexico (Sinaloa and Durango)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sinaloa)'">Mexican States;Mexico (Sinaloa)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sinaloa-Durango border)'">Mexican States;Mexico (Sinaloa-Durango border)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Sonora'">Mexican States;Mexico (Sonora</xsl:when>
			<xsl:when test="$pRegion='Mexico (Yucatan)'">Mexican States;Mexico (Yucatan)</xsl:when>
			<xsl:when test="$pRegion='Mexico (Zacatecas)'">Mexican States;Mexico (Zacatecas)</xsl:when>
			<xsl:when test="$pRegion='Mexico?'">Mexican States;Mexico?</xsl:when>
			<xsl:when test="$pRegion='Minnesota'">US States;Minnesota</xsl:when>
			<xsl:when test="$pRegion='Mozambique'">ISO Countries;Mozambique</xsl:when>
			<xsl:when test="$pRegion='N Africa'">Regions;N Africa</xsl:when>
			<xsl:when test="$pRegion='N central United States'">Regions;N central United States</xsl:when>
			<xsl:when test="$pRegion='N Mexico'">Regions;N Mexico</xsl:when>
			<xsl:when test="$pRegion='N South America'">Regions;N South America</xsl:when>
			<xsl:when test="$pRegion='N South America to Peru'">Regions;N South America to Peru</xsl:when>
			<xsl:when test="$pRegion='NE Mexico'">Regions;NE Mexico</xsl:when>
			<xsl:when test="$pRegion='NE United States'">Regions;NE United States</xsl:when>
			<xsl:when test="$pRegion='Nebraska'">US States;Nebraska</xsl:when>
			<xsl:when test="$pRegion='New Guinea'">ISO Countries;New Guinea</xsl:when>
			<xsl:when test="$pRegion='New Mexico'">US States;New Mexico</xsl:when>
			<xsl:when test="$pRegion='New Mexico and W Texas'">US States;New Mexico and W Texas</xsl:when>
			<xsl:when test="$pRegion='Nicaragua'">ISO Countries;Nicaragua</xsl:when>
			<xsl:when test="$pRegion='Nigeria'">ISO Countries;Nigeria</xsl:when>
			<xsl:when test="$pRegion='North Dakota'">US States;North Dakota</xsl:when>
			<xsl:when test="$pRegion='northern Ecuador'">Regions;northern Ecuador</xsl:when>
			<xsl:when test="$pRegion='northern Ecuador (Amazonian side of Andes)'">Regions;northern Ecuador (Amazonian side of Andes)</xsl:when>
			<xsl:when test="$pRegion='northern Peru'">Regions;northern Peru</xsl:when>
			<xsl:when test="$pRegion='northern South America and Peru'">Regions;northern South America and Peru</xsl:when>
			<xsl:when test="$pRegion='NW Mexico'">Regions;NW Mexico</xsl:when>
			<xsl:when test="$pRegion='Oaxaca'">Mexican States;Oaxaca</xsl:when>
			<xsl:when test="$pRegion='Ontario'">US States;Ontario</xsl:when>
			<xsl:when test="$pRegion='Pacific'">Oceans;Pacific</xsl:when>
			<xsl:when test="$pRegion='Pacific Islands'">Islands;Pacific Islands</xsl:when>
			<xsl:when test="$pRegion='Panama'">ISO Countries;Panama</xsl:when>
			<xsl:when test="$pRegion='Paraguay'">ISO Countries;Paraguay</xsl:when>
			<xsl:when test="$pRegion='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pRegion='Peru '">ISO Countries;Peru </xsl:when>
			<xsl:when test="$pRegion='Peru (Cajamarca)'">ISO Countries;Peru (Cajamarca)</xsl:when>
			<xsl:when test="$pRegion='Peru?'">ISO Countries;Peru?</xsl:when>
			<xsl:when test="$pRegion='Philippines'">ISO Countries;Philippines</xsl:when>
			<xsl:when test="$pRegion='Portugal'">ISO Countries;Portugal</xsl:when>
			<xsl:when test="$pRegion='Puebla'">Mexican States;Puebla</xsl:when>
			<xsl:when test="$pRegion='Puerto Rico'">ISO Countries;Puerto Rico</xsl:when>
			<xsl:when test="$pRegion='Ruwanda'">ISO Countries;Ruwanda</xsl:when>
			<xsl:when test="$pRegion='Ryukyu Islands'">Islands;Ryukyu Islands</xsl:when>
			<xsl:when test="$pRegion='S Africa'">Regions;S Africa</xsl:when>
			<xsl:when test="$pRegion='S Asia'">Regions;S Asia</xsl:when>
			<xsl:when test="$pRegion='S China'">Regions;S China</xsl:when>
			<xsl:when test="$pRegion='S Florida'">Regions;S Florida</xsl:when>
			<xsl:when test="$pRegion='S to Angola'">Regions;S to Angola</xsl:when>
			<xsl:when test="$pRegion='SE Asia'">Regions;SE Asia</xsl:when>
			<xsl:when test="$pRegion='SE United States'">Regions;SE United States</xsl:when>
			<xsl:when test="$pRegion='SE United States (and TX)'">Regions;SE United States (and TX)</xsl:when>
			<xsl:when test="$pRegion='Sierra Leone to Nigeria'">Regions;Sierra Leone to Nigeria</xsl:when>
			<xsl:when test="$pRegion='South Africa'">ISO Countries;South Africa</xsl:when>
			<xsl:when test="$pRegion='South America'">Continents;South America</xsl:when>
			<xsl:when test="$pRegion='South America S to Bolivia'">Regions;South America S to Bolivia</xsl:when>
			<xsl:when test="$pRegion='South America?'">Continents;South America?</xsl:when>
			<xsl:when test="$pRegion='southcentral Ecuador'">Regions;southcentral Ecuador</xsl:when>
			<xsl:when test="$pRegion='south-central Ecuador'">Regions;south-central Ecuador</xsl:when>
			<xsl:when test="$pRegion='southern Brazil highlands'">Regions;southern Brazil highlands</xsl:when>
			<xsl:when test="$pRegion='southern Ecuador'">Regions;southern Ecuador</xsl:when>
			<xsl:when test="$pRegion='southern Ecuador and northern Peru'">Regions;southern Ecuador and northern Peru</xsl:when>
			<xsl:when test="$pRegion='Southern Mexico to Panama'">Regions;Southern Mexico to Panama</xsl:when>
			<xsl:when test="$pRegion='Sri Lanka'">ISO Countries;Sri Lanka</xsl:when>
			<xsl:when test="$pRegion='St Kitts (?)'">Islands;St Kitts (?)</xsl:when>
			<xsl:when test="$pRegion='Surinam'">ISO Countries;Surinam</xsl:when>
			<xsl:when test="$pRegion='Suriname'">ISO Countries;Suriname</xsl:when>
			<xsl:when test="$pRegion='SW United States'">Regions;SW United States</xsl:when>
			<xsl:when test="$pRegion='Taiwan'">ISO Countries;Taiwan</xsl:when>
			<xsl:when test="$pRegion='Tanzania'">ISO Countries;Tanzania</xsl:when>
			<xsl:when test="$pRegion='Texas'">US States;Texas</xsl:when>
			<xsl:when test="$pRegion='Trinidad'">ISO Countries;Trinidad</xsl:when>
			<xsl:when test="$pRegion='tropical West Africa to S Sudan'">Regions;tropical West Africa to S Sudan</xsl:when>
			<xsl:when test="$pRegion='tropical West Africa to Zaire'">Regions;tropical West Africa to Zaire</xsl:when>
			<xsl:when test="$pRegion='United States'">ISO Countries;United States</xsl:when>
			<xsl:when test="$pRegion='Uruguay'">ISO Countries;Uruguay</xsl:when>
			<xsl:when test="$pRegion='Uruguay?'">ISO Countries;Uruguay?</xsl:when>
			<xsl:when test="$pRegion='Venezuela'">ISO Countries;Venezuela</xsl:when>
			<xsl:when test="$pRegion='Venezuela (Tachira Páramo de El Colorado)'">ISO Countries;Venezuela (Tachira Páramo de El Colorado)</xsl:when>
			<xsl:when test="$pRegion='W Indies'">Regions;W Indies</xsl:when>
			<xsl:when test="$pRegion='W Mexico'">Regions;W Mexico</xsl:when>
			<xsl:when test="$pRegion='W Texas'">Regions;W Texas</xsl:when>
			<xsl:when test="$pRegion='W United States'">Regions;W United States</xsl:when>
			<xsl:when test="$pRegion='West Indies'">Regions;West Indies</xsl:when>
			<xsl:when test="$pRegion='western Dominican Republic '">Regions;western Dominican Republic </xsl:when>
			<xsl:when test="$pRegion='Wet tropical North America'">Regions;Wet tropical North America</xsl:when>
			<xsl:when test="$pRegion='Zaire'">ISO Countries;Zaire</xsl:when>
			<xsl:when test="$pRegion='Zambia'">ISO Countries;Zambia</xsl:when>
			<xsl:when test="$pRegion='Zanzibar'">ISO Countries;Zanzibar</xsl:when>
			<xsl:when test="$pRegion='Zimbabwe'">ISO Countries;Zimbabwe</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
