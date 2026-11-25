<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:frmwrk="Corel Framework Data" exclude-result-prefixes="frmwrk">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<frmwrk:uiconfig><frmwrk:applicationInfo userConfiguration="true"/></frmwrk:uiconfig>
<xsl:template match="node()|@*"><xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy></xsl:template>
<xsl:template match="uiConfig/items"><xsl:copy><xsl:apply-templates select="node()|@*"/>
<itemData guid="5fc642e6-edef-4046-9736-53108abce563" type="checkButton" check="*Docker('859ee77f-8d38-45d5-9658-969f73ae8f7f')" dynamicCategory="2cc24a3e-fe24-4708-9a74-9c75406eebcd" userCaption="JXL Novorius" noBmpOnMenu="true" enable="true"/>
<itemData guid="661788ee-67c7-49a9-8f51-0e42f09b077d" type="wpfhost" hostedType="Addons\JXLNovorius\JXLNovorius.Addon.dll,JXLNovorius.DockerUI" enable="true"/>
</xsl:copy></xsl:template>
<xsl:template match="uiConfig/dockers"><xsl:copy><xsl:apply-templates select="node()|@*"/>
<dockerData guid="859ee77f-8d38-45d5-9658-969f73ae8f7f" userCaption="JXL Novorius" wantReturn="true" focusStyle="noThrow"><container><item dock="fill" margin="0,0,0,0" guidRef="661788ee-67c7-49a9-8f51-0e42f09b077d"/></container></dockerData>
</xsl:copy></xsl:template></xsl:stylesheet>