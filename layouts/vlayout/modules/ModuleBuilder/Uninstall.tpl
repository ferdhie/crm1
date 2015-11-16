{*<!--
/***********************************************************************************************
** The contents of this file are subject to the Vtiger Module-Builder License Version 1.0
 * ( "License" ); You may not use this file except in compliance with the License
 * The Original Code is:  Technokrafts Labs Pvt Ltd
 * The Initial Developer of the Original Code is Technokrafts Labs Pvt Ltd.
 * Portions created by Technokrafts Labs Pvt Ltd are Copyright ( C ) Technokrafts Labs Pvt Ltd.
 * All Rights Reserved.
**
*************************************************************************************************/
-->*}
{strip}
<div class='container-fluid'>
<div class="contentHeader row-fluid">
	<h3 class="span8 textOverflowEllipsis">		
		<table>
			<tr>
				<td>
					<img src="modules/ModuleBuilder/images/ModuleBuilderBig.png" alt="{vtranslate($MODULE, $MODULE)}"
					 title="{vtranslate($MODULE, $MODULE)}" height="48" width="48"/>	
				</td>
				<td>
					{vtranslate('LBL_UNINSTALLATION_WIZARD', $MODULE)} 
				</td>
			</tr>
		</table>
	</h3><!--class="span8 textOverflowEllipsis"-->
</div><!--class="contentHeader row-fluid"-->

<br />
<div class="gridster ready" align="center">
	<ul style="position: relative; height: 150px; width:800px;">
		<li class="new dashboardWidget gs_w" style="display: list-item;">
			<div class="dashboardWidgetHeader">
				<table width="100%" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td class="span5">
								<div class="dashboardTitle textOverflowEllipsis" title="Sales Pipeline" style="width: 15em;">
									<b>&nbsp;&nbsp;{vtranslate('LBL_NOTES', $MODULE)}</b>
								</div><!--class="dashboardTitle textOverflowEllipsis"-->	
							</td>
						</tr>
					</tbody>
				</table>
			</div><!--class="dashboardWidgetHeader"-->	
			<div class="slimScrollDiv" style="position: relative; overflow: hidden; height: 150px;">
				<div class="dashboardWidgetContent" style="overflow: hidden; width: auto; height: 150px;">
					<div class="padding10 row-fluid" align="left">
						<i style="margin-left:20px" class="icon-info-sign span"></i> 
						<span style="margin-left:26px" class="span10">{vtranslate('LBL_AUTO_UNINSTALL', $MODULE)}</span>
						<br />
						<i style="margin-left:20px" class="icon-info-sign span"></i> 
						<span style="margin-left:26px" class="span10">{vtranslate('LBL_BACKUP_REQUEST', $MODULE)}</span>
						<br />
						<i style="margin-left:20px" class="icon-info-sign span"></i> 
						<span style="margin-left:26px" class="span10">
							<div>
									{vtranslate('LBL_UN_STEP', $MODULE)}
								<span style="margin-left:32px" class="span10">
									{vtranslate('LBL_UN_STEP1', $MODULE)}
								</span>
							</div>
						</span>
						<br/>
						<br/>
						<br/>
						<i style="margin-left:20px" class="icon-info-sign span"></i> 
						<span style="margin-left:26px" class="span10">{vtranslate('LBL_TKS_HELP', $MODULE)}</span>
					</div><!--class="padding10 row-fluid"-->	
				</div><!--class="dashboardWidgetContent"-->	
			</div><!--class="slimScrollDiv"-->	
		</li><!--class="new dashboardWidget gs_w"-->
		<li>
		{include file="ModuleBuilderActions.tpl"|@vtemplate_path:$MODULE}
		</li>
	</ul>
</div><!--class="gridster ready"-->
{/strip}