<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:frmwrk="Corel Framework Data" exclude-result-prefixes="frmwrk">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<frmwrk:uiconfig><frmwrk:compositeNode xPath="/uiConfig/commandBars/commandBarData[@guid='3eaa9bbe-28fd-4672-9128-02974ee96332']"/><frmwrk:compositeNode xPath="/uiConfig/frame"/></frmwrk:uiconfig>
<xsl:template match="node()|@*"><xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy></xsl:template>
<xsl:template match="commandBarData[@guid='3eaa9bbe-28fd-4672-9128-02974ee96332']/menu | commandBarData[@guid='3eaa9bbe-28fd-4672-9128-02974ee96332']/container[not(../menu)]"><xsl:copy><xsl:apply-templates select="node()|@*"/><xsl:if test="not(item[@guidRef='5fc642e6-edef-4046-9736-53108abce563'])"><item guidRef="5fc642e6-edef-4046-9736-53108abce563"/></xsl:if></xsl:copy></xsl:template></xsl:stylesheet>