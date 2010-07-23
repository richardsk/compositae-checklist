<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml GuianaShield_sample.xml?>
<!--provider id = 12-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion" select="translate(., '?', '')"/>
				<!-- create standard format output using provided schema -->
				<Distribution schema="unknown" occurrence="Present" origin="">
					<xsl:attribute name="region">
						<xsl:value-of select="$vRegion"/>
					</xsl:attribute>
					<xsl:attribute name="isOriginal">true</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
