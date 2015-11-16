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
<div class='container-fluid editViewContainer' id='editViewContainer'>
	{assign var=WIDTHTYPE value=$USER_MODEL->get('rowheight')}
	<input type="hidden" name="module" value="{$MODULE}" />
	<input type="hidden" name="action" value="Save" />
	<input type="hidden" id="noofblocks" name="noofblocks" value="{$NOOFBLOCK}" />
		<form class="tks_modulevalidate" id="tks_modulevalidate">
			<input type="hidden" name="module" value="{$MODULE}" />
			<input type="hidden" name="action" value="BuildModule" />
			<input type="hidden" name="mode" value="saveModule" />
			<input type="hidden" id="noofblocks" name="noofblocks" value="{$NOOFBLOCK}" />
			<input type="hidden" id="tkssequence" name="tkssequence" value="" />
			<input type="hidden" id="token" name="token" value="{$TOKEN}" />
			<div class="contentHeader row-fluid">
			{assign var=SINGLE_MODULE_NAME value='SINGLE_'|cat:$MODULE}
				<h3 class="span8 textOverflowEllipsis">
				<table>
					<tr>
						<td>
							<img src="modules/ModuleBuilder/images/ModuleBuilderBig.png" alt="{vtranslate($MODULE, $MODULE)}"
							 title="{vtranslate($MODULE, $MODULE)}" height="48" width="48"/>	
						</td>
						<td>
							{vtranslate($SINGLE_MODULE_NAME, $MODULE)} 
						</td>
					</tr>
				</table>
				</h3><!--class="span8 textOverflowEllipsis"-->
				<span class="pull-right">
					<button class="btn btn-success" type="button" id="nextStep" 
						data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_CLICK_NEXT', $MODULE)}">
						<i class="icon-step-forward"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_NEXT', $MODULE)}</strong>
					</button>&nbsp;
					<button class="btn btn-success hide" type="submit" id="saveModule" 
						data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_CLICK_SAVE', $MODULE)}">
						<i class="icon-download-alt"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_SAVE', $MODULE)}</strong>
					</button>&nbsp;	
					<button class="btn btn-success hide download" type="button" id="download" 
						data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_CLICK_DOWNLOAD', $MODULE)}">
						<i class="icon-download"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_DOWNLOAD', $MODULE)}</strong>
					</button>
					<a class="cancelLink" type="reset" onclick="javascript:location.reload();">{vtranslate('LBL_CANCEL', $MODULE)}</a>
				</span><!--class="pull-right"-->
				{if $USER_MODEL->get('is_admin') eq 'on'}
				<span class="btn-group pull-right">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<button class="btn dropdown-toggle" href="#" data-toggle="dropdown">
							<i class="icon-wrench" alt="{vtranslate('LBL_SETTINGS', $MODULE)}" title="{vtranslate('LBL_SETTINGS', $MODULE)}"></i>&nbsp;&nbsp;
							<i class="caret"></i>
						</button>
						<ul class="dropdown-menu">
							<li><a href='{$UNINSTALLURL}'>{vtranslate('LBL_UNINSTALL_MODULE_BUILDER', $MODULE)}</a></li>
						</ul>
				</span>
				{/if}
			</div><!--class="contentHeader row-fluid"-->
			
			<table class="table table-bordered blockContainer showInlineTable equalSplit">
				<tr>
					<td class="fieldLabel medium">
						<label class="muted pull-right marginRight10px"> <span class="redColor">*</span> {vtranslate('MODULE_NAME', $MODULE)}</label>
					</td>
					<td class="fieldValue medium">
						<div class="span6 fieldValue">		
								<input id="tks_modulename" type="text" name="tks_modulename" value="" style="width: 305px;" 
									data-validation-engine="validate[required] funcCall[Vtiger_OnlyAphabets_Validator_Js.invokeValidation]]" />
									&nbsp;&nbsp;
									<i class="icon-info-sign alignMiddle" data-container="body" 
									data-toggle="popover" data-placement="top" data-content="{vtranslate('LBL_ENTER_MODULENAME', $MODULE)}" ></i>
						</div><!--class="span6 fieldValue"-->
					</td>
					<td class="fieldLabel medium">
						<label class="muted pull-right marginRight10px"> <span class="redColor">*</span> {vtranslate('MODULE_LABEL', $MODULE)}</label>
					</td>
					<td class="fieldValue medium">
						<div class="span6 fieldValue">	
								<input id="tks_modulelabel" type="text" name="tks_modulelabel" value="" style="width: 305px;" 
									data-validation-engine="validate[required] funcCall[Vtiger_OnlyAphabetsWithSapce_Validator_Js.invokeValidation]]"/>
									&nbsp;&nbsp;
									<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" data-placement="top" 
										data-content="{vtranslate('LBL_ENTER_MODULELABEL', $MODULE)}" ></i>
						</div><!--class="span6 fieldValue"-->
					</td>
				</tr>
				<tr>
					<td class="fieldLabel medium">
						<label class="muted pull-right marginRight10px"> <span class="redColor">*</span> {vtranslate('PARENT_TAB_NAME', $MODULE)}</label>
					</td>
					<td class="fieldValue medium">
						<div class="span6 fieldValue">
							<select class="chzn-select" name="tks_parent" id="tks_parent" style="width: 314px" >
									  {foreach item="PARENTTAB" from=$TKS_PARENT_MODULE }
											<option value="{$PARENTTAB}">{vtranslate($PARENTTAB,$MODULE)}</option>
									  {/foreach}
							</select>
							&nbsp;&nbsp;
							<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" 
								data-placement="top" data-content="{vtranslate('SELECT_PARENT_TAB', $MODULE)}"></i>
						</div><!--class="span6 fieldValue"-->
					</td>
					<td class="fieldLabel medium">
						<span class = 'hide entityField'>
							<label class="muted pull-right marginRight10px">{vtranslate('ENTITY_IDENTIFIER_FIELD', $MODULE)}</label>
						</span>	
					</td>
					<td class="fieldValue medium tks_entity_div">
						<div class="span6 fieldValue entityField hide">
							<select class="chzn-select" name="tks_entity" id="tks_entity" style="width: 314px">
									<option value="" selected="selected">{vtranslate('SELECT_FIELD', $MODULE)}</option>
									{foreach from=$TKS_ENTITY key=k item=v}
										<option value="{$k}">{$v}</option>
									 {/foreach}
							</select>
							&nbsp;&nbsp;
							<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" 
								data-placement="bottom" data-content="{vtranslate('SELECT_ENTITY_IDENTIFIER', $MODULE)}"></i>
						</div><!--class="span6 fieldValue"-->
					</td>
				</tr>
			</table><!--class="table table-bordered blockContainer showInlineTable"-->
		</form><!--class="tks_modulevalidate" id="tks_modulevalidate"-->
		<br>
		<hr>
		<div class="container-fluid hide" id="layoutEditorContainer">
			<div class="contents tabbable">
			
				<ul class="nav nav-tabs layoutTabs massEditTabs">
					<li class="active" data-container="body" data-toggle="popover" data-placement="right" data-content="{vtranslate('LBL_MODULE_FIELDS_LAYOUT', $MODULE)}">
						<a data-toggle="tab" href="#detailViewLayout">
								<strong>{vtranslate('LBL_DETAILVIEW_LAYOUT', $MODULE)}</strong>
						</a>
					</li>
					<li class="relatedListTab" data-container="body" data-toggle="popover" data-placement="right" data-content="{vtranslate('LBL_MODULE_RELATED_TAB', $MODULE)}">
						<a data-toggle="tab" href="#relatedTabOrder">
							<strong>{vtranslate('LBL_ARRANGE_RELATED_TABS', $MODULE)}</strong>
						</a>
					</li>
            	</ul><!--class="nav nav-tabs layoutTabs massEditTabs"-->
				
				 <div class="tab-content layoutContent padding20 themeTableColor overflowVisible">
					<div class="tab-pane active" id="detailViewLayout">
					{assign var=FIELD_TYPE_INFO value=$SELECTED_MODULE_MODEL->getAddFieldTypeInfo()}
						<div class="btn-toolbar padding20">
							<button class="btn addButton addCustomBlock" type="button" 
								data-container="body" data-toggle="popover" data-placement="right" data-content="{vtranslate('LBL_ADD_NEW_BLOCK', $MODULE)}">
								<i class="icon-plus"></i>&nbsp;
								<strong>{vtranslate('LBL_ADD_CUSTOM_BLOCK', $MODULE)}</strong>
							</button>
							<span class="pull-right">
								<button class="btn btn-success saveFieldSequence hide" type="button" 
									data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_SAVE_SEQUENCE', $MODULE)}">
									<i class="icon-align-justify"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_SAVE_FIELD_SEQUENCE', $MODULE)}</strong>
								</button>
							</span>
						</div><!--class="btn-toolbar padding20"-->
						
						<div id="moduleBlocks">
							<div class="tksfirstblock" ></div>
						</div>	<!--id="moduleBlocks"-->
						
					</div><!--class="tab-pane active" id="detailViewLayout"-->
					
					<div class="tab-pane" id="relatedTabOrder">
						<div class="relatedTabModulesList">
							<table class="table table-bordered blockContainer showInlineTable relatedlists">
								<tr>
									<th class="blockHeader">&nbsp;</th>
									<th class="blockHeader">{vtranslate('MODULE_NAME', $MODULE)}</th>
									<th class="blockHeader">
										{vtranslate('SELECT_ACTION', $MODULE)}
										&nbsp;&nbsp;
										<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" 
											data-placement="bottom" data-content="{vtranslate('LBL_SELECT_INFO', $MODULE)}"></i>
									</th>
									<th class="blockHeader">
									{vtranslate('ADD_ACTION', $MODULE)}
									&nbsp;&nbsp;
										<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" 
											data-placement="bottom" data-content="{vtranslate('LBL_ADD_INFO', $MODULE)}"></i>
									</th>
								</tr>
								<input type="hidden" name="tks_related_mod_cnt" value="{$RELATED_LIST|@count}"  />
								{assign var=i value=0}
								{foreach from=$RELATED_LIST key=k item=v}
								{assign var=moduletks value=$k|@getTranslatedString:'$MODULE'}
								<tr class="relblock">
									<td><input type="checkbox" tabindex="" value="{$k}" id="{$i}" class="relcheck" name="{$k}"/></td>
									<td>
										{$moduletks}
										{if $k eq 'Leads'}
										&nbsp;&nbsp;
										<i class="icon-info-sign alignMiddle" data-container="body" data-toggle="popover" 
											data-placement="bottom" data-content="{vtranslate('LBL_LEAD_WARNING', $MODULE)}"></i>
										{/if}	
									</td>
									<td><input type="checkbox" tabindex="" name="{$k}_sel" disabled="disabled" class="small relsel"></td>
									<td><input type="checkbox" tabindex="" name="{$k}_add"  disabled="disabled" class="small reladd"></td>
								</tr>
								{assign var=i value=$i+1}
								{/foreach}
							</table><!--class="table table-bordered blockContainer showInlineTable relatedlists"-->
						</div><!--class="relatedTabModulesList"-->
					</div><!--class="tab-pane" id="relatedTabOrder"-->	


				</div><!--class="tab-content layoutContent padding20 themeTableColor overflowVisible"-->
		
				<!--new field START-->
				<li class="newCustomFieldCopy hide">
					<div class="marginLeftZero border1px" data-field-id="" data-sequence="">
						<div class="row-fluid padding1per">
							<span class="span1">&nbsp;
								<a><img src="{vimage_path('drag.png')}" border="0" title="{vtranslate('LBL_DRAG',$MODULE)}"/></a>
							</span><!--class="span1"-->
							<div class="span11 marginLeftZero" style="word-wrap: break-word;">
								<span class="fieldLabels"></span>
								<span class="btn-group pull-right actions">
									<a href="javascript:void(0)" class="dropdown-toggle editFieldDetails" data-toggle="dropdown">
										<i class="icon-pencil alignMiddle" title="{vtranslate('LBL_EDIT', $MODULE)}"></i>
									</a><!--class="dropdown-toggle editFieldDetails"-->
									<a href="javascript:void(0)" class="deleteCustomField" data-field-id="">
										<i class="icon-trash alignMiddle" title="{vtranslate('LBL_DELETE', $MODULE)}"></i>
									</a><!--class="deleteCustomField" -->
									<div class="basicFieldOperations hide pull-right" style="width: 250px;">
										<form class="form-horizontal fieldDetailsForm">
											<div class="modal-header contentsBackground">
												<div class="pull-right"><a href="javascript:void(0)" class="cancel">X</a></div>
											</div><!--class="modal-header contentsBackground"-->
											<div style="padding-bottom: 5px;">
												<span>
													<input type="hidden" name="mandatory" value="O" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="mandatory" value="M" />&nbsp;{vtranslate('LBL_MANDATORY_FIELD', $MODULE)}
													</label>
												</span>
												<span>
													<input type="hidden" name="presence" value="1" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="presence" value="2" readonly="readonly" />&nbsp;{vtranslate('LBL_ACTIVE', $MODULE)}
													</label>
												</span>
												<span>
													<input type="hidden" name="quickcreate" value="1" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="quickcreate" value="0" />&nbsp;{vtranslate('LBL_QUICK_CREATE', $MODULE)}
													</label>
												</span>
												<span>
													<input type="hidden" name="summaryfield" value="0"/>
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="summaryfield" value="1" />&nbsp;{vtranslate('LBL_SUMMARY_FIELD', $MODULE)}
													</label>
												</span>
												<span>
													<input type="hidden" name="masseditable" value="2" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="masseditable" value="1" />&nbsp;{vtranslate('LBL_MASS_EDIT', $MODULE)}
													</label>
												</span>
												<span>
													<input type="hidden" name="tksfilterfield" value="0" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="tksfilterfield" value="1" />&nbsp;
														{vtranslate('LBL_TKS_FILTER', $MODULE)}</label>
												</span>
												<span>
													<input type="hidden" name="defaultvalue" value="" />
													<label class="checkbox" style="padding-left: 25px; padding-top: 5px;">
														<input type="checkbox" name="defaultvalue" value="1" />&nbsp;
														{vtranslate('LBL_DEFAULT_VALUE', $MODULE)}</label>
													<div class="padding1per defaultValueUi" style="padding : 0px 10px 0px 25px;"></div>
												</span>
											</div>
											<div class="modal-footer">
												<span class="pull-right">
													<div class="pull-right">
														<a href="javascript:void(0)" style="margin: 5px;color:#AA3434;margin-top:10px;" class="cancel">
															{vtranslate('LBL_CANCEL', $MODULE)}
														</a>
													</div>
													<button class="btn btn-success saveFieldDetails" data-field-id="" type="submit">
														<i class="icon-download-alt"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_SAVE', $MODULE)}</strong>
													</button>
												</span>
											</div><!--class="modal-footer"-->
										</form><!--class="form-horizontal fieldDetailsForm"-->
									</div><!--class="basicFieldOperations hide pull-right"-->	
								</span><!--class="btn-group pull-right actions"-->
							</div><!--class="span11 marginLeftZero"-->
						</div><!--class="row-fluid padding1per"-->
					</div><!--class="marginLeftZero border1px"-->
				</li><!--class="newCustomFieldCopy hide"-->
				<!--new field END-->
				
				<!--add NEW BLOCK pop up START-->
				<div class="modal createFieldModal hide">
					<div class="modal-header contentsBackground">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h3>{vtranslate('LBL_CREATE_CUSTOM_FIELD', $MODULE)}</h3>
					</div><!--class="modal-header contentsBackground"-->
					<form class="form-horizontal createCustomFieldForm">
						<div class="modal-body">
							<div class="control-group">
								<span class="control-label">
									{vtranslate('LBL_SELECT_FIELD_TYPE', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<span class="row-fluid">
										<select class="fieldTypesList span7" name="fieldType">
											{foreach item=FIELD_TYPE from=$ADD_SUPPORTED_FIELD_TYPES}
												<option value="{$FIELD_TYPE}"
														{foreach key=TYPE_INFO item=TYPE_INFO_VALUE from=$FIELD_TYPE_INFO[$FIELD_TYPE]}
															data-{$TYPE_INFO}="{$TYPE_INFO_VALUE}"
														{/foreach}>
													{vtranslate($FIELD_TYPE, $MODULE)}
												</option>
											{/foreach}
										</select>
									</span><!--class="row-fluid"-->
								</div><!--class="controls"-->
							</div><!--class="control-group"-->
							<div class="control-group">
								<span class="control-label">
									<span class="redColor">*</span>&nbsp;
									{vtranslate('LBL_LABEL_NAME', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<input type="text" maxlength="50" name="fieldLabel" value="" data-validation-engine=
										"validate[required] funcCall[Vtiger_OnlyAphabetsWithSapce_Validator_Js.invokeValidation]]" />
								</div><!--class="controls"-->
							</div><!--class="control-group"-->
							<div class="control-group supportedType lengthsupported">
								<span class="control-label">
									<span class="redColor">*</span>&nbsp;
									{vtranslate('LBL_LENGTH', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<input type="text" name="fieldLength" value="" data-validation-engine="validate[required, funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" />
								</div><!--class="controls"-->
							</div><!--class="control-group supportedType lengthsupported"-->
							<div class="control-group supportedType decimalsupported hide">
								<span class="control-label">
									<span class="redColor">*</span>&nbsp;
									{vtranslate('LBL_DECIMALS', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<input type="text" name="decimal" value="" data-validation-engine="validate[required, funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" />
								</div><!--class="controls"-->
							</div><!--class="control-group supportedType decimalsupported hide"-->
							<div class="control-group tksrelatedModules hide">
								<span class="control-label">
									<span class="redColor">*</span>&nbsp;
									{vtranslate('LBL_RELATED_MODULES', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<span class="row-fluid">
										<select multiple name="relate" style="width:73%">
											{foreach from=$RELATED_LIST key=k item=v}
												<option value="{$k}">
													{vtranslate($k, $k)}
												</option>
											{/foreach}
										</select>
									</span><!--class="row-fluid"-->
								</div><!--class="controls"-->
							</div><!--class="control-group tksrelatedModules hide"-->
							<div class="control-group supportedType preDefinedValueExists hide">
								<span class="control-label">
									<span class="redColor">*</span>&nbsp;
									{vtranslate('LBL_PICKLIST_VALUES', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<div class="row-fluid">
										<input type="hidden" id="picklistUi" class="span7 select2" name="pickListValues"
											   placeholder="{vtranslate('LBL_ENTER_PICKLIST_VALUES', $MODULE)}" 
											   	data-validation-engine="validate[required, funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" 
													data-validator={Zend_Json::encode([['name'=>'PicklistFieldValues']])} />
									</div><!--class="row-fluid"-->
								</div><!--class="controls"-->
							</div><!--class="control-group supportedType preDefinedValueExists hide"-->
							<div class="control-group isMandatoryField">
								<span class="control-label">
									&nbsp;
								</span><!--class="control-label"-->
								<div class="controls">
				
									<label class="checkbox">
										<input type="checkbox" class="checkbox" name="isMandatory" value="1" >&nbsp;{vtranslate('LBL_TKS_MANDATORY',$MODULE)}
									</label>
								</div><!--class="controls"-->
							</div><!--class="control-group isMandatoryField"-->
							<div class="control-group isfilterfield">
								<span class="control-label">
									&nbsp;
								</span><!--class="control-label"-->
								<div class="controls">
				
									<label class="checkbox isFilter">
										<input type="checkbox" class="checkbox isFilter" name="isFilter" value="1" >&nbsp;{vtranslate('LBL_TKS_FILTER',$MODULE)}
									</label>
								</div><!--class="controls"-->
							</div><!--class="control-group isfilterfield"-->
							<div class="control-group supportedType picklistOption hide">
								<span class="control-label">
									&nbsp;
								</span><!--class="control-label"-->
							</div><!--class="control-group supportedType picklistOption hide"-->
						</div><!--class="modal-body"-->
						{include file='ModalFooter.tpl'|@vtemplate_path:'Vtiger'}
					</form><!--class="form-horizontal createCustomFieldForm"-->
				</div><!--class="modal createFieldModal hide"-->
				<!--add NEW BLOCK pop up END-->
				
				<!--add BLOCK pop up START-->
				<div class="modal addBlockModal hide">
					<div class="modal-header contentsBackground">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h3>{vtranslate('LBL_ADD_CUSTOM_BLOCK', $MODULE)}</h3>
					</div><!--class="modal-header contentsBackground"-->
					<form class="form-horizontal addCustomBlockForm">
						<div class="modal-body">
							<div class="control-group">
								<span class="control-label">
									<span class="redColor">*</span>
									<span>{vtranslate('LBL_BLOCK_NAME', $MODULE)}</span>
								</span><!--class="control-label"-->
								<div class="controls">
									<input type="text" name="label" class="span3" 
										data-validation-engine="validate[required] funcCall[Vtiger_OnlyAphabetsWithSapce_Validator_Js.invokeValidation]]" />
								</div><!--class="controls"-->
							</div><!--class="control-group"-->
							<div class="control-group">
								<span class="control-label">
									{vtranslate('LBL_ADD_AFTER', $MODULE)}
								</span><!--class="control-label"-->
								<div class="controls">
									<span class="row-fluid">
										<select class="span8" name="beforeBlockId">
											<option value="0">{vtranslate('SELECT_BLOCK', $MODULE)}</option>
										</select>
									</span><!--class="row-fluid"-->
								</div><!--class="controls"-->
							</div><!--class="control-group"-->
						</div><!--class="modal-body"-->
						{include file='ModalFooter.tpl'|@vtemplate_path:'Vtiger'}
					</form><!--class="form-horizontal addCustomBlockForm"-->
				</div><!--class="modal addBlockModal hide"-->
				<!--add BLOCK pop up END-->
				
				<!--NEW BLOCK DIV START-->
					<div class="newCustomBlockCopy hide marginBottom10px border1px blockSortable" data-block-id="" data-sequence="" 
								style="border-radius: 4px 4px 0px 0px;background: white;">
					<input type = 'hidden' name = 'tksblockid' value ='0' id = 'tksblockid' />
					<input type = 'hidden' name = 'tksblocklabel' value ='' id = 'tksblocklabel' />
					<div class="row-fluid layoutBlockHeader">
						<div class="span6 blockLabel padding10">
							<img class="alignMiddle" src="{vimage_path('drag.png')}" />&nbsp;&nbsp;
						</div><!--class="span6 blockLabel padding10"-->
						<div class="span6 marginLeftZero" style="float:right !important;">
							<div class="pull-right btn-toolbar blockActions" style="margin: 4px;">
								<div class="btn-group">
									<button class="btn addCustomField" type="button" 
										data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_NEW_FIELD', $MODULE)}">
										<i class="icon-plus"></i>&nbsp;&nbsp;<strong>{vtranslate('LBL_ADD_CUSTOM_FIELD', $MODULE)}</strong>
									</button>
								</div><!--class="btn-group"-->
								<div class="btn-group" data-container="body" data-toggle="popover" data-placement="left" data-content="{vtranslate('LBL_DELETE_FIELD', $MODULE)}">
									<button class="btn dropdown-toggle" data-toggle="dropdown">
										<strong>{vtranslate('LBL_ACTIONS', $MODULE)}</strong>&nbsp;&nbsp;
										<i class="caret"></i>
									</button>
									<ul class="dropdown-menu pull-right">
										<li class="deleteCustomBlock">
											<a href="javascript:void(0)">{vtranslate('LBL_DELETE_CUSTOM_BLOCK', $MODULE)}</a>
										</li>
									</ul>
								</div><!--class="btn-group"-->
							</div><!--class="pull-right btn-toolbar blockActions"-->
						</div><!--class="span6 marginLeftZero"-->
					</div><!--class="row-fluid layoutBlockHeader"-->
					<div class="blockFieldsList row-fluid blockFieldsSortable" style="padding:5px;min-height: 27px">
						<ul class="connectedSortable span6 ui-sortable" style="list-style-type: none; float: left;min-height:1px;padding:2px;" name="sortable1"></ul>
						<ul class="connectedSortable span6 ui-sortable" style="list-style-type: none; margin: 0;float: left;min-height:1px;padding:2px;" name="sortable2"></ul>
					</div><!--class="blockFieldsList row-fluid blockFieldsSortable"-->
				</div><!--class="newCustomBlockCopy hide editFieldsTable marginBottom10px border1px blockSortable"-->
			<!--NEW BLOCK DIV END-->

			</div><!--class="contents tabbable"-->
		</div><!--class="container-fluid hide" id="layoutEditorContainer"-->
		<br>
		<hr>
		<p>
			<a class="cancelLink" href="{$CLEARCACHEURL}" title="{vtranslate('LBL_CLEAR_CACHE_TITLE', $MODULE)}" 
				data-container="body" data-toggle="popover" data-placement="right" data-content="{vtranslate('LBL_CLEARCACHE', $MODULE)}">
				{vtranslate('LBL_CLEAR_CACHE_TITLE', $MODULE)}
			</a>
			<br/>
			<i class="icon-info-sign alignMiddle"></i>&nbsp;{vtranslate('LBL_CLEAR_CACHE_INFO', $MODULE)}
			<br/>
			<i class="icon-info-sign alignMiddle"></i>&nbsp;{vtranslate('LBL_MODULE_INSTALL_NOTES', $MODULE)}
			<br/>
			<i class="icon-info-sign alignMiddle"></i>&nbsp;{vtranslate('LBL_MODULE_INSTALL_NOTES1', $MODULE)}
		</p>
		<div class ="tooltiphide hide">
			<div class="popover popover-tooltip"><div class="arrow"></div>
				<div class="popover-inner">
					<p style="font-size:9px" >
						<div class="popover-content" style"font-weight:lighter;position:relative;">
							<div></div>
						</div>
					</p>
				</div>
			</div>
		</div>				
</div><!--class='container-fluid editViewContainer' id='editViewContainer'-->			
{/strip}