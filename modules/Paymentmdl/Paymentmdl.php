<?php
/***********************************************************************************************
** The contents of this file are subject to the Vtiger Module-Builder License Version 1.3
 * ( "License" ); You may not use this file except in compliance with the License
 * The Original Code is:  Technokrafts Labs Pvt Ltd
 * The Initial Developer of the Original Code is Technokrafts Labs Pvt Ltd.
 * Portions created by Technokrafts Labs Pvt Ltd are Copyright ( C ) Technokrafts Labs Pvt Ltd.
 * All Rights Reserved.
**
*************************************************************************************************/

include_once 'modules/Vtiger/CRMEntity.php';

class Paymentmdl extends Vtiger_CRMEntity {
	var $table_name = 'vtiger_paymentmdl';
	var $table_index= 'paymentmdlid';

	/**
	 * Mandatory table for supporting custom fields.
	 */
	var $customFieldTable = Array('vtiger_paymentmdlcf', 'paymentmdlid');

	/**
	 * Mandatory for Saving, Include tables related to this module.
	 */
	var $tab_name = Array('vtiger_crmentity', 'vtiger_paymentmdl', 'vtiger_paymentmdlcf');

	/**
	 * Mandatory for Saving, Include tablename and tablekey columnname here.
	 */
	var $tab_name_index = Array(
		'vtiger_crmentity' => 'crmid',
		'vtiger_paymentmdl'   => 'paymentmdlid',
	    'vtiger_paymentmdlcf' => 'paymentmdlid');

	/**
	 * Mandatory for Listing (Related listview)
	 */
	var $list_fields = Array (
		/* Format: Field Label => Array(tablename, columnname) */
		// tablename should not have prefix 'vtiger_'
		'Payment No' => Array('paymentmdl', 'paymentmdlno'),
                'Tanggal' => array('paymentmdl', 'paymentmdl_tks_tanggalpembayar'),
/*FIELDSTART*/'Termin'=> Array('paymentmdl', 'paymentmdl_tks_termin'),/*FIELDEND*/
                'Jenis' => array('paymentmdl', 'paymentmdl_tks_jenispembayaran'),
                'Jumlah' => array('paymentmdl', 'paymentmdl_tks_biayauangmuka'),
                'Cara' => array('paymentmdl', 'carabayar'),
		'Assigned To' => Array('crmentity','smownerid')
	);
	var $list_fields_name = Array (
		/* Format: Field Label => fieldname */
		'Payment No' => 'paymentmdlno',
                'Tanggal' => 'paymentmdl_tks_tanggalpembayar',
                'Subject' => 'subject',
/*FIELDSTART*/'Termin'=> 'paymentmdl_tks_termin',/*FIELDEND*/
                'Jenis' => 'paymentmdl_tks_jenispembayaran',
                'Cara' => 'carabayar',
                'Jumlah' => 'paymentmdl_tks_biayauangmuka',
		'Assigned To' => 'assigned_user_id'
	);

	// Make the field link to detail view
	var $list_link_field = 'paymentmdl_tks_termin';

	// For Popup listview and UI type support
	var $search_fields = Array(
		/* Format: Field Label => Array(tablename, columnname) */
		// tablename should not have prefix 'vtiger_'
		'Payment No' => Array('paymentmdl', 'paymentmdlno'),
                'Tanggal' => array('paymentmdl', 'paymentmdl_tks_tanggalpembayar'),
/*FIELDSTART*/'Termin'=> Array('paymentmdl', 'paymentmdl_tks_termin'),/*FIELDEND*/
                'Jumlah' => array('paymentmdl', 'paymentmdl_tks_biayauangmuka'),
		'Assigned To' => Array('vtiger_crmentity','assigned_user_id'),
	);
	var $search_fields_name = Array (
		/* Format: Field Label => fieldname */
		'Payment No' => 'paymentmdlno',
                'Tanggal' => 'paymentmdl_tks_tanggalpembayar',
/*FIELDSTART*/'Termin'=> 'paymentmdl_tks_termin',/*FIELDEND*/
                'Jumlah' => 'paymentmdl_tks_biayauangmuka',
		'Assigned To' => 'assigned_user_id',
	);

	// For Popup window record selection
	var $popup_fields = Array ('paymentmdl_tks_termin');

	// For Alphabetical search
	var $def_basicsearch_col = 'paymentmdl_tks_termin';

	// Column value to use on detail view record text display
	var $def_detailview_recname = 'paymentmdl_tks_termin';

	// Used when enabling/disabling the mandatory fields for the module.
	// Refers to vtiger_field.fieldname values.
	var $mandatory_fields = Array('paymentmdl_tks_termin','assigned_user_id');

	var $default_order_by = 'paymentmdl_tks_tanggalpembayar';
	var $default_sort_order='DESC';

	/**
	* Invoked when special actions are performed on the module.
	* @param String Module name
	* @param String Event Type
	*/
	function vtlib_handler($moduleName, $eventType) {
		global $adb;
 		if($eventType == 'module.postinstall') {
			// TODO Handle actions after this module is installed.
			Paymentmdl::checkWebServiceEntry();
		} else if($eventType == 'module.disabled') {
			// TODO Handle actions before this module is being uninstalled.
		} else if($eventType == 'module.preuninstall') {
			// TODO Handle actions when this module is about to be deleted.
		} else if($eventType == 'module.preupdate') {
			// TODO Handle actions before this module is updated.
		} else if($eventType == 'module.postupdate') {
			// TODO Handle actions after this module is updated.
			Paymentmdl::checkWebServiceEntry();
		}
 	}
        
        public function save($module_name, $fileid = '') {
            global $adb;
            
            if (!$this->column_fields['subject'])
                $this->column_fields['subject'] = 'Pembayaran ' . $_POST['salesorder_id_display'];
            
            if (!$this->column_fields['salesorder_id'])
                die('<center>Salesorder required</center>');
            
            $strwhere = $this->id ? " AND vtiger_paymentmdl.paymentmdlid <> '{$this->id}'" : "";
            $counter = $adb->GetOne("SELECT COUNT(vtiger_paymentmdl.*) FROM vtiger_paymentmdl, vtiger_crmentity "
                    .   "WHERE vtiger_paymentmdl.paymentmdlid=vtiger_crmentity.crmid "
                    .   "AND vtiger_crmentity.deleted=0 "
                    .   "AND vtiger_paymentmdl.salesorder_id='{$this->column_fields['salesorder_id']}' "
                    .   "AND vtiger_paymentmdl.paymentmdl_tks_termin = '{$this->column_fields['vtiger_paymentmdl']}' $strwhere");
            if ($counter) {
                die('<center>Sudah ada pembayaran dengan termin yang sama</center>');
            }
            
            parent::save($module_name, $fileid);
        }

         
	/*
	 * Function to handle module specific operations when saving a entity
	 */
	function save_module($module) {
		global $adb;
		$q = 'SELECT '.$this->def_detailview_recname.' FROM '.$this->table_name. ' WHERE ' . $this->table_index. ' = '.$this->id;
		
		$result =  $adb->pquery($q,array());
		$cnt = $adb->num_rows($result);
		if($cnt > 0) 
		{
			$label = $adb->query_result($result,0,$this->def_detailview_recname);
			$q1 = 'UPDATE vtiger_crmentity SET label = \''.$label.'\' WHERE crmid = '.$this->id;
			$adb->pquery($q1,array());
		}
                
                if (!$this->column_fields['paymentmdlno'])
                {
                    $counter = $adb->GetOne("SELECT COUNT(vtiger_paymentmdl.*) FROM vtiger_paymentmdl, vtiger_crmentity "
                            .   "WHERE vtiger_paymentmdl.paymentmdlid=vtiger_crmentity.crmid "
                            .   "AND vtiger_crmentity.deleted=0 "
                            .   "AND vtiger_paymentmdl.salesorder_id={$this->column_fields['salesorder_id']}");
                    if (!$counter)
                        $counter=1;
                    $this->column_fields['paymentmdlno'] = 'PM-'.str_replace('-', '', $this->column_fields['paymentmdl_tks_tanggalpembayar']).'-'. str_pad($this->column_fields['salesorder_id'], 5, "0", STR_PAD_LEFT). '-'. str_pad($counter, 3, "0", STR_PAD_LEFT);
                    $adb->pquery("UPDATE vtiger_paymentmdl SET paymentmdlno=? WHERE paymentmdlid=?",array( $this->column_fields['paymentmdlno'], $this->id ));
                }
	}
	/**
	 * Function to check if entry exsist in webservices if not then enter the entry
	 */
	static function checkWebServiceEntry() {
		global $log;
		$log->debug("Entering checkWebServiceEntry() method....");
		global $adb;

		$sql       =  "SELECT count(id) AS cnt FROM vtiger_ws_entity WHERE name = 'Paymentmdl'";
		$result   	= $adb->query($sql);
		if($adb->num_rows($result) > 0)
		{
			$no = $adb->query_result($result, 0, 'cnt');
			if($no == 0)
			{
				$tabid = $adb->getUniqueID("vtiger_ws_entity");
				$ws_entitySql = "INSERT INTO vtiger_ws_entity ( id, name, handler_path, handler_class, ismodule ) VALUES".
						  " (?, 'Paymentmdl','include/Webservices/VtigerModuleOperation.php', 'VtigerModuleOperation' , 1)";
				$res = $adb->pquery($ws_entitySql, array($tabid));
				$log->debug("Entered Record in vtiger WS entity ");	
			}
		}
		$log->debug("Exiting checkWebServiceEntry() method....");					
	}
}