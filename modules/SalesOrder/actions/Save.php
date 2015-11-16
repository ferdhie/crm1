<?php
/*+***********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 *************************************************************************************/
class SalesOrder_Save_Action extends Inventory_Save_Action {
    
    public function saveRecord($request) {
        global $adb;
        
        $jangka_waktu_um = $request->get('jangka_waktu_um', 1);
        $arrum_due_date = array();
        $arrum = array();
        
        for($i=1; $i<=$jangka_waktu_um; $i++) {
            $um_due_date = $request->get("um{$i}_due_date", '00-00-0000');
            if (!$um_due_date || $um_due_date == '00-00-0000' || !preg_match('~^\d{2}-\d{2}-\d{4}$~i', $um_due_date)) {
                break;
            }
            $arrum_due_date[]=$um_due_date;
            $um = floatval($request->get("um{$i}", '0.00'));
            $arrum[]=$um;
        }
        
        $recordModel = parent::saveRecord($request);
        $recordId = $recordModel->getId();
        
        $adb->startTransaction();
        $adb->pquery("DELETE FROM cms_uangmuka WHERE salesorder_id = ?", array($recordId));
        for($i=0; $i<$jangka_waktu_um; $i++) {
            $um_due_date = date('Y-m-d', mktime( 0, 0, 0, 
                    ltrim(substr($arrum_due_date[$i], 3, 2), '0'), 
                    ltrim(substr($arrum_due_date[$i], 0, 2), '0'), 
                    substr($arrum_due_date[$i], 6, 4  )));
            //echo "$arrum[$i], $um_due_date<br>\n";
            $adb->pquery("INSERT INTO cms_uangmuka (salesorder_id, um, um_due_date) VALUES (?, ?, ?)", array($recordId, $arrum[$i], $um_due_date));
        }
        $adb->completeTransaction();
        //exit;

        return $recordModel;
    }

    
}
