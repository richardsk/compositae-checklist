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
					<xsl:attribute name="region"><xsl:value-of select="$vDep"/></xsl:attribute>
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
			<xsl:when test="$pRegion='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pRegion='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pRegion='Panama'">ISO Countries;Panama</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="conDepartment">
		<xsl:param name="pDepartment"/>
		<xsl:choose>
			<xsl:when test="$pDepartment='Azuay'">Provinces of Ecuador;Azuay</xsl:when>
			<xsl:when test="$pDepartment='Bolávar'">Provinces of Ecuador;Bolávar</xsl:when>
			<xsl:when test="$pDepartment='Cañar'">Provinces of Ecuador;Cañar</xsl:when>
			<xsl:when test="$pDepartment='Carchi'">Provinces of Ecuador;Carchi</xsl:when>
			<xsl:when test="$pDepartment='Chimborazo'">Provinces of Ecuador;Chimborazo</xsl:when>
			<xsl:when test="$pDepartment='Cotopaxi'">Provinces of Ecuador;Cotopaxi</xsl:when>
			<xsl:when test="$pDepartment='El Oro'">Provinces of Ecuador;El Oro</xsl:when>
			<xsl:when test="$pDepartment='Esmeraldas'">Provinces of Ecuador;Esmeraldas</xsl:when>
			<xsl:when test="$pDepartment='Galapagos'">Provinces of Ecuador;Galapagos</xsl:when>
			<xsl:when test="$pDepartment='Guayas'">Provinces of Ecuador;Guayas</xsl:when>
			<xsl:when test="$pDepartment='Imbabura'">Provinces of Ecuador;Imbabura</xsl:when>
			<xsl:when test="$pDepartment='Los Ríos'">Provinces of Ecuador;Los Ríos</xsl:when>
			<xsl:when test="$pDepartment='Loja'">Provinces of Ecuador;Loja</xsl:when>
			<xsl:when test="$pDepartment='Morona-Santiago'">Provinces of Ecuador;Morona-Santiago</xsl:when>
			<xsl:when test="$pDepartment='Napo'">Provinces of Ecuador;Napo</xsl:when>
			<xsl:when test="$pDepartment='Pichincha'">Provinces of Ecuador;Pichincha</xsl:when>
			<xsl:when test="$pDepartment='Sucumbíos'">Provinces of Ecuador;Sucumbíos</xsl:when>
			<xsl:when test="$pDepartment='Tungurahua'">Provinces of Ecuador;Tungurahua</xsl:when>
			<xsl:when test="$pDepartment='Zamora-Chinchipe'">Provinces of Ecuador;Zamora-Chinchipe</xsl:when>
			<xsl:when test="$pDepartment='Manabí'">Provinces of Ecuador;Manabí</xsl:when>
			<xsl:when test="$pDepartment='Pastaza'">Provinces of Ecuador;Pastaza</xsl:when>
			<xsl:when test="$pDepartment='Africa'">ISO Countries;Africa</xsl:when>
			<xsl:when test="$pDepartment='Antilles (general)'">Region;Antilles (general)</xsl:when>
			<xsl:when test="$pDepartment='Aruba'">ISO Countries;Aruba</xsl:when>
			<xsl:when test="$pDepartment='Bonaire'">Islands;Bonaire</xsl:when>
			<xsl:when test="$pDepartment='Curacao'">Islands;Curacao</xsl:when>
			<xsl:when test="$pDepartment='Asia'">Region;Asia</xsl:when>
			<xsl:when test="$pDepartment='Bahamas'">ISO Countries;Bahamas</xsl:when>
			<xsl:when test="$pDepartment='Belize'">ISO Countries;Belize</xsl:when>
			<xsl:when test="$pDepartment='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pDepartment='Canal Area'">Zone;Canal Area</xsl:when>
			<xsl:when test="$pDepartment='Central America (general)'">Region;Central America (general)</xsl:when>
			<xsl:when test="$pDepartment='Chiriquí'">Province of Panama;Chiriquí</xsl:when>
			<xsl:when test="$pDepartment='Coclé'">Province of Panama;Coclé</xsl:when>
			<xsl:when test="$pDepartment='Colombia'">ISO Countries;Colombia</xsl:when>
			<xsl:when test="$pDepartment='Colón'">Province of Panama;Colón</xsl:when>
			<xsl:when test="$pDepartment='Costa Rica'">ISO Countries;Costa Rica</xsl:when>
			<xsl:when test="$pDepartment='Cuba'">ISO Countries;Cuba</xsl:when>
			<xsl:when test="$pDepartment='Darién'">Province of Panama;Darién</xsl:when>
			<xsl:when test="$pDepartment='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pDepartment='El Salvador'">ISO Countries;El Salvador</xsl:when>
			<xsl:when test="$pDepartment='endemic to Panama'">ISO Countries;endemic to Panama</xsl:when>
			<xsl:when test="$pDepartment='Europe'">Region;Europe</xsl:when>
			<xsl:when test="$pDepartment='Florida'">US States;Florida</xsl:when>
			<xsl:when test="$pDepartment='Galapagos'">Islands;Galapagos</xsl:when>
			<xsl:when test="$pDepartment='Greater Antilles (general)'">Region;Greater Antilles (general)</xsl:when>
			<xsl:when test="$pDepartment='Guatemala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pDepartment='Guianas'">Region;Guianas</xsl:when>
			<xsl:when test="$pDepartment='Herrera'">Province of Panama;Herrera</xsl:when>
			<xsl:when test="$pDepartment='Hispaniola'">ISO Countries;Hispaniola</xsl:when>
			<xsl:when test="$pDepartment='Honduras'">ISO Countries;Honduras</xsl:when>
			<xsl:when test="$pDepartment='Jamaica'">ISO Countries;Jamaica</xsl:when>
			<xsl:when test="$pDepartment='Lesser Antilles (general)'">Region;Lesser Antilles (general)</xsl:when>
			<xsl:when test="$pDepartment='Los Santos'">Province of Panama;Los Santos</xsl:when>
			<xsl:when test="$pDepartment='Mexico'">ISO Countries;Mexico</xsl:when>
			<xsl:when test="$pDepartment='Nicaragua'">ISO Countries;Nicaragua</xsl:when>
			<xsl:when test="$pDepartment='North America'">Region;North America</xsl:when>
			<xsl:when test="$pDepartment='Panamá'">Province of Panama;Panamá</xsl:when>
			<xsl:when test="$pDepartment='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pDepartment='Puerto Rico'">ISO Countries;Puerto Rico</xsl:when>
			<xsl:when test="$pDepartment='San Blas'">Territory of Panama;San Blas</xsl:when>
			<xsl:when test="$pDepartment='South America (general)'">Region;South America (general)</xsl:when>
			<xsl:when test="$pDepartment='South America (other - Brazil, etc.)'">Region;South America (other - Brazil, etc.)</xsl:when>
			<xsl:when test="$pDepartment='South America (tropical)'">Region;South America (tropical)</xsl:when>
			<xsl:when test="$pDepartment='Southern United States'">Region;Southern United States</xsl:when>
			<xsl:when test="$pDepartment='Texas'">US States;Texas</xsl:when>
			<xsl:when test="$pDepartment='Trinidad, Tobago'">ISO Countries;Trinidad, Tobago</xsl:when>
			<xsl:when test="$pDepartment='U.S.A.'">ISO Countries;U.S.A.</xsl:when>
			<xsl:when test="$pDepartment='Venezuela'">ISO Countries;Venezuela</xsl:when>
			<xsl:when test="$pDepartment='Veraguas'">Province of Panama;Veraguas</xsl:when>
			<xsl:when test="$pDepartment='Bocas Del Toro'">Province of Panama;Bocas Del Toro</xsl:when>
			<xsl:when test="$pDepartment='Amazonas'">Regions of Peru;Amazonas</xsl:when>
			<xsl:when test="$pDepartment='Ancash'">Regions of Peru;Ancash</xsl:when>
			<xsl:when test="$pDepartment='Apurímac'">Regions of Peru;Apurímac</xsl:when>
			<xsl:when test="$pDepartment='Arequipa'">Regions of Peru;Arequipa</xsl:when>
			<xsl:when test="$pDepartment='Ayacucho'">Regions of Peru;Ayacucho</xsl:when>
			<xsl:when test="$pDepartment='Cajamarca'">Regions of Peru;Cajamarca</xsl:when>
			<xsl:when test="$pDepartment='Cuzco'">Regions of Peru;Cuzco</xsl:when>
			<xsl:when test="$pDepartment='Huancavelica'">Regions of Peru;Huancavelica</xsl:when>
			<xsl:when test="$pDepartment='Huánuco'">Regions of Peru;Huánuco</xsl:when>
			<xsl:when test="$pDepartment='Ica'">Regions of Peru;Ica</xsl:when>
			<xsl:when test="$pDepartment='Junín'">Regions of Peru;Junín</xsl:when>
			<xsl:when test="$pDepartment='La Libertad'">Regions of Peru;La Libertad</xsl:when>
			<xsl:when test="$pDepartment='Lambayeque'">Regions of Peru;Lambayeque</xsl:when>
			<xsl:when test="$pDepartment='Lima'">Province of Peru;Lima</xsl:when>
			<xsl:when test="$pDepartment='Loreto'">Regions of Peru;Loreto</xsl:when>
			<xsl:when test="$pDepartment='Madre de Dios'">Regions of Peru;Madre de Dios</xsl:when>
			<xsl:when test="$pDepartment='Moquegua'">Regions of Peru;Moquegua</xsl:when>
			<xsl:when test="$pDepartment='Pasco'">Regions of Peru;Pasco</xsl:when>
			<xsl:when test="$pDepartment='Piura'">Regions of Peru;Piura</xsl:when>
			<xsl:when test="$pDepartment='Puno'">Regions of Peru;Puno</xsl:when>
			<xsl:when test="$pDepartment='San Martín'">Regions of Peru;San Martín</xsl:when>
			<xsl:when test="$pDepartment='Tacna'">Regions of Peru;Tacna</xsl:when>
			<xsl:when test="$pDepartment='Tumbes'">Regions of Peru;Tumbes</xsl:when>
			<xsl:when test="$pDepartment='Ucayali'">Regions of Peru;Ucayali</xsl:when>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
