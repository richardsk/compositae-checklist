<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:key use="@schema" name="kSchema" match="Distribution" />
  <xsl:key use="concat(@schema, '+', @region)" name="kSchemaRegion" match="Distribution" />
  <xsl:key use="concat(@schema,'+', @region, '+', @occurrence, '+', @origin)" name="kBiostat" match="Distribution" />
  <xsl:key name="kProv" match="Provider" use="."/>
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <DataSet>
      <xsl:for-each select="//Distribution">
        <xsl:sort select="@schema" />
        <xsl:sort select="@region" />
        <xsl:sort select="@occurrence" />
        <xsl:sort select="@origin" />
        <xsl:variable name="vSchema" select="@schema" />
        <xsl:if test="generate-id()=generate-id(key('kSchema', @schema)[1])">
          <xsl:for-each select="//Distribution[@schema=$vSchema]">
            <xsl:sort select="@region" />
            <xsl:sort select="@occurrence" />
            <xsl:sort select="@origin" />
            <xsl:variable name="vRegion" select="@region" />
            <xsl:if test="generate-id()=generate-id(key('kSchemaRegion', concat(@schema, '+', @region))[1])">
              <xsl:for-each select="//Distribution[@schema=$vSchema and @region=$vRegion]">
                <xsl:sort select="@schema" />
                <xsl:sort select="@region" />
                <xsl:sort select="@occurrence" />
                <xsl:sort select="@origin" />
                <xsl:if test="generate-id()=generate-id(key('kBiostat', concat(@schema,'+', @region, '+', @occurrence, '+', @origin))[1])">
                  <Biostat>
                    <xsl:attribute name="schema">
                      <xsl:value-of select="@schema" />
                    </xsl:attribute>
                    <xsl:attribute name="region">
                      <xsl:value-of select="$vRegion" />
                    </xsl:attribute>
                    <xsl:attribute name="Occurrence">
                      <xsl:value-of select="@occurrence" />
                    </xsl:attribute>
                    <xsl:attribute name="Origin">
                      <xsl:value-of select="@origin" />
                    </xsl:attribute>
                    <Providers>
                      <xsl:variable name="vOcc" select="@occurrence" />
                      <xsl:variable name="vOrigin" select="@origin" />
                      <xsl:for-each select="//Provider[count(Distributions/Distribution[@schema=$vSchema and @region=$vRegion and @occurrence=$vOcc and @origin=$vOrigin]) &gt; 0]">
                        <xsl:sort select="@id" data-type="number" />
                        <xsl:if test="generate-id(.) = generate-id(key('kProv', .)[1])">
                          <Provider>
                            <xsl:attribute name="id">
                              <xsl:value-of select="@id" />
                            </xsl:attribute>
                            <xsl:value-of select="@name" />
                          </Provider>
                        </xsl:if>
                      </xsl:for-each>
                    </Providers>
                  </Biostat>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </DataSet>
  </xsl:template>
</xsl:stylesheet>