<div id="salesorderDiv">
{if !empty($SALESORDER_ID)}
    {strip}	
        {assign var="FINAL" value=$RELATED_PRODUCTS.1.final_details}

	{assign var="IS_INDIVIDUAL_TAX_TYPE" value=false}
	{assign var="IS_GROUP_TAX_TYPE" value=true}

	{if $FINAL.taxtype eq 'individual'}
		{assign var="IS_GROUP_TAX_TYPE" value=false}
		{assign var="IS_INDIVIDUAL_TAX_TYPE" value=true}
	{/if}
        
        <input type="hidden" name="salesorder_title" value="{$SALESORDER_RECORD->getName()}">
        
	<table class="table table-bordered blockContainer lineItemTable" id="lineItemTab">
            <thead>
            <th class="detailViewBlockHeader">Item Details</th>
            <th colspan="2" class="detailViewBlockHeader">
                Currency: {$CURRENCY_INFO['currency_name']} ({$CURRENCY_INFO['currency_symbol']})
            </th>
            <th colspan="2" class="detailViewBlockHeader">
                Tax Mode: {$FINAL.taxtype}
            </th>
            </thead>
            <tbody>
		<tr>
			<td><span class="redColor">*</span><b>{vtranslate('LBL_ITEM_NAME',$MODULE)}</b></td>
			<td><b>{vtranslate('LBL_QTY',$MODULE)}</b></td>
			<td><b>{vtranslate('LBL_LIST_PRICE',$MODULE)}</b></td>
			<td><b class="pull-right">{vtranslate('LBL_TOTAL',$MODULE)}</b></td>
			<td><b class="pull-right">{vtranslate('LBL_NET_PRICE',$MODULE)}</b></td>
		</tr>
		{foreach key=row_no item=data from=$RELATED_PRODUCTS}
                <tr id="row{$row_no}" class="lineItemRow" {if $data["entityType$row_no"] eq 'Products'}data-quantity-in-stock={$data["qtyInStock$row_no"]}{/if}>
                    <input type="hidden" class="rowNumber" value="{$row_no}" />
                    <td>
                            <div>
                                <input type="hidden" id="hdnProductId{$row_no}" name="hdnProductId{$row_no}" value="{$data["hdnProductId$row_no"]}">
                                <input type="hidden" id="entityType{$row_no}" name="entityType{$row_no}" value="{$data["entityType$row_no"]}">
                                {$data["productName$row_no"]}
                            </div>
                            <input type="hidden" value="{$data["subproduct_ids$row_no"]}" id="subproduct_ids{$row_no}" name="subproduct_ids{$row_no}" class="subProductIds" />
                            <div id="subprod_names{$row_no}" name="subprod_names{$row_no}" class="subInformation"><span class="subProductsContainer">{$data["subprod_names$row_no"]}</span></div>
                    </td>
                    <td>
                        <input id="qty{$row_no}" name="qty{$row_no}" type="hidden" value="{if !empty($data["qty$row_no"])}{$data["qty$row_no"]}{else}0{/if}"/>
                        {$data["qty$row_no"]}
                    </td>
                    <td>
                        <input id="listPrice{$row_no}" name="listPrice{$row_no}" type="hidden" value="{if !empty($data["listPrice$row_no"])}{$data["listPrice$row_no"]}{else}0{/if}"/>
                        <div>
                            {$data["listPrice$row_no"]}
                        </div>
                        <div>(-)&nbsp; Discount:</div>
                        <div>
                            <b>Total After Discount</b>
                        </div>
                        {if $FINAL.taxtype neq 'group'}
                            <div>(+)&nbsp; Tax </div>
                        {/if}
                    </td>
                    <td>
                        <div>
                            {$data["productTotal$row_no"]}
                        </div>
                        <div>
                            {$data["discountTotal$row_no"]}
                        </div>
                        <div>
                            {$data["totalAfterDiscount$row_no"]}
                        </div>
                        {if $FINAL.taxtype neq 'group'}
                            <div>
                                {$data["taxTotal$row_no"]}
                            </div>
                        {/if}
                    </td>
                    <td>
                        <span class="pull-right">
                            {$data["netPrice$row_no"]}
                        </span>
                    </td>
                </tr>
		{/foreach}
        </tbody>
        </table>

        
	<table class="table table-bordered">
	    <tr>
		<td width="83%">
		    <div class="pull-right"><b>Total Items</b></div>
		</td>
		<td>
		    <span class="pull-right"><b>{$FINAL["hdnSubTotal"]}</b></span>
		</td>
	    </tr>
	    <tr>
		<td width="83%">
		    <span class="pull-right">(-)&nbsp;<b>Discount</b></span>
		</td>
		<td>
		    <span class="pull-right">{$FINAL['discountTotal_final']}</span>
		</td>
	    </tr>
            <tr>
		<td width="83%">
		    <span class="pull-right"><b>Total Before Tax </b></span>
		</td>
		<td>
		    <span class="pull-right">{$FINAL["preTaxTotal"]}</span>
		</td>
	    </tr>
	    {if $FINAL.taxtype eq 'group'}
		<tr>
		    <td width="83%">
			<span class="pull-right">(+)&nbsp;<b>Final Tax</b></span>
		    </td>
		    <td>
			<span class="pull-right">{$FINAL['tax_totalamount']}</span>
		    </td>
		</tr>
	    {/if}
	    <tr>
		<td width="83%">
		    <span class="pull-right">
			<b>Grand Total</b>
		    </span>
		</td>
		<td>
		    <span class="pull-right">
			{$FINAL["grandTotal"]}
		    </span>
		</td>
	    </tr>
	</table>
	<br/>
        
        <table class="table table-bordered" id="paymentInfoTable">
            <tr>
                        <th width="2%"><b>No</b></th>
                        <th width="49%"><b>Keterangan</b></th>
                        <th width="15%"><b>Jatuh Tempo</b></th>
                        <th width="17%"><b class="pull-right">Jumlah</b></th>
                        <th width="17%"><b class="pull-right">Terbayar</b></th>
                </tr>
                <tr>
                        <td>1</td>
                        <td>Nomor Unit Pesanan / NUP</td>
                        <td>
                                <span class="pull-right" id="idNup">
                                        {if $FINAL.nup_due_date}{DateTimeField::convertToUserFormat($FINAL.nup_due_date)}{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right" id="so_nup">
                                {if $FINAL.nup}{$FINAL.nup}{else}0{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right">
                                {if $PAYMENTS["Pembayaran NUP"].1}{$PAYMENTS["Pembayaran NUP"].1}{else}0{/if}
                                </span>
                        </td>
                </tr>
                <tr>
                        <td>2</td>
                        <td>Booking Fee</td>
                        <td>
                                <span class="pull-right" id="idBookingFee">
                                        {if $FINAL.bookingfee_due_date}{DateTimeField::convertToUserFormat($FINAL.bookingfee_due_date)}{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right" id="so_bookingfee">
                                        {if $FINAL.bookingfee}{$FINAL.bookingfee}{else}0{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right">
                                {if $PAYMENTS["Pembayaran Booking Fee"].1}{$PAYMENTS["Pembayaran Booking Fee"].1}{else}0{/if}
                                </span>
                        </td>
                </tr>
                <tr>
                        <td>3</td>
                        <td>Jangka Waktu</td>
                        <td>
                                <span class="pull-right">&nbsp;</span>
                        </td>
                        <td>
                                <span class="pull-right" id="jangka_waktu_um_val">{$FINAL.jangka_waktu_um}</span>
                        </td>
                        <td>&nbsp;</td>
                </tr>
                {assign "UANGMUKA" $FINAL.uangmuka}
                {for $i=1 to 36}
                    {if $i <= $FINAL.jangka_waktu_um}
                        <tr>
                                <td>{$i + 3}</td>
                                <td>Uang Muka {$i} {if $i eq 1}/ TANDA JADI{/if}</td>
                                <td>
                                        <span class="pull-right">
                                                {if $UANGMUKA[$i].um_due_date}{DateTimeField::convertToUserFormat($UANGMUKA[$i].um_due_date)}{/if}
                                        </span>
                                </td>
                                <td>
                                        <span class="pull-right" id="so_um{$i}">
                                                {if $UANGMUKA[$i].um}{$UANGMUKA[$i].um}{else}0{/if}
                                        </span>
                                </td>
                                <td>
                                        <span class="pull-right" id="payment_um{$i}">
                                            {assign "bayar" $PAYMENTS["Pembayaran Uang Muka"][$i]}
                                            {if $bayar}{$bayar}{else}0{/if}
                                        </span>
                                </td>
                        </tr>
                    {/if}
                {/for}
                <tr>
                        <td>{$FINAL.jangka_waktu_um + 4}</td>
                        <td>JAMSOSTEK</td>
                        <td>
                                <span class="pull-right">
                                        {if $FINAL.jamsostek_due_date}{DateTimeField::convertToUserFormat($FINAL.jamsostek_due_date)}{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right" id="so_jamsostek">
                                        {if $FINAL.jamsostek}{$FINAL.jamsostek}{else}0{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right">
                                {if $PAYMENTS["Pembayaran Jamsostek"].1}{$PAYMENTS["Pembayaran Jamsostek"].1}{else}0{/if}
                                </span>
                        </td>
                </tr>
                <tr>
                        <td>{$FINAL.jangka_waktu_um + 5}</td>
                        <td>{if $FINAL.carapinjam}{$FINAL.carapinjam}{/if}</td>
                        <td>
                                <span class="pull-right">
                                        {if $FINAL.pinjaman_due_date}{DateTimeField::convertToUserFormat($FINAL.pinjaman_due_date)}{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right" id="so_pinjaman">
                                        {if $FINAL.pinjaman}{$FINAL.pinjaman}{else}0{/if}
                                </span>
                        </td>
                        <td>
                                <span class="pull-right">
                                {if $PAYMENTS["Pembayaran Angsuran"].1}{$PAYMENTS["Pembayaran Angsuran"].1}{else}0{/if}
                                </span>
                        </td>
                </tr>
                <tr>
                        <td colspan="3"><span class="pull-right"><b>Total Pembayaran</b></span></td>
                        <td>
                                <span class="pull-right">
                                        <b id="final_total_tagihan">{if $FINAL.totalbayar}{$FINAL.totalbayar}{else}0{/if}</b>
                                        <input id="final_terbayar" type="hidden" name="final_terbayar" value="{$TOTAL_PAYMENTMDL}">
                                </span>
                        </td>
                        <td>
                                <span class="pull-right">
                                        <b id="final_total_terbayar">{$TOTAL_PAYMENTMDL}</b>
                                </span>
                        </td>
                </tr>
        </table>
    {/strip}
{/if}
</div>
