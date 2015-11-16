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
{if $PACKAGEERROR eq true}
<div style="margin:0 auto;width: 50em;">
	<table border='0' cellpadding='5' cellspacing='0' height='600px' width="700px">
	<tr><td align='center'>
		<div style='border: 3px solid rgb(153, 153, 153); background-color: rgb(255, 255, 255); width: 80%; position: relative; z-index: 500;'>

		<table border='0' cellpadding='5' cellspacing='0' width='98%'>
		<tr>
			<td rowspan='2' width='11%'><img src="{vimage_path('denied.gif')}" ></td>
			<td style='border-bottom: 1px solid rgb(204, 204, 204);' nowrap='nowrap' width='70%'>
				<span class='genHeaderSmall'>{vtranslate($PACKAGENAME, $MODULE)}{vtranslate('LBL_PACKAGE_NOT_FOUND', $MODULE)}</span>
				{if $USER_MODEL->get('is_admin') eq 'on'}
				<ul>
					<li>{vtranslate($PACKAGENAME, $MODULE)}{vtranslate('LBL_MISSING_PACKAGE', $MODULE)}</li>
					<li>{vtranslate('LBL_INSTALL_PACKAGE', $MODULE)}</li>
					<li>{vtranslate('LBL_CONTACT_HOSTING', $MODULE)}</li>
					<li>{vtranslate('LBL_TKS_HELP', $MODULE)}</li>
					<li>
						<a href='{$UNINSTALLURL}'>
							<font color="#FF0000">{vtranslate('LBL_CLICK_HERE', $MODULE)}{vtranslate('LBL_UNINSTALL_MODULE_BUILDER', $MODULE)}.</font>
						</a>
					</li>
				</ul>
				{else}
				<ul>
					<li>{vtranslate('LBL_NONADMIN_PACKAGE_MESSAGE', $MODULE)}</li>
				</ul>
				{/if}
			</td>
		</tr>
		<tr>
			<td class='small' align='right' nowrap='nowrap'>
				<a href='javascript:window.history.back();'>{vtranslate('LBL_GO_BACK')}</a><br>
			</td>
		</tr>
		</table>
		</div>
		{include file="ModuleBuilderActions.tpl"|@vtemplate_path:$MODULE}
	</td></tr>
	</table>
</div>
{/if}
{if $DIRCRATION eq true}
<div style="margin:0 auto;width: 50em;">
	<table border='0' cellpadding='5' cellspacing='0' height='600px' width="700px">
	<tr><td align='center'>
		<div style='border: 3px solid rgb(153, 153, 153); background-color: rgb(255, 255, 255); width: 80%; position: relative; z-index: 500;'>

		<table border='0' cellpadding='5' cellspacing='0' width='98%'>
		<tr>
			<td rowspan='2' width='11%'><img src="{vimage_path('denied.gif')}" ></td>
			<td style='border-bottom: 1px solid rgb(204, 204, 204);' nowrap='nowrap' width='70%'>
				<span class='genHeaderSmall'>{vtranslate('LBL_DIRCREATION', $MODULE)}</span>
				{if $USER_MODEL->get('is_admin') eq 'on'}
				<ul>
					<li>{vtranslate('LBL_DIRCREATION1', $MODULE)}</li>
					<li>{vtranslate('LBL_TKS_HELP', $MODULE)}</li>
				</ul>
				{else}
				<ul>
					<li>{vtranslate('LBL_NONADMIN_PACKAGE_MESSAGE', $MODULE)}</li>
				</ul>
				{/if}
			</td>
		</tr>
		<tr>
			<td class='small' align='right' nowrap='nowrap'>
				<a href='javascript:window.history.back();'>{vtranslate('LBL_GO_BACK')}</a><br>
			</td>
		</tr>
		</table>
		</div>
		{include file="ModuleBuilderActions.tpl"|@vtemplate_path:$MODULE}
	</td></tr>
	</table>
	
</div>
{/if}
{/strip}