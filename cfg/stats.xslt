<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:api="xmlapi_1.0"
exclude-result-prefixes="api"
>
<xsl:output method="xml" indent="yes" />

<xsl:template match="/">
  <xsl:apply-templates select="./*" />
</xsl:template>

<xsl:template match="/*">
  <xsl:apply-templates select="./*">
    <xsl:with-param name="nvp_pivot2" select="local-name()" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="/*/*">
  <xsl:param name="nvp_pivot2" />
  <xsl:variable name="time_pivot" >
    <xsl:choose>
      <!-- Accounting classes -->
      <xsl:when test="./api:timeRecorded" > 
        <xsl:value-of select="./api:timeRecorded" />
      </xsl:when>
      <!-- OAM classes -->
      <xsl:when test="./api:scheduledTime" >
        <xsl:value-of select="./api:scheduledTime" />
      </xsl:when>
      <!-- Performance classes -->
      <xsl:otherwise>
        <xsl:value-of select="./api:timeCaptured" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:apply-templates select="./*" >
    <xsl:with-param name="nvp_pivot1" select="$time_pivot"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="local-name()"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="/*/*/*">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:param name="nvp_pivot3" />
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="position()"/>
    <xsl:with-param name="nvp_name" select="local-name()"/>
    <xsl:with-param name="nvp_value" select="node()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="produce_nvp">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:param name="nvp_pivot3" />
  <xsl:param name="nvp_recId" />
  <xsl:param name="nvp_name" />
  <xsl:param name="nvp_value" />
  <row>
    <column name="pivot1">
      <xsl:value-of select="$nvp_pivot1" />
    </column>
    <column name="pivot2">
      <xsl:value-of select="$nvp_pivot2" />
    </column>
    <column name="pivot3">
      <xsl:value-of select="$nvp_pivot3" />
    </column>
    <column name="pivot4">
      <xsl:value-of select="''" />
    </column>
    <column name="recId">
      <xsl:value-of select="$nvp_recId" />
    </column>
    <column name="name">
      <xsl:value-of select="$nvp_name" />
    </column>
    <column name="value">
      <xsl:value-of select="$nvp_value" />
    </column>
  </row>
</xsl:template>

</xsl:stylesheet>

