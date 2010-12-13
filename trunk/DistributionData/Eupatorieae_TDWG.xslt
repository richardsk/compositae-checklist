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
			<xsl:when test="$pStatus='Introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Present'">Present;</xsl:when>
			<xsl:when test="$pStatus='Waif - an ephemeral introduction, not persistently naturalized'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pStatus='Probably Native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pStatus='Probably Introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pStatus='Native and Introduced - some infra-taxa are native and others are introduced'">Present;</xsl:when>
			<xsl:otherwise>Present;</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
			<xsl:choose>
				<xsl:when test="$pRegion='Africa'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='Am Bor'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Amazonian Peru'">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='Andes from Venezuela to Bolivia '">TDWG Level 2;83</xsl:when>
				<xsl:when test="$pRegion='Andes S to Bolivia'">TDWG Level 2;83</xsl:when>
				<xsl:when test="$pRegion='Angola'">TDWG Level 4;ANG-OO</xsl:when>
				<xsl:when test="$pRegion='Argentina'">TDWG Level 2;85</xsl:when>
				<xsl:when test="$pRegion='Arizona'">TDWG Level 4;ARI-OO</xsl:when>
				<xsl:when test="$pRegion='Asia Minor'">TDWG Level 2;34</xsl:when>
				<xsl:when test="$pRegion='Australia'">TDWG Level 2;50</xsl:when>
				<xsl:when test="$pRegion='Australia (Queensland)'">TDWG Level 4;QLD-QU</xsl:when>
				<xsl:when test="$pRegion='Bahamas'">TDWG Level 4;BAH-OO</xsl:when>
				<xsl:when test="$pRegion='Baja California'">TDWG Level 4;MXN-BC</xsl:when>
				<xsl:when test="$pRegion='Belize'">TDWG Level 4;BLZ-OO</xsl:when>
				<xsl:when test="$pRegion='Bolivia'">TDWG Level 4;BOL-OO</xsl:when>
				<xsl:when test="$pRegion='Borneo'">TDWG Level 3;BOR</xsl:when>
				<xsl:when test="$pRegion='Botswana'">TDWG Level 4;BOT-OO</xsl:when>
				<xsl:when test="$pRegion='Brazil'">TDWG Level 2;84</xsl:when>
				<xsl:when test="$pRegion='Brazil (Bahia)'">TDWG Level 4;BZE-BA</xsl:when>
				<xsl:when test="$pRegion='British Columbia'">TDWG Level 4;BRC-OO</xsl:when>
				<xsl:when test="$pRegion='Burundi'">TDWG Level 4;BUR-OO</xsl:when>
				<xsl:when test="$pRegion='California'">TDWG Level 4;CAL-OO</xsl:when>
				<xsl:when test="$pRegion='Cameroon'">TDWG Level 4;CMN-OO</xsl:when>
				<xsl:when test="$pRegion='Cañar'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Cape of Good Hope'">TDWG Level 2;27</xsl:when>
				<xsl:when test="$pRegion='central and S Africa'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='central and SW United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Central and W United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Central America'">TDWG Level 2;80</xsl:when>
				<xsl:when test="$pRegion='Central America to Panama'">TDWG Level 2;80</xsl:when>
				<xsl:when test="$pRegion='central Ecuador '">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Central Mexico'">TDWG Level 3;MXC</xsl:when>
				<xsl:when test="$pRegion='central United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Ceylon'">TDWG Level 4;SRL-OO</xsl:when>
				<xsl:when test="$pRegion='Chile'">TDWG Level 2;85</xsl:when>
				<xsl:when test="$pRegion='China'">TDWG Level 2;36</xsl:when>
				<xsl:when test="$pRegion='Colombia'">TDWG Level 4;CLM-OO</xsl:when>
				<xsl:when test="$pRegion='Colombia (Antioquia)'">TDWG Level 4;CLM-OO</xsl:when>
				<xsl:when test="$pRegion='Colombia (Cundinamarca: Páramo de Palacio)'">TDWG Level 4;CLM-OO</xsl:when>
				<xsl:when test="$pRegion='Colombia (Nariño)'">TDWG Level 4;CLM-OO</xsl:when>
				<xsl:when test="$pRegion='Costa Rica'">TDWG Level 4;COS-OO</xsl:when>
				<xsl:when test="$pRegion='Costa Rica?'">TDWG Level 4;COS-OO</xsl:when>
				<xsl:when test="$pRegion='Cuba'">TDWG Level 4;CUB-OO</xsl:when>
				<xsl:when test="$pRegion='Cuba and the Isla de Pinos'">TDWG Level 4;CUB-OO</xsl:when>
				<xsl:when test="$pRegion='Dominica'">TDWG Level 4;WIN-DO</xsl:when>
				<xsl:when test="$pRegion='Dominican Republic'">TDWG Level 4;DOM-OO</xsl:when>
				<xsl:when test="$pRegion='E and central North America'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='E and Central United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='E Africa'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='E Asia'">TDWG Level 1;3</xsl:when>
				<xsl:when test="$pRegion='E Canada'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='E North America'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='E United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='E United States to Wyoming'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='East Africa'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='East Indies'">TDWG Level 1;4</xsl:when>
				<xsl:when test="$pRegion='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador '">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Azuay'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Azuay)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Azuay/Morona-Santiago border)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Carchi)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Chimborazo)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Loja)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Napo)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (northwestern lowlands)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Peru?)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Pichincha)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Quito and Tungurahua)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Zamora-Chinchipe and Loja)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Ecuador (Zamora-Chinchipe)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='El Salvador'">TDWG Level 4;ELS-OO</xsl:when>
				<xsl:when test="$pRegion='England'">TDWG Level 4;GRB-OO</xsl:when>
				<xsl:when test="$pRegion='Ethiopia'">TDWG Level 4;ETH-OO</xsl:when>
				<xsl:when test="$pRegion='Eucador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='Europe'">TDWG Level 1;1</xsl:when>
				<xsl:when test="$pRegion='Fernando Po'">TDWG Level 4;GGI-BI</xsl:when>
				<xsl:when test="$pRegion='Fiji'">TDWG Level 4;FIJ-OO</xsl:when>
				<xsl:when test="$pRegion='Florida'">TDWG Level 4;FLA-OO</xsl:when>
				<xsl:when test="$pRegion='French Guiana'">TDWG Level 4;FRG-OO</xsl:when>
				<xsl:when test="$pRegion='Galapagos'">TDWG Level 4;GAL-OO</xsl:when>
				<xsl:when test="$pRegion='Georgia'">TDWG Level 4;GEO-OO</xsl:when>
				<xsl:when test="$pRegion='Greater Antilles'">TDWG Level 2;81</xsl:when>
				<xsl:when test="$pRegion='Grenada'">TDWG Level 4;WIN-GR</xsl:when>
				<xsl:when test="$pRegion='Guadeloupe'">TDWG Level 4;LEE-GU</xsl:when>
				<xsl:when test="$pRegion='Guatemala'">TDWG Level 4;GUA-OO</xsl:when>
				<xsl:when test="$pRegion='Guatemala to Panama'">TDWG Level 2;80</xsl:when>
				<xsl:when test="$pRegion='Guayana'">TDWG Level 4;GUY-OO</xsl:when>
				<xsl:when test="$pRegion='Guerrero'">TDWG Level 4;MXS-GR</xsl:when>
				<xsl:when test="$pRegion='Guyana'">TDWG Level 4;GUY-OO</xsl:when>
				<xsl:when test="$pRegion='Hainan'">TDWG Level 4;CHH-OO</xsl:when>
				<xsl:when test="$pRegion='Haiti'">TDWG Level 4;HAI-HA</xsl:when>
				<xsl:when test="$pRegion='Hispaniola'">TDWG Level 2;81</xsl:when>
				<xsl:when test="$pRegion='Honduras'">TDWG Level 4;HON-OO</xsl:when>
				<xsl:when test="$pRegion='Hong Kong'">TDWG Level 4;CHS-HK</xsl:when>
				<xsl:when test="$pRegion='Illinois'">TDWG Level 4;ILL-OO</xsl:when>
				<xsl:when test="$pRegion='India'">TDWG Level 3;IND</xsl:when>
				<xsl:when test="$pRegion='Indian Ocean'">TDWG Level 2;29</xsl:when>
				<xsl:when test="$pRegion='Indiana'">TDWG Level 4;INI-OO</xsl:when>
				<xsl:when test="$pRegion='Indo-China'">TDWG Level 2;41</xsl:when>
				<xsl:when test="$pRegion='Indonesia'">TDWG Level 2;42</xsl:when>
				<xsl:when test="$pRegion='Jamaica'">TDWG Level 4;JAM-OO</xsl:when>
				<xsl:when test="$pRegion='Jamaica?'">TDWG Level 4;JAM-OO</xsl:when>
				<xsl:when test="$pRegion='Japan'">TDWG Level 3;JAP</xsl:when>
				<xsl:when test="$pRegion='Kentucky'">TDWG Level 4;KTY-OO</xsl:when>
				<xsl:when test="$pRegion='Lesser Antilles'">TDWG Level 2;81</xsl:when>
				<xsl:when test="$pRegion='Lesser Antilles (Dominica)'">TDWG Level 4;WIN-DO</xsl:when>
				<xsl:when test="$pRegion='Malagasy Republic'">TDWG Level 4;MDG-OO</xsl:when>
				<xsl:when test="$pRegion='Malawi'">TDWG Level 4;MLW-OO</xsl:when>
				<xsl:when test="$pRegion='Martinique'">TDWG Level 4;WIN-MA</xsl:when>
				<xsl:when test="$pRegion='Mexico'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='Mexico (Chiapas'">TDWG Level 4;MXT-CI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Chiapas)'">TDWG Level 4;MXT-CI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Guerrero)'">TDWG Level 4;MXS-GR</xsl:when>
				<xsl:when test="$pRegion='Mexico (Mexico state)'">TDWG Level 4;MXC-ME</xsl:when>
				<xsl:when test="$pRegion='Mexico (Michoacán)'">TDWG Level 4;MXS-MI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Nayarit)'">TDWG Level 4;MXS-NA</xsl:when>
				<xsl:when test="$pRegion='Mexico (northwestern Jalisco)'">TDWG Level 4;MXS-JA</xsl:when>
				<xsl:when test="$pRegion='Mexico (Nuevo León)'">TDWG Level 4;MXE-NL</xsl:when>
				<xsl:when test="$pRegion='Mexico (Oaxaca and Puebla)'">TDWG Level 4;MXS-OA</xsl:when>
				<xsl:when test="$pRegion='Mexico (Oaxaca)'">TDWG Level 4;MXS-OA</xsl:when>
				<xsl:when test="$pRegion='Mexico (Quintana Roo)'">TDWG Level 4;MXT-QR</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sierra Madre Occidental'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sierra Madre Occidentale'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sinaloa and Durango)'">TDWG Level 4;MXN-SI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sinaloa)'">TDWG Level 4;MXN-SI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sinaloa-Durango border)'">TDWG Level 4;MXN-SI</xsl:when>
				<xsl:when test="$pRegion='Mexico (Sonora'">TDWG Level 4;MXN-SO</xsl:when>
				<xsl:when test="$pRegion='Mexico (Yucatan)'">TDWG Level 4;MXT-YU</xsl:when>
				<xsl:when test="$pRegion='Mexico (Zacatecas)'">TDWG Level 4;MXE-ZA</xsl:when>
				<xsl:when test="$pRegion='Mexico?'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='Minnesota'">TDWG Level 4;MIN-OO</xsl:when>
				<xsl:when test="$pRegion='Mozambique'">TDWG Level 4;MOZ-OO</xsl:when>
				<xsl:when test="$pRegion='N Africa'">TDWG Level 2;20</xsl:when>
				<xsl:when test="$pRegion='N central United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='N Mexico'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='N South America'">TDWG Level 2;82</xsl:when>
				<xsl:when test="$pRegion='N South America to Peru'">TDWG Level 1;8</xsl:when>
				<xsl:when test="$pRegion='NE Mexico'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='NE United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Nebraska'">TDWG Level 4;NEB-OO</xsl:when>
				<xsl:when test="$pRegion='New Guinea'">TDWG Level 3;NWG</xsl:when>
				<xsl:when test="$pRegion='New Mexico'">TDWG Level 4;NWM-OO</xsl:when>
				<xsl:when test="$pRegion='New Mexico and W Texas'">TDWG Level 2;77</xsl:when>
				<xsl:when test="$pRegion='Nicaragua'">TDWG Level 4;NIC-OO</xsl:when>
				<xsl:when test="$pRegion='Nigeria'">TDWG Level 4;NGA-OO</xsl:when>
				<xsl:when test="$pRegion='North Dakota'">TDWG Level 4;NDA-OO</xsl:when>
				<xsl:when test="$pRegion='northern Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='northern Ecuador (Amazonian side of Andes)'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='northern Peru'">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='northern South America and Peru'">TDWG Level 2;82</xsl:when>
				<xsl:when test="$pRegion='NW Mexico'">TDWG Level 3;MXN</xsl:when>
				<xsl:when test="$pRegion='Oaxaca'">TDWG Level 4;MXS-OA</xsl:when>
				<xsl:when test="$pRegion='Ontario'">TDWG Level 4;ONT-OO</xsl:when>
				<xsl:when test="$pRegion='Pacific'">TDWG Level 1;6</xsl:when>
				<xsl:when test="$pRegion='Pacific Islands'">TDWG Level 1;6</xsl:when>
				<xsl:when test="$pRegion='Panama'">TDWG Level 4;PAN-OO</xsl:when>
				<xsl:when test="$pRegion='Paraguay'">TDWG Level 4;PAR-OO</xsl:when>
				<xsl:when test="$pRegion='Peru'">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='Peru '">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='Peru (Cajamarca)'">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='Peru?'">TDWG Level 4;PER-OO</xsl:when>
				<xsl:when test="$pRegion='Philippines'">TDWG Level 4;PHI-OO</xsl:when>
				<xsl:when test="$pRegion='Portugal'">TDWG Level 4;POR-OO</xsl:when>
				<xsl:when test="$pRegion='Puebla'">TDWG Level 4;MXC-PU</xsl:when>
				<xsl:when test="$pRegion='Puerto Rico'">TDWG Level 4;PUE-OO</xsl:when>
				<xsl:when test="$pRegion='Ruwanda'">TDWG Level 4;RWA-OO</xsl:when>
				<xsl:when test="$pRegion='Ryukyu Islands'">TDWG Level 4;NNS-OO</xsl:when>
				<xsl:when test="$pRegion='S Africa'">TDWG Level 2;27</xsl:when>
				<xsl:when test="$pRegion='S Asia'">TDWG Level 1;4</xsl:when>
				<xsl:when test="$pRegion='S China'">TDWG Level 2;36</xsl:when>
				<xsl:when test="$pRegion='S Florida'">TDWG Level 4;FLA-OO</xsl:when>
				<xsl:when test="$pRegion='S to Angola'">TDWG Level 4;ANG-OO</xsl:when>
				<xsl:when test="$pRegion='SE Asia'">TDWG Level 1;4</xsl:when>
				<xsl:when test="$pRegion='SE United States'">TDWG Level 2;78</xsl:when>
				<xsl:when test="$pRegion='SE United States (and TX)'">TDWG Level 2;78</xsl:when>
				<xsl:when test="$pRegion='Sierra Leone to Nigeria'">TDWG Level 2;22</xsl:when>
				<xsl:when test="$pRegion='South Africa'">TDWG Level 2;27</xsl:when>
				<xsl:when test="$pRegion='South America'">TDWG Level 1;8</xsl:when>
				<xsl:when test="$pRegion='South America S to Bolivia'">TDWG Level 1;8</xsl:when>
				<xsl:when test="$pRegion='South America?'">TDWG Level 1;8</xsl:when>
				<xsl:when test="$pRegion='southcentral Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='south-central Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='southern Brazil highlands'">TDWG Level 2;84</xsl:when>
				<xsl:when test="$pRegion='southern Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
				<xsl:when test="$pRegion='southern Ecuador and northern Peru'">TDWG Level 2;83</xsl:when>
				<xsl:when test="$pRegion='Southern Mexico to Panama'">TDWG Level 2;80</xsl:when>
				<xsl:when test="$pRegion='Sri Lanka'">TDWG Level 4;SRL-OO</xsl:when>
				<xsl:when test="$pRegion='St Kitts (?)'">TDWG Level 4;LEE-SK</xsl:when>
				<xsl:when test="$pRegion='Surinam'">TDWG Level 4;SUR-OO</xsl:when>
				<xsl:when test="$pRegion='Suriname'">TDWG Level 4;SUR-OO</xsl:when>
				<xsl:when test="$pRegion='SW United States'">TDWG Level 2;76</xsl:when>
				<xsl:when test="$pRegion='Taiwan'">TDWG Level 4;TAI-OO</xsl:when>
				<xsl:when test="$pRegion='Tanzania'">TDWG Level 4;TAN-OO</xsl:when>
				<xsl:when test="$pRegion='Texas'">TDWG Level 4;TEX-OO</xsl:when>
				<xsl:when test="$pRegion='Trinidad'">TDWG Level 4;TRT-OO</xsl:when>
				<xsl:when test="$pRegion='tropical West Africa to S Sudan'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='tropical West Africa to Zaire'">TDWG Level 1;2</xsl:when>
				<xsl:when test="$pRegion='United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Uruguay'">TDWG Level 4;URU-OO</xsl:when>
				<xsl:when test="$pRegion='Uruguay?'">TDWG Level 4;URU-OO</xsl:when>
				<xsl:when test="$pRegion='Venezuela'">TDWG Level 4;VEN-OO</xsl:when>
				<xsl:when test="$pRegion='Venezuela (Tachira Páramo de El Colorado)'">TDWG Level 4;VEN-OO</xsl:when>
				<xsl:when test="$pRegion='W Indies'">TDWG Level 2;81</xsl:when>
				<xsl:when test="$pRegion='W Mexico'">TDWG Level 2;79</xsl:when>
				<xsl:when test="$pRegion='W Texas'">TDWG Level 4;TEX-OO</xsl:when>
				<xsl:when test="$pRegion='W United States'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='West Indies'">TDWG Level 2;81</xsl:when>
				<xsl:when test="$pRegion='western Dominican Republic '">TDWG Level 4;DOM-OO</xsl:when>
				<xsl:when test="$pRegion='Wet tropical North America'">TDWG Level 1;7</xsl:when>
				<xsl:when test="$pRegion='Zaire'">TDWG Level 4;ZAI-OO</xsl:when>
				<xsl:when test="$pRegion='Zambia'">TDWG Level 4;ZAM-OO</xsl:when>
				<xsl:when test="$pRegion='Zanzibar'">TDWG Level 4;TAN-OO</xsl:when>
				<xsl:when test="$pRegion='Zimbabwe'">TDWG Level 4;ZIM-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
