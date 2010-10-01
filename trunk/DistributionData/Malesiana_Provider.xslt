<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Conabio_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<Distribution schema="Region" occurrence="Present" origin="" region="Malesiana"/>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
