<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
xmlns:api="xmlapi_1.0"
exclude-result-prefixes="soap api"
>
<xsl:output method="xml" indent="yes" />

<xsl:template match="/">
  <xsl:apply-templates select="action" />
  <xsl:apply-templates select="soap:Envelope/soap:Body/api:jms/*">
    <xsl:with-param name="nvp_pivot1" select="soap:Envelope/soap:Header/api:header/api:MTOSI_osTime" />
    <xsl:with-param name="nvp_pivot2" select="soap:Envelope/soap:Header/api:header/api:MTOSI_objectType" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="api:logFileAvailableEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="api:neId"/>
    <xsl:with-param name="nvp_recId" select="'1'"/>
    <xsl:with-param name="nvp_name" select="'fileName'"/>
    <xsl:with-param name="nvp_value" select="api:fileName"/>
  </xsl:call-template>
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="api:neId"/>
    <xsl:with-param name="nvp_recId" select="'2'"/>
    <xsl:with-param name="nvp_name" select="'serverIpAddress'"/>
    <xsl:with-param name="nvp_value" select="api:serverIpAddress"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="api:fileAvailableEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="''"/>
    <xsl:with-param name="nvp_recId" select="'1'"/>
    <xsl:with-param name="nvp_name" select="'fileName'"/>
    <xsl:with-param name="nvp_value" select="api:fileName"/>
  </xsl:call-template>
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="''"/>
    <xsl:with-param name="nvp_recId" select="'2'"/>
    <xsl:with-param name="nvp_name" select="'serverIpAddress'"/>
    <xsl:with-param name="nvp_value" select="'{SAM_SERVER}'"/>
  </xsl:call-template>
</xsl:template>

<!-- SAM Object Creation - Begins -->

<xsl:template match="api:objectCreationEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" /> <!-- actually this is a third pivot -->
  <xsl:variable name="nvp_event" select="/soap:Envelope/soap:Header/api:header/api:ALA_eventName"/>
  <xsl:apply-templates select="*/*" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_event"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot2"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="/soap:Envelope/soap:Body/api:jms/api:objectCreationEvent/*/*">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:param name="nvp_pivot3" />
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="position()"/>
    <xsl:with-param name="nvp_name" select="local-name()"/>
    <xsl:with-param name="nvp_value" select="text()"/>
  </xsl:call-template>
</xsl:template>

<!-- SAM Object Creation - Ends -->

<!-- SAM Inventory Attribute Value Change - Begins -->

<xsl:template match="api:attributeValueChangeEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" /> <!-- actually this is a third pivot -->
  <xsl:variable name="nvp_event" select="/soap:Envelope/soap:Header/api:header/api:ALA_eventName"/>
  <xsl:apply-templates select="api:attribute">
	  <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
	  <xsl:with-param name="nvp_pivot2" select="$nvp_event"/>
	  <xsl:with-param name="nvp_pivot3" select="$nvp_pivot2"/>
	  <xsl:with-param name="nvp_ofv" select="api:objectFullName/text()"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="api:attribute">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:param name="nvp_pivot3" />
  <xsl:param name="nvp_ofv" />  <!-- objectFullName -->
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="'1'"/>
    <xsl:with-param name="nvp_name" select="'objectFullName'"/>
    <xsl:with-param name="nvp_value" select="$nvp_ofv"/>
  </xsl:call-template>
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="'2'"/>
    <xsl:with-param name="nvp_name" select="'attributeName'"/>
    <xsl:with-param name="nvp_value" select="*/text()"/>
  </xsl:call-template>
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="'3'"/>
    <xsl:with-param name="nvp_name" select="'newValue'"/>
    <xsl:with-param name="nvp_value" select="api:newValue/*/text()"/>
  </xsl:call-template>
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="$nvp_pivot3"/>
    <xsl:with-param name="nvp_recId" select="'4'"/>
    <xsl:with-param name="nvp_name" select="'oldValue'"/>
    <xsl:with-param name="nvp_value" select="api:oldValue/*/text()"/>
  </xsl:call-template>
</xsl:template>

<!-- SAM Inventory Attribute Value Change - Ends -->

<!-- SAM Object Deletion - Begins -->

<xsl:template match="api:objectDeletionEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" /> <!-- actually this is a third pivot -->
  <xsl:variable name="nvp_event" select="/soap:Envelope/soap:Header/api:header/api:ALA_eventName"/>
  <xsl:call-template name="produce_nvp" >
	  <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
	  <xsl:with-param name="nvp_pivot2" select="$nvp_event"/>
	  <xsl:with-param name="nvp_pivot3" select="$nvp_pivot2"/>
	  <xsl:with-param name="nvp_recId" select="'1'"/>
	  <xsl:with-param name="nvp_name" select="'objectFullName'"/>
	  <xsl:with-param name="nvp_value" select="api:objectFullName/text()"/>
  </xsl:call-template>
</xsl:template>

<!-- SAM Object Deletion - Ends -->

<!-- SAM Special Messages - Begins -->

<xsl:template match="action">
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="''"/>
    <xsl:with-param name="nvp_pivot2" select="'action'"/>
    <xsl:with-param name="nvp_pivot3" select="''"/>
    <xsl:with-param name="nvp_recId" select="'1'"/>
    <xsl:with-param name="nvp_name" select="'SPECIALMSG'"/>
    <xsl:with-param name="nvp_value" select="text()"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="api:keepAliveEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:call-template name="produce_nvp" >
	  <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
	  <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
	  <xsl:with-param name="nvp_pivot3" select="''"/>
	  <xsl:with-param name="nvp_recId" select="'1'"/>
	  <xsl:with-param name="nvp_name" select="'SPECIALMSG'"/>
	  <xsl:with-param name="nvp_value" select="'keepAliveEvent'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="api:stateChangeEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:choose>
    <xsl:when test="api:eventName/text() = 'JmsMissedEvents'">
      <xsl:call-template name="produce_nvp" >
        <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
        <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
        <xsl:with-param name="nvp_pivot3" select="''"/>
        <xsl:with-param name="nvp_recId" select="'1'"/>
        <xsl:with-param name="nvp_name" select="'SPECIALMSG'"/>
        <xsl:with-param name="nvp_value" select="'JmsMissedEvents'"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="api:eventName/text() = 'SystemInfoEvent'">
      <xsl:call-template name="produce_nvp" >
        <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
        <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
        <xsl:with-param name="nvp_pivot3" select="''"/>
        <xsl:with-param name="nvp_recId" select="'1'"/>
        <xsl:with-param name="nvp_name" select="'SPECIALMSG'"/>
        <!-- value should be like - SystemInfoEvent|9.32.9.3|1353585305268 -->
        <xsl:with-param name="nvp_value" select="concat('SystemInfoEvent','|',api:sysPrimaryIp/text(),'|',api:jmsStartTime/text())"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="api:terminateClientSessionEvent">
  <xsl:param name="nvp_pivot1" />
  <xsl:param name="nvp_pivot2" />
  <xsl:call-template name="produce_nvp" >
    <xsl:with-param name="nvp_pivot1" select="$nvp_pivot1"/>
    <xsl:with-param name="nvp_pivot2" select="$nvp_pivot2"/>
    <xsl:with-param name="nvp_pivot3" select="''"/>
    <xsl:with-param name="nvp_recId" select="'1'"/>
    <xsl:with-param name="nvp_name" select="'SPECIALMSG'"/>
    <xsl:with-param name="nvp_value" select="'terminateClientSessionEvent'"/>
  </xsl:call-template>
</xsl:template>

<!-- SAM Special Messages - Ends -->

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

<!-- From 5620SAM_XML_OSS_Interface_Developer_Guide.pdf -->
<xsl:template match="api:alarmStatusChangeEvent"></xsl:template>
<xsl:template match="api:dBActivityEvent"></xsl:template>
<xsl:template match="api:dBConnectionStateChangeEvent"></xsl:template>
<xsl:template match="api:dBErrorEvent"></xsl:template>
<xsl:template match="api:dBProxyStateChangeEvent"></xsl:template>
<xsl:template match="api:deployerEvent"></xsl:template>
<xsl:template match="api:eventVessel"></xsl:template>
<xsl:template match="api:ExceptionEventXMLFormat"></xsl:template>
<xsl:template match="api:IncrementalRequestEvent"></xsl:template>
<xsl:template match="api:managedRouteEvent"></xsl:template>
<xsl:template match="api:relationshipChangeEvent"></xsl:template>
<xsl:template match="api:scriptExecutionEvent"></xsl:template>
<xsl:template match="api:statsEvent"></xsl:template>
<xsl:template match="api:xmlFilterChangeEvent"></xsl:template>

</xsl:stylesheet>

