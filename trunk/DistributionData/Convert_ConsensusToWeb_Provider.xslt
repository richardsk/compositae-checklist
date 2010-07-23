<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:key use="concat(@schema, '+', @region)" name="kSchemaRegion" match="Biostat" />
  <xsl:key name="kProv" match="Provider" use="."/>
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <style>
      th, td {TEXT-ALIGN: left; PADDING-RIGHT: 1px; PADDING-LEFT: 3px}
      th {BORDER-TOP: #cccccc 1px solid; BACKGROUND-COLOR: #f2f2f}
      .topline {BORDER-TOP: #cccccc 1px solid}
      .noline {}
    </style>
    <table width="100%">
      <tbody>
        <tr>
          <th>Schema</th>
          <th>Region</th>
          <th>Biostatus</th>
          <th>Occurrence</th>
          <th>Origin</th>
          <th>Providers</th>
        </tr>
        <xsl:for-each select="//Biostat">
          <xsl:variable name="class">
            <xsl:choose>
              <xsl:when test="generate-id() = generate-id(key('kSchemaRegion', concat(@schema, '+', @region))[1])">topline</xsl:when>
              <xsl:otherwise>noline</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <tr>
            <th>
              <xsl:if test="@schema[not(.= preceding::Biostat/@schema)]">
                <xsl:value-of select="@schema" />
              </xsl:if>
            </th>
            <td>
              <xsl:attribute name="class">
                <xsl:value-of select="$class" />
              </xsl:attribute>
              <xsl:if test="generate-id() = generate-id(key('kSchemaRegion', concat(@schema, '+', @region))[1])">
                <xsl:value-of select="@region" />
              </xsl:if>
            </td>
            <td>
              <xsl:attribute name="class">
                <xsl:value-of select="$class" />
              </xsl:attribute>
              <xsl:call-template name="biostatus">
                <xsl:with-param name="pOcc" select="@Occurrence" />
                <xsl:with-param name="pOrig" select="@Origin" />
              </xsl:call-template>
            </td>
            <td>
              <xsl:attribute name="class">
                <xsl:value-of select="$class" />
              </xsl:attribute>
              <xsl:value-of select="@Occurrence" />
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
            <td>
              <xsl:attribute name="class">
                <xsl:value-of select="$class" />
              </xsl:attribute>
              <xsl:value-of select="@Origin" />
              <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
            </td>
            <td>
              <xsl:attribute name="class">
                <xsl:value-of select="$class" />
              </xsl:attribute>
              <xsl:for-each select=".//Provider">
                <xsl:sort select="." />
                <xsl:if test="generate-id(.) = generate-id(key('kProv', .)[1])">
                  <xsl:if test="position()!=1">, </xsl:if>
                  <xsl:value-of select="." />
                </xsl:if>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template name="biostatus">
    <xsl:param name="pOcc" />
    <xsl:param name="pOrig" />
    <xsl:choose>
      <xsl:when test="$pOrig='Indigenous'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Indigenous</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Endemic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Endemic</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Non-endemic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Non-endemic</xsl:when>
          <xsl:when test="$pOcc='Sometimes present'">?Vagrant</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Exotic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Exotic</xsl:when>
          <xsl:when test="$pOcc='Sometimes present'">Casual</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig=''">
        <xsl:choose>
          <xsl:when test="$pOcc='Absent'">Absent</xsl:when>
          <xsl:when test="$pOcc='Present'">Present</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>