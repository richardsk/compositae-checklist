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
			<xsl:when test="$pProv='Adventicia.'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='Adventicia'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='Native.'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pProv='Endémica.'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pProv='Naturalizada.'">Present in wild;Exotic</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='BAI'">Provinces of Argentina;Buenos Aires</xsl:when>
			<xsl:when test="$pProv='COR'">Provinces of Argentina;Córdoba</xsl:when>
			<xsl:when test="$pProv='CHA'">Provinces of Argentina;Chaco</xsl:when>
			<xsl:when test="$pProv='COS'">Provinces of Argentina;Corrientes</xsl:when>
			<xsl:when test="$pProv='DFE'">Provinces of Argentina;Argentina Distrito Federal</xsl:when>
			<xsl:when test="$pProv='ERI'">Provinces of Argentina;Entre Ríos</xsl:when>
			<xsl:when test="$pProv='FOR'">Provinces of Argentina;Formosa</xsl:when>
			<xsl:when test="$pProv='LPA'">Provinces of Argentina;La Pampa</xsl:when>
			<xsl:when test="$pProv='MIS'">Provinces of Argentina;Misiones</xsl:when>
			<xsl:when test="$pProv='SFE'">Provinces of Argentina;Santa Fé</xsl:when>
			<xsl:when test="$pProv='CHU'">Provinces of Argentina;Chubut</xsl:when>
			<xsl:when test="$pProv='NEU'">Provinces of Argentina;Neuquén</xsl:when>
			<xsl:when test="$pProv='RNE'">Provinces of Argentina;Rio Negro</xsl:when>
			<xsl:when test="$pProv='SCR'">Provinces of Argentina;Santa Cruz</xsl:when>
			<xsl:when test="$pProv='TDF'">Provinces of Argentina;Tierra del Fuego (Argentina)</xsl:when>
			<xsl:when test="$pProv='CAT'">Provinces of Argentina;Catamarca</xsl:when>
			<xsl:when test="$pProv='JUJ'">Provinces of Argentina;Jujuy</xsl:when>
			<xsl:when test="$pProv='LRI'">Provinces of Argentina;La Rioja</xsl:when>
			<xsl:when test="$pProv='MEN'">Provinces of Argentina;Mendoza</xsl:when>
			<xsl:when test="$pProv='SAL'">Provinces of Argentina;Salta</xsl:when>
			<xsl:when test="$pProv='SDE'">Provinces of Argentina;Santiago del Estero</xsl:when>
			<xsl:when test="$pProv='SJU'">Provinces of Argentina;San Juan</xsl:when>
			<xsl:when test="$pProv='SLU'">Provinces of Argentina;San Luis</xsl:when>
			<xsl:when test="$pProv='TUC'">Provinces of Argentina;Tucumán</xsl:when>
			<xsl:when test="$pProv='PAR'">States of Brazil;Paraná</xsl:when>
			<xsl:when test="$pProv='RGS'">States of Brazil;Rio Grande do Sul</xsl:when>
			<xsl:when test="$pProv='SCA'">States of Brazil;Santa Catarina</xsl:when>
			<xsl:when test="$pProv='VIII'">Regions of Chile;Biobío</xsl:when>
			<xsl:when test="$pProv='IV'">Regions of Chile;Coquimbo</xsl:when>
			<xsl:when test="$pProv='IX'">Regions of Chile;La Araucania</xsl:when>
			<xsl:when test="$pProv='VII'">Regions of Chile;Maule</xsl:when>
			<xsl:when test="$pProv='VI'">Regions of Chile;O’Higgins</xsl:when>
			<xsl:when test="$pProv='RME'">Regions of Chile;Santiago</xsl:when>
			<xsl:when test="$pProv='V'">Regions of Chile;Valparaíso</xsl:when>
			<xsl:when test="$pProv='II'">Regions of Chile;Antofagasta</xsl:when>
			<xsl:when test="$pProv='III'">Regions of Chile;Atacama</xsl:when>
			<xsl:when test="$pProv='I'">Regions of Chile;Tarapacá</xsl:when>
			<xsl:when test="$pProv='XI'">Regions of Chile;Aisén</xsl:when>
			<xsl:when test="$pProv='X'">Regions of Chile;Los Lagos</xsl:when>
			<xsl:when test="$pProv='XII'">Regions of Chile;Magellanes</xsl:when>
			<xsl:when test="$pProv='IDP'">Regions of Chile;Desventurados Is.</xsl:when>
			<xsl:when test="$pProv='IJF'">Regions of Chile;Juan Fernández Is.</xsl:when>
			<xsl:when test="$pProv='PRY'">ISO Countries;Paraguay</xsl:when>
			<xsl:when test="$pProv='URY'">ISO Countries;Uruguay</xsl:when>
			<xsl:when test="$pProv='ARG'">ISO Countries;Argentina</xsl:when>
			<xsl:when test="$pProv='BRA'">ISO Countries;Brazil</xsl:when>
			<xsl:when test="$pProv='CHL'">ISO Countries;Chile</xsl:when>
			<xsl:when test="$pProv='COL'">Departments of Uruguay;Colonia</xsl:when>
			<xsl:when test="$pProv='ART'">Departments of Uruguay;Artigas</xsl:when>
			<xsl:when test="$pProv='CAS'">Departments of Uruguay;Canelones</xsl:when>
			<xsl:when test="$pProv='CLA'">Departments of Uruguay;Cerro Largo</xsl:when>
			<xsl:when test="$pProv='DUR'">Departments of Uruguay;Durazno</xsl:when>
			<xsl:when test="$pProv='FLA'">Departments of Uruguay;Florida</xsl:when>
			<xsl:when test="$pProv='FLO'">Departments of Uruguay;Flores</xsl:when>
			<xsl:when test="$pProv='LAV'">Departments of Uruguay;Lavelleja</xsl:when>
			<xsl:when test="$pProv='MAL'">Departments of Uruguay;Maldonado</xsl:when>
			<xsl:when test="$pProv='MON'">Departments of Uruguay;Montevideo</xsl:when>
			<xsl:when test="$pProv='PAY'">Departments of Uruguay;Paysandú</xsl:when>
			<xsl:when test="$pProv='RIV'">Departments of Uruguay;Rivera</xsl:when>
			<xsl:when test="$pProv='RNO'">Departments of Uruguay;Rio Negro</xsl:when>
			<xsl:when test="$pProv='ROC'">Departments of Uruguay;Rocha</xsl:when>
			<xsl:when test="$pProv='SAO'">Departments of Uruguay;Salto</xsl:when>
			<xsl:when test="$pProv='SJO'">Departments of Uruguay;San José</xsl:when>
			<xsl:when test="$pProv='SOR'">Departments of Uruguay;Soriano</xsl:when>
			<xsl:when test="$pProv='TAC'">Departments of Uruguay;Tacuarembó</xsl:when>
			<xsl:when test="$pProv='TYT'">Departments of Uruguay;Treinta y Tres</xsl:when>
			<xsl:when test="$pProv='APA'">Departments of Paraguay;Alto Paraná</xsl:when>
			<xsl:when test="$pProv='AMA'">Departments of Paraguay;Amambay</xsl:when>
			<xsl:when test="$pProv='CAU'">Departments of Paraguay;Caaguazú</xsl:when>
			<xsl:when test="$pProv='CAA'">Departments of Paraguay;Caazapá</xsl:when>
			<xsl:when test="$pProv='CAN'">Departments of Paraguay;Canindeyú</xsl:when>
			<xsl:when test="$pProv='CON'">Departments of Paraguay;Concepción</xsl:when>
			<xsl:when test="$pProv='COA'">Departments of Paraguay;Cordillera</xsl:when>
			<xsl:when test="$pProv='MIE'">Departments of Paraguay;Misiones</xsl:when>
			<xsl:when test="$pProv='PAI'">Departments of Paraguay;Paraguari</xsl:when>
			<xsl:when test="$pProv='SPE'">Departments of Paraguay;San Pedro</xsl:when>
			<xsl:when test="$pProv='CEN'">Departments of Paraguay;Central</xsl:when>
			<xsl:when test="$pProv='GUA'">Departments of Paraguay;Guairá</xsl:when>
			<xsl:when test="$pProv='PHA'">Departments of Paraguay;Presudente Hayes</xsl:when>
			<xsl:when test="$pProv='APY'">Departments of Paraguay;Alto Paraguay</xsl:when>
			<xsl:when test="$pProv='ITA'">Departments of Paraguay;Itapúa</xsl:when>
			<xsl:when test="$pProv='NEE'">Departments of Paraguay;Ñeembucú</xsl:when>		
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>
