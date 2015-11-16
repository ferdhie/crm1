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
<br />
<br />
{*<!--TECHNOKRAFTS START -- FOOTER -->*}
<div align="center" style="color: rgb(153, 153, 153);">
	{vtranslate('LBL_FOOTER', $MODULE)} :: v {vtranslate('LBL_MODULE_VERSION', $MODULE)}
	<br/>
	<a href="{vtranslate('Order_URL', $MODULE)}" name="TECHNOKRAFTS">{vtranslate('COPYRIGHT', $MODULE)}</a>
	<br/>
	{vtranslate('LBL_COUNTRY', $MODULE)}
	<br/>
	<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
		<input type="hidden" name="cmd" value="_donations">
		<input type="hidden" name="business" value="paypal@technokrafts.net">
		<input type="hidden" name="lc" value="US">
		<input type="hidden" name="item_name" value="Donation for Module Builder">
		<input type="hidden" name="item_number" value="001">
		<input type="hidden" name="no_note" value="0">
		<input type="hidden" name="currency_code" value="USD">
		<input type="hidden" name="bn" value="PP-DonationsBF:btn_donate_SM.gif:NonHostedGuest">
		<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
		<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
	</form>
</div>
{*<!--TECHNOKRAFTS END -- FOOTER -->*}
<br />
<br />
{/strip}