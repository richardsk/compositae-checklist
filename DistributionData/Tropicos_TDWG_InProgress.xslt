<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">

			<xsl:for-each select="Region">

				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="../Occurrence"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="../Origin"/></xsl:attribute>
				</Distribution>

			</xsl:for-each>

			<xsl:for-each select="Department">

				<xsl:variable name="vDepartment">
					<xsl:call-template name="conDepartment">
						<xsl:with-param name="pDepartment" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vDepartment,';')"/>
				<xsl:variable name="vDep" select="substring-after($vDepartment,';')"/>
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="department"><xsl:value-of select="$vDep"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="../Occurrence"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="../Origin"/></xsl:attribute>
				</Distribution>

			</xsl:for-each>


			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pRegion='Peru'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pRegion='Panama'">TDWG Level 4;PAN-OO</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="conDepartment">
		<xsl:param name="pDepartment"/>
		<xsl:choose>
			<xsl:when test="$pDepartment='Azuay'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Bolávar'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Cañar'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Carchi'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Chimborazo'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Cotopaxi'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='El Oro'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Esmeraldas'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Galapagos'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Guayas'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Imbabura'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Los Ríos'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Loja'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Morona-Santiago'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Napo'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Pichincha'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Sucumbíos'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Tungurahua'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Zamora-Chinchipe'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Manabí'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Pastaza'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='Africa'">TDWG Level 1;2</xsl:when>
			<xsl:when test="$pDepartment='Antilles (general)'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pDepartment='Aruba'">TDWG Level 4;ARU-OO</xsl:when>
			<xsl:when test="$pDepartment='Bonaire'">TDWG Level 4;NLA-BO</xsl:when>
			<xsl:when test="$pDepartment='Curacao'">TDWG Level 4;NLA-CU</xsl:when>
			<xsl:when test="$pDepartment='Asia'">TDWG Level 1;3,4</xsl:when>
			<xsl:when test="$pDepartment='Bahamas'">TDWG Level 4;BAH-OO</xsl:when>
			<xsl:when test="$pDepartment='Belize'">TDWG Level 4;BLZ-OO</xsl:when>
			<xsl:when test="$pDepartment='Bolivia'">TDWG Level 4;BOL-OO</xsl:when>
			<xsl:when test="$pDepartment='Canal Area'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Central America (general)'">TDWG Level 2;80</xsl:when>
			<xsl:when test="$pDepartment='Bocas Del Toro'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Chiriquí'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Coclé'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Colombia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pDepartment='Colón'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Cosmopolitan (worldwide)'">;</xsl:when>
			<xsl:when test="$pDepartment='Costa Rica'">TDWG Level 4;COS-OO</xsl:when>
			<xsl:when test="$pDepartment='Cuba'">TDWG Level 4;CUB-OO</xsl:when>
			<xsl:when test="$pDepartment='Darién'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Ecuador'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pDepartment='El Salvador'">TDWG Level 4;ELS-OO</xsl:when>
			<xsl:when test="$pDepartment='endemic to Panama'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Europe'">TDWG Level 1;1</xsl:when>
			<xsl:when test="$pDepartment='Florida'">TDWG Level 4;FLA-OO</xsl:when>
			<xsl:when test="$pDepartment='Galapagos'">TDWG Level 4;GAL-OO</xsl:when>
			<xsl:when test="$pDepartment='Greater Antilles (general)'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pDepartment='Guatemala'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pDepartment='Guianas'">TDWG Level 2;82</xsl:when>
			<xsl:when test="$pDepartment='Herrera'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Hispaniola'">TDWG Level 3;HAI</xsl:when>
			<xsl:when test="$pDepartment='Hispaniola'">TDWG Level 4;DOM-OO</xsl:when>
			<xsl:when test="$pDepartment='Honduras'">TDWG Level 4;HON-OO</xsl:when>
			<xsl:when test="$pDepartment='Jamaica'">TDWG Level 4;JAM-OO</xsl:when>
			<xsl:when test="$pDepartment='Lesser Antilles (general)'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pDepartment='Los Santos'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Mexico'">TDWG Level 2;79</xsl:when>
			<xsl:when test="$pDepartment='New World (general)'">;</xsl:when>
			<xsl:when test="$pDepartment='New World (tropical)'">;</xsl:when>
			<xsl:when test="$pDepartment='Nicaragua'">TDWG Level 4;NIC-OO</xsl:when>
			<xsl:when test="$pDepartment='North America'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pDepartment='Oceania (incl. Australia)'">;</xsl:when>
			<xsl:when test="$pDepartment='Old World (general)'">;</xsl:when>
			<xsl:when test="$pDepartment='Old World (tropical)'">;</xsl:when>
			<xsl:when test="$pDepartment='Panamá'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Pantropical'">;</xsl:when>
			<xsl:when test="$pDepartment='Peru'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Puerto Rico'">TDWG Level 4;PUE-OO</xsl:when>
			<xsl:when test="$pDepartment='San Blas'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='South America (general)'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pDepartment='South America (other - Brazil, etc.)'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pDepartment='South America (tropical)'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pDepartment='Southern United States'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pDepartment='Texas'">TDWG Level 4;TEX-OO</xsl:when>
			<xsl:when test="$pDepartment='Trinidad, Tobago'">TDWG Level 4;TRT-OO</xsl:when>
			<xsl:when test="$pDepartment='U.S.A.'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pDepartment='Venezuela'">TDWG Level 4;VEN-OO</xsl:when>
			<xsl:when test="$pDepartment='Veraguas'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pDepartment='Amazonas'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Ancash'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Apurímac'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Arequipa'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Ayacucho'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Cajamarca'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Cuzco'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Huancavelica'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Huánuco'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Ica'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Junín'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='La Libertad'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Lambayeque'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Lima'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Loreto'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Madre de Dios'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Moquegua'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Pasco'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Piura'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Puno'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='San Martín'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Tacna'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Tumbes'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pDepartment='Ucayali'">TDWG Level 4;PER-OO</xsl:when>			
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
