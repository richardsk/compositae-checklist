<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<DataSet>
			<xsl:apply-templates select="NewDataSet/Provider"/>
		</DataSet>
	</xsl:template>

	<xsl:template match="NewDataSet/Provider">
		<Provider>
			<xsl:attribute name="id">
				<xsl:value-of select="ProviderPk"/>
			</xsl:attribute>
			<Name>
				<xsl:value-of select="ProviderName"/>
			</Name>
			<FullName>
				<xsl:value-of select="ProviderNameFull"/>
			</FullName>
			<ProjectUrl>
				<xsl:value-of select="ProviderProjectUrl"/>
			</ProjectUrl>
			<HomeUrl>
				<xsl:value-of select="ProviderHomeUrl"/>
			</HomeUrl>
			<ContactName>
				<xsl:value-of select="ProviderContactName"/>
			</ContactName>
			<ContactEmail>
				<xsl:value-of select="ProviderContactEmail"/>
			</ContactEmail>
			<ContactPhone>
				<xsl:value-of select="ProviderContactPhone"/>
			</ContactPhone>
		</Provider>
	</xsl:template>

	
</xsl:stylesheet> 

